import 'package:flutter/material.dart';

import 'package:healthcare/core/theme/app_theme.dart';
import 'attendance_api.dart';
import 'attendance_models.dart';
import 'face_capture.dart';

/// ===========================================================================
///  FACE ENROLL
///
///  6 photos leta hai aur POST /nurse/face/enroll par bhej deta hai.
///  Success par Navigator.pop(context, true) - caller card refresh kar leta hai.
/// ===========================================================================

class FaceEnrollPage extends StatefulWidget {
  const FaceEnrollPage({super.key});

  @override
  State<FaceEnrollPage> createState() => _FaceEnrollPageState();
}

class _FaceEnrollPageState extends State<FaceEnrollPage> {
  static const List<_Pose> _poses = [
    _Pose('Seedha', 'Camera me seedha dekhein', Icons.face_rounded),
    _Pose('Left', 'Halka sa baayein mudein', Icons.arrow_back_rounded),
    _Pose('Right', 'Halka sa daayein mudein', Icons.arrow_forward_rounded),
    _Pose('Upar', 'Thoda upar dekhein', Icons.keyboard_arrow_up_rounded),
    _Pose('Neeche', 'Thoda neeche dekhein', Icons.keyboard_arrow_down_rounded),
    _Pose('Smile', 'Halki si muskaan', Icons.sentiment_satisfied_rounded),
  ];

  final List<FaceShot?> _shots = List<FaceShot?>.filled(6, null);

  bool _checking = true;
  bool _saving = false;
  AttendanceStatus? _status;

  int get _filled => _shots.where((s) => s != null).length;
  bool get _complete => _filled == _poses.length;

  @override
  void initState() {
    super.initState();
    _checkExisting();
  }

