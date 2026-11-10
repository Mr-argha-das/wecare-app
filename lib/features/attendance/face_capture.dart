import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:healthcare/core/theme/app_theme.dart';

/// ===========================================================================
///  FACE CAPTURE
///
///  Front camera se photo leta hai aur use spec ke format me badal deta hai:
///     "data:image/jpeg;base64,<....>"
///
///  Size control image_picker native side par karta hai:
///     maxWidth / maxHeight = 720  -> long side <= 720 px
///     imageQuality         = 80   -> JPEG q80
///  Result normally ~60-130 KB hota hai (soft limit ~250 KB).
///
///  SECURITY: base64 string kabhi print / log nahi ki jaati.
/// ===========================================================================

const int kFaceMaxSide = 720;
const int kFaceJpegQuality = 80;
const int kFaceSoftLimitBytes = 250 * 1024;

class FaceShot {
  final Uint8List bytes;
  final String dataUri;

  const FaceShot({required this.bytes, required this.dataUri});

  int get sizeKb => (bytes.length / 1024).ceil();
  bool get isOversized => bytes.length > kFaceSoftLimitBytes;
}

final ImagePicker _picker = ImagePicker();

/// Front camera kholo aur ek face photo lo.
///
/// [review] true ho to photo lene ke baad oval preview + Retake dikhta hai.
/// Cancel karne par `null` milta hai.
Future<FaceShot?> captureFacePhoto(
  BuildContext context, {
  required String title,
  String? hint,
  bool review = true,
}) async {
  // ---------- 1. Camera permission ----------
  final granted = await _ensureCameraPermission(context);
  if (!granted) return null;

  // ---------- 2. Guide sheet ----------
  if (!context.mounted) return null;
  final proceed = await showModalBottomSheet<bool>(
    context: context,
    backgroundColor: Colors.transparent,
    isScrollControlled: true,
    builder: (_) => _CaptureGuideSheet(title: title, hint: hint),
  );
  if (proceed != true) return null;

  // ---------- 3. Capture (retake loop) ----------
  while (true) {
    if (!context.mounted) return null;

    final face = await _openFrontCamera(context);
    if (face == null) return null; // cancel / error

    if (!review) return face;
    if (!context.mounted) return face;

    final keep = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _FaceReviewDialog(shot: face),
    );

    if (keep == true) return face;
    if (keep == null) return null; // dialog band
    // keep == false -> loop dobara chalega (Retake)
  }
}

Future<bool> _ensureCameraPermission(BuildContext context) async {
  final status = await Permission.camera.request();
  if (status.isGranted || status.isLimited) return true;

  if (!context.mounted) return false;

  if (status.isPermanentlyDenied) {
    final go = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Camera permission band hai'),
        content: const Text(
          'Face attendance ke liye camera chahiye.\n'
          'Settings me jaakar Camera permission allow karein.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Settings kholein'),
          ),
        ],
      ),
    );
    if (go == true) await openAppSettings();
    return false;
  }

  if (context.mounted) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Camera permission ke bina photo nahi li ja sakti.'),
        backgroundColor: AppTheme.danger,
      ),
    );
  }
  return false;
}

Future<FaceShot?> _openFrontCamera(BuildContext context) async {
  XFile? shot;
  try {
    shot = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: kFaceJpegQuality,
      maxWidth: kFaceMaxSide.toDouble(),
      maxHeight: kFaceMaxSide.toDouble(),
    );
  } catch (_) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Camera open nahi ho paya. Dobara koshish karein.'),
          backgroundColor: AppTheme.danger,
        ),
      );
    }
    return null;
  }

  if (shot == null) return null; // user ne cancel kiya

  final bytes = await shot.readAsBytes();
  if (bytes.isEmpty) return null;

  return FaceShot(
    bytes: bytes,
    dataUri: 'data:image/jpeg;base64,${base64Encode(bytes)}',
  );
}

/// ===========================================================================
///  OVAL FRAME  (guide + preview dono me use hota hai)
/// ===========================================================================
class OvalFaceFrame extends StatelessWidget {
  final Widget? child;
  final double width;
  final Color borderColor;

  const OvalFaceFrame({
    super.key,
    this.child,
    this.width = 170,
    this.borderColor = AppTheme.primary,
  });

  @override
  Widget build(BuildContext context) {
    final height = width * 1.25;
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppTheme.primarySoft,
        borderRadius: BorderRadius.all(
          Radius.elliptical(width / 2, height / 2),
        ),
        border: Border.all(color: borderColor, width: 3),
      ),
      clipBehavior: Clip.antiAlias,
      child:
          child ??
          Icon(
            Icons.person_rounded,
            size: width * 0.55,
            color: borderColor.withOpacity(0.3),
          ),
    );
  }
}

/// ===========================================================================
///  GUIDE SHEET
/// ===========================================================================
class _CaptureGuideSheet extends StatelessWidget {
  final String title;
  final String? hint;

  const _CaptureGuideSheet({required this.title, this.hint});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(12),
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 42,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFFDCE6E2),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              const SizedBox(height: 18),
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              if (hint != null) ...[
                const SizedBox(height: 6),
                Text(
                  hint!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
              const SizedBox(height: 18),
              const OvalFaceFrame(width: 132),
              const SizedBox(height: 18),
              const _Tip(
                icon: Icons.wb_sunny_outlined,
                text: 'Achhi roshni me rahein',
              ),
              const _Tip(
                icon: Icons.center_focus_strong_outlined,
                text: 'Chehra frame ke beech me rakhein',
              ),
              const _Tip(
                icon: Icons.visibility_outlined,
                text: 'Mask / chashma hata dein',
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.photo_camera_rounded),
                  label: const Text('Camera kholein'),
                  onPressed: () => Navigator.pop(context, true),
                ),
              ),
              const SizedBox(height: 6),
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Tip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _Tip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 19, color: AppTheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 13.5,
                color: AppTheme.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// ===========================================================================
///  REVIEW DIALOG
/// ===========================================================================
class _FaceReviewDialog extends StatelessWidget {
  final FaceShot shot;

  const _FaceReviewDialog({required this.shot});

  @override
  Widget build(BuildContext context) {
    const double w = 160;
    return AlertDialog(
      title: const Text('Photo theek hai?'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          OvalFaceFrame(
            width: w,
            child: Image.memory(
              shot.bytes,
              fit: BoxFit.cover,
              width: w,
              height: w * 1.25,
              gaplessPlayback: true,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            '${shot.sizeKb} KB',
            style: const TextStyle(fontSize: 12, color: AppTheme.textSecondary),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('Retake'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, true),
          child: const Text('Use photo'),
        ),
      ],
    );
  }
}
