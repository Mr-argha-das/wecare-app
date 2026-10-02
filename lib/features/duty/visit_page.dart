import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'package:healthcare/routes/app_routes.dart';
import '../../core/network/api_client.dart';

class VisitPage extends StatefulWidget {
  const VisitPage({super.key});

  @override
  State<VisitPage> createState() => _VisitPageState();
}

class _VisitPageState extends State<VisitPage> {
  List visits = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _loadVisits();
  }

  Future<void> _loadVisits() async {
    try {
      setState(() => loading = true);
      final res = await ApiClient.get("/nurse/nurse/visits");
      print(res);
      visits = res ?? [];
    } catch (e) {
      log(e.toString());
    }
    setState(() => loading = false);
  }

  void _openCompleteDialog(Map visit) async {
    final result = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _CompleteVisitDialog(
        visitId: visit["visit_id"],
        patientId: visit["patient_id"],
      ),
    );

    if (result == true) {
      _snack("Visit completed successfully");
      _loadVisits();
    }
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Patient Visits")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : visits.isEmpty
          ? const Center(child: Text("No visits available"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: visits.length,
              itemBuilder: (context, index) {
                final v = visits[index];
                return _VisitCard(
                  visit: v,
                  onComplete: () => _openCompleteDialog(v),
                  onSOS: () {
                    Navigator.pushNamed(context, AppRoutes.sos);
                  },
                );
              },
            ),
    );
  }
}

/// ================= VISIT CARD =================

/// ================= VISIT CARD =================

class _VisitCard extends StatefulWidget {
  final Map visit;
  final VoidCallback onComplete;
  final VoidCallback onSOS;

  const _VisitCard({
    required this.visit,
    required this.onComplete,
    required this.onSOS,
  });

  @override
  State<_VisitCard> createState() => _VisitCardState();
}

class _VisitCardState extends State<_VisitCard> {
  Map<String, dynamic>? lastVitals;
  bool loadingVitals = false;

  @override
  void initState() {
    super.initState();
    _loadVitals();
  }

  /// 🔥 LOAD LATEST VITALS
  Future<void> _loadVitals() async {
    try {
      loadingVitals = true;

      final res = await ApiClient.get(
        "/nurse/patients/${widget.visit["patient_id"]}/vital-details?limit=1",
      );

      final vitals = res["vitals"];

      if (vitals != null && vitals.isNotEmpty) {
        lastVitals = vitals[0];
      }
    } catch (e) {
      log("Vitals load error: $e");
    }

    setState(() => loadingVitals = false);
  }

