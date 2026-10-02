import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'staff_provider.dart';

class StaffApplyPage extends ConsumerWidget {
  const StaffApplyPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final name = TextEditingController();
    final phone = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text("Apply as Staff")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: name,
              decoration: const InputDecoration(labelText: "Full Name"),
            ),
            TextField(
              controller: phone,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                ref.read(staffProvider.notifier).apply({
                  "full_name": name.text,
                  "phone": phone.text,
                  "staff_type": "GNM",
                });
              },
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}
