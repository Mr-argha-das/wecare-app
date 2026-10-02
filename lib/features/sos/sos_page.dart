import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/features/duty/nurse_service.dart';
import 'package:healthcare/features/sos/patient_search_delegate.dart';
import 'package:healthcare/features/sos/sos_service.dart';

class SOSPage extends StatefulWidget {
  const SOSPage({super.key});

  @override
  State<SOSPage> createState() => _SOSPageState();
}

class _SOSPageState extends State<SOSPage> {
  final TextEditingController ctrl = TextEditingController();

  bool loading = false;
  bool loadingPatients = true;

  List<Map<String, dynamic>> patients = [];
  Map<String, dynamic>? selectedPatient;

  @override
  void initState() {
    super.initState();
    _loadPatients();
  }

  Future<void> _loadPatients() async {
    try {
      final data = await NurseService.getPatients();
      setState(() {
        patients = data;
        loadingPatients = false;
      });
    } catch (e) {
      loadingPatients = false;
      _snack("Failed to load patients", error: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(
        title: const Text(
          "Emergency SOS",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            /// 🔴 WARNING
            Card(
              color: Colors.red.shade50,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Icon(
                      Icons.warning_amber_rounded,
                      color: Colors.red,
                      size: 36,
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        "Use SOS only in real emergencies.\nAdmin will be alerted immediately.",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// 🧑‍⚕️ PATIENT SELECT
            GestureDetector(
              onTap: loadingPatients ? null : _openPatientSearch,
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      const Icon(Icons.person),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          selectedPatient == null
                              ? "Select Patient"
                              : "${selectedPatient!["name"]} • Room ${selectedPatient!["room_no"] ?? "-"}",
                          style: TextStyle(
                            fontSize: 16,
                            color: selectedPatient == null
                                ? Colors.grey
                                : Colors.black,
                          ),
                        ),
                      ),
                      const Icon(Icons.search),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 14),

            /// 📝 MESSAGE
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: TextField(
                  controller: ctrl,
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText:
                        "Describe the emergency (accident, threat, medical issue...)",
                    hintStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey.shade100, // 🔥 background
                    contentPadding: const EdgeInsets.all(14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primary,
                        width: 1,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.red,
                        width: .5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: AppTheme.primary,
                        width: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            const Spacer(),

            /// 🚨 SEND BUTTON
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                // icon: const Icon(Icons.sos, size: 28),
                label: loading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(
                        "SEND SOS",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onPressed: loading ? null : _sendSOS,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 🔍 SEARCH DIALOG
  void _openPatientSearch() async {
    final result = await showSearch(
      context: context,
      delegate: PatientSearchDelegate(patients),
    );

    if (result != null) {
      setState(() => selectedPatient = result);
    }
  }

  /// 🚨 SEND SOS
  Future<void> _sendSOS() async {
    if (selectedPatient == null) {
      _snack("Please select a patient", error: true);
      return;
    }

    if (ctrl.text.trim().isEmpty) {
      _snack("Please enter emergency message", error: true);
      return;
    }

    try {
      setState(() => loading = true);

      await SOSService.triggerSOS(
        patientId: selectedPatient!["patient_id"],
        message: ctrl.text,
      );

      _snack("SOS sent successfully");
      Navigator.pop(context);
    } catch (e) {
      _snack(e.toString(), error: true);
    } finally {
      setState(() => loading = false);
    }
  }

  void _snack(String msg, {bool error = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: error ? Colors.red : Colors.green,
      ),
    );
  }
}
