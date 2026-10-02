import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/storage/token_storage.dart';
import 'package:healthcare/core/storage/payment_storage.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/duty/nurse_profile.dart';
import 'package:healthcare/features/payment/payment_verification_page.dart';

import 'dashboard_service.dart';
import 'profile_header_section.dart';
import 'active_visits_section.dart';
import 'weekly_work_graph.dart';
import 'action_cards_section.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<Map<String, dynamic>>? _dashboardFuture;
  bool _checkingConsent = true;

  @override
  void initState() {
    super.initState();
    _bootstrap();
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }

  Future<void> _bootstrap() async {
    try {
      /* ==============================
       1️⃣ Get nurse profile
    ============================== */
      final res = await ApiClient.get("/nurse/profile/me/json");

      final payment = await ApiClient.get("/payments/my-status");
      if (payment["paid"] != true) {
        final nurseId = res["nurse"]["id"]?.toString();
        final orderId = payment["order_id"]?.toString();
        final paymentStatus = payment["status"]?.toString() ?? "not_started";

        if (orderId != null && orderId.isNotEmpty) {
          await PaymentStorage.save(
            orderId: orderId,
            flow: "nurse",
            userId: nurseId,
            localStatus: paymentStatus,
          );
        }
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (_) => PaymentVerificationPage(
              orderId: orderId ?? "Not created",
              flow: "nurse",
              userId: nurseId,
              initialStatus:
                  paymentStatus == "not_started" ? "failed" : paymentStatus,
            ),
          ),
          (_) => false,
        );
        return;
      }

      final isSignatureVerified = res["nurse"]["digital_signature_verify"];

      /* ==============================
       2️⃣ If NOT verified → force logout
    ============================== */

      if (!isSignatureVerified && mounted) {
        _snack(
          "Verification pending ⚠️\nPlease wait for admin approval.\nYou will receive an email after verification.",
          error: true,
        );

        await Future.delayed(const Duration(seconds: 0));

        Navigator.pushReplacementNamed(context, "/login");
        return;
      }

      /* ==============================
       3️⃣ Load dashboard normally
    ============================== */

      if (!mounted) return;

      setState(() {
        _dashboardFuture = DashboardService.fetchDashboard();
        _checkingConsent = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() => _checkingConsent = false);
      _showError(e.toString());
    }
  }

  void _showError(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
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

    /// 🔐 CLEAR TOKEN
    await TokenStorage.clearToken();
    await TokenStorage.clearRole();

    if (!mounted) return;

    /// 🚪 Redirect to Login
    Navigator.pushNamedAndRemoveUntil(context, "/login", (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    /// 🔒 While consent is being checked
    if (_checkingConsent || _dashboardFuture == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>>(
          future: _dashboardFuture,
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

            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No dashboard data"));
            }
            final data = snapshot.data!;
            final Map<String, dynamic> nurse =
                (data["nurse"] as Map<String, dynamic>?) ?? {};
            print(nurse);

            return RefreshIndicator(
              onRefresh: () async {
                setState(() {
                  _dashboardFuture = DashboardService.fetchDashboard();
                });
              },
              child: CustomScrollView(
                slivers: [
                  /// 🔷 HEADER
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            CupertinoPageRoute(
                              builder: (context) => NurseDetailPage(),
                            ),
                          );
                        },
                        child: ProfileHeader(
                          name: nurse["name"] ?? "N/A",
                          profile: nurse["profile"] ?? "",
                          // ward: "1",
                          nurseType: nurse["nurse_type"] ?? "-",
                          status: nurse["status"] ?? "Unknown",
                          workedTime: nurse["worked_time"]?.toString() ?? "0",
                          onProfilePressed: () {
                            Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (context) => const NurseDetailPage(),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),

                  /// 📍 TODAY VISITS
                  _Section(
                    title: "Today's Visits",
                    child: ActiveVisitsSection(
                      visits: data["today_visits"] ?? [],
                    ),
                  ),

                  /// 📊 WEEKLY GRAPH
                  _Section(
                    title: "Weekly Work Hours",
                    child: WeeklyWorkGraph(hours: data["weekly_hours"] ?? []),
                  ),

                  /// ⚡ ACTIONS
                  _Section(
                    title: "Quick Actions",
                    child: ActionCardsSection(
                      staffId: nurse["nurse_id"] ?? "",
                      status: nurse["status"] ?? "Unknown",
                    ),
                  ),

                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// ================= SECTION WRAPPER =================

class _Section extends StatelessWidget {
  final String title;
  final Widget child;

  const _Section({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color? color;

  const _InfoCard({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final themeColor = color ?? Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: themeColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: themeColor.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: themeColor, size: 26),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14.5,
                color: Colors.grey.shade800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
