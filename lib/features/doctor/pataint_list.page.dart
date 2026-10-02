import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/doctor/pataint_details.dart';

class MyPatientsPage extends StatefulWidget {
  const MyPatientsPage({super.key});

  @override
  State<MyPatientsPage> createState() => _MyPatientsPageState();
}

class _MyPatientsPageState extends State<MyPatientsPage> {
  Future<dynamic>? _patientsFuture;

  /// 🔍 SEARCH STATE
  final TextEditingController _searchCtrl = TextEditingController();
  List _allPatients = [];
  List _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _patientsFuture = ApiClient.get("/doctor/patients");
  }

  void _applySearch(String query) {
    final q = query.toLowerCase().trim();

    setState(() {
      _filteredPatients = _allPatients.where((p) {
        final name = (p["name"] ?? "").toString().toLowerCase();
        final phone = (p["phone"] ?? "").toString().toLowerCase();
        return name.contains(q) || phone.contains(q);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("My Patients")),
      body: FutureBuilder(
        future: _patientsFuture,
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
          final List patients = data["patients"] ?? [];

          /// INIT LISTS ON FIRST LOAD
          if (_allPatients.isEmpty) {
            _allPatients = patients;
            _filteredPatients = List.from(_allPatients);
          }

          return RefreshIndicator(
            onRefresh: () async {
              final res = await ApiClient.get("/doctor/patients");
              setState(() {
                _allPatients = res["patients"] ?? [];
                _filteredPatients = List.from(_allPatients);
                _searchCtrl.clear();
              });
            },
            child: Column(
              children: [
                /// 🔍 SEARCH BAR
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: TextField(
                    controller: _searchCtrl,
                    onChanged: _applySearch,
                    decoration: InputDecoration(
                      hintText: "Search by name or phone",
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: BorderSide.none, // 🔥 remove default border
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: const BorderSide(
                          color: AppTheme.primary,
                          width: 1,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12)),
                        borderSide: const BorderSide(
                          color: AppTheme.primary,
                          width: 1,
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                /// 👥 PATIENT LIST
                Expanded(
                  child: _filteredPatients.isEmpty
                      ? const Center(
                          child: Text(
                            "No patients found",
                            style: TextStyle(color: Colors.grey),
                          ),
                        )
                      : ListView.separated(
                          padding: const EdgeInsets.all(16),
                          itemCount: _filteredPatients.length,
                          separatorBuilder: (_, __) =>
                              const SizedBox(height: 12),
                          itemBuilder: (context, index) {
                            final p = _filteredPatients[index];
                            return _PatientCard(patient: p);
                          },
                        ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// ================= PATIENT CARD =================

class _PatientCard extends StatelessWidget {
  final Map<String, dynamic> patient;

  const _PatientCard({required this.patient});

  String _formatDate(String? isoDate) {
    if (isoDate == null || isoDate.isEmpty) return "-";
    try {
      final dt = DateTime.parse(isoDate);
      return "${dt.day.toString().padLeft(2, '0')}-"
          "${dt.month.toString().padLeft(2, '0')}-"
          "${dt.year}";
    } catch (_) {
      return "-";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// 🔹 NAME / AGE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    patient["name"] ?? "-",
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    patient["phone"] ?? "-",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${patient["age"] ?? "-"} yrs",
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    patient["gender"] ?? "-",
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 📍 ADDRESS
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on, size: 16, color: Colors.grey),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  patient["address"] ?? "-",
                  style: const TextStyle(color: Colors.grey),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          /// 🗓 SERVICE DATES
          Row(
            children: [
              const Icon(Icons.calendar_today, size: 14, color: Colors.grey),
              const SizedBox(width: 6),
              Text(
                "From ${_formatDate(patient["service_start"])}",
                style: const TextStyle(color: Colors.grey),
              ),
              const SizedBox(width: 12),
              Text(
                "To ${_formatDate(patient["service_end"])}",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),

          const SizedBox(height: 12),

          /// 🔘 ACTION
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                CupertinoPageRoute(
                  builder: (_) => PatientDetailPage(patientId: patient["id"]),
                ),
              );
            },
            child: Container(
              height: 40,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text(
                  "View Prescriptions",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
