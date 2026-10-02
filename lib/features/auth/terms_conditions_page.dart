import 'package:flutter/material.dart';
import 'package:healthcare/core/theme/app_theme.dart';

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.primarylight,
      appBar: AppBar(title: const Text("Terms & Conditions")),
      body: const SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Text(_termsText, style: TextStyle(fontSize: 14, height: 1.6)),
      ),
    );
  }
}

const String _termsText = """
Effective Date: 08 / 08 / 2026

These Terms & Conditions ("Terms") govern the use of the website, mobile application, 
and services provided by WECARE360 GLOBAL HOME HEALTHCARE PRIVATE LIMITED ("Company", 
"WECARE360", "we", "our", "us"). By using our services, you agree to these Terms.

1. ABOUT THE COMPANY
WECARE360 provides care-taking and support staff sourcing services including nurses, 
caregivers, attendants, and related manpower for home healthcare support.
WECARE360 does not operate hospitals, clinics, or provide direct medical treatment.

2. SERVICES OFFERED
• Patient care attendants / caregivers
• Home-based nursing services
• Support staff for elderly, post-operative, or special-care patients
• Digital platform (website & mobile app) for service management

3. USER ELIGIBILITY
• Patients or legal guardians must be 18 years or older
• Nurses / caregivers must submit valid identity, qualification, and experience documents
• WECARE360 reserves the right to approve or reject any user

4. SUBSCRIPTION & VALIDITY
Patient subscriptions are valid for 6 months from activation.
Nurse/caregiver subscriptions are valid for 1 year from activation.
Renewal is mandatory after expiry.

5. PAYMENTS & REFUNDS
All payments are online and non-refundable unless required by law.

6. ROLE & LIMITATION OF LIABILITY
WECARE360 acts only as a facilitator between patients and caregivers.
Medical care, conduct, and negligence are the sole responsibility of the caregiver/nurse.
Liability of WECARE360 is limited to the service fee received.

7. LIVE LOCATION TRACKING (NURSES / CAREGIVERS)
• Nurses and caregivers agree to allow live location tracking during active duty hours
• Location tracking is used strictly for:
  - Duty verification
  - Patient safety
  - Service transparency
• Location tracking is enabled only during assigned service hours
• WECARE360 does not track location outside active duty
• By accepting these Terms, nurses explicitly consent to live location access

8. USER CONDUCT
Users must not misuse the platform or provide false information.
Violation may lead to suspension or termination.

9. STAFF VERIFICATION DISCLAIMER
WECARE360 performs basic verification; final acceptance lies with the patient/family.

10. TERMINATION
Accounts may be suspended or terminated for violations or expired subscriptions.

11. FORCE MAJEURE
WECARE360 is not liable for events beyond reasonable control.

12. GOVERNING LAW
These Terms are governed by Indian laws.
Jurisdiction: Ahmedabad, Gujarat.

13. CONTACT
WECARE360 GLOBAL HOME HEALTHCARE PRIVATE LIMITED
Registered Office: Ahmedabad, Gujarat, India
Email: wcare823@gmail.com
""";
