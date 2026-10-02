import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class PrescribeMedicinePage extends StatefulWidget {
  final String patientId;
  
  const PrescribeMedicinePage({super.key, required this.patientId});
  
  @override
  State<PrescribeMedicinePage> createState() => _PrescribeMedicinePageState();
}

class _PrescribeMedicinePageState extends State<PrescribeMedicinePage> {
  Future<dynamic>? _medicineFuture;
  List<Map<String, dynamic>> selectedMeds = [];

  String search = "";
  final TextEditingController durationCtrl = TextEditingController(text: "5");
  final TextEditingController notesCtrl = TextEditingController();

  final List<String> timingOptions = ["Morning", "Afternoon", "Night"];

  final Set<String> selectedTimings = {"Morning"};

  @override
  void initState() {
    super.initState();
    _medicineFuture = ApiClient.get("/md/admin/medicine");
  }

  Future<void> _submitPrescription() async {
    if (selectedMeds.isEmpty) {
      _showMsg("Select at least one medicine");
      return;
    }

    try {
      final notesList = notesCtrl.text
          .split("\n")
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();

      for (final med in selectedMeds) {
        await ApiClient.post("/patient/doctor/prescribe-from-master", {
          "patient_id": widget.patientId,
          "medicine_id": med["id"],
          "timing": selectedTimings.toList(),
          "duration_days": int.parse(durationCtrl.text),
          "notes": notesList,
        });
      }

      _showMsg("Medicines prescribed successfully", success: true);
      Navigator.pop(context, true);
    } catch (e) {
      _showMsg(e.toString());
    }
  }

  void _showMsg(String msg, {bool success = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: success ? Colors.green : Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Prescribe Medicines")),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(14),
        child: ElevatedButton(
          onPressed: _submitPrescription,
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            "Prescribe Selected Medicines",
            style: TextStyle(fontSize: 16),
          ),
        ),
      ),

      body: FutureBuilder(
        future: _medicineFuture,
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

          final List meds = snapshot.data as List;

          final filtered = meds.where((m) {
            final q = search.toLowerCase();
            return m["name"].toLowerCase().contains(q) ||
                m["company"].toLowerCase().contains(q);
          }).toList();

          return Column(
            children: [
              /// 🔍 Search
              Padding(
                padding: const EdgeInsets.all(16),
                child: TextField(
                  decoration: const InputDecoration(
                    hintText: "Search medicine...",
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide.none, // 🔥 remove default border
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: AppTheme.primary, width: 1),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                      borderSide: BorderSide(color: AppTheme.primary, width: 1),
                    ),
                  ),
                  onChanged: (v) {
                    setState(() => search = v);
                  },
                ),
              ),

              /// ⏰ Timing & Duration
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Timings",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Wrap(
                      spacing: 10,
                      children: timingOptions.map((t) {
                        return FilterChip(
                          label: Text(
                            t,
                            style: TextStyle(
                              color: selectedTimings.contains(t)
                                  ? Colors.white
                                  : Colors.black87,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          selected: selectedTimings.contains(t),
                          onSelected: (val) {
                            setState(() {
                              val
                                  ? selectedTimings.add(t)
                                  : selectedTimings.remove(t);
                            });
                          },
                          selectedColor: AppTheme.primary, // 🔥 selected bg
                          backgroundColor:
                              Colors.grey.shade100, // 🔹 unselected bg
                          checkmarkColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20,
                            ), // pill shape
                            side: BorderSide(
                              color: selectedTimings.contains(t)
                                  ? AppTheme.primary
                                  : Colors.grey.shade300,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: durationCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: "Duration (days)",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide.none, // 🔥 remove default border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppTheme.primary,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppTheme.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 12),

                    const Text(
                      "Doctor Notes / Instructions",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),

                    const SizedBox(height: 6),

                    TextField(
                      controller: notesCtrl,
                      maxLines: 3,
                      decoration: const InputDecoration(
                        hintText:
                            "Enter each instruction on new line\nExample:\nTake after food\nDrink water",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide:
                              BorderSide.none, // 🔥 remove default border
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppTheme.primary,
                            width: 1,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(12)),
                          borderSide: BorderSide(
                            color: AppTheme.primary,
                            width: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              /// 💊 Medicine List
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) {
                    final med = filtered[index];
                    final selected = selectedMeds.any(
                      (m) => m["id"] == med["id"],
                    );

                    return Card(
                      elevation: .5,
                      color: Colors.grey.shade50,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: CheckboxListTile(
                        value: selected,
                        onChanged: (val) {
                          setState(() {
                            val == true
                                ? selectedMeds.add(med)
                                : selectedMeds.removeWhere(
                                    (m) => m["id"] == med["id"],
                                  );
                          });
                        },

                        title: Text(
                          med["name"],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(med["company"]),
                            Text("${med["dosage"]} • ${med["form"]}"),
                          ],
                        ),
                        secondary: Text(
                          "₹${med["price"]}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
