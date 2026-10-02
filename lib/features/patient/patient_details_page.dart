import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

class PatientDetailsPage extends StatelessWidget {
  final Map<String, dynamic> patient;
  const PatientDetailsPage({super.key, required this.patient});

  @override
  Widget build(BuildContext context) {
    final bool active = patient["active"] ?? false;

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(title: const Text("Patient Details")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          /// 👤 HEADER
          _Header(patient: patient, active: active),

          const SizedBox(height: 20),

          /// ℹ BASIC INFO
          _Card(
            title: "Basic Information",
            children: [
              _infoRow("Age", "${patient["age"]} years"),
              _infoRow("Gender", patient["gender"]),
              _infoRow("Condition", patient["condition"]),
            ],
          ),

          const SizedBox(height: 20),

          /// 💊 MEDICINES
          _MedicinesSection(medicines: patient["medicines"] ?? []),

          const SizedBox(height: 20),

          /// 📄 REPORTS
          _ReportsSection(reports: patient["reports"] ?? []),

          const SizedBox(height: 32),
        ],
      ),
    );
  }
}

/// =======================
/// 👤 HEADER CARD
/// =======================
class _Header extends StatelessWidget {
  final Map patient;
  final bool active;
  const _Header({required this.patient, required this.active});

  @override
  Widget build(BuildContext context) {
    final statusColor = active ? AppTheme.success : AppTheme.danger;

    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            CircleAvatar(
              radius: 36,
              backgroundColor: AppTheme.primarySoft,
              child: const Icon(Icons.person, size: 38),
            ),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient["name"],
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "${patient["age"]} yrs • ${patient["gender"]}",
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),

            Chip(
              label: Text(active ? "ACTIVE" : "INACTIVE"),
              backgroundColor: statusColor.withOpacity(0.15),
              labelStyle: TextStyle(
                color: statusColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// 💊 MEDICINES SECTION
/// =======================
class _MedicinesSection extends StatelessWidget {
  final List medicines;
  const _MedicinesSection({required this.medicines});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Medicine Details",
      children: medicines.isEmpty
          ? [_empty("No medicines prescribed")]
          : medicines.map<Widget>((m) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.medication),
                title: Text(m["name"]),
                subtitle: Text(
                  "${m["dosage"]} • ${m["frequency"]} • ${m["duration"]}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              );
            }).toList(),
    );
  }
}

/// =======================
/// 📄 REPORTS SECTION
/// =======================
class _ReportsSection extends StatelessWidget {
  final List reports;
  const _ReportsSection({required this.reports});

  @override
  Widget build(BuildContext context) {
    return _Card(
      title: "Medical Reports",
      children: reports.isEmpty
          ? [_empty("No reports available")]
          : reports.map<Widget>((r) {
              return ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.picture_as_pdf),
                title: Text(r["title"]),
                subtitle: Text(
                  "${r["date"]} • ${r["status"]}",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                trailing: const Icon(Icons.visibility),
              );
            }).toList(),
    );
  }
}

/// =======================
/// 🃏 GENERIC CARD
/// =======================
class _Card extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _Card({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 8,
      shadowColor: Colors.black.withOpacity(0.08),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const Divider(),
            ...children,
          ],
        ),
      ),
    );
  }
}

/// =======================
/// 🔹 HELPERS
/// =======================
Widget _infoRow(String label, String value) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(color: AppTheme.textSecondary)),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    ),
  );
}

Widget _empty(String text) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Text(text, style: const TextStyle(color: AppTheme.textSecondary)),
  );
}
