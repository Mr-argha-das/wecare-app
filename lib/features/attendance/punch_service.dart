import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import 'package:healthcare/core/theme/app_theme.dart';
import 'attendance_api.dart';
import 'attendance_models.dart';
import 'face_capture.dart';

/// ===========================================================================
///  PUNCH FLOW
///
///  Ek jagah par poora flow:
///     front camera -> photo -> GPS -> POST /nurse/face/punch -> result
///
///  Koi offline queue nahi hai (spec ke mutabik). Fail hone par caller
///  "Retry" wala snackbar dikhata hai.
/// ===========================================================================

class PunchFlowException implements Exception {
  final String message;
  const PunchFlowException(this.message);
  @override
  String toString() => message;
}

class PunchOutcome {
  final PunchResult? result;
  final String? error;
  final bool cancelled;

  const PunchOutcome._({this.result, this.error, this.cancelled = false});

  factory PunchOutcome.success(PunchResult r) => PunchOutcome._(result: r);
  factory PunchOutcome.failed(String e) => PunchOutcome._(error: e);
  static const PunchOutcome userCancelled = PunchOutcome._(cancelled: true);

  bool get isSuccess => result != null;
}

/// Punch in / out ka poora flow chalao.
Future<PunchOutcome> runPunchFlow(
  BuildContext context, {
  required bool punchIn,
}) async {
  final type = punchIn ? 'in' : 'out';

  // ---------- 1. Face photo ----------
  final shot = await captureFacePhoto(
    context,
    title: punchIn ? 'Punch In - Face verify' : 'Punch Out - Face verify',
    hint: punchIn
        ? 'Duty shuru karne ke liye apna chehra scan karein'
        : 'Duty khatam karne ke liye apna chehra scan karein',
  );
  if (shot == null) return PunchOutcome.userCancelled;

  // ---------- 2. Loading ----------
  if (!context.mounted) return PunchOutcome.userCancelled;
  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (_) => const _PunchLoadingDialog(),
  );

  try {
    // ---------- 3. GPS ----------
    final pos = await resolveCurrentPosition();

    // ---------- 4. Upload ----------
    final result = await FaceAttendanceApi.punch(
      type: type,
      imageDataUri: shot.dataUri,
      latitude: pos.latitude,
      longitude: pos.longitude,
      accuracy: pos.accuracy,
    );

    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    return PunchOutcome.success(result);
  } on PunchFlowException catch (e) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    return PunchOutcome.failed(e.message);
  } catch (e) {
    if (context.mounted) Navigator.of(context, rootNavigator: true).pop();
    // Backend ka {"detail": "..."} message jaisa hai waisa hi dikhana hai.
    return PunchOutcome.failed(apiErrorText(e));
  }
}

/// GPS location nikalo - saari permission problems ke saaf messages ke saath.
Future<Position> resolveCurrentPosition() async {
  final serviceOn = await Geolocator.isLocationServiceEnabled();
  if (!serviceOn) {
    throw const PunchFlowException(
      'Location (GPS) band hai. Kripya GPS on karke dobara try karein.',
    );
  }

  var perm = await Geolocator.checkPermission();
  if (perm == LocationPermission.denied) {
    perm = await Geolocator.requestPermission();
  }

  if (perm == LocationPermission.denied) {
    throw const PunchFlowException(
      'Location permission ke bina attendance nahi ho sakti.',
    );
  }
  if (perm == LocationPermission.deniedForever) {
    throw const PunchFlowException(
      'Location permission block hai. Settings me jaakar allow karein.',
    );
  }

  try {
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    ).timeout(const Duration(seconds: 25));
  } on TimeoutException {
    // Last known location se kaam chala lo.
    final last = await Geolocator.getLastKnownPosition();
    if (last != null) return last;
    throw const PunchFlowException(
      'Location nahi mil payi. Khule aasman ke neeche jaakar dobara try karein.',
    );
  }
}

class _PunchLoadingDialog extends StatelessWidget {
  const _PunchLoadingDialog();

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Dialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 28, vertical: 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 34,
                height: 34,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
              SizedBox(height: 16),
              Text(
                'Face verify ho raha hai...',
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Location aur photo bheji ja rahi hai',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
