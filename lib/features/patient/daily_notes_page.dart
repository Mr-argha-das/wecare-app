import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';

class DailyNotesPage extends StatefulWidget {
  final String patientId;
  const DailyNotesPage({super.key, required this.patientId});

  @override
  State<DailyNotesPage> createState() => _DailyNotesPageState();
}

class _DailyNotesPageState extends State<DailyNotesPage> {
  final ctrl = TextEditingController();
  List notes = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res =
        await ApiClient.get("/nurse/patients/${widget.patientId}/notes");
    setState(() {
      notes = jsonDecode(res.body);
      loading = false;
    });
  }

  Future<void> _save() async {
    await ApiClient.post(
      "/nurse/patients/${widget.patientId}/notes",
      {"note": ctrl.text},
    );
    ctrl.clear();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Daily Notes")),
      body: Column(
        children: [
          Expanded(
            child: loading
                ? const Center(child: CircularProgressIndicator())
                : ListView(
                    children: notes
                        .map(
                          (n) => ListTile(
                            title: Text(n["note"]),
                            subtitle: Text(n["created_at"]),
                          ),
                        )
                        .toList(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: ctrl,
                    decoration:
                        const InputDecoration(hintText: "Write note"),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _save,
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
