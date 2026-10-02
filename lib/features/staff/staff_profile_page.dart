import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../core/theme/app_theme.dart';
import '../../routes/app_routes.dart';

class StaffProfilePage extends StatelessWidget {
  const StaffProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = {
      "full_name": "Riya Sharma",
      "phone": "9876543210",
      "email": "riya@gmail.com",
      "staff_type": "GNM",
      "aadhaar_no": "XXXX-XXXX-1234",
      "aadhaar_verified": true,
      "verification_status": "APPROVED",
      "joining_date": DateTime.now()
          .subtract(const Duration(days: 180))
          .toIso8601String(),
      "base_salary": 18000,
      "is_active": true,
      "qualification_docs": ["GNM Certificate", "Nursing License"],
      "experience_docs": ["2 Years Experience Letter"],
      "signature": null,
    };

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text("Profile"), elevation: 0),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _TopProfileCard(data),
          const SizedBox(height: 16),

          _ActionCard(),
          const SizedBox(height: 16),

          _DetailsCard(data),
          const SizedBox(height: 16),

          _DocsCard(
            "Qualification Documents",
            (data["qualification_docs"] as List?)?.cast<String>() ?? [],
          ),
          const SizedBox(height: 12),

          _DocsCard(
            "Experience Documents",
            (data["experience_docs"] as List?)?.cast<String>() ?? [],
          ),
          const SizedBox(height: 16),

          _SignatureCard(data["signature"].toString()),
          const SizedBox(height: 30),

          /// 🚪 LOGOUT BUTTON
          _LogoutButton(),
        ],
      ),
    );
  }
}

/// 👤 TOP PROFILE CARD
class _TopProfileCard extends StatelessWidget {
  final Map data;
  const _TopProfileCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppTheme.primary, AppTheme.secondary],
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primary.withOpacity(0.25),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 42,
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 44, color: AppTheme.primary),
            ),
            const SizedBox(height: 12),

            Text(
              data["full_name"],
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 6),

            Chip(
              label: Text(data["verification_status"]),
              backgroundColor: Colors.white,
              labelStyle: const TextStyle(
                color: AppTheme.success,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 18),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _MiniInfo("Role", data["staff_type"]),
                _MiniInfo("Phone", data["phone"]),
                _MiniInfo("Salary", "₹${data["base_salary"]}"),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 📥 ACTION CARD
class _ActionCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppTheme.primary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: ListTile(
        leading: const Icon(Icons.download, color: Colors.white),
        title: const Text(
          "Download Staff Records",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
      ),
    );
  }
}

/// 📄 DETAILS CARD
class _DetailsCard extends StatelessWidget {
  final Map data;
  const _DetailsCard(this.data);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Staff Details",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const Divider(),

            _DetailRow("Email", data["email"]),
            _DetailRow("Aadhaar", data["aadhaar_no"]),
            _DetailRow(
              "Joining Date",
              DateFormat(
                "dd MMM yyyy",
              ).format(DateTime.parse(data["joining_date"])),
            ),
            _DetailRow(
              "Aadhaar Verified",
              data["aadhaar_verified"] ? "Yes" : "No",
            ),
            _DetailRow(
              "Account Status",
              data["is_active"] ? "Active" : "Inactive",
            ),
          ],
        ),
      ),
    );
  }
}

/// 📁 DOCUMENTS
class _DocsCard extends StatelessWidget {
  final String title;
  final List<String> docs;

  const _DocsCard(this.title, this.docs);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const Divider(),

            if (docs.isEmpty)
              const Text(
                "No documents uploaded",
                style: TextStyle(color: Colors.grey),
              ),

            ...docs.map(
              (d) => ListTile(
                dense: true,
                leading: const Icon(Icons.description, color: AppTheme.primary),
                title: Text(d),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// ✍️ SIGNATURE
class _SignatureCard extends StatelessWidget {
  final String? signature;
  const _SignatureCard(this.signature);

  @override
  Widget build(BuildContext context) {
    final isValidUrl =
        signature != null &&
        signature!.isNotEmpty &&
        signature != "null" &&
        signature!.startsWith("http");

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 100,
        child: Center(
          child: isValidUrl
              ? Image.network(
                  signature!,
                  errorBuilder: (_, __, ___) {
                    return const Text(
                      "Signature not available",
                      style: TextStyle(color: Colors.grey),
                    );
                  },
                )
              : const Text(
                  "No signature uploaded",
                  style: TextStyle(color: Colors.grey),
                ),
        ),
      ),
    );
  }
}

/// 🚪 LOGOUT BUTTON WITH CONFIRMATION
class _LogoutButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.danger,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      icon: const Icon(Icons.logout),
      label: const Text("LOGOUT"),
      onPressed: () => _confirmLogout(context),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppTheme.danger),
            onPressed: () {
              Navigator.pop(context);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text("Logout"),
          ),
        ],
      ),
    );
  }
}

/// 🔹 SMALL INFO
class _MiniInfo extends StatelessWidget {
  final String label;
  final String value;
  const _MiniInfo(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(color: Colors.white.withOpacity(0.85), fontSize: 12),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String label;
  final String value;
  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
