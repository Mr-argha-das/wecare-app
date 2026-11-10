import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:healthcare/core/theme/app_theme.dart';
import 'attendance_api.dart';
import 'attendance_models.dart';
import 'face_enroll_page.dart';
import 'face_history_page.dart';
import 'punch_service.dart';

/// ===========================================================================
///  ATTENDANCE CARD  (nurse dashboard)
///
///  - Aaj ka Punch In / Punch Out time + state
///  - Punch In (green) sirf tab enabled jab today.can_punch_in == true
///  - Punch Out (red)  sirf tab enabled jab today.can_punch_out == true
///  - enrolled == false  -> "Face enroll karein", dono buttons disabled
///  - App foreground me aate hi status dobara fetch hota hai
/// ===========================================================================

class AttendanceCard extends StatefulWidget {
  /// Dashboard par compact version, Attendance tab par bada version.
  final bool compact;

  const AttendanceCard({super.key, this.compact = true});

  @override
  State<AttendanceCard> createState() => _AttendanceCardState();
}

class _AttendanceCardState extends State<AttendanceCard>
    with WidgetsBindingObserver {
  AttendanceStatus? _status;
  bool _loading = true;
  bool _busy = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _load();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// App dobara foreground me aaye to status refresh karo.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;
    // Punch chal raha ho (camera khula tha) to beech me refresh mat karo.
    if (_busy) return;
    _load(silent: true);
  }

  // -------------------------------------------------------------------------
  Future<void> _load({bool silent = false}) async {
    if (!silent) {
      setState(() {
        _loading = true;
        _error = null;
      });
    }
    try {
      final s = await FaceAttendanceApi.fetchStatus();
      if (!mounted) return;
      setState(() {
        _status = s;
        _loading = false;
        _error = null;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        if (!silent || _status == null) _error = apiErrorText(e);
      });
    }
  }

  Future<void> refresh() => _load();

  // -------------------------------------------------------------------------
  Future<void> _punch({required bool punchIn}) async {
    if (_busy) return;
    setState(() => _busy = true);

    final outcome = await runPunchFlow(context, punchIn: punchIn);

    if (!mounted) {
      return;
    }
    setState(() => _busy = false);

    if (outcome.cancelled) return;

    if (outcome.isSuccess) {
      _snack(outcome.result!.successLine, error: false);
      await _load(silent: true);
      return;
    }

    _snack(
      outcome.error ?? 'Punch fail ho gaya.',
      error: true,
      retry: () => _punch(punchIn: punchIn),
    );
  }

  Future<void> _openEnroll() async {
    final done = await Navigator.push<bool>(
      context,
      CupertinoPageRoute(builder: (_) => const FaceEnrollPage()),
    );
    if (done == true) await _load();
  }

  void _openHistory() {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (_) => const FaceHistoryPage()),
    );
  }

  void _snack(String msg, {required bool error, VoidCallback? retry}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(msg),
          backgroundColor: error ? AppTheme.danger : AppTheme.success,
          duration: Duration(seconds: error ? 6 : 4),
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
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5ECE9)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const SizedBox(
        height: 132,
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (_status == null) {
      return _ErrorBlock(message: _error ?? 'Attendance load nahi hui.', onRetry: _load);
    }

    final status = _status!;
    final today = status.today;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- HEADER ----------
        Row(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AppTheme.primarySoft,
                borderRadius: BorderRadius.circular(11),
              ),
              child: const Icon(
                Icons.face_rounded,
                size: 20,
                color: AppTheme.primary,
              ),
            ),
            const SizedBox(width: 11),
            const Expanded(
              child: Text(
                'Attendance',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ),
            _StateChip(state: today.state, label: today.stateLabel),
          ],
        ),

        const SizedBox(height: 14),

        // ---------- TIMES ----------
        Row(
          children: [
            Expanded(
              child: _TimeTile(
                label: 'Punch In',
                time: today.punchInText,
                icon: Icons.login_rounded,
                color: AppTheme.success,
                filled: today.punchIn != null,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _TimeTile(
                label: 'Punch Out',
                time: today.punchOutText,
                icon: Icons.logout_rounded,
                color: AppTheme.danger,
                filled: today.punchOut != null,
              ),
            ),
          ],
        ),

        // ---------- NOT ENROLLED ----------
        if (!status.enrolled) ...[
          const SizedBox(height: 14),
          _EnrollBanner(onTap: _openEnroll),
        ],

        // ---------- ERROR (background refresh fail) ----------
        if (_error != null && status.enrolled) ...[
          const SizedBox(height: 10),
          Text(
            _error!,
            style: const TextStyle(fontSize: 12, color: AppTheme.danger),
          ),
        ],

        const SizedBox(height: 14),

        // ---------- BUTTONS ----------
        Row(
          children: [
            Expanded(
              child: _PunchButton(
                label: 'Punch In',
                icon: Icons.login_rounded,
                color: AppTheme.success,
                // Criterion 2: sirf can_punch_in true + enrolled hone par
                enabled: status.enrolled && today.canPunchIn && !_busy,
                busy: _busy,
                onTap: () => _punch(punchIn: true),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _PunchButton(
                label: 'Punch Out',
                icon: Icons.logout_rounded,
                color: AppTheme.danger,
                enabled: status.enrolled && today.canPunchOut && !_busy,
                busy: _busy,
                onTap: () => _punch(punchIn: false),
              ),
            ),
          ],
        ),

        // ---------- FOOTER ----------
        if (widget.compact) ...[
          const SizedBox(height: 4),
          Row(
            children: [
              TextButton.icon(
                onPressed: _openHistory,
                icon: const Icon(Icons.history_rounded, size: 18),
                label: const Text('History'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  minimumSize: const Size(0, 36),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
              const Spacer(),
              if (status.enrolled)
                TextButton.icon(
                  onPressed: _openEnroll,
                  icon: const Icon(Icons.verified_user_outlined, size: 18),
                  label: const Text('Face'),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    minimumSize: const Size(0, 36),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
            ],
          ),
        ],
      ],
    );
  }
}

/// ===========================================================================
///  SMALL PIECES
/// ===========================================================================

class _StateChip extends StatelessWidget {
  final AttendanceState state;
  final String label;

  const _StateChip({required this.state, required this.label});

  @override
  Widget build(BuildContext context) {
    late final Color c;
    switch (state) {
      case AttendanceState.onDuty:
        c = AppTheme.success;
        break;
      case AttendanceState.completed:
        c = AppTheme.primary;
        break;
      case AttendanceState.notPunchedIn:
        c = AppTheme.textSecondary;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: c.withOpacity(0.10),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(color: c, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: c,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeTile extends StatelessWidget {
  final String label;
  final String time;
  final IconData icon;
  final Color color;
  final bool filled;

  const _TimeTile({
    required this.label,
    required this.time,
    required this.icon,
    required this.color,
    required this.filled,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: filled ? color.withOpacity(0.07) : const Color(0xFFF5F8F7),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: filled ? color.withOpacity(0.25) : const Color(0xFFE5ECE9),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: filled ? color : AppTheme.textSecondary,
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 5),
          Text(
            time,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.3,
              color: filled ? AppTheme.textPrimary : AppTheme.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _PunchButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final bool enabled;
  final bool busy;
  final VoidCallback onTap;

  const _PunchButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.enabled,
    required this.busy,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: enabled ? onTap : null,
      icon: busy && enabled
          ? const SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: Colors.white,
              ),
            )
          : Icon(icon, size: 18),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        disabledBackgroundColor: const Color(0xFFB9CAC5),
        disabledForegroundColor: Colors.white,
        elevation: 0,
        minimumSize: const Size(0, 48),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }
}

class _EnrollBanner extends StatelessWidget {
  final VoidCallback onTap;

  const _EnrollBanner({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppTheme.accent.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppTheme.accent.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.info_outline,
              size: 20,
              color: Color(0xFFB4701F),
            ),
            const SizedBox(width: 10),
            const Expanded(
              child: Text(
                'Face enroll karein',
                style: TextStyle(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF8A5513),
                ),
              ),
            ),
            const Icon(
              Icons.chevron_right_rounded,
              size: 20,
              color: Color(0xFFB4701F),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorBlock extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorBlock({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(
          Icons.cloud_off_rounded,
          size: 34,
          color: AppTheme.textSecondary,
        ),
        const SizedBox(height: 10),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, color: AppTheme.textSecondary),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: onRetry,
          icon: const Icon(Icons.refresh_rounded, size: 18),
          label: const Text('Retry'),
          style: OutlinedButton.styleFrom(minimumSize: const Size(0, 42)),
        ),
      ],
    );
  }
}
