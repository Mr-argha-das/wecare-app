import 'package:flutter/material.dart';

enum AppLanguage { english, hindi, gujarati, marathi, kannada }

class Lang2 {
  static AppLanguage current = AppLanguage.english;

  static final Map<AppLanguage, Map<String, String>> strings = {

    /// ================= ENGLISH =================
    AppLanguage.english: {

      "patient_title":
          "🧑‍⚖️ Patient / Guardian Declaration\n(For Nursing Staff / Care Taker / Combo Staff / Semi Nursing Staff Services)",

      "patient_point1":
          "1️⃣ Service Authorization\nI / We voluntarily request and authorize the company to provide Nursing Staff / Care Taker / Combo Staff / Semi Nursing Staff services at the patient’s residence.\nI / We confirm that the services are requested with our full consent and responsibility.",

      "patient_point2":
          "2️⃣ Nature of Services\nNursing staff are trained caregivers and may include GNM qualified staff where available.",

      "patient_point3":
          "Combo Staff / Semi Nursing Staff may not necessarily be GNM qualified and may have practical experience and basic medical knowledge only.",

      "patient_point4":
          "Medical diagnosis and treatment decisions must always be taken only by a registered medical practitioner.",

      "services_title":
          "🏥 Scope of Nursing Services (As per doctor advice & company policy)",

      "patient_point5":
          "• Administration of medicines as prescribed by doctor",

      "patient_point6":
          "• Monitoring vital signs (BP, Sugar, Pulse, Temperature)",

      "patient_point7":
          "• Wound dressing, injection administration, catheter care, Ryle’s tube care",

      "patient_point8":
          "• Basic nursing observation and reporting",

      "patient_caretaker_title":
          "🧑‍🦽 Care Taker / Combo Staff Work Scope",

      "patient_point9":
          "• Patient mobility support",

      "patient_point10":
          "• Feeding assistance, bathing and hygiene care",

      "patient_point11":
          "• Toileting assistance, position change and comfort care",

      "legal_title":
          "⚠ Behaviour & Environment Policy",

      "patient_point12":
          "Patient family must ensure safe environment, hygienic conditions and respectful behaviour towards staff.",

      "patient_point13":
          "Misbehavior, abuse, threats, harassment or violence against staff shall be punishable under IPC 294 / 504 / 506.",

      "nonsolicitation_title":
          "🚫 Non-Solicitation Policy",

      "patient_point14":
          "Patient / guardian agrees not to directly or indirectly hire any company provided staff.",

      "patient_point15":
          "Violation may result in ₹1,00,000 penalty, legal recovery and FIR under IPC 406 / 420.",

      "patient_point16":
          "This condition applies during service period and for 12 months after service termination.",

      "confidentiality_title":
          "🔒 Confidentiality & Data Protection",

      "patient_point17":
          "Patient data such as medical records, photos, videos or reports must not be misused or shared without authorization.\nViolation punishable under IT Act 2000 – Section 43 & 66.",

      "payment_title":
          "💰 Payment Terms",

      "patient_point18":
          "All payments must be made only to the company account as per invoice.",

      "patient_point19":
          "Direct payment to staff is strictly prohibited.",

      "declaration":
          "✍ Final Declaration\nI / We confirm that we have read, understood and voluntarily accepted all the above terms and conditions.",
    },



    /// ================= HINDI =================
    AppLanguage.hindi: {

      "patient_title":
          "🧑‍⚖️ पेशेंट / अभिभावक घोषणा\n(नर्सिंग स्टाफ / केयर टेकर / कॉम्बो स्टाफ / सेमी नर्सिंग स्टाफ सेवाओं के लिए)",

      "patient_point1":
          "1️⃣ सेवा प्राधिकरण\nमैं / हम स्वेच्छा से कंपनी को हमारे निवास पर नर्सिंग स्टाफ / केयर टेकर / कॉम्बो स्टाफ / सेमी नर्सिंग स्टाफ सेवाएँ प्रदान करने की अनुमति देते हैं।",

      "patient_point2":
          "2️⃣ सेवाओं की प्रकृति\nनर्सिंग स्टाफ प्रशिक्षित देखभालकर्ता होते हैं और उपलब्धता के अनुसार GNM योग्य भी हो सकते हैं।",

      "patient_point3":
          "कॉम्बो / सेमी नर्सिंग स्टाफ आवश्यक नहीं कि GNM योग्य हों।",

      "patient_point4":
          "चिकित्सकीय निर्णय केवल पंजीकृत डॉक्टर द्वारा लिए जाने चाहिए।",

      "services_title":
          "🏥 नर्सिंग सेवाओं का दायरा",

      "patient_point5":
          "• डॉक्टर द्वारा बताई गई दवाइयों का प्रशासन",

      "patient_point6":
          "• वाइटल मॉनिटरिंग (बीपी, शुगर, नाड़ी, तापमान)",

      "patient_point7":
          "• घाव ड्रेसिंग / इंजेक्शन / कैथेटर / राइल्स ट्यूब देखभाल",

      "patient_point8":
          "• सामान्य नर्सिंग देखभाल",

      "patient_caretaker_title":
          "🧑‍🦽 केयर टेकर / कॉम्बो स्टाफ कार्य क्षेत्र",

      "patient_point9":
          "• मरीज की गतिशीलता में सहायता",

      "patient_point10":
          "• भोजन कराने, नहलाने और स्वच्छता में सहायता",

      "patient_point11":
          "• शौचालय सहायता और आराम देखभाल",

      "legal_title":
          "⚠ व्यवहार नीति",

      "patient_point12":
          "मरीज परिवार स्टाफ के लिए सुरक्षित और सम्मानजनक वातावरण सुनिश्चित करेगा।",

      "patient_point13":
          "दुर्व्यवहार IPC 294 / 504 / 506 के अंतर्गत दंडनीय है।",

      "nonsolicitation_title":
          "🚫 नॉन-सॉलिसिटेशन नीति",

      "patient_point14":
          "मरीज / अभिभावक कंपनी स्टाफ को सीधे नियुक्त नहीं करेंगे।",

      "patient_point15":
          "उल्लंघन पर ₹1,00,000 दंड और IPC 406 / 420 के तहत कार्रवाई हो सकती है।",

      "patient_point16":
          "यह नियम सेवा अवधि और सेवा समाप्ति के बाद 12 महीने तक लागू रहेगा।",

      "confidentiality_title":
          "🔒 गोपनीयता",

      "patient_point17":
          "मरीज डेटा का दुरुपयोग नहीं किया जाएगा।",

      "payment_title":
          "💰 भुगतान शर्तें",

      "patient_point18":
          "सभी भुगतान केवल कंपनी खाते में किए जाएंगे।",

      "patient_point19":
          "स्टाफ को सीधे भुगतान करना मना है।",

      "declaration":
          "✍ अंतिम घोषणा\nमैं / हम सभी शर्तों को पढ़कर स्वीकार करते हैं।",
    },
  };

  static String t(String key) {
    final map = strings[current];
    if (map != null && map.containsKey(key)) {
      return map[key]!;
    }

    final en = strings[AppLanguage.english];
    if (en != null && en.containsKey(key)) {
      return en[key]!;
    }

    debugPrint("Missing translation key: $key");
    return key;
  }
}