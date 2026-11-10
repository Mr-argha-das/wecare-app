import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:healthcare/core/theme/app_theme.dart';
import 'attendance_api.dart';
import 'attendance_models.dart';

/// ===========================================================================
///  FACE ATTENDANCE HISTORY
///
///  GET /nurse/face/history?month=YYYY-MM
///  Default: current month. Future month par jaana allowed nahi.
/// ===========================================================================

class FaceHistoryPage extends StatelessWidget {
  const FaceHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(
        title: const Text('Attendance History'),
        centerTitle: true,
      ),
      body: const FaceHistoryView(),
    );
  }
}

/// Tab ke andar bhi use ho sake isliye alag widget.
class FaceHistoryView extends StatefulWidget {
  const FaceHistoryView({super.key});

  @override
  State<FaceHistoryView> createState() => _FaceHistoryViewState();
}

class _FaceHistoryViewState extends State<FaceHistoryView> {
  late DateTime _month;
  AttendanceHistory? _data;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _month = DateTime(now.year, now.month); // default = current month
    _load();
  }

  bool get _canGoNext {
    final now = DateTime.now();
    return _month.year < now.year ||
        (_month.year == now.year && _month.month < now.month);
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await FaceAttendanceApi.fetchHistory(
        DateFormat('yyyy-MM').format(_month),
      );
      if (!mounted) return;
      setState(() {
        _data = res;
        _loading = false;
      });
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = apiErrorText(e);
      });
    }
  }

  void _shift(int diff) {
    if (diff > 0 && !_canGoNext) return;
    setState(() {
      _month = DateTime(_month.year, _month.month + diff);
    });
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _MonthBar(
          month: _month,
          canGoNext: _canGoNext,
          onPrev: () => _shift(-1),
          onNext: () => _shift(1),
        ),
        Expanded(child: _buildBody()),
      ],
    );
  }

  Widget _buildBody() {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return _CenteredMessage(
        icon: Icons.cloud_off_rounded,
        title: 'Load nahi ho payi',
        message: _error!,
        actionLabel: 'Retry',
        onAction: _load,
      );
    }

    final data = _data;
    if (data == null || data.days.isEmpty) {
      return RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          children: const [
            SizedBox(height: 90),
            _CenteredMessage(
              icon: Icons.event_busy_rounded,
              title: 'Is mahine ka koi record nahi',
              message: 'Punch karte hi yahan record dikhne lagega.',
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
        itemCount: data.days.length + 1,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) {
          if (i == 0) return _SummaryRow(summary: data.summary);
          return _DayTile(day: data.days[i - 1]);
        },
      ),
    );
  }
}

/// ===========================================================================
class _MonthBar extends StatelessWidget {
  final DateTime month;
  final bool canGoNext;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthBar({
    required this.month,
    required this.canGoNext,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5ECE9)),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onPrev,
            icon: const Icon(Icons.chevron_left_rounded),
            color: AppTheme.primary,
          ),
          Expanded(
            child: Text(
              DateFormat('MMMM yyyy').format(month),
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 15.5,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
          ),
          IconButton(
            onPressed: canGoNext ? onNext : null,
            icon: const Icon(Icons.chevron_right_rounded),
            color: AppTheme.primary,
            disabledColor: const Color(0xFFC3D2CD),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final AttendanceSummary summary;

  const _SummaryRow({required this.summary});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Expanded(
            child: _StatBox(
              label: 'Present',
              value: summary.present,
              color: AppTheme.success,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatBox(
              label: 'Half',
              value: summary.half,
              color: AppTheme.accent,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _StatBox(
              label: 'Absent',
              value: summary.absent,
              color: AppTheme.danger,
            ),
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final int value;
  final Color color;

  const _StatBox({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: color.withOpacity(0.22)),
      ),
      child: Column(
        children: [
          Text(
            '$value',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          const SizedBox(height: 2),
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
    );
  }
}

class _DayTile extends StatelessWidget {
  final AttendanceDay day;

  const _DayTile({required this.day});

  Color get _statusColor {
    if (day.status.startsWith('half')) return AppTheme.accent;
    if (day.status.startsWith('p')) return AppTheme.success;
    return AppTheme.danger;
  }

  String get _statusLabel {
    if (day.status.isEmpty) return '-';
    return day.status[0].toUpperCase() + day.status.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5ECE9)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // DATE
          Container(
            width: 48,
            padding: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.09),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Text(
                  day.dayNumber,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w800,
                    color: _statusColor,
                  ),
                ),
                Text(
                  day.weekday,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 13),

          // TIMES
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _MiniTime(
                      icon: Icons.login_rounded,
                      color: AppTheme.success,
                      text: IstTime.clockOf(day.punchIn),
                    ),
                    const SizedBox(width: 12),
                    _MiniTime(
                      icon: Icons.logout_rounded,
                      color: AppTheme.danger,
                      text: IstTime.clockOf(day.punchOut),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Worked: ${day.hoursText}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ],
            ),
          ),

          // STATUS
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
            decoration: BoxDecoration(
              color: _statusColor.withOpacity(0.10),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Text(
              _statusLabel,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: _statusColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniTime extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const _MiniTime({
    required this.icon,
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppTheme.textPrimary,
          ),
        ),
      ],
    );
  }
}

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;

  const _CenteredMessage({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 44, color: AppTheme.textSecondary),
            const SizedBox(height: 14),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppTheme.textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: AppTheme.textSecondary,
              ),
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
