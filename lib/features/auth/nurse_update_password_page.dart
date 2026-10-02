import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class NurseUpdatePasswordPage extends StatefulWidget {
  final String phone;
  final String? currentPassword;

  const NurseUpdatePasswordPage({
    super.key,
    required this.phone,
    this.currentPassword,
  });

  @override
  State<NurseUpdatePasswordPage> createState() =>
      _NurseUpdatePasswordPageState();
}

class _NurseUpdatePasswordPageState extends State<NurseUpdatePasswordPage> {
  final passwordController = TextEditingController();

  bool loading = false;
  bool hide = true;

  // =====================================================
  // INIT
  // =====================================================
  @override
  void initState() {
    super.initState();

    /// ✅ old password prefill
    passwordController.text = widget.currentPassword ?? "";
  }

  @override
  void dispose() {
    passwordController.dispose();
    super.dispose();
  }

  // =====================================================
  // UPDATE PASSWORD
  // =====================================================
  Future<void> updatePassword() async {
    final password = passwordController.text.trim();

    if (password.isEmpty) {
      _toast("Enter password");
      return;
    }

    setState(() => loading = true);

    try {
      await ApiClient.post("/auth/update-password", {
        "phone": widget.phone,
        "password": password,
      });

      _toast("✅ Password updated");
      Navigator.pop(context, true);
    } catch (e) {
      _toast(e.toString().replaceAll("Exception:", ""));
    }

    setState(() => loading = false);
  }

  void _toast(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  // =====================================================
  // UI
  // =====================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Update Password"), centerTitle: true),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                /// phone
                Text(
                  "Phone: ${widget.phone}",
                  style: const TextStyle(color: Colors.grey, fontSize: 13),
                ),

                const SizedBox(height: 25),

                /// 🔐 SINGLE PASSWORD FIELD
                TextField(
                  controller: passwordController,
                  obscureText: hide,
                  autofocus: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hide ? Icons.visibility : Icons.visibility_off,
                      ),
                      onPressed: () => setState(() => hide = !hide),
                    ),
                  ),
                ),

                const SizedBox(height: 30),

                /// button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: loading ? null : updatePassword,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text("Save Password"),
                  ),
                ),
              ],
            ),
          ),

          /// loading
          if (loading)
            Container(
              color: Colors.black26,
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}