  /// 🔥 OPEN BOTTOM SHEET
  void _openVitalsDetails() {
    if (lastVitals == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No previous vitals found")));
      return;
    }

    final patientName = widget.visit["patient_name"] ?? "Unknown";
    String formatDate(String? iso) {
      if (iso == null) return "-";
      final dt = DateTime.tryParse(iso);
      if (dt == null) return iso;

      return "${dt.day}/${dt.month}/${dt.year}  ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}";
    }

    String prettyKey(String key) {
      return key
          .replaceAll("_", " ")
          .split(" ")
          .map((w) => w[0].toUpperCase() + w.substring(1))
          .join(" ");
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              /// 🔥 HEADER
              const SizedBox(height: 4),

              const Text(
                "Previous Vitals",
                style: TextStyle(color: Colors.black54),
              ),

              Text(
                patientName,
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Divider(height: 20),

              /// vitals list
              ...lastVitals!.entries
                  .where((e) => e.key != "id") // hide id
                  .map((e) {
                    if (e.key == "recorded_at") {
                      return _row("Recorded At", formatDate(e.value));
                    }
                    return _row(prettyKey(e.key), e.value);
                  }),
            ],
          ),
        );
      },
    );
  }

  Widget _row(String k, dynamic v) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(k, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(v?.toString() ?? "-"),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visit = widget.visit;
    final bool completed = visit["completed"];
    final List meds = visit["medications"] ?? [];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        elevation: .5,
        borderRadius: BorderRadius.circular(12),
        color: Colors.grey.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// NAME + STATUS + VIEW BUTTON
              Row(
                children: [
                  Expanded(
                    child: Text(
                      visit["patient_name"] ?? "Unknown",
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),

                  _StatusBadge(completed: completed),

                  const SizedBox(width: 6),

                  IconButton(
                    tooltip: "View Vitals",
                    icon: loadingVitals
                        ? const SizedBox(
                            height: 18,
                            width: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.visibility),
                    onPressed: loadingVitals ? null : _openVitalsDetails,
                  ),
                ],
              ),

              SizedBox(height: visit["dutyLocation"] == "HOME" ? 0 : 0),

              // patient_address
              /// ADDRESS
              if (visit["dutyLocation"] == "HOME")
                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 16,
                      color: Colors.black,
                    ),

                    Expanded(
                      child: Text(
                        visit["address"] ?? "-",
                        style: const TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),

              // Row(
              //   children: [
              //     const Icon(Icons.location_on, size: 16, color: Colors.grey),
              //     const SizedBox(width: 6),
              //     Expanded(
              //       child: Text(
              //         visit["patient_address"] ?? "",
              //         style: const TextStyle(color: Colors.grey),
              //       ),
              //     ),
              //   ],
              // ),
              // const SizedBox(height: 8),

              /// WARD / ROOM
              visit["dutyLocation"] == "HOSPITAL"
                  ? Text(
                      "Ward: ${visit["ward"] ?? "-"} | Room: ${visit["room_no"] ?? "-"}",
                      style: const TextStyle(fontSize: 13),
                    )
                  : const SizedBox.shrink(),

              const Divider(height: 24),

              /// MEDS
              if (meds.isNotEmpty) ...[
                const Text(
                  "Medicines",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                ...meds.map((m) => Text(m["medicine_name"])),
              ],

              const SizedBox(height: 12),

              /// BUTTONS
              Row(
                children: [
                  // if (!completed)
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onComplete,
                      child: const Text("Complete"),
                    ),
                  ),
                  // if (!completed)
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      onPressed: widget.onSOS,
                      child: const Text("SOS"),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CompleteVisitDialog extends StatefulWidget {
  final String visitId;
  final String patientId;

  const _CompleteVisitDialog({required this.visitId, required this.patientId});

  @override
  State<_CompleteVisitDialog> createState() => _CompleteVisitDialogState();
}

class _CompleteVisitDialogState extends State<_CompleteVisitDialog> {
  final _formKey = GlobalKey<FormState>();

  /// ================= CONTROLLERS =================

  final noteCtrl = TextEditingController();

  final bpCtrl = TextEditingController();
  final pulseCtrl = TextEditingController();
  final spo2Ctrl = TextEditingController();
  final tempCtrl = TextEditingController();
  final rbsCtrl = TextEditingController();
  final o2Ctrl = TextEditingController();

  final bipapCtrl = TextEditingController();
  final ivCtrl = TextEditingController();
  final suctionCtrl = TextEditingController();
  final feedingCtrl = TextEditingController();
  final vomitingCtrl = TextEditingController();

  final urineCtrl = TextEditingController();
  final stoolCtrl = TextEditingController();
  final otherCtrl = TextEditingController();

  bool loading = false;
  bool consentAccepted = false;

  /// 🔥 store previous vitals for dropdown
  Map<String, dynamic>? lastVitals;

  /// ================= HELPERS =================

  int? _int(String v) => v.isEmpty ? null : int.tryParse(v);
  double? _double(String v) => v.isEmpty ? null : double.tryParse(v);

  /// ================= INIT =================

  /// ================= SUBMIT =================

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => loading = true);

    try {
      print("🚀 SUBMIT START");
      /// 1️⃣ VITALS
      final payload = {
        "bp": bpCtrl.text,
        "pulse": _int(pulseCtrl.text),
        "spo2": _int(spo2Ctrl.text),
        "temperature": _double(tempCtrl.text),
        "o2_level": _int(o2Ctrl.text),
        "rbs": _double(rbsCtrl.text),

        "bipap_ventilator": bipapCtrl.text,
        "iv_fluids": ivCtrl.text,
        "suction": suctionCtrl.text,
        "feeding_tube": feedingCtrl.text,
        "vomit_aspirate": vomitingCtrl.text,
        "urine": urineCtrl.text,
        "stool": stoolCtrl.text,
        "other": otherCtrl.text,
      };

      print("📤 VITALS PAYLOAD => $payload");

      await ApiClient.post(
        "/nurse/patients/${widget.patientId}/vital-details",
        payload,
      );

      /// 2️⃣ COMPLETE VISIT
      await ApiClient.post("/nurse/visits/${widget.visitId}/complete", {});

      /// 3️⃣ OPTIONAL REMARK
      await _openRemarkDialog();

      print("✅ VISIT COMPLETED");

      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (e, s) {
      print("🔥 SUBMIT ERROR => $e");
      print(s);

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to submit")));
    }

    setState(() => loading = false);
  }

  Future<void> _openRemarkDialog() async {
    noteCtrl.clear();

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        bool savingRemark = false;

        return StatefulBuilder(
          builder: (context, setDialogState) {
            Future<void> saveRemark() async {
              final remark = noteCtrl.text.trim();
              if (remark.isEmpty) {
                Navigator.pop(dialogContext);
                return;
              }

              setDialogState(() => savingRemark = true);

              try {
                await ApiClient.post("/nurse/patients/${widget.patientId}/notes", {
                  "title": "Given Medicine",
                  "note": remark,
                });

                if (!dialogContext.mounted) return;
                Navigator.pop(dialogContext);
              } catch (_) {
                if (!dialogContext.mounted) return;
                ScaffoldMessenger.of(dialogContext).showSnackBar(
                  const SnackBar(content: Text("Failed to save remark")),
                );
                setDialogState(() => savingRemark = false);
              }
            }

            return AlertDialog(
              title: const Text("Given Medicine"),
              content: TextFormField(
                controller: noteCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  labelText: "Remark (Optional)",
                  hintText: "Type remark if needed",
                ),
              ),
              actions: [
                TextButton(
                  onPressed: savingRemark
                      ? null
                      : () => Navigator.pop(dialogContext),
                  child: const Text("Skip"),
                ),
                ElevatedButton(
                  onPressed: savingRemark ? null : saveRemark,
                  child: savingRemark
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Text("Save"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  /// ================= UI =================

  void _openVitalsDetails() {
    if (lastVitals == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("No previous vitals found")));
      return;
    }

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: ListView(
            children: [
              const Text(
                "Previous Vitals",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              _vitalRow("BP", lastVitals!["bp"]),
              _vitalRow("Pulse", lastVitals!["pulse"]),
              _vitalRow("SpO2", lastVitals!["spo2"]),
              _vitalRow("Temp", lastVitals!["temperature"]),
              _vitalRow("O2 Level", lastVitals!["o2_level"]),
              _vitalRow("RBS", lastVitals!["rbs"]),
              _vitalRow("IV Fluids", lastVitals!["iv_fluids"]),
              _vitalRow("Suction", lastVitals!["suction"]),
              _vitalRow("R.T/ORAL", lastVitals!["feeding_tube"]),
              _vitalRow("Vomit Aspirate", lastVitals!["vomit_aspirate"]),
              _vitalRow("Urine", lastVitals!["urine"]),
              _vitalRow("Stool", lastVitals!["stool"]),
              _vitalRow("Other", lastVitals!["other"]),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _sectionTitle("Vitals"),
                _grid([
                  _input("BP", bpCtrl),
                  _input("Pulse", pulseCtrl, number: true),
                  _input("SpO2", spo2Ctrl, number: true),
                  _input("Temp", tempCtrl, number: true),
                  _input("O2 Lavel", o2Ctrl, number: true, required: false),
                  _input("RBS", rbsCtrl, number: true, required: false),
                ]),

                _sectionTitle("Supports"),
                _grid([
                  _input("BiPAP", bipapCtrl, required: false),
                  _input("IV Fluids", ivCtrl, required: false),
                  _input("Suction", suctionCtrl, required: false),
                  _input("R.T/ORAL", feedingCtrl, required: false),
                  _input("Vomit Aspirate", vomitingCtrl, required: false),
                ]),

                _sectionTitle("Outputs"),
                _grid([
                  _input("Urine", urineCtrl, required: false),
                  _input("Stool", stoolCtrl, required: false),
                  _input("Other", otherCtrl, required: false),
                ]),

                const SizedBox(height: 14),

                Row(
                  children: [
                    Checkbox(
                      value: consentAccepted,
                      onChanged: (v) =>
                          setState(() => consentAccepted = v ?? false),
                    ),
                    const Expanded(
                      child: Text("I confirm information is correct"),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: loading || !consentAccepted ? null : _submit,
                    child: loading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text("Submit & Complete"),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// ================= DROPDOWN =================

  Widget _previousVitalsDropdown() {
    return ExpansionTile(
      initiallyExpanded: false, // 👈 auto open chahiye? true kar do
      title: const Text(
        "Previous Vitals",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      children: [
        if (lastVitals == null)
          const Padding(
            padding: EdgeInsets.all(12),
            child: Text("Loading or no previous vitals found"),
          )
        else ...[
          _vitalRow("BP", lastVitals!["bp"]),
          _vitalRow("Pulse", lastVitals!["pulse"]),
          _vitalRow("SpO2", lastVitals!["spo2"]),
          _vitalRow("Temp", lastVitals!["temperature"]),
          _vitalRow("O2 Level", lastVitals!["o2_level"]),
          _vitalRow("RBS", lastVitals!["rbs"]),
          _vitalRow("IV Fluids", lastVitals!["iv_fluids"]),
          _vitalRow("Suction", lastVitals!["suction"]),
          _vitalRow("R.T/ORAL", lastVitals!["feeding_tube"]),
          _vitalRow("Vomit Aspirate", lastVitals!["vomit_aspirate"]),
          _vitalRow("Urine", lastVitals!["urine"]),
          _vitalRow("Stool", lastVitals!["stool"]),
          _vitalRow("Other", lastVitals!["other"]),
        ],
      ],
    );
  }

  Widget _vitalRow(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          Text(value?.toString() ?? "-"),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) => Padding(
    padding: const EdgeInsets.only(top: 14, bottom: 6),
    child: Text(
      title,
      style: TextStyle(fontWeight: FontWeight.bold, color: AppTheme.primary),
    ),
  );

  Widget _grid(List<Widget> children) {
    return GridView.count(
      crossAxisCount: 2, // ⭐ always 2 fields
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 3.2, // height control (adjust if needed)
      children: children,
    );
  }

  Widget _input(
    String label,
    TextEditingController ctrl, {
    bool number = false,
    bool required = true,
    int max = 1,
  }) {
    return TextFormField(
      controller: ctrl,
      maxLines: max,
      keyboardType: number ? TextInputType.number : TextInputType.text,
      validator: required
          ? (v) => v == null || v.isEmpty ? "Required" : null
          : null,
      decoration: _inputDecoration(label),
    );
  }
}

InputDecoration _inputDecoration(String label) {
  return InputDecoration(
    labelText: label,
    filled: true,
    fillColor: AppTheme.primarylight,
    // 🔹 normal (unfocused)
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppTheme.primary, width: 1),
    ),

    // 🔹 focused
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: AppTheme.primary, width: 1.8),
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: AppTheme.primary, width: 1),
    ),
  );
}

/// ================= STATUS BADGE =================

class _StatusBadge extends StatelessWidget {
  final bool completed;
  const _StatusBadge({required this.completed});

  @override
  Widget build(BuildContext context) {
    final color = completed ? Colors.green : Colors.orange;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        completed ? "COMPLETED" : "PENDING",
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
