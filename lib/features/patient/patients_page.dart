import 'package:flutter/material.dart';
import 'package:healthcare/features/patient/patient_details_page.dart';

/// =======================
/// 🎨 APP THEME
/// =======================
class AppTheme {
  static const primary = Color(0xff4A6CF7);
  static const bg = Color(0xffF5F7FB);
  static const success = Color(0xff43A047);
  static const danger = Color(0xffE53935);
}

/// =======================
/// 👥 PATIENT LIST + DETAILS PAGE
/// =======================
class PatientsPage extends StatefulWidget {
  const PatientsPage({super.key});

  @override
  State<PatientsPage> createState() => _PatientsPageState();
}

class _PatientsPageState extends State<PatientsPage> {
  int? expandedIndex;

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bg,
      appBar: AppBar(
        title: const Text("Patients"),
        backgroundColor: AppTheme.primary,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: patients.length,
        itemBuilder: (context, index) {
          final patient = patients[index];
          final expanded = expandedIndex == index;

          return Column(
            children: [
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PatientDetailsPage(patient: patient),
                    ),
                  );
                },
                child: _PatientCard(
                  patient: patient,
                  expanded: expanded,
                  onTap: () {
                    setState(() {
                      expandedIndex = expanded ? null : index;
                    });
                  },
                ),
              ),
              if (expanded) _PatientDetails(patient),
            ],
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
  final bool expanded;
  final VoidCallback onTap;

  const _PatientCard({
    required this.patient,
    required this.expanded,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool active = patient["active"];
    final color = active ? AppTheme.success : AppTheme.danger;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => PatientDetailsPage(patient: patient),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NAME + STATUS
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
                  _StatusChip(active: active),
                ],
              ),

              const SizedBox(height: 8),

              Text(
                "${patient["age"]} yrs • ${patient["gender"]}",
                style: const TextStyle(color: Colors.grey),
              ),

              const SizedBox(height: 6),

              Text("Condition: ${patient["condition"]}"),

              const SizedBox(height: 10),

              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: onTap,
                  child: Text(
                    expanded ? "Hide Details ▲" : "View Details ▼",
                    style: TextStyle(
                      color: AppTheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// =======================
/// 📄 PATIENT DETAILS
/// =======================
class _PatientDetails extends StatelessWidget {
  final Map<String, dynamic> patient;
  const _PatientDetails(this.patient);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 20),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 💊 MEDICINES
            _SectionTitle("Medicines"),
            ...(patient["medicines"] as List).isEmpty
                ? [_EmptyText("No medicines prescribed")]
                : (patient["medicines"] as List).map(
                    (m) => ListTile(
                      leading: const Icon(Icons.medication),
                      title: Text(m["name"]),
                      subtitle: Text(
                        "${m["dosage"]} • ${m["frequency"]} • ${m["duration"]}",
                      ),
                    ),
                  ),

            const SizedBox(height: 16),

            /// 📄 REPORTS
            _SectionTitle("Reports"),
            ...(patient["reports"] as List).isEmpty
                ? [_EmptyText("No reports available")]
                : (patient["reports"] as List).map(
                    (r) => ListTile(
                      leading: const Icon(Icons.picture_as_pdf),
                      title: Text(r["title"]),
                      subtitle: Text("${r["date"]} • ${r["status"]}"),
                      trailing: const Icon(Icons.visibility),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

/// =======================
/// 🔹 HELPERS
/// =======================
class _StatusChip extends StatelessWidget {
  final bool active;
  const _StatusChip({required this.active});

  @override
  Widget build(BuildContext context) {
    final color = active ? AppTheme.success : AppTheme.danger;
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
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
      ),
    );
  }
}

class _EmptyText extends StatelessWidget {
  final String text;
  const _EmptyText(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(text, style: const TextStyle(color: Colors.grey)),
    );
  }
}
