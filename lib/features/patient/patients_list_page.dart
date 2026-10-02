import 'package:flutter/material.dart';
import 'package:healthcare/features/patient/patient_details_page.dart';

/// 🎨 APP THEME COLORS (light reference)
class AppTheme {
  static const primary = Color(0xff4A6CF7);
  static const bg = Color(0xffF5F7FB);
  static const success = Color(0xff43A047);
}

/// =======================
/// 👥 PATIENTS LIST PAGE
/// =======================
class PatientsListPage extends StatelessWidget {
  const PatientsListPage({super.key});

  @override
  Widget build(BuildContext context) {
    /// 🔹 SINGLE PATIENT DATA STRUCTURE
    final List<Map<String, dynamic>> patients = [
      {
        "name": "Anita Verma",
        "age": 45,
        "gender": "Female",
        "condition": "Diabetes",
        "active": true,
        "medicines": [
          {
            "name": "Metformin",
            "dosage": "500 mg",
            "frequency": "Twice a day",
            "duration": "30 Days",
          },
          {
            "name": "Insulin",
            "dosage": "10 Units",
            "frequency": "Once a day",
            "duration": "15 Days",
          },
        ],
        "reports": [
          {
            "title": "Blood Sugar Report",
            "date": "12 Sep 2024",
            "status": "Normal",
          },
          {"title": "ECG Report", "date": "05 Sep 2024", "status": "Reviewed"},
        ],
      },
      {
        "name": "Rajesh Kumar",
        "age": 60,
        "gender": "Male",
        "condition": "Heart Patient",
        "active": false,
        "medicines": [
          {
            "name": "Aspirin",
            "dosage": "75 mg",
            "frequency": "Once a day",
            "duration": "60 Days",
          },
        ],
        "reports": [
          {"title": "ECG Report", "date": "20 Aug 2024", "status": "Critical"},
        ],
      },
    ];

    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text("Patients"),
        backgroundColor: AppTheme.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: patients.length,
        itemBuilder: (_, i) {
          final patient = patients[i];
          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PatientDetailsPage(patient: patient),
                ),
              );
            },
            child: _PatientCard(patient: patient),
          );
        },
      ),
    );
  }
}

/// =======================
/// 🧾 PATIENT CARD
/// =======================
class _PatientCard extends StatelessWidget {
  final Map<String, dynamic> patient;
  const _PatientCard({required this.patient});

  @override
  Widget build(BuildContext context) {
    final bool active = patient["active"];

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 14),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  patient["name"],
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                _StatusChip(active),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              "${patient["age"]} yrs • ${patient["gender"]}",
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 6),
            Text("Condition: ${patient["condition"]}"),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PatientDetailsPage(patient: patient),
                    ),
                  );
                },
                child: const Text("View Details"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// 🟢🔴 STATUS CHIP
/// =======================
class _StatusChip extends StatelessWidget {
  final bool active;
  const _StatusChip(this.active);

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.success : Colors.grey;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        active ? "ACTIVE" : "INACTIVE",
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
