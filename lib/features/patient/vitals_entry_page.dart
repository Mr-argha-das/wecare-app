import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';

class VitalsEntryPage extends StatefulWidget {
  final String patientId;
  const VitalsEntryPage({super.key, required this.patientId});

  @override
  State<VitalsEntryPage> createState() => _VitalsEntryPageState();
}

class _VitalsEntryPageState extends State<VitalsEntryPage> {
  final bp = TextEditingController();
  final pulse = TextEditingController();
  final spo2 = TextEditingController();
  final temp = TextEditingController();
  final sugar = TextEditingController();
  bool loading = false;

  Future<void> _save() async {
    setState(() => loading = true);

    await ApiClient.post(
      "/nurse/patients/${widget.patientId}/vitals",
      {
        "bp": bp.text,
        "pulse": int.parse(pulse.text),
        "spo2": int.parse(spo2.text),
        "temperature": double.parse(temp.text),
        "sugar": sugar.text.isEmpty ? null : double.parse(sugar.text),
      },
    );

    setState(() => loading = false);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Enter Vitals")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _f("BP", bp),
            _f("Pulse", pulse),
            _f("SpO₂", spo2),
            _f("Temperature", temp),
            _f("Sugar", sugar),
            const Spacer(),
            ElevatedButton(
              onPressed: loading ? null : _save,
              child: const Text("SAVE VITALS"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _f(String l, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(labelText: l),
      ),
    );
  }
}
