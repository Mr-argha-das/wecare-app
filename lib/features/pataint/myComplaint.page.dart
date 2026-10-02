import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class MyComplaintsPage extends StatefulWidget {
  const MyComplaintsPage({super.key});

  @override
  State<MyComplaintsPage> createState() => _MyComplaintsPageState();
}

class _MyComplaintsPageState extends State<MyComplaintsPage> {
  Future<dynamic>? _future;
  final TextEditingController _messageCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadComplaints();
  }

  String _complaintType = "Other";

  final List<String> _complaintTypes = [
    "Staff Behavior",
    "Late Arrival",
    "Service Issue",
    "Billing Issue",
    "Equipment Issue",
    "Other",
  ];
  void _loadComplaints() {
    _future = ApiClient.get("/admin/complaint/my-complaints");
  }

  // ---------------- RAISE COMPLAINT ----------------
  Future<void> _submitComplaint() async {
    final msg = _messageCtrl.text.trim();
    if (msg.isEmpty) return;

    try {
      await ApiClient.post("/admin/complaint/create", {
        "message": msg,
        "complaint_type": _complaintType,
      });

      _messageCtrl.clear();
      Navigator.pop(context);
      setState(_loadComplaints);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Complaint raised successfully")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    }
  }

  // ---------------- UI ----------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("My Complaints")),

      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openCreateDialog,
        icon: const Icon(Icons.add),
        label: const Text("Raise Complaint"),
      ),

      body: FutureBuilder<dynamic>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snap.hasError) {
            return Center(
              child: Text(
                snap.error.toString(),
                style: const TextStyle(color: Colors.red),
              ),
            );
          }

          final complaints = snap.data ?? [];

          if (complaints.isEmpty) {
            return const Center(
              child: Text(
                "No complaints raised yet",
                style: TextStyle(color: Colors.grey),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: complaints.length,
            itemBuilder: (_, i) {
              final c = complaints[i];
              return _ComplaintCard(c);
            },
          );
        },
      ),
    );
  }

  // ---------------- CREATE DIALOG ----------------
  void _openCreateDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppTheme.primarylight,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) {
        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Raise Complaint",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),

              // ✅ YAHAN ADD KARNA HAI
              DropdownButtonFormField<String>(
                value: _complaintType,
                items: _complaintTypes
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    _complaintType = val!;
                  });
                },
                decoration: const InputDecoration(
                  labelText: "Complaint Type",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
              ),

              const SizedBox(height: 12),

              TextField(
                controller: _messageCtrl,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: "Write your complaint...",
                  // border: OutlineInputBorder(
                  //   borderRadius: BorderRadius.all(Radius.circular(12)),
                  // ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide.none, // 🔥 remove default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: Colors.redAccent, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                    borderSide: BorderSide(color: AppTheme.primary, width: 1),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _submitComplaint,
                  child: const Text("Submit"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

// ================= CARD =================

class _ComplaintCard extends StatelessWidget {
  final Map data;
  const _ComplaintCard(this.data);

  Color _statusColor(String s) {
    switch (s) {
      case "RESOLVED":
        return Colors.green;
      case "IN_PROGRESS":
        return Colors.orange;
      default:
        return Colors.red;
    }
  }

  @override
  Widget build(BuildContext context) {
    final status = data["status"] ?? "OPEN";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          Text(data["message"] ?? "-", style: const TextStyle(fontSize: 15)),
          const SizedBox(height: 12),

          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
              decoration: BoxDecoration(
                color: _statusColor(status).withOpacity(0.15),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: _statusColor(status),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
