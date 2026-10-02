import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/auth/about_us_page.dart';
import 'package:healthcare/features/duty/nurse_profile_edit_page.dart';
import '../../core/network/api_client.dart';
import '../../core/storage/token_storage.dart';
import '../../routes/app_routes.dart';

class NurseDetailPage extends StatefulWidget {
  const NurseDetailPage({super.key});

  @override
  State<NurseDetailPage> createState() => _NurseDetailPageState();
}

class _NurseDetailPageState extends State<NurseDetailPage> {
  Map? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _fetchNurseDetail();
  }

  Future<void> _fetchNurseDetail() async {
    try {
      final res = await ApiClient.get("/nurse/profile/me/json");

      print(res);
      setState(() {
        data = res;
        loading = false;
      });
    } catch (e) {
      print("Error fetching nurse details: $e");
      setState(() => loading = false);
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    await TokenStorage.clearToken();
    await TokenStorage.clearRole();
    if (!mounted) return;

    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "This action will permanently remove your account and related profile data. Continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    try {
      await ApiClient.delete("/auth/delete-account", {});
      await TokenStorage.clearToken();
      await TokenStorage.clearRole();
      if (!mounted) return;
      Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Account deactivated successfully")),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }
    if (data == null) {
      return const Scaffold(body: Center(child: Text("No data")));
    }

    final nurse = data!['nurse'];
    final kpi = data!['kpi'];
    final graph = data!['attendance_graph'];

    assert(() {
      print("GRAPH: $graph");
      print("LABELS TYPE: ${graph['labels'][0].runtimeType}");
      print("VALUES TYPE: ${graph['values'][0].runtimeType}");
      return true;
    }());
    final attendanceRecords = data!['attendance_records'];
    final visits = data!['recent_visits'];

    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      // nurse['name'] ??
      appBar: AppBar(
        title: const Text("Nurse Details"),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
          IconButton(
            icon: const Icon(Icons.info_outline), // about icon
            tooltip: "About Us",
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsPage()),
              );
            },
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(14, 6, 14, 0),
        child: Column(
          children: [
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text("Logout"),
                          onTap: _logout,
                        ),
                        const Divider(),
                        ListTile(
                          leading: const Icon(Icons.delete_forever, color: Colors.red),
                          title: const Text("Delete Account"),
                          onTap: _deleteAccount,
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),
            // const SizedBox(height: 20),
            Stack(
              children: [
                /// MAIN CARD
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  color: AppTheme.primary,
                  elevation: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: Row(
                      children: [
                        if (nurse['profile_photo'] != null)
                          CircleAvatar(
                            radius: 42,
                            backgroundImage: NetworkImage(
                              nurse['profile_photo'],
                            ),
                          )
                        else
                          Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),

                            child: const CircleAvatar(
                              radius: 40,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                size: 36,
                                color: AppTheme.primary,
                              ),
                            ),
                          ),

                        const SizedBox(width: 16),

                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                nurse['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                nurse['phone'],
                                style: const TextStyle(
                                  fontSize: 12,
                                  // fontWeight: FontWeigh,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                "${nurse['nurse_type']} Nurse",
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 3),

                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // 🔹 First line (single badge)

                                  // 🔹 Second line (two badges)
                                  Wrap(
                                    spacing: 4,
                                    children: [
                                      if (nurse['aadhaar_verified'] == true)
                                        Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 4,
                                          ),
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 12,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade500,
                                            borderRadius: BorderRadius.circular(
                                              28,
                                            ),
                                          ),

                                          child: const Text(
                                            "Aadhar Verified",
                                            style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      SizedBox(width: 0),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.orange.shade300,
                                          borderRadius: BorderRadius.circular(
                                            28,
                                          ),
                                        ),
                                        child: Text(
                                          // nurse['verification_status'] ?? "N/A",
                                          nurse['digital_signature_verify'] ==
                                                  true
                                              ? "Signed"
                                              : nurse['digital_signature_verify'] ==
                                                    false
                                              ? "Unsigned"
                                              : "N/A",
                                          style: const TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),

                                      // Container(
                                      //   padding: const EdgeInsets.symmetric(
                                      //     horizontal: 12,
                                      //     vertical: 2,
                                      //   ),
                                      //   decoration: BoxDecoration(
                                      //     color: Colors.blue.shade100,
                                      //     borderRadius: BorderRadius.circular(
                                      //       28,
                                      //     ),
                                      //   ),
                                      //   child: Text(
                                      // nurse['police_verification_status'] ??
                                      //     "N/A",
                                      //     style: const TextStyle(
                                      //       fontSize: 12,
                                      //       fontWeight: FontWeight.w600,
                                      //       color: Colors.black87,
                                      //     ),
                                      //   ),
                                      // ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                /// 🔥 TOP RIGHT ICON
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (_) => const NurseEditProfilePage(),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(6),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.edit,
                        size: 18,
                        color: AppTheme.primary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            // ===== KPI CARDS =====
            _buildKpiSection(kpi, nurse),
            const SizedBox(height: 20),

            // ===== ATTENDANCE GRAPH CARD =====
            _buildAttendanceGraphSection(graph),
            const SizedBox(height: 24),

            // ===== LOGOUT BUTTON =====
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _logout,
                  icon: const Icon(Icons.logout, color: Colors.white),
                  label: const Text(
                    "Logout",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildKpiSection(Map kpi, nurse) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = (constraints.maxWidth - 12) / 2;

        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            SizedBox(
              width: double.infinity,
              child: _kpiCard(
                "Police Verification Status",
                nurse['police_verification_status'] ?? "N/A",
                bgColor: Colors.orange.shade400,
              ),
            ),
            SizedBox(
              width: width,
              child: _kpiCard("Attendance", "${kpi['attendance']} Days"),
            ),
            SizedBox(
              width: width,
              child: _kpiCard("Credited Salary", "₹ ${kpi['salary'] ?? '0'}"),
            ),

            // SizedBox(
            //   width: width,
            //   child: _kpiCard(
            //     "Active Duty",
            //     kpi['active_duty'] ?? "N/A",
            //     extra: kpi['shift'],
            //   ),
            // ),
          ],
        );
      },
    );
  }

  Widget _kpiCard(String title, String value, {Color? bgColor, String? extra}) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(12),
      color: bgColor ?? Colors.grey.shade50,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (extra != null)
              Text(
                extra,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }

  // ================= ATTENDANCE GRAPH SECTION =================
  // Widget _buildAttendanceGraphSection(Map graph) {
  //   final maxY =
  //       (graph['values'] as List).fold(0, (a, b) => a > b ? a : b).toDouble() +
  //       1;
  //   return Card(
  //     elevation: .5,
  //     shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
  //     child: Padding(
  //       padding: const EdgeInsets.all(16),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: [
  //           const Text(
  //             "📊 Weekly Attendance",
  //             style: TextStyle(fontWeight: FontWeight.bold),
  //           ),
  //           const SizedBox(height: 12),
  //           SizedBox(
  //             height: 200,
  //             child: BarChart(
  //               BarChartData(
  //                 alignment: BarChartAlignment.spaceAround,
  //                 maxY: maxY,
  //                 barGroups: List.generate(
  //                   graph['values'].length,
  //                   (i) => BarChartGroupData(
  //                     x: i,
  //                     barRods: [
  //                       BarChartRodData(
  //                         toY: (graph['values'][i] as int).toDouble(),
  //                         color: Colors.blue,
  //                       ),
  //                     ],
  //                   ),
  //                 ),
  //                 titlesData: FlTitlesData(
  //                   show: true,
  //                   bottomTitles: AxisTitles(
  //                     sideTitles: SideTitles(
  //                       showTitles: true,
  //                       getTitlesWidget: (value, _) =>
  //                           Text("${graph['labels'][value.toInt()]}"),
  //                     ),
  //                   ),
  //                 ),
  //               ),
  //             ),
  //           ),
  //         ],
  //       ),
  //     ),
  //   );
  // }

  Widget _buildAttendanceGraphSection(Map graph) {
    final List<int> labels = (graph['labels'] as List)
        .map((e) => int.parse(e.toString()))
        .toList();

    final List<int> values = (graph['values'] as List)
        .map((e) => int.parse(e.toString()))
        .toList();

    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 10, 4, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Monthly Attendance",
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 140,
            child: BarChart(
              BarChartData(
                maxY: 1,
                alignment: BarChartAlignment.spaceBetween,
                gridData: FlGridData(show: false),
                borderData: FlBorderData(show: false),

                titlesData: FlTitlesData(
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, _) {
                        final index = value.toInt();
                        if (index < 0 || index >= labels.length) {
                          return const SizedBox();
                        }
                        if (![
                          0,
                          2,
                          4,
                          6,
                          8,
                          10,
                          12,
                          14,
                          16,
                          18,
                          20,
                          22,
                          24,
                          26,
                          28,
                          30,
                        ].contains(index)) {
                          return const SizedBox();
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            labels[index].toString(),
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),

                // 🔥 BARS (present + absent both visible)
                barGroups: List.generate(
                  values.length,
                  (i) => BarChartGroupData(
                    x: i,
                    barRods: [
                      BarChartRodData(
                        toY: values[i] == 1 ? 1 : 0.15, // 👈 important
                        width: 4,
                        borderRadius: BorderRadius.circular(2),
                        color: values[i] == 1
                            ? Colors.green.shade500
                            : Colors.red.shade400,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 12),

          // 🔹 LEGEND
          Row(
            children: [
              _legendDot(Colors.green.shade500, "Present"),
              const SizedBox(width: 16),
              _legendDot(Colors.red.shade400, "Absent"),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
      ],
    );
  }

  Widget _kpiCar8d(String title, String value, {String? extra}) {
    return Material(
      elevation: 2, // 👈 yahin elevation
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade50,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey.shade800),
            ),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (extra != null)
              Text(
                extra,
                style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
              ),
          ],
        ),
      ),
    );
  }

  // ================= GENERIC SECTION CARD =================
  Widget _buildSectionCard(String title, List<Widget> children) {
    return Material(
      elevation: 2, // 👈 yahin elevation
      borderRadius: BorderRadius.circular(12),
      color: Colors.grey.shade50,
      shadowColor: Colors.black.withOpacity(0.2),
      child: Container(
        padding: const EdgeInsets.all(0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}
