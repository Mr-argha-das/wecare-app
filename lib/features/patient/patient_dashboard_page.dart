import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';

class PatientDashboardPage extends StatefulWidget {
  final String patientId;
  const PatientDashboardPage({super.key, required this.patientId});

  @override
  State<PatientDashboardPage> createState() => _PatientDashboardPageState();
}

class _PatientDashboardPageState extends State<PatientDashboardPage> {
  Map<String, dynamic>? data;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final res = await ApiClient.get("/nurse/patients/${widget.patientId}");
    setState(() {
      data = jsonDecode(res.body);
      loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Patient Dashboard")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Card(
              color: Theme.of(context).colorScheme.secondary,
              child: ListTile(
                leading: const Icon(Icons.person),
                title: Text(data!["name"]),
                subtitle: Text("${data!["age"]} yrs • ${data!["gender"]}"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
