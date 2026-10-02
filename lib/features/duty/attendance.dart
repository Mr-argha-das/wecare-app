import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class NurseAttendancePage extends StatefulWidget {
  const NurseAttendancePage({super.key});

  @override
  State<NurseAttendancePage> createState() => _NurseAttendancePageState();
}

class _NurseAttendancePageState extends State<NurseAttendancePage> {
  DateTime selectedMonth = DateTime.now();

  bool loading = true;
  bool error = false;

  List<Map<String, dynamic>> attendance = [];

  int present = 0;
  int absent = 0;
  int half = 0;
  int totalDays = 0;

  @override
  void initState() {
    super.initState();
    _loadAttendance();
  }

  // =======================================================
  // 🔥 FETCH ATTENDANCE
  // =======================================================

  Future<void> _loadAttendance() async {
    setState(() {
      loading = true;
      error = false;
    });

    try {
      final monthStr = DateFormat("yyyy-MM").format(selectedMonth);

      final res = await ApiClient.get("/nurse/attendance?month=$monthStr");
      print("Atten $res");
      setState(() {
        attendance = List<Map<String, dynamic>>.from(res["attendance"] ?? []);

        final summary = res["summary"] ?? {};

        present = summary["present"] ?? 0;
        absent = summary["absent"] ?? 0;
        half = summary["half"] ?? 0;
        totalDays = summary["total_days"] ?? attendance.length;

        loading = false;
      });
    } catch (e) {
      setState(() {
        loading = false;
        error = true;
      });

      _snack("Failed to load attendance");
    }
  }

  // =======================================================
  // 🔥 MONTH CHANGE
  // =======================================================

  void _changeMonth(int diff) {
    selectedMonth = DateTime(selectedMonth.year, selectedMonth.month + diff);

    _loadAttendance();
  }

  // =======================================================
  // UI
  // =======================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("My Attendance"), centerTitle: true),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : error
          ? _ErrorView(onRetry: _loadAttendance)
          : RefreshIndicator(
              onRefresh: _loadAttendance,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _MonthSelector(
                      month: selectedMonth,
                      onPrev: () => _changeMonth(-1),
                      onNext: () => _changeMonth(1),
                    ),

                    const SizedBox(height: 20),

                    /// SUMMARY
                    Row(
                      children: [
                        _SummaryCard(
                          title: "Present",
                          count: present,
                          color: Colors.green,
                        ),
                        const SizedBox(width: 10),
                        _SummaryCard(
                          title: "Half",
                          count: half,
                          color: Colors.orange,
                        ),
                        const SizedBox(width: 10),
                        _SummaryCard(
                          title: "Absent",
                          count: absent,
                          color: Colors.red,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    Text(
                      "$present / $totalDays days worked",
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),

                    const SizedBox(height: 20),

                    /// ATTENDANCE
                    ///
                    Expanded(
                      child: _AttendanceCalendar(
                        month: selectedMonth,
                        attendance: attendance,
                      ),
                    ),

                    /// LIST
                    // Expanded(
                    //   child: ListView.builder(
                    //     physics: const AlwaysScrollableScrollPhysics(),
                    //     itemCount: attendance.length,
                    //     itemBuilder: (context, index) {
                    //       final a = attendance[index];

                    //       return _AttendanceTile(
                    //         day: a["day"],
                    //         status: a["status"],
                    //       );
                    //     },
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

////////////////////////////////////////////////////////////////////////
/// CALENDAR VIEW
////////////////////////////////////////////////////////////////////////

class _AttendanceCalendar extends StatelessWidget {
  final DateTime month;
  final List<Map<String, dynamic>> attendance;

  const _AttendanceCalendar({required this.month, required this.attendance});

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();

    /// map day -> status
    final Map<int, String> statusMap = {
      for (var a in attendance) a["day"]: a["status"],
    };

    final daysInMonth = DateUtils.getDaysInMonth(month.year, month.month);

    return GridView.builder(
      physics: const AlwaysScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: daysInMonth,
      itemBuilder: (context, index) {
        final day = index + 1;
        final date = DateTime(month.year, month.month, day);

        final isFuture = date.isAfter(today);

        final status = statusMap[day];

        Color color = Colors.grey.shade500;
        IconData icon = Icons.circle;

        if (!isFuture) {
          switch (status) {
            case "PRESENT":
              color = Colors.green;
              icon = Icons.check;
              break;

            case "HALF":
              color = Colors.orange;
              icon = Icons.timelapse;
              break;

            case "ABSENT":
              color = Colors.red;
              icon = Icons.close;
              break;

            default:
              color = Colors.black;
          }
        }

        return Container(
          decoration: BoxDecoration(
            color: color.withOpacity(0.15),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(.5)),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "$day",
                style: TextStyle(fontWeight: FontWeight.bold, color: color),
              ),
              const SizedBox(height: 4),
              // Icon(icon, size: 16, color: color),
            ],
          ),
        );
      },
    );
  }
}

////////////////////////////////////////////////////////////////////////
/// ERROR VIEW
////////////////////////////////////////////////////////////////////////

class _ErrorView extends StatelessWidget {
  final VoidCallback onRetry;

  const _ErrorView({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
          const SizedBox(height: 10),
          const Text("Failed to load attendance"),
          const SizedBox(height: 10),
          ElevatedButton(onPressed: onRetry, child: const Text("Retry")),
        ],
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////
/// MONTH SELECTOR
////////////////////////////////////////////////////////////////////////

class _MonthSelector extends StatelessWidget {
  final DateTime month;
  final VoidCallback onPrev;
  final VoidCallback onNext;

  const _MonthSelector({
    required this.month,
    required this.onPrev,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(icon: const Icon(Icons.chevron_left), onPressed: onPrev),
        Text(
          DateFormat("MMMM yyyy").format(month),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        IconButton(icon: const Icon(Icons.chevron_right), onPressed: onNext),
      ],
    );
  }
}

////////////////////////////////////////////////////////////////////////
/// SUMMARY CARD
////////////////////////////////////////////////////////////////////////

class _SummaryCard extends StatelessWidget {
  final String title;
  final int count;
  final Color color;

  const _SummaryCard({
    required this.title,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              "$count",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

////////////////////////////////////////////////////////////////////////
/// ATTENDANCE TILE
////////////////////////////////////////////////////////////////////////

class _AttendanceTile extends StatelessWidget {
  final int day;
  final String status;

  const _AttendanceTile({required this.day, required this.status});

  @override
  Widget build(BuildContext context) {
    Color color;
    IconData icon;

    switch (status) {
      case "PRESENT":
        color = Colors.green;
        icon = Icons.check_circle;
        break;

      case "HALF":
        color = Colors.orange;
        icon = Icons.timelapse;
        break;

      default:
        color = Colors.red;
        icon = Icons.cancel;
    }

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color),
        title: Text("Day $day"),
        trailing: Text(
          status,
          style: TextStyle(color: color, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
