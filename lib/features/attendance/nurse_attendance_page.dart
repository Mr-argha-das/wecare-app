import 'package:flutter/material.dart';

import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/duty/attendance.dart';
import 'attendance_card.dart';
import 'face_history_page.dart';

/// ===========================================================================
///  MY ATTENDANCE  (2 tabs)
///
///   Tab 1 - "Face"     : naya face attendance (punch in/out + history)
///   Tab 2 - "Monthly"  : purana calendar view (GET /nurse/attendance)
///
///  Purana screen delete nahi kiya gaya - wahi widget `MonthlyAttendanceTab`
///  ke naam se dusre tab me chalta hai.
/// ===========================================================================

class NurseAttendancePage extends StatelessWidget {
  const NurseAttendancePage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppTheme.primarylight,
        appBar: AppBar(
          title: const Text('My Attendance'),
          centerTitle: true,
          bottom: const TabBar(
            labelColor: AppTheme.primary,
            unselectedLabelColor: AppTheme.textSecondary,
            indicatorColor: AppTheme.primary,
            indicatorWeight: 3,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            tabs: [
              Tab(text: 'Face Attendance'),
              Tab(text: 'Monthly'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_FaceTab(), MonthlyAttendanceTab()],
        ),
      ),
    );
  }
}

class _FaceTab extends StatelessWidget {
  const _FaceTab();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 14, 16, 4),
          child: AttendanceCard(compact: false),
        ),
        const Padding(
          padding: EdgeInsets.fromLTRB(18, 14, 18, 2),
          child: Row(
            children: [
              Icon(Icons.history_rounded, size: 18, color: AppTheme.primary),
              SizedBox(width: 8),
              Text(
                'Is mahine ka record',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.textPrimary,
                ),
              ),
            ],
          ),
        ),
        const Expanded(child: FaceHistoryView()),
      ],
    );
  }
}
