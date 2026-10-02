import 'package:flutter/material.dart';
import 'package:healthcare/core/network/api_client.dart';
import '../../core/theme/app_theme.dart';
import 'package:flutter_html/flutter_html.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  Map<String, dynamic>? about;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  /* =====================================================
      🔹 LOAD ABOUT DATA
  ===================================================== */
  Future<void> _load() async {
    try {
      final res = await ApiClient.getWithoutTokern("/nurse/about-us-get");

      setState(() {
        about = res;
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
    }
  }

  /* =====================================================
      🔹 UI
  ===================================================== */
  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final name = about?["name"] ?? "";
    final designation = about?["designation"] ?? "";
    final description = about?["description"] ?? "";
    final image = about?["profile_image"] ?? "";

    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("About Us"), centerTitle: true),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// 🔵 Profile Image (same as old)
            Center(
              child: CircleAvatar(
                radius: 70,
                backgroundColor: Colors.grey.shade200,
                backgroundImage: image.isNotEmpty ? NetworkImage(image) : null,
                child: image.isEmpty
                    ? const Icon(Icons.person, size: 60)
                    : null,
              ),
            ),

            const SizedBox(height: 20),

            /// 🔵 Name (same styling as old)
            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 6),

            /// 🔵 Designation
            Text(
              designation,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
            ),

            const SizedBox(height: 30),

            /// 🔵 Description Card (same like OLD)
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(0),
              child: Html(
                data: description,
                style: {
                  "body": Style(
                    fontSize: FontSize(16),
                    lineHeight: LineHeight(1.5),
                    color: Colors.grey.shade800,
                  ),
                },
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
