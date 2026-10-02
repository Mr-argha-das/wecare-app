import 'package:file_picker/file_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';
import 'dart:io';

import 'package:healthcare/features/auth/nurse_update_password_page.dart';

class PatientUpdateProfilePage extends StatefulWidget {
  const PatientUpdateProfilePage({super.key});

  @override
  State<PatientUpdateProfilePage> createState() =>
      _PatientUpdateProfilePageState();
}

class _PatientUpdateProfilePageState extends State<PatientUpdateProfilePage> {
  final _formKey = GlobalKey<FormState>();

  bool loading = true;
  bool saving = false;

  // ✅ Controllers (INITIALIZED in initState)
  late TextEditingController name;
  late TextEditingController fatherName;
  late TextEditingController phone;
  late TextEditingController password;
  late TextEditingController otherNumber;
  late TextEditingController email;
  late TextEditingController age;
  late TextEditingController gender;
  late TextEditingController address;
  late TextEditingController medicalHistory;

  List documents = [];

  @override
  void initState() {
    super.initState();

    // ✅ Initialize controllers EMPTY (IMPORTANT)
    name = TextEditingController();
    fatherName = TextEditingController();
    phone = TextEditingController();
    password = TextEditingController();
    otherNumber = TextEditingController();
    email = TextEditingController();
    age = TextEditingController();
    gender = TextEditingController();
    address = TextEditingController();
    medicalHistory = TextEditingController();

    _loadProfile();
  }

  // ================= FETCH PROFILE =================
  Future<void> _loadProfile() async {
    try {
      final res = await ApiClient.get("/patient/profile/view");
      final p = res["patient"];
      print("patient $p");
      // ✅ Fill controller values
      name.text = p["name"] ?? "";
      fatherName.text = p["father_name"] ?? "";
      phone.text = p["phone"] ?? "";
      password.text = p["password_hash"] ?? "";
      otherNumber.text = p["other_number"] ?? "";
      email.text = p["email"] ?? "";
      age.text = p["age"]?.toString() ?? "";
      gender.text = p["gender"] ?? "";
      address.text = p["address"] ?? "";
      medicalHistory.text = p["medical_history"] ?? "";

      documents = p["documents"] ?? [];
    } catch (e) {
      _snack(e.toString());
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  Future<void> _addDocument() async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = File(result.files.single.path!);

    try {
      // 🔥 upload file (tumhara existing service)
      final path = await FileUploadService.uploadFile(
        file,
        folder: "patient_documents",
      );

      final res = await ApiClient.post(
        "/patient/${"me"}/add-document", // agar backend me "me" allowed ho
        {"path": path},
      );

      setState(() {
        documents = res["documents"];
      });

      _snack("Document added");
    } catch (e) {
      _snack(e.toString());
    }
  }

  Future<void> _replaceDocument(String oldPath) async {
    final result = await FilePicker.platform.pickFiles();
    if (result == null) return;

    final file = File(result.files.single.path!);

    try {
      final newPath = await FileUploadService.uploadFile(
        file,
        folder: "patient_documents",
      );

      final res = await ApiClient.put("/patient/${"me"}/update-document", {
        "old_path": oldPath,
        "new_path": newPath,
      });

      setState(() {
        documents = res["documents"];
      });

      _snack("Document updated");
    } catch (e) {
      _snack(e.toString());
    }
  }

  Future<void> _deleteDocument(String path) async {
    try {
      final res = await ApiClient.delete("/patient/${"me"}/delete-document", {
        "path": path,
      });

      setState(() {
        documents = res["documents"];
      });

      _snack("Document deleted");
    } catch (e) {
      _snack(e.toString());
    }
  }

  // ================= UPDATE PROFILE =================
  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => saving = true);

