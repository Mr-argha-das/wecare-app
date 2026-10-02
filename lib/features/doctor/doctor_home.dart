import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/storage/token_storage.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/auth/about_us_page.dart';
import 'package:healthcare/features/doctor/edit_doctor_profile_page.dart';
import 'package:healthcare/features/doctor/pataint_list.page.dart';
import 'package:healthcare/routes/app_routes.dart';

class DoctorProfilePage extends StatefulWidget {
  const DoctorProfilePage({super.key});

  @override
  State<DoctorProfilePage> createState() => _DoctorProfilePageState();
}

class _DoctorProfilePageState extends State<DoctorProfilePage> {
  Future<dynamic>? _doctorFuture;

  @override
  void initState() {
    super.initState();
    _doctorFuture = ApiClient.get("/doctor/my-patients");
  }

  Future<void> _logout() async {
    final confirmed = await showDialog<bool>(
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
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Logout"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;
    await TokenStorage.clearToken();
    await TokenStorage.clearRole();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, AppRoutes.login, (route) => false);
  }

  Future<void> _deleteAccount() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Delete Account"),
        content: const Text(
          "This action will permanently remove your doctor account and linked profile data. Continue?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Delete"),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

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
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false, // 👈 back button off
        title: const Text(
          "Doctor Profile",
          style: TextStyle(color: Colors.black),
        ),
        actions: [
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

      body: FutureBuilder(
        future: _doctorFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final data = snapshot.data as Map<String, dynamic>;
          final doctor = data["doctor"] ?? {};
          final List patients = data["patients"] ?? [];

          return RefreshIndicator(
            onRefresh: () async {
              setState(() {
                _doctorFuture = ApiClient.get("/doctor/my-patients");
              });
            },
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
              child: Column(
                children: [
                  /// 👨‍⚕️ Doctor Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: _cardDecoration(),
                    child: Stack(
                      children: [
                        // =========================
                        // MAIN CONTENT
                        // =========================
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              doctor["name"] ?? "-",
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            Text(
                              doctor["phone"] ?? "-",
                              style: const TextStyle(fontSize: 12),
                            ),

                            const SizedBox(height: 2),

                            Text(
                              "Specialization: ${doctor["specialization"] ?? "-"}",
                            ),

                            const SizedBox(height: 5),

                            _tag(
                              "${doctor["experience_years"] ?? 0} yrs experience",
                              Colors.green,
                            ),
                          ],
                        ),

                        // =========================
                        // 🔥 EDIT BUTTON (TOP RIGHT)
                        // =========================
                        Positioned(
                          top: 0,
                          right: 0,
                          child: GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const EditDoctorProfilePage(),
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 18,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  /// 📊 Stats
                  Row(
                    children: [
                      _statCard(
                        "Total Patients",
                        data["total_patients"].toString(),
                      ),
                      const SizedBox(width: 12),
                      _statCard(
                        "Experience",
                        "${doctor["experience_years"] ?? 0} yrs",
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Card(
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

                  const SizedBox(height: 20),

                  /// 👥 Patient List
                  Container(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
                    decoration: _cardDecoration(),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Assigned Patients",
                              style: TextStyle(
                                fontSize: 17,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => MyPatientsPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "See All",
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        if (patients.isEmpty)
                          const Center(
                            child: Text(
                              "No patients assigned",
                              style: TextStyle(color: Colors.grey),
                            ),
                          )
                        else
                          ListView.separated(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: patients.length,
                            separatorBuilder: (_, __) =>
                                const Divider(height: 20),
                            itemBuilder: (context, index) {
                              final p = patients[index];
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        p["name"] ?? "-",
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        p["phone"] ?? "-",
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${p["age"] ?? "-"} / ${p["gender"] ?? "-"}",
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  // ================= UI HELPERS =================

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: Colors.grey.shade50,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withOpacity(0.05),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  Widget _tag(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(text, style: TextStyle(color: color, fontSize: 12)),
    );
  }

  Widget _statCard(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: _cardDecoration(),
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
            const SizedBox(height: 7),
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
