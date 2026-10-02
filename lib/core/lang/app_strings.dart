import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'language_provider.dart';

class T {
  static const _data = {
    "title": {
      "en": "Nurse Self Signup",
      "hi": "नर्स पंजीकरण",
      "gu": "નર્સ નોંધણી",
      "bn": "নার্স নিবন্ধন",
      "mr": "नर्स नोंदणी",
      "ta": "செவிலியர் பதிவு",
      "te": "నర్స్ నమోదు",
      "kn": "ನರ್ಸ್ ನೋಂದಣಿ",
    },

    "phone": {
      "en": "Phone",
      "hi": "फोन",
      "gu": "ફોન",
      "bn": "ফোন",
      "mr": "फोन",
      "ta": "தொலைபேசி",
      "te": "ఫోన్",
      "kn": "ಫೋನ್",
    },

    "submit": {
      "en": "Submit Application",
      "hi": "आवेदन जमा करें",
      "gu": "અરજી સબમિટ કરો",
      "bn": "আবেদন জমা দিন",
      "mr": "अर्ज सबमिट करा",
      "ta": "விண்ணப்பிக்கவும்",
      "te": "దరఖాస్తు పంపండి",
      "kn": "ಅರ್ಜಿಯನ್ನು ಸಲ್ಲಿಸಿ",
    },
    "personal_info": {
      "en": "Personal Information",
      "hi": "व्यक्तिगत जानकारी",
      "gu": "વ્યક્તિગત માહિતી",
      "bn": "ব্যক্তিগত তথ্য",
      "mr": "वैयक्तिक माहिती",
      "ta": "தனிப்பட்ட தகவல்",
      "te": "వ్యక్తిగత సమాచారం",
      "kn": "ವೈಯಕ್ತಿಕ ಮಾಹಿತಿ",
    },

    "name": {
      "en": "Full Name",
      "hi": "पूरा नाम",
      "gu": "પૂર્ણ નામ",
      "bn": "পূর্ণ নাম",
      "mr": "पूर्ण नाव",
      "ta": "முழு பெயர்",
      "te": "పూర్తి పేరు",
      "kn": "ಪೂರ್ಣ ಹೆಸರು",
    },

    "email": {
      "en": "Email",
      "hi": "ईमेल",
      "gu": "ઇમેઇલ",
      "bn": "ইমেইল",
      "mr": "ईमेल",
      "ta": "மின்னஞ்சல்",
      "te": "ఈమెయిల్",
      "kn": "ಇಮೇಲ್",
    },

    "select_date": {
      "en": "Select Joining Date",
      "hi": "जॉइनिंग तिथि चुनें",
      "gu": "જોડાવાની તારીખ પસંદ કરો",
      "bn": "যোগদানের তারিখ নির্বাচন করুন",
      "mr": "जॉइनिंग तारीख निवडा",
      "ta": "சேரும் தேதி தேர்வு செய்யவும்",
      "te": "చేరిన తేదీ ఎంచుకోండి",
      "kn": "ಸೇರಿದ ದಿನಾಂಕ ಆಯ್ಕೆಮಾಡಿ",
    },
  };

  static String t(WidgetRef ref, String key) {
    final lang = ref.watch(languageProvider).languageCode;
    return _data[key]?[lang] ?? key;
  }
}