    try {
      await ApiClient.put("/patient/profile/update", {
        "name": name.text,
        "father_name": fatherName.text,
        "phone": phone.text,
        "password_hash": password.text,
        "other_number": otherNumber.text,
        "email": email.text,
        "age": int.parse(age.text),
        "gender": gender.text,
        "address": address.text,
        "medical_history": medicalHistory.text,
        "documents": documents,
      });

      _snack("Profile updated successfully");
      Navigator.pop(context);
    } catch (e) {
      _snack(e.toString());
    } finally {
      if (mounted) setState(() => saving = false);
    }
  }

  @override
  void dispose() {
    // ✅ Dispose controllers
    name.dispose();
    fatherName.dispose();
    phone.dispose();
    otherNumber.dispose();
    email.dispose();
    age.dispose();
    gender.dispose();
    address.dispose();
    medicalHistory.dispose();
    super.dispose();
  }

  // ================= UI =================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Update Profile")),
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(height: 16),

                    // GestureDetector(
                    //   onTap: () async {
                    //     // 🔥 async add karo

                    //     final updated = await Navigator.push(
                    //       context,
                    //       CupertinoPageRoute(
                    //         builder: (_) => NurseUpdatePasswordPage(
                    //           phone: phone.text,
                    //           currentPassword: password.text,
                    //         ),
                    //       ),
                    //     );

                    //     if (updated == true) {
                    //       _loadProfile(); // 🔥 correct function name
                    //     }
                    //   },
                    //   child: Container(
                    //     padding: const EdgeInsets.symmetric(
                    //       vertical: 10,
                    //       horizontal: 14,
                    //     ),
                    //     decoration: BoxDecoration(
                    //       color: Colors.white,
                    //       borderRadius: BorderRadius.circular(10),
                    //       border: Border.all(color: AppTheme.primary),
                    //     ),
                    //     child: const Row(
                    //       mainAxisAlignment: MainAxisAlignment.center,
                    //       children: [
                    //         Icon(
                    //           Icons.lock_reset,
                    //           size: 18,
                    //           color: AppTheme.primary,
                    //         ),
                    //         SizedBox(width: 8),
                    //         Text(
                    //           "Update Admin Password",
                    //           style: TextStyle(
                    //             color: AppTheme.primary,
                    //             fontWeight: FontWeight.w600,
                    //           ),
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                    // ),
                    SizedBox(height: 20),

                    _field("Name", name),
                    _field("Father Name", fatherName),
                    _field("Phone", phone, keyboard: TextInputType.phone),
                    _field(
                      "Other Number",
                      otherNumber,
                      keyboard: TextInputType.phone,
                    ),
                    _field(
                      "Email",
                      email,
                      keyboard: TextInputType.emailAddress,
                    ),
                    _field("Age", age, keyboard: TextInputType.number),
                    _field("Gender", gender),
                    _field("Address", address, maxLines: 2),
                    _field("Medical History", medicalHistory, maxLines: 3),

                    const SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: saving ? null : _saveProfile,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: saving
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Save Changes"),
                    ),

                    // const SizedBox(height: 30),

                    // Text(
                    //   "Documents",
                    //   style: TextStyle(
                    //     fontSize: 16,
                    //     fontWeight: FontWeight.bold,
                    //   ),
                    // ),

                    // const SizedBox(height: 12),

                    // // 📄 Document List
                    // if (documents.isEmpty)
                    //   const Text(
                    //     "No documents uploaded",
                    //     style: TextStyle(color: Colors.grey),
                    //   ),

                    // for (final doc in documents)
                    //   Container(
                    //     margin: const EdgeInsets.only(bottom: 10),
                    //     padding: const EdgeInsets.all(10),
                    //     decoration: BoxDecoration(
                    //       border: Border.all(color: Colors.grey.shade300),
                    //       borderRadius: BorderRadius.circular(10),
                    //       color: Colors.white,
                    //     ),
                    //     child: Row(
                    //       children: [
                    //         const Icon(
                    //           Icons.insert_drive_file,
                    //           color: Colors.grey,
                    //         ),
                    //         const SizedBox(width: 8),
                    //         Expanded(
                    //           child: Text(
                    //             doc.split("/").last,
                    //             overflow: TextOverflow.ellipsis,
                    //           ),
                    //         ),
                    //         IconButton(
                    //           icon: const Icon(Icons.edit, size: 18),
                    //           onPressed: () => _replaceDocument(doc),
                    //         ),
                    //         IconButton(
                    //           icon: const Icon(
                    //             Icons.delete,
                    //             size: 18,
                    //             color: Colors.red,
                    //           ),
                    //           onPressed: () => _deleteDocument(doc),
                    //         ),
                    //       ],
                    //     ),
                    //   ),

                    // const SizedBox(height: 12),

                    // // ➕ Add document button
                    // OutlinedButton.icon(
                    //   onPressed: _addDocument,
                    //   icon: const Icon(Icons.upload_file),
                    //   label: const Text("Add Document"),
                    // ),
                  ],
                ),
              ),
            ),
    );
  }

  // ================= FIELD WIDGET =================
  Widget _field(
    String label,
    TextEditingController controller, {
    int maxLines = 1,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboard,
        validator: (v) => v == null || v.trim().isEmpty ? "Required" : null,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),

          // normal
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade400, width: 1),
          ),

          // focused
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppTheme.primary, width: 1),
          ),
        ),
      ),
    );
  }

  void _snack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}
