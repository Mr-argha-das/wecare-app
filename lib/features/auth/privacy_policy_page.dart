import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Privacy Policy")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(_privacyText, style: TextStyle(fontSize: 14, height: 1.6)),
      ),
    );
  }
}

const String _privacyText = """
WECARE360 GLOBAL HOME HEALTHCARE PRIVATE LIMITED respects your privacy.

1. DATA COLLECTION
We collect personal data including:
• Name, phone number, address
• Identity and qualification documents
• Profile photos
• Device and app usage data
• Live location (for nurses/caregivers during duty hours only)

2. LIVE LOCATION DATA (NURSES / CAREGIVERS)
• Live location is collected only during active duty
• Used for duty verification, patient safety, and service monitoring
• Location access is disabled automatically after duty completion
• We do not track users continuously or without consent

3. USER CONSENT
By registering and using the app, users voluntarily consent to data collection.
Permissions are requested explicitly and can be revoked by the user.

4. DATA USAGE
Data is used for:
• Service delivery
• Staff verification
• Compliance and legal obligations
• Platform improvement

5. DATA SHARING
We do not sell personal data.
Data is shared only with:
• Authorized internal teams
• Legal authorities when required by law

6. DATA SECURITY
We use reasonable technical and organizational measures to protect user data.

7. WITHDRAWAL OF CONSENT
Users may withdraw consent in writing.
Service access may be limited upon withdrawal.

8. POLICY UPDATES
Privacy Policy may be updated periodically.
Continued use indicates acceptance.

9. CONTACT
Email: wcare823@gmail.com
Registered Office: Ahmedabad, Gujarat, India
""";
