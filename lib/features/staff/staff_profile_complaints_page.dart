import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/storage/token_storage.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/routes/app_routes.dart';

class StaffProfileComplaintsPage extends StatefulWidget {
  const StaffProfileComplaintsPage({super.key});

  @override
  State<StaffProfileComplaintsPage> createState() =>
      _StaffProfileComplaintsPageState();
}

class _StaffProfileComplaintsPageState
    extends State<StaffProfileComplaintsPage> {
  late Future<dynamic> _profileFuture;
  late Future<dynamic> _complaintsFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    _profileFuture = ApiClient.get("/staff/profile");
    _complaintsFuture = ApiClient.get("/admin/complaint/all");
  }

  void _reload() {
    setState(() {
      _loadData();
    });
  }

  Color _statusColor(String s) {
    switch (s) {
      case "OPEN":
        return Colors.orange;
      case "IN_PROGRESS":
        return Colors.blue;
      case "RESOLVED":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(
        title: const Text("My Profile & Complaints"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _reload),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            /// ================= PROFILE =================
            FutureBuilder<dynamic>(
              future: _profileFuture,
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const _LoadingCard();
                }

                if (snap.hasError) {
                  return _errorCard(snap.error.toString());
                }

                final p = snap.data;
                return _Card(
                  title: "👤 My Profile",
                  child: Column(
                    children: [
                      _row("Name", p["name"]),
                      _row("Role", p["role"]),
                      _row("Phone", p["phone"]),
                      _row("Email", p["email"] ?? "-"),
                      _row("Alt Number", p["other_number"] ?? "-"),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Chip(
                          label: Text(
                            p["is_active"] ? "ACTIVE" : "INACTIVE",
                            style: const TextStyle(color: Colors.white),
                          ),
                          backgroundColor: p["is_active"]
                              ? Colors.green
                              : Colors.red,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            /// ================= COMPLAINTS =================
            FutureBuilder<dynamic>(
              future: _complaintsFuture,
              builder: (_, snap) {
                if (snap.connectionState == ConnectionState.waiting) {
                  return const _LoadingCard();
                }

                if (snap.hasError) {
                  return _errorCard(snap.error.toString());
                }

                final complaints = snap.data!;
                if (complaints.isEmpty) {
                  return const _Card(
                    title: "📝 Complaints",
                    child: Text(
                      "No complaints found",
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                }

                return _Card(
                  title: "📝 Complaints",
                  child: Column(
                    children: complaints.map<Widget>((c) {
                      return _ComplaintCard(
                        complaint: c,
                        statusColor: _statusColor,
                        onAccept: () async {
                          await ApiClient.post(
                            "/admin/complaint/in-progress?complaint_id=${c["id"]}",
                            {},
                          );
                          _reload();
                        },
                        onResolve: () async {
                          await ApiClient.post(
                            "/admin/complaint/resolve?complaint_id=${c["id"]}",
                            {},
                          );
                          _reload();
                        },
                      );
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GestureDetector(
          onTap: () async {
            await TokenStorage.clearToken();
            await TokenStorage.clearRole();
            if (!mounted) return;
            Navigator.pushNamedAndRemoveUntil(
              context,
              AppRoutes.login,
              (route) => false,
            );
          },
          child: Container(
            height: 50,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(20),
            ),
            alignment: Alignment.center,
            child: const Text(
              "Logout",
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _row(String label, dynamic val) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(label, style: const TextStyle(color: Colors.grey)),
          ),
          Expanded(
            child: Text(
              val?.toString() ?? "-",
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _errorCard(String msg) {
    return _Card(
      title: "Error",
      child: Text(msg, style: const TextStyle(color: Colors.red)),
    );
  }
}

/// ================= COMPLAINT CARD =================

class _ComplaintCard extends StatelessWidget {
  final Map complaint;
  final Color Function(String) statusColor;
  final VoidCallback onAccept;
  final VoidCallback onResolve;

  const _ComplaintCard({
    required this.complaint,
    required this.statusColor,
    required this.onAccept,
    required this.onResolve,
  });

  @override
  Widget build(BuildContext context) {
    final status = complaint["status"];

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            complaint["message"],
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Chip(
                label: Text(
                  status,
                  style: const TextStyle(color: Colors.white),
                ),
                backgroundColor: statusColor(status),
              ),
              Row(
                children: [
                  if (status == "OPEN")
                    _ActionBtn(
                      text: "Accept",
                      color: Colors.orange,
                      onTap: onAccept,
                    ),
                  if (status != "RESOLVED") const SizedBox(width: 8),
                  if (status != "RESOLVED")
                    _ActionBtn(
                      text: "Resolve",
                      color: Colors.green,
                      onTap: onResolve,
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ================= UI HELPERS =================

class _ActionBtn extends StatelessWidget {
  final String text;
  final Color color;
  final VoidCallback onTap;

  const _ActionBtn({
    required this.text,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;

  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(40),
      child: Center(child: CircularProgressIndicator()),
    );
  }
}