  Future<void> _checkExisting() async {
    try {
      final s = await FaceAttendanceApi.fetchStatus();
      if (!mounted) return;
      setState(() {
        _status = s;
        _checking = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _checking = false);
    }
  }

  // -------------------------------------------------------------------------
  Future<void> _capture(int index) async {
    if (_saving) return;
    final pose = _poses[index];
    final shot = await captureFacePhoto(
      context,
      title: 'Photo ${index + 1} / ${_poses.length} - ${pose.name}',
      hint: pose.hint,
    );
    if (shot == null || !mounted) return;
    setState(() => _shots[index] = shot);
  }

  Future<void> _captureNext() async {
    final next = _shots.indexWhere((s) => s == null);
    if (next == -1) return;
    await _capture(next);
  }

  Future<void> _save() async {
    if (!_complete || _saving) return;
    setState(() => _saving = true);

    try {
      final uris = _shots.map((s) => s!.dataUri).toList();
      final msg = await FaceAttendanceApi.enrollFaces(uris);
      if (!mounted) return;
      _snack(msg ?? 'Face enroll ho gaya ✅', error: false);
      await Future<void>.delayed(const Duration(milliseconds: 700));
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(apiErrorText(e), error: true, retry: _save);
    }
  }

  Future<void> _deleteEnrollment() async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Face data hatayein?'),
        content: const Text(
          'Purani enroll ki hui photos delete ho jayengi. '
          'Iske baad dobara 6 photos leni hongi.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (ok != true) return;

    setState(() => _saving = true);
    try {
      await FaceAttendanceApi.deleteEnrollment();
      if (!mounted) return;
      setState(() {
        _saving = false;
        _status = null;
        for (var i = 0; i < _shots.length; i++) {
          _shots[i] = null;
        }
      });
      _snack('Face data delete ho gaya. Ab dobara enroll karein.', error: false);
    } catch (e) {
      if (!mounted) return;
      setState(() => _saving = false);
      _snack(apiErrorText(e), error: true);
    }
  }

  void _snack(String msg, {required bool error, VoidCallback? retry}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: error ? AppTheme.danger : AppTheme.success,
          duration: Duration(seconds: error ? 6 : 3),
          action: retry == null
              ? null
              : SnackBarAction(
                  label: 'Retry',
                  textColor: Colors.white,
                  onPressed: retry,
                ),
        ),
      );
  }

  // -------------------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    final alreadyEnrolled = _status?.enrolled == true;

    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text('Face Enroll'), centerTitle: true),
      body: _checking
          ? const Center(child: CircularProgressIndicator())
          : AbsorbPointer(
              absorbing: _saving,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
                children: [
                  if (alreadyEnrolled) _enrolledBanner(),

                  const Text(
                    'Attendance ke liye apna chehra register karein',
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Alag-alag angle se 6 photos chahiye, taaki har baar punch '
                    'karte waqt chehra sahi pehchana ja sake.',
                    style: TextStyle(fontSize: 13.5, color: AppTheme.textSecondary),
                  ),

                  const SizedBox(height: 16),

                  // ---------- PROGRESS ----------
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: LinearProgressIndicator(
                      value: _filled / _poses.length,
                      minHeight: 8,
                      backgroundColor: const Color(0xFFDCE6E2),
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$_filled / ${_poses.length} photos li gayi',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppTheme.textSecondary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ---------- GRID ----------
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _poses.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.70,
                        ),
                    itemBuilder: (_, i) => _SlotTile(
                      pose: _poses[i],
                      shot: _shots[i],
                      index: i,
                      onTap: () => _capture(i),
                    ),
                  ),

                  const SizedBox(height: 18),
                  const _PrivacyNote(),
                ],
              ),
            ),
      bottomNavigationBar: _checking ? null : _bottomBar(),
    );
  }

  Widget _enrolledBanner() {
    final count = _status?.enrolledImages ?? 0;
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppTheme.success.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.verified_rounded, color: AppTheme.success, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              count > 0
                  ? 'Face pehle se enrolled hai ($count photos)'
                  : 'Face pehle se enrolled hai',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w600,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          TextButton(
            onPressed: _saving ? null : _deleteEnrollment,
            style: TextButton.styleFrom(foregroundColor: AppTheme.danger),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  Widget _bottomBar() {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: SizedBox(
        width: double.infinity,
        child: _complete
            ? ElevatedButton.icon(
                onPressed: _saving ? null : _save,
                icon: _saving
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Icon(Icons.cloud_upload_rounded),
                label: Text(_saving ? 'Upload ho raha hai...' : 'Save & Enroll'),
              )
            : ElevatedButton.icon(
                onPressed: _saving ? null : _captureNext,
                icon: const Icon(Icons.photo_camera_rounded),
                label: Text('Photo ${_filled + 1} lein'),
              ),
      ),
    );
  }
}

/// ===========================================================================
class _Pose {
  final String name;
  final String hint;
  final IconData icon;
  const _Pose(this.name, this.hint, this.icon);
}

class _SlotTile extends StatelessWidget {
  final _Pose pose;
  final FaceShot? shot;
  final int index;
  final VoidCallback onTap;

  const _SlotTile({
    required this.pose,
    required this.shot,
    required this.index,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final done = shot != null;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: done ? AppTheme.success : const Color(0xFFE5ECE9),
            width: done ? 1.6 : 1,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (done)
                    Image.memory(
                      shot!.bytes,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    )
                  else
                    Container(
                      color: AppTheme.primarySoft,
                      child: Icon(
                        pose.icon,
                        size: 28,
                        color: AppTheme.primary.withOpacity(0.55),
                      ),
                    ),
                  if (done)
                    const Positioned(
                      top: 4,
                      right: 4,
                      child: CircleAvatar(
                        radius: 10,
                        backgroundColor: AppTheme.success,
                        child: Icon(
                          Icons.check_rounded,
                          size: 13,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
              child: Text(
                '${index + 1}. ${pose.name}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                  color: done ? AppTheme.success : AppTheme.textSecondary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PrivacyNote extends StatelessWidget {
  const _PrivacyNote();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5ECE9)),
      ),
      child: const Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.lock_outline, size: 18, color: AppTheme.primary),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              'Photos sirf attendance verify karne ke liye secure server par '
              'bheji jaati hain. Phone me save nahi hoti.',
              style: TextStyle(fontSize: 12.5, color: AppTheme.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}
