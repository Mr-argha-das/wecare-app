import 'package:flutter/material.dart';

enum AppLanguage { english, hindi, gujarati, marathi, kannada }

class Lang {
  static AppLanguage current = AppLanguage.english;

  static final Map<AppLanguage, Map<String, String>> strings = {
    // ────────────────────────────────────────────────
    //                  ENGLISH (full & exact)
    // ────────────────────────────────────────────────
    AppLanguage.english: {
      "title":
          "👩‍⚕️👨‍⚕️ Staff Legal Declaration & Undertaking\n(Applicable for Nursing Staff / Care Taker / Combo Staff)",

      "point1":
          "1️⃣ I declare that all documents submitted by me are true and genuine.\nProviding false information is punishable under IPC 177 / 191 / 420.",
      "point2":
          "2️⃣ I will follow all company rules including duty timing, transfers, discipline, uniform, and behavior policy.",
      "point3":
          "3️⃣ I will not misuse or leak any patient medical information, photos, videos, or reports.\nViolation is punishable under IPC 406 & IT Act 2000 (Section 43, 66).",
      "point4":
          "4️⃣ Taking direct payment, tips, gifts, or private work from patients or relatives without written company permission is strictly prohibited.\nViolation may result in termination, legal action, and financial penalty.",
      "point5":
          "5️⃣ Leaving duty without prior notice may cause financial loss to the company and may lead to penalty or termination.",
      "point6":
          "6️⃣ Smoking, alcohol, tobacco, or drug use during duty or at patient premises is strictly prohibited and may lead to immediate termination and police action.",
      "point7":
          "7️⃣ Misbehavior, abuse, threats, or harassment with patients or relatives is punishable under IPC 294 / 504 / 506.",
      "point8":
          "8️⃣ Theft, fraud, cheating, or damage to patient or company property is punishable under IPC 380 / 406 / 420.",
      "point9":
          "9️⃣ Misuse of confidential company or patient data, influencing patients against the company, or inducing staff transfer is strictly prohibited and may lead to civil & criminal action.",
      "point10":
          "🔟 Service may be terminated without notice if police verification fails.",
      "point11":
          "1️⃣1️⃣ With consent of the patient or their authorized attendant, live location tracking of staff may be done during the service period for monitoring and safety purposes only.",

      "caretaker_title": "🧑‍⚕️ Care Taker / Combo Staff Work Scope",
      "point12":
          "1️⃣2️⃣ Assisting patient in daily activities such as mobility, feeding, bathing, toileting, and hygiene care.",
      "point13":
          "1️⃣3️⃣ Bed making, patient comfort care, position change, and basic cleanliness around patient area.",
      "point14":
          "1️⃣4️⃣ Supporting nursing staff as instructed (for combo staff), without performing unauthorized medical procedures.",
      "point15":
          "1️⃣5️⃣ Reporting any change in patient condition to the company or assigned supervisor immediately.",

      "confidential_title": "🔒 Confidentiality & Discipline",
      "confidential":
          "Patient and company data must not be misused or shared in any form.\nViolation may lead to disciplinary action and legal proceedings under IT Act, 2000 and applicable Indian laws.",

      "fee_title": "💼 Job Application Fee",
      "fee_content":
          "• Job Application / Registration Fee: ₹199/-\n"
          "• Validity: 12 Months from date of payment\n"
          "• Fee Type: One-time, non-refundable\n"
          "• Applicable For: Job application & profile activation",

      "upload_signature": "Upload your signature",
      "tap_upload": "Tap to upload signature",
      "submit": "Submit & Sign",
      "camera": "Camera",
      "gallery": "Gallery",
      "upload_title": "Upload Signature",
      "success": "Signature uploaded successfully!",
      "please_upload": "Please upload signature",
      "signup_done":
          "Signup complete ✅\nWait for admin approval.\nYou will get an email after verification.",
    },

    // ────────────────────────────────────────────────
    //                      HINDI (as you provided)
    // ────────────────────────────────────────────────
    AppLanguage.hindi: {
      "title":
          "👩‍⚕️👨‍⚕️ स्टाफ कानूनी घोषणा एवं प्रतिबद्धता\n(नर्सिंग स्टाफ / केयर टेकर / कॉम्बो स्टाफ के लिए लागू)",
      "point1":
          "1️⃣ मैं घोषणा करता/करती हूँ कि मेरे द्वारा जमा किए गए सभी दस्तावेज़ सत्य और वास्तविक हैं।\nझूठी जानकारी देना IPC 177 / 191 / 420 के अंतर्गत दंडनीय है।",
      "point2":
          "2️⃣ मैं कंपनी के सभी नियमों का पालन करूँगा/करूँगी जिसमें ड्यूटी का समय, स्थानांतरण, अनुशासन, वर्दी और व्यवहार नीति शामिल हैं।",
      "point3":
          "3️⃣ मैं मरीज की कोई भी चिकित्सकीय जानकारी, फोटो, वीडियो या रिपोर्ट का दुरुपयोग या लीक नहीं करूँगा/करूँगी।\nउल्लंघन IPC 406 एवं IT Act 2000 (धारा 43, 66) के अंतर्गत दंडनीय है।",
      "point4":
          "4️⃣ कंपनी की लिखित अनुमति के बिना मरीज या उनके परिजनों से प्रत्यक्ष भुगतान, टिप्स, उपहार या निजी काम लेना सख्त मना है।\nउल्लंघन पर नौकरी समाप्ति, कानूनी कार्रवाई और आर्थिक दंड हो सकता है।",
      "point5":
          "5️⃣ पूर्व सूचना के बिना ड्यूटी छोड़ने से कंपनी को आर्थिक नुकसान हो सकता है और दंड या नौकरी समाप्ति हो सकती है।",
      "point6":
          "6️⃣ ड्यूटी के दौरान या मरीज के परिसर में धूम्रपान, शराब, तंबाकू या ड्रग्स का सेवन सख्त मना है और तत्काल नौकरी समाप्ति व पुलिस कार्रवाई हो सकती है।",
      "point7":
          "7️⃣ मरीजों या परिजनों के साथ दुर्व्यवहार, गाली, धमकी या उत्पीड़न IPC 294 / 504 / 506 के अंतर्गत दंडनीय है।",
      "point8":
          "8️⃣ मरीज या कंपनी की संपत्ति की चोरी, धोखाधड़ी, ठगी या नुकसान IPC 380 / 406 / 420 के अंतर्गत दंडनीय है।",
      "point9":
          "9️⃣ कंपनी या मरीज की गोपनीय जानकारी का दुरुपयोग, मरीज को कंपनी के खिलाफ भड़काना या स्टाफ को स्थानांतरित करवाना सख्त मना है और सिविल व आपराधिक कार्रवाई हो सकती है।",
      "point10":
          "🔟 पुलिस सत्यापन असफल होने पर बिना नोटिस के सेवा समाप्त की जा सकती है।",
      "point11":
          "1️⃣1️⃣ मरीज या उनके अधिकृत परिजन की सहमति से सेवा अवधि के दौरान स्टाफ की लाइव लोकेशन ट्रैकिंग की जा सकती है (केवल निगरानी और सुरक्षा के लिए)।",

      "caretaker_title": "🧑‍⚕️ केयर टेकर / कॉम्बो स्टाफ के कार्य क्षेत्र",
      "point12":
          "1️⃣2️⃣ मरीज की दैनिक गतिविधियों में सहायता जैसे चलना-फिरना, खाना खिलाना, नहलाना, शौचालय सहायता और स्वच्छता देखभाल।",
      "point13":
          "1️⃣3️⃣ बिस्तर बनाना, मरीज की सुविधा, स्थिति बदलना और मरीज क्षेत्र की बुनियादी सफाई।",
      "point14":
          "1️⃣4️⃣ नर्सिंग स्टाफ की दिए गए निर्देशों का पालन करना (कॉम्बो स्टाफ के लिए), बिना अनधिकृत चिकित्सकीय प्रक्रिया किए।",
      "point15":
          "1️⃣5️⃣ मरीज की स्थिति में कोई भी बदलाव तुरंत कंपनी या नियुक्त सुपरवाइजर को सूचित करना।",

      "confidential_title": "🔒 गोपनीयता एवं अनुशासन",
      "confidential":
          "मरीज और कंपनी के डेटा का किसी भी रूप में दुरुपयोग या साझा करना वर्जित है।\nउल्लंघन पर IT Act, 2000 और अन्य भारतीय कानूनों के तहत अनुशासनात्मक एवं कानूनी कार्रवाई होगी।",

      "fee_title": "💼 जॉब आवेदन शुल्क",
      "fee_content":
          "• जॉब आवेदन / रजिस्ट्रेशन शुल्क: ₹199/-\n"
          "• वैधता: भुगतान की तारीख से 12 महीने\n"
          "• शुल्क प्रकार: एक बार, गैर-वापसी योग्य\n"
          "• लागू: जॉब आवेदन एवं प्रोफाइल एक्टिवेशन के लिए",

      "upload_signature": "अपना हस्ताक्षर अपलोड करें",
      "tap_upload": "हस्ताक्षर अपलोड करने के लिए टैप करें",
      "submit": "सबमिट एवं साइन करें",
      "camera": "कैमरा",
      "gallery": "गैलरी",
      "upload_title": "हस्ताक्षर अपलोड करें",
      "success": "हस्ताक्षर सफलतापूर्वक अपलोड हो गया!",
      "please_upload": "कृपया हस्ताक्षर अपलोड करें",
      "signup_done":
          "साइनअप पूरा हुआ ✅\nएडमिन अप्रूवल का इंतज़ार करें।\nवेरिफिकेशन के बाद आपको ईमेल मिलेगा।",
    },

    // ────────────────────────────────────────────────
    //                   GUJARATI (full translation)
    // ────────────────────────────────────────────────
    AppLanguage.gujarati: {
      "title":
          "👩‍⚕️👨‍⚕️ સ્ટાફ કાનૂની ઘોષણા અને ખાતરી\n(નર્સિંગ સ્ટાફ / કેર ટેકર / કોમ્બો સ્ટાફ માટે લાગુ)",

      "point1":
          "1️⃣ હું જાહેર કરું છું કે મારા દ્વારા સબમિટ કરાયેલા તમામ દસ્તાવેજો સાચા અને અધિકૃત છે.\nખોટી માહિતી આપવી IPC 177 / 191 / 420 હેઠળ દંડનીય છે.",
      "point2":
          "2️⃣ હું કંપનીના તમામ નિયમોનું પાલન કરીશ જેમાં ડ્યુટીનો સમય, ટ્રાન્સફર, શિસ્ત, યુનિફોર્મ અને વર્તન નીતિનો સમાવેશ થાય છે.",
      "point3":
          "3️⃣ હું દર્દીની કોઈપણ તબીબી માહિતી, ફોટો, વીડિયો કે રિપોર્ટનો દુરુપયોગ કે લીક નહીં કરું.\nઉલ્લંઘન IPC 406 અને IT Act 2000 (કલમ 43, 66) હેઠળ દંડનીય છે.",
      "point4":
          "4️⃣ કંપનીની લેખિત પરવાનગી વિના દર્દી કે તેમના સંબંધીઓ પાસેથી સીધી ચુકવણી, ટિપ્સ, ભેટ કે ખાનગી કામ લેવું સખત પ્રતિબંધિત છે.\nઉલ્લંઘન પર નોકરી રદ, કાનૂની કાર્યવાહી અને આર્થિક દંડ થઈ શકે છે.",
      "point5":
          "5️⃣ પૂર્વ સૂચના વિના ડ્યુટી છોડવાથી કંપનીને આર્થિક નુકસાન થઈ શકે છે અને દંડ કે નોકરી રદ થઈ શકે છે.",
      "point6":
          "6️⃣ ડ્યુટી દરમિયાન કે દર્દીના સ્થળે ધૂમ્રપાન, દારૂ, તમાકુ કે ડ્રગ્સનો ઉપયોગ સખત પ્રતિબંધિત છે અને તાત્કાલિક નોકરી રદ તેમજ પોલીસ કાર્યવાહી થઈ શકે છે.",
      "point7":
          "7️⃣ દર્દીઓ કે સંબંધીઓ સાથે ખરાબ વર્તન, ગાળા, ધમકી કે હેરાનગતિ IPC 294 / 504 / 506 હેઠળ દંડનીય છે.",
      "point8":
          "8️⃣ દર્દી કે કંપનીની સંપત્તિની ચોરી, છેતરપિંડી, ઠગાઈ કે નુકસાન IPC 380 / 406 / 420 હેઠળ દંડનીય છે.",
      "point9":
          "9️⃣ કંપની કે દર્દીની ગોપનીય માહિતીનો દુરુપયોગ, દર્દીને કંપની વિરુદ્ધ ભડકાવવું કે સ્ટાફને ટ્રાન્સફર કરાવવું સખત પ્રતિબંધિત છે અને સિવિલ તેમજ ક્રિમિનલ કાર્યવાહી થઈ શકે છે.",
      "point10":
          "🔟 પોલીસ વેરિફિકેશન નિષ્ફળ થવાથી નોટિસ વિના સેવા સમાપ્ત કરી શકાય છે.",
      "point11":
          "1️⃣1️⃣ દર્દી કે તેમના અધિકૃત વ્યક્તિની સંમતિથી સેવા દરમિયાન સ્ટાફનું લાઇવ લોકેશન ટ્રેકિંગ થઈ શકે છે (માત્ર નિરીક્ષણ અને સુરક્ષા માટે).",

      "caretaker_title": "🧑‍⚕️ કેર ટેકર / કોમ્બો સ્ટાફનું કાર્ય ક્ષેત્ર",
      "point12":
          "1️⃣2️⃣ દર્દીને રોજિંદા પ્રવૃત્તિઓમાં મદદ જેમ કે ચાલવું-ફરવું, ખવડાવવું, નાહવું, શૌચાલય મદદ અને સ્વચ્છતા સંભાળ.",
      "point13":
          "1️⃣3️⃣ બેડ બનાવવું, દર્દીની આરામ, પોઝિશન બદલવું અને દર્દી વિસ્તારની મૂળભૂત સફાઈ.",
      "point14":
          "1️⃣4️⃣ નર્સિંગ સ્ટાફના આદેશ મુજબ મદદ કરવી (કોમ્બો સ્ટાફ માટે), અનધિકૃત તબીબી પ્રક્રિયા વિના.",
      "point15":
          "1️⃣5️⃣ દર્દીની સ્થિતિમાં કોઈપણ ફેરફાર તરત જ કંપની કે નિયુક્ત સુપરવાઇઝરને જાણ કરવી.",

      "confidential_title": "🔒 ગોપનીયતા અને શિસ્ત",
      "confidential":
          "દર્દી અને કંપનીના ડેટાનો કોઈપણ રીતે દુરુપયોગ કે શેર કરવો પ્રતિબંધિત છે.\nઉલ્લંઘન પર IT Act, 2000 અને લાગુ ભારતીય કાયદાઓ હેઠળ શિસ્તભંગ અને કાનૂની કાર્યવાહી થશે.",

      "fee_title": "💼 જોબ અરજી ફી",
      "fee_content":
          "• જોબ અરજી / રજિસ્ટ્રેશન ફી: ₹199/-\n"
          "• માન્યતા: ચુકવણીની તારીખથી 12 મહિના\n"
          "• ફી પ્રકાર: એક વખત, બિન-રિફંડેબલ\n"
          "• લાગુ: જોબ અરજી અને પ્રોફાઇલ એક્ટિવેશન માટે",

      "upload_signature": "તમારી સહી અપલોડ કરો",
      "tap_upload": "સહી અપલોડ કરવા માટે ટેપ કરો",
      "submit": "સબમિટ અને સાઇન કરો",
      "camera": "કેમેરા",
      "gallery": "ગેલેરી",
      "upload_title": "સહી અપલોડ કરો",
      "success": "સહી સફળતાપૂર્વક અપલોડ થઈ!",
      "please_upload": "કૃપા કરીને સહી અપલોડ કરો",
      "signup_done":
          "સાઇનઅપ પૂર્ણ થયું ✅\nએડમિન મંજૂરીની રાહ જુઓ.\nવેરિફિકેશન પછી તમને ઇમેઇલ મળશે.",
    },

    // ────────────────────────────────────────────────
    //                   MARATHI (full translation)
    // ────────────────────────────────────────────────
    AppLanguage.marathi: {
      "title":
          "👩‍⚕️👨‍⚕️ कर्मचारी कायदेशीर घोषणा आणि हमी\n(नर्सिंग स्टाफ / केअर टेकर / कॉम्बो स्टाफ साठी लागू)",

      "point1":
          "1️⃣ मी घोषित करतो/करते की माझ्याकडून सादर केलेले सर्व कागदपत्रे खरी आणि वैध आहेत.\nखोटी माहिती देणे IPC 177 / 191 / 420 अंतर्गत दंडनीय आहे.",
      "point2":
          "2️⃣ मी कंपनीचे सर्व नियम पाळेन ज्यात ड्युटीचा वेळ, ट्रान्सफर, शिस्त, युनिफॉर्म आणि वर्तन धोरण यांचा समावेश आहे.",
      "point3":
          "3️⃣ मी रुग्णाच्या वैद्यकीय माहिती, फोटो, व्हिडिओ किंवा अहवालाचा गैरवापर किंवा लीक करणार नाही.\nउल्लंघन IPC 406 आणि IT Act 2000 (कलम 43, 66) अंतर्गत दंडनीय आहे.",
      "point4":
          "4️⃣ कंपनीच्या लेखी परवानगीशिवाय रुग्ण किंवा त्यांच्या नातेवाइकांकडून थेट पेमेंट, टिप्स, भेटवस्तू किंवा खाजगी काम घेणे काटेकोरपणे प्रतिबंधित आहे.\nउल्लंघनामुळे नोकरी संपुष्टात, कायदेशीर कारवाई आणि आर्थिक दंड होऊ शकतो.",
      "point5":
          "5️⃣ पूर्व सूचनेशिवाय ड्युटी सोडल्यास कंपनीला आर्थिक नुकसान होऊ शकते आणि दंड किंवा नोकरी संपुष्टात येऊ शकते.",
      "point6":
          "6️⃣ ड्युटीदरम्यान किंवा रुग्णाच्या परिसरात धूम्रपान, मद्य, तंबाखू किंवा ड्रग्सचा वापर काटेकोरपणे प्रतिबंधित आहे आणि तात्काळ नोकरी संपुष्टात व पोलिस कारवाई होऊ शकते.",
      "point7":
          "7️⃣ रुग्ण किंवा नातेवाइकांसोबत दुर्व्यवहार, शिवीगाळ, धमकी किंवा छळ IPC 294 / 504 / 506 अंतर्गत दंडनीय आहे.",
      "point8":
          "8️⃣ रुग्ण किंवा कंपनीच्या मालमत्तेची चोरी, फसवणूक, ठगी किंवा नुकसान IPC 380 / 406 / 420 अंतर्गत दंडनीय आहे.",
      "point9":
          "9️⃣ कंपनी किंवा रुग्णाच्या गोपनीय डेटाचा गैरवापर, रुग्णांना कंपनीविरुद्ध भडकावणे किंवा स्टाफला ट्रान्सफर करणे काटेकोरपणे प्रतिबंधित आहे आणि सिव्हिल व क्रिमिनल कारवाई होऊ शकते.",
      "point10":
          "🔟 पोलिस पडताळणी अयशस्वी झाल्यास नोटीसशिवाय सेवा संपुष्टात केली जाऊ शकते.",
      "point11":
          "1️⃣1️⃣ रुग्ण किंवा त्यांच्या अधिकृत व्यक्तीच्या संमतीने सेवा कालावधीत स्टाफचे लाइव्ह लोकेशन ट्रॅकिंग केले जाऊ शकते (फक्त निरीक्षण आणि सुरक्षिततेसाठी).",

      "caretaker_title": "🧑‍⚕️ केअर टेकर / कॉम्बो स्टाफचे कार्य क्षेत्र",
      "point12":
          "1️⃣2️⃣ रुग्णाला दैनंदिन क्रियांमध्ये मदत जसे चालणे-फिरणे, जेवण खाणे, आंघोळ, शौचालय मदत आणि स्वच्छता काळजी.",
      "point13":
          "1️⃣3️⃣ बेड बनवणे, रुग्णाची सोय, स्थिती बदलणे आणि रुग्ण क्षेत्राची मूलभूत स्वच्छता.",
      "point14":
          "1️⃣4️⃣ नर्सिंग स्टाफच्या सूचनेनुसार मदत करणे (कॉम्बो स्टाफसाठी), अनधिकृत वैद्यकीय प्रक्रिया न करता.",
      "point15":
          "1️⃣5️⃣ रुग्णाच्या स्थितीत कोणताही बदल तात्काळ कंपनी किंवा नियुक्त सुपरवायझरला कळवणे.",

      "confidential_title": "🔒 गोपनीयता आणि शिस्त",
      "confidential":
          "रुग्ण आणि कंपनीच्या डेटाचा कोणत्याही प्रकारे गैरवापर किंवा शेअर करणे प्रतिबंधित आहे.\nउल्लंघनामुळे IT Act, 2000 आणि लागू भारतीय कायद्यांतर्गत शिस्तभंग आणि कायदेशीर कारवाई होईल.",

      "fee_title": "💼 जॉब अर्ज शुल्क",
      "fee_content":
          "• जॉब अर्ज / नोंदणी शुल्क: ₹199/-\n"
          "• वैधता: पेमेंट तारखेपासून 12 महिने\n"
          "• शुल्क प्रकार: एकदाच, परतावा न होणारे\n"
          "• लागू: जॉब अर्ज आणि प्रोफाइल अॅक्टिव्हेशनसाठी",

      "upload_signature": "तुमची सही अपलोड करा",
      "tap_upload": "सही अपलोड करण्यासाठी टॅप करा",
      "submit": "सबमिट आणि साइन करा",
      "camera": "कॅमेरा",
      "gallery": "गॅलरी",
      "upload_title": "सही अपलोड करा",
      "success": "सही यशस्वीरित्या अपलोड झाली!",
      "please_upload": "कृपया सही अपलोड करा",
      "signup_done":
          "साइनअप पूर्ण झाले ✅\nअॅडमिन मंजुरीची वाट पाहा.\nव्हेरिफिकेशन नंतर तुम्हाला ईमेल मिळेल.",
    },

    // ────────────────────────────────────────────────
    //                   KANNADA (full translation)
    // ────────────────────────────────────────────────
    AppLanguage.kannada: {
      "title":
          "👩‍⚕️👨‍⚕️ ಸಿಬ್ಬಂದಿ ಕಾನೂನು ಘೋಷಣೆ ಮತ್ತು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳುವಿಕೆ\n(ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿ / ಕೇರ್ ಟೇಕರ್ / ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಗೆ ಅನ್ವಯಿಸುತ್ತದೆ)",

      "point1":
          "1️⃣ ನಾನು ಘೋಷಿಸುತ್ತೇನೆ/ಘೋಷಿಸುತ್ತೇನೆ ನನ್ನಿಂದ ಸಲ್ಲಿಸಲಾದ ಎಲ್ಲಾ ದಾಖಲೆಗಳು ನಿಜ ಮತ್ತು ಮಾನ್ಯವಾಗಿವೆ.\nತಪ್ಪು ಮಾಹಿತಿ ನೀಡುವುದು IPC 177 / 191 / 420 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ.",
      "point2":
          "2️⃣ ನಾನು ಕಂಪನಿಯ ಎಲ್ಲಾ ನಿಯಮಗಳನ್ನು ಪಾಲಿಸುತ್ತೇನೆ ಇದರಲ್ಲಿ ಡ್ಯೂಟಿ ಸಮಯ, ವರ್ಗಾವಣೆ, ಶಿಸ್ತು, ಯೂನಿಫಾರ್ಮ್ ಮತ್ತು ವರ್ತನೆ ನೀತಿಯನ್ನು ಒಳಗೊಂಡಿದೆ.",
      "point3":
          "3️⃣ ನಾನು ರೋಗಿಯ ಯಾವುದೇ ವೈದ್ಯಕೀಯ ಮಾಹಿತಿ, ಫೋಟೋ, ವೀಡಿಯೊ ಅಥವಾ ವರದಿಯನ್ನು ದುರುಪಯೋಗ ಅಥವಾ ಸೋರಿಕೆ ಮಾಡುವುದಿಲ್ಲ.\nಉಲ್ಲಂಘನೆ IPC 406 ಮತ್ತು IT Act 2000 (ಕಲಂ 43, 66) ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ.",
      "point4":
          "4️⃣ ಕಂಪನಿಯ ಲಿಖಿತ ಅನುಮತಿಯಿಲ್ಲದೆ ರೋಗಿ ಅಥವಾ ಅವರ ಸಂಬಂಧಿಕರಿಂದ ನೇರ ಪಾವತಿ, ಟಿಪ್ಸ್, ಉಡುಗೊರೆ ಅಥವಾ ಖಾಸಗಿ ಕೆಲಸ ತೆಗೆದುಕೊಳ್ಳುವುದು ಕಟ್ಟುನಿಟ್ಟಾಗಿ ನಿಷೇಧಿಸಲಾಗಿದೆ.\nಉಲ್ಲಂಘನೆಗೆ ಉದ್ಯೋಗ ರದ್ದು, ಕಾನೂನು ಕ್ರಮ ಮತ್ತು ಆರ್ಥಿಕ ದಂಡ ಆಗಬಹುದು.",
      "point5":
          "5️⃣ ಮುಂಚಿತ ಸೂಚನೆಯಿಲ್ಲದೆ ಡ್ಯೂಟಿ ಬಿಡುವುದರಿಂದ ಕಂಪನಿಗೆ ಆರ್ಥಿಕ ನಷ್ಟವಾಗಬಹುದು ಮತ್ತು ದಂಡ ಅಥವಾ ಉದ್ಯೋಗ ರದ್ದಾಗಬಹುದು.",
      "point6":
          "6️⃣ ಡ್ಯೂಟಿ ಸಮಯದಲ್ಲಿ ಅಥವಾ ರೋಗಿಯ ಪರಿಸರದಲ್ಲಿ ಧೂಮಪಾನ, ಮದ್ಯ, ತಂಬಾಕು ಅಥವಾ ಡ್ರಗ್ಸ್ ಬಳಕೆ ಕಟ್ಟುನಿಟ್ಟಾಗಿ ನಿಷೇಧಿಸಲಾಗಿದೆ ಮತ್ತು ತಕ್ಷಣ ಉದ್ಯೋಗ ರದ್ದು ಮತ್ತು ಪೊಲೀಸ್ ಕ್ರಮ ಆಗಬಹುದು.",
      "point7":
          "7️⃣ ರೋಗಿಗಳು ಅಥವಾ ಸಂಬಂಧಿಕರೊಂದಿಗೆ ದುರ್ವರ್ತನೆ, ದುರುಪಯೋಗ, ಬೆದರಿಕೆ ಅಥವಾ ಹಿಂಸೆ IPC 294 / 504 / 506 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ.",
      "point8":
          "8️⃣ ರೋಗಿ ಅಥವಾ ಕಂಪನಿಯ ಆಸ್ತಿಯ ಕಳ್ಳತನ, ಮೋಸ, ಠಕ್ಕರಿ ಅಥವಾ ಹಾನಿ IPC 380 / 406 / 420 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ.",
      "point9":
          "9️⃣ ಕಂಪನಿ ಅಥವಾ ರೋಗಿಯ ಗೌಪ್ಯ ಡೇಟಾದ ದುರುಪಯೋಗ, ರೋಗಿಗಳನ್ನು ಕಂಪನಿಯ ವಿರುದ್ಧ ಭಡಕಾಯಿಸುವುದು ಅಥವಾ ಸಿಬ್ಬಂದಿಯನ್ನು ವರ್ಗಾಯಿಸುವುದು ಕಟ್ಟುನಿಟ್ಟಾಗಿ ನಿಷೇಧಿಸಲಾಗಿದೆ ಮತ್ತು ಸಿವಿಲ್ ಹಾಗೂ ಕ್ರಿಮಿನಲ್ ಕ್ರಮ ಆಗಬಹುದು.",
      "point10":
          "🔟 ಪೊಲೀಸ್ ಪರಿಶೀಲನೆ ವಿಫಲವಾದರೆ ನೋಟಿಸ್ ಇಲ್ಲದೆ ಸೇವೆ ರದ್ದು ಮಾಡಬಹುದು.",
      "point11":
          "1️⃣1️⃣ ರೋಗಿ ಅಥವಾ ಅವರ ಅಧಿಕೃತ ವ್ಯಕ್ತಿಯ ಸಮ್ಮತಿಯೊಂದಿಗೆ ಸೇವಾ ಅವಧಿಯಲ್ಲಿ ಸಿಬ್ಬಂದಿಯ ಲೈವ್ ಲೊಕೇಶನ್ ಟ್ರ್ಯಾಕಿಂಗ್ ಮಾಡಬಹುದು (ಕೇವಲ ಮೇಲ್ವಿಚಾರಣೆ ಮತ್ತು ಸುರಕ್ಷತೆಗಾಗಿ).",

      "caretaker_title": "🧑‍⚕️ ಕೇರ್ ಟೇಕರ್ / ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಯ ಕೆಲಸ ವ್ಯಾಪ್ತಿ",
      "point12":
          "1️⃣2️⃣ ರೋಗಿಗೆ ದೈನಂದಿನ ಚಟುವಟಿಕೆಗಳಲ್ಲಿ ಸಹಾಯ ಉದಾ. ಚಲನೆ, ಆಹಾರ ನೀಡುವುದು, ಸ್ನಾನ, ಶೌಚಾಲಯ ಸಹಾಯ ಮತ್ತು ಸ್ವಚ್ಛತೆ ಕಾಳಜಿ.",
      "point13":
          "1️⃣3️⃣ ಹಾಸಿಗೆ ಮಾಡುವುದು, ರೋಗಿಯ ಆರಾಮ, ಸ್ಥಾನ ಬದಲಾವಣೆ ಮತ್ತು ರೋಗಿ ಪ್ರದೇಶದ ಮೂಲಭೂತ ಸ್ವಚ್ಛತೆ.",
      "point14":
          "1️⃣4️⃣ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿಯ ಸೂಚನೆಯಂತೆ ಸಹಾಯ ಮಾಡುವುದು (ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಗೆ), ಅನಧಿಕೃತ ವೈದ್ಯಕೀಯ ಕಾರ್ಯವಿಧಾನಗಳನ್ನು ಮಾಡದೆ.",
      "point15":
          "1️⃣5️⃣ ರೋಗಿಯ ಸ್ಥಿತಿಯಲ್ಲಿ ಯಾವುದೇ ಬದಲಾವಣೆಯನ್ನು ತಕ್ಷಣ ಕಂಪನಿ ಅಥವಾ ನಿಯೋಜಿತ ಸೂಪರ್ವೈಸರ್‌ಗೆ ವರದಿ ಮಾಡುವುದು.",

      "confidential_title": "🔒 ಗೌಪ್ಯತೆ ಮತ್ತು ಶಿಸ್ತು",
      "confidential":
          "ರೋಗಿ ಮತ್ತು ಕಂಪನಿಯ ಡೇಟಾವನ್ನು ಯಾವುದೇ ರೂಪದಲ್ಲಿ ದುರುಪಯೋಗ ಅಥವಾ ಹಂಚಿಕೊಳ್ಳುವುದು ನಿಷೇಧಿಸಲಾಗಿದೆ.\nಉಲ್ಲಂಘನೆಗೆ IT Act, 2000 ಮತ್ತು ಭಾರತೀಯ ಕಾನೂನುಗಳ ಅಡಿಯಲ್ಲಿ ಶಿಸ್ತುಭಂಗ ಮತ್ತು ಕಾನೂನು ಕ್ರಮಗಳು ಆಗುತ್ತವೆ.",

      "fee_title": "💼 ಉದ್ಯೋಗ ಅರ್ಜಿ ಶುಲ್ಕ",
      "fee_content":
          "• ಉದ್ಯೋಗ ಅರ್ಜಿ / ನೋಂದಣಿ ಶುಲ್ಕ: ₹199/-\n"
          "• ಮಾನ್ಯತೆ: ಪಾವತಿ ದಿನಾಂಕದಿಂದ 12 ತಿಂಗಳು\n"
          "• ಶುಲ್ಕ ಪ್ರಕಾರ: ಒಂದು ಬಾರಿ, ಮರುಪಾವತಿ ಯೋಗ್ಯವಲ್ಲ\n"
          "• ಅನ್ವಯ: ಉದ್ಯೋಗ ಅರ್ಜಿ ಮತ್ತು ಪ್ರೊಫೈಲ್ ಸಕ್ರಿಯಗೊಳಿಸುವಿಕೆಗೆ",

      "upload_signature": "ನಿಮ್ಮ ಸಹಿಯನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
      "tap_upload": "ಸಹಿ ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ",
      "submit": "ಸಲ್ಲಿಸಿ ಮತ್ತು ಸಹಿ ಮಾಡಿ",
      "camera": "ಕ್ಯಾಮೆರಾ",
      "gallery": "ಗ್ಯಾಲರಿ",
      "upload_title": "ಸಹಿ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
      "success": "ಸಹಿ ಯಶಸ್ವಿಯಾಗಿ ಅಪ್‌ಲೋಡ್ ಆಯಿತು!",
      "please_upload": "ದಯವಿಟ್ಟು ಸಹಿಯನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
      "signup_done":
          "ಸೈನ್‌ಅಪ್ ಪೂರ್ಣಗೊಂಡಿದೆ ✅\nಆಡ್ಮಿನ್ ಅನುಮೋದನೆಗಾಗಿ ನಿರೀಕ್ಷಿಸಿ.\nಪರಿಶೀಲನೆ ನಂತರ ನಿಮಗೆ ಇಮೇಲ್ ಸಿಗುತ್ತದೆ.",
    },
  };

  static String t(String key) {
    final currentMap = strings[current];
    if (currentMap != null && currentMap.containsKey(key)) {
      return currentMap[key]!;
    }

    final englishMap = strings[AppLanguage.english];
    if (englishMap != null && englishMap.containsKey(key)) {
      return englishMap[key]!;
    }

    debugPrint("⚠️ Missing translation key: $key  (lang = ${current.name})");
    return key;
  }
}

class Lang2 {
  static AppLanguage current = AppLanguage.english;

  static final Map<AppLanguage, Map<String, String>> strings = {
    // ────────────────────────────────────────────────
    //                  ENGLISH
    // ────────────────────────────────────────────────
    AppLanguage.english: {
      // Original Staff Declaration
      "title":
          "👩‍⚕️👨‍⚕️ Staff Legal Declaration & Undertaking\n(Applicable for Nursing Staff / Care Taker / Combo Staff)",
      "point1":
          "1️⃣ I declare that all documents submitted by me are true and genuine.\nProviding false information is punishable under IPC 177 / 191 / 420.",
      "point2":
          "2️⃣ I will follow all company rules including duty timing, transfers, discipline, uniform, and behavior policy.",
      "point3":
          "3️⃣ I will not misuse or leak any patient medical information, photos, videos, or reports.\nViolation is punishable under IPC 406 & IT Act 2000 (Section 43, 66).",
      "point4":
          "4️⃣ Taking direct payment, tips, gifts, or private work from patients or relatives without written company permission is strictly prohibited.\nViolation may result in termination, legal action, and financial penalty.",
      "point5":
          "5️⃣ Leaving duty without prior notice may cause financial loss to the company and may lead to penalty or termination.",
      "point6":
          "6️⃣ Smoking, alcohol, tobacco, or drug use during duty or at patient premises is strictly prohibited and may lead to immediate termination and police action.",
      "point7":
          "7️⃣ Misbehavior, abuse, threats, or harassment with patients or relatives is punishable under IPC 294 / 504 / 506.",
      "point8":
          "8️⃣ Theft, fraud, cheating, or damage to patient or company property is punishable under IPC 380 / 406 / 420.",
      "point9":
          "9️⃣ Misuse of confidential company or patient data, influencing patients against the company, or inducing staff transfer is strictly prohibited and may lead to civil & criminal action.",
      "point10":
          "🔟 Service may be terminated without notice if police verification fails.",
      "point11":
          "1️⃣1️⃣ With consent of the patient or their authorized attendant, live location tracking of staff may be done during the service period for monitoring and safety purposes only.",

      "caretaker_title": "🧑‍⚕️ Care Taker / Combo Staff Work Scope",
      "point12":
          "1️⃣2️⃣ Assisting patient in daily activities such as mobility, feeding, bathing, toileting, and hygiene care.",
      "point13":
          "1️⃣3️⃣ Bed making, patient comfort care, position change, and basic cleanliness around patient area.",
      "point14":
          "1️⃣4️⃣ Supporting nursing staff as instructed (for combo staff), without performing unauthorized medical procedures.",
      "point15":
          "1️⃣5️⃣ Reporting any change in patient condition to the company or assigned supervisor immediately.",

      "confidential_title": "🔒 Confidentiality & Discipline",
      "confidential":
          "Patient and company data must not be misused or shared in any form.\nViolation may lead to disciplinary action and legal proceedings under IT Act, 2000 and applicable Indian laws.",

      "fee_title": "💼 Job Application Fee",
      "fee_content":
          "• Job Application / Registration Fee: ₹199/-\n"
          "• Validity: 12 Months from date of payment\n"
          "• Fee Type: One-time, non-refundable\n"
          "• Applicable For: Job application & profile activation",

      // ─── New: Patient / Guardian Declaration ───
      "patient_title":
          "🧑‍⚖️ Patient / Guardian Declaration\n(Applicable for Nursing Staff / Care Taker / Combo Nursing Staff – GNM Running Staff)",
      "patient_point1":
          "1️⃣ I / We voluntarily authorize the company to provide Nursing Staff / Care Taker / Combo Nursing Staff (GNM Running Staff) services at my residence.",
      "patient_point2":
          "2️⃣ I / We understand that nursing staff are trained caregivers and not doctors.",
      "patient_point3":
          "3️⃣ In case of emergency, deterioration, hospitalization, ambulance, or doctor consultation, full responsibility shall be mine/ours.",
      "patient_point4":
          "4️⃣ The company or its staff shall not be liable for complications, sudden health changes, or death due to patient’s medical condition.",

      "services_title":
          "🏥 Services May Include\n(As per doctor advice & company scope)",
      "patient_point5":
          "5️⃣ Medication administration as prescribed by the doctor.",
      "patient_point6": "6️⃣ Vital monitoring (BP, Sugar, Pulse, Temperature).",
      "patient_point7":
          "7️⃣ Wound dressing / Injection / Catheter / Ryle’s tube care (only by authorized nursing staff).",
      "patient_point8": "8️⃣ General nursing care & patient assistance.",

      "patient_caretaker_title": "🧑‍🦽 Care Taker / Combo Staff Work Scope",
      "patient_point9":
          "9️⃣ Assisting patient in daily activities such as mobility, feeding, bathing, toileting, and hygiene care.",
      "patient_point10":
          "🔟 Bed making, position change, comfort care, and basic cleanliness around patient area.",
      "patient_point11":
          "1️⃣1️⃣ Supporting nursing staff as instructed (for combo staff), without performing unauthorized medical procedures.",

      "legal_title": "⚠ Legal & Behaviour Terms",
      "patient_point12":
          "1️⃣2️⃣ I / We will maintain a safe, hygienic, and respectful environment for staff.",
      "patient_point13":
          "1️⃣3️⃣ Misbehavior, abuse, threats, or harassment with staff are punishable under IPC 294 / 504 / 506.",

      "nonsolicitation_title": "🚫 Non-Solicitation & Penalty",
      "patient_point14":
          "1️⃣4️⃣ I / We will not directly or indirectly hire, retain, or engage any company-provided staff.",
      "patient_point15":
          "1️⃣5️⃣ Violation may result in:\n• ₹1,00,000/- penalty\n• Legal recovery & FIR under IPC 406 / 420",
      "patient_point16":
          "1️⃣6️⃣ This condition applies during the service period and for 12 months after service termination.",

      "confidentiality_title": "🔒 Confidentiality & Data Protection",
      "patient_point17":
          "1️⃣7️⃣ Patient data, photos, videos, or reports must not be misused or leaked.\nViolation is punishable under IT Act 2000 – Section 43 & 66.",

      "payment_title": "💰 Payment Terms",
      "patient_point18":
          "1️⃣8️⃣ All service payments shall be made only to the company as per invoice.",
      "patient_point19":
          "1️⃣9️⃣ Direct payment to staff is strictly prohibited.",

      "declaration":
          "✍ Declaration\n2️⃣0️⃣ I / We have read, understood, and willingly accepted all the above terms and conditions.",

      "patient_fee_title": "👨‍👩‍👧 Patient Relative Access Fee",
      "patient_fee_content":
          "• Patient Relative Software Access Fee: ₹199/-\n"
          "• Validity: 6 months from date of payment (for 1 person only)\n"
          "• Access Includes:\n– Patient vitals monitoring\n– App / software access for patient updates\n"
          "• Fee Type: One-time, non-refundable\n"
          "Once payment is successful, the fee will not be refunded.",

      // UI strings (common)
      "upload_signature": "Upload your signature",
      "tap_upload": "Tap to upload signature",
      "submit": "Submit & Sign",
      "camera": "Camera",
      "gallery": "Gallery",
      "upload_title": "Upload Signature",
      "success": "Signature uploaded successfully!",
      "please_upload": "Please upload signature",
      "signup_done":
          "Signup complete ✅\nWait for admin approval.\nYou will get an email after verification.",
    },

    // ────────────────────────────────────────────────
    //                      HINDI
    // ────────────────────────────────────────────────
    AppLanguage.hindi: {
      // Original Staff Declaration (your previous version)
      "title":
          "👩‍⚕️👨‍⚕️ स्टाफ कानूनी घोषणा एवं प्रतिबद्धता\n(नर्सिंग स्टाफ / केयर टेकर / कॉम्बो स्टाफ के लिए लागू)",
      "point1":
          "1️⃣ मैं घोषणा करता/करती हूँ कि मेरे द्वारा जमा किए गए सभी दस्तावेज़ सत्य और वास्तविक हैं।\nझूठी जानकारी देना IPC 177 / 191 / 420 के अंतर्गत दंडनीय है।",
      "point2":
          "2️⃣ मैं कंपनी के सभी नियमों का पालन करूँगा/करूँगी जिसमें ड्यूटी का समय, स्थानांतरण, अनुशासन, वर्दी और व्यवहार नीति शामिल हैं।",
      "point3":
          "3️⃣ मैं मरीज की कोई भी चिकित्सकीय जानकारी, फोटो, वीडियो या रिपोर्ट का दुरुपयोग या लीक नहीं करूँगा/करूँगी।\nउल्लंघन IPC 406 एवं IT Act 2000 (धारा 43, 66) के अंतर्गत दंडनीय है।",
      "point4":
          "4️⃣ कंपनी की लिखित अनुमति के बिना मरीज या उनके परिजनों से प्रत्यक्ष भुगतान, टिप्स, उपहार या निजी काम लेना सख्त मना है।\nउल्लंघन पर नौकरी समाप्ति, कानूनी कार्रवाई और आर्थिक दंड हो सकता है।",
      "point5":
          "5️⃣ पूर्व सूचना के बिना ड्यूटी छोड़ने से कंपनी को आर्थिक नुकसान हो सकता है और दंड या नौकरी समाप्ति हो सकती है।",
      "point6":
          "6️⃣ ड्यूटी के दौरान या मरीज के परिसर में धूम्रपान, शराब, तंबाकू या ड्रग्स का सेवन सख्त मना है और तत्काल नौकरी समाप्ति व पुलिस कार्रवाई हो सकती है।",
      "point7":
          "7️⃣ मरीजों या परिजनों के साथ दुर्व्यवहार, गाली, धमकी या उत्पीड़न IPC 294 / 504 / 506 के अंतर्गत दंडनीय है।",
      "point8":
          "8️⃣ मरीज या कंपनी की संपत्ति की चोरी, धोखाधड़ी, ठगी या नुकसान IPC 380 / 406 / 420 के अंतर्गत दंडनीय है।",
      "point9":
          "9️⃣ कंपनी या मरीज की गोपनीय जानकारी का दुरुपयोग, मरीज को कंपनी के खिलाफ भड़काना या स्टाफ को स्थानांतरित करवाना सख्त मना है और सिविल व आपराधिक कार्रवाई हो सकती है।",
      "point10":
          "🔟 पुलिस सत्यापन असफल होने पर बिना नोटिस के सेवा समाप्त की जा सकती है।",
      "point11":
          "1️⃣1️⃣ मरीज या उनके अधिकृत परिजन की सहमति से सेवा अवधि के दौरान स्टाफ की लाइव लोकेशन ट्रैकिंग की जा सकती है (केवल निगरानी और सुरक्षा के लिए)।",

      "caretaker_title": "🧑‍⚕️ केयर टेकर / कॉम्बो स्टाफ के कार्य क्षेत्र",
      "point12":
          "1️⃣2️⃣ मरीज की दैनिक गतिविधियों में सहायता जैसे चलना-फिरना, खाना खिलाना, नहलाना, शौचालय सहायता और स्वच्छता देखभाल।",
      "point13":
          "1️⃣3️⃣ बिस्तर बनाना, मरीज की सुविधा, स्थिति बदलना और मरीज क्षेत्र की बुनियादी सफाई।",
      "point14":
          "1️⃣4️⃣ नर्सिंग स्टाफ की दिए गए निर्देशों का पालन करना (कॉम्बो स्टाफ के लिए), बिना अनधिकृत चिकित्सकीय प्रक्रिया किए।",
      "point15":
          "1️⃣5️⃣ मरीज की स्थिति में कोई भी बदलाव तुरंत कंपनी या नियुक्त सुपरवाइजर को सूचित करना।",

      "confidential_title": "🔒 गोपनीयता एवं अनुशासन",
      "confidential":
          "मरीज और कंपनी के डेटा का किसी भी रूप में दुरुपयोग या साझा करना वर्जित है।\nउल्लंघन पर IT Act, 2000 और अन्य भारतीय कानूनों के तहत अनुशासनात्मक एवं कानूनी कार्रवाई होगी।",

      "fee_title": "💼 जॉब आवेदन शुल्क",
      "fee_content":
          "• जॉब आवेदन / रजिस्ट्रेशन शुल्क: ₹199/-\n"
          "• वैधता: भुगतान की तारीख से 12 महीने\n"
          "• शुल्क प्रकार: एक बार, गैर-वापसी योग्य\n"
          "• लागू: जॉब आवेदन एवं प्रोफाइल एक्टिवेशन के लिए",

      // ─── Patient / Guardian Declaration ───
      "patient_title":
          "🧑‍⚖️ पेशेंट / अभिभावक घोषणा\n(नर्सिंग स्टाफ / केयर टेकर / कॉम्बो नर्सिंग स्टाफ – GNM रनिंग स्टाफ के लिए लागू)",
      "patient_point1":
          "1️⃣ मैं / हम स्वेच्छा से कंपनी को मेरे निवास पर नर्सिंग स्टाफ / केयर टेकर / कॉम्बो नर्सिंग स्टाफ (GNM रनिंग स्टाफ) सेवाएँ प्रदान करने की अनुमति देते हैं।",
      "patient_point2":
          "2️⃣ मैं / हम समझते हैं कि नर्सिंग स्टाफ प्रशिक्षित देखभालकर्ता हैं, डॉक्टर नहीं।",
      "patient_point3":
          "3️⃣ आपातकाल, स्थिति बिगड़ने, अस्पताल में भर्ती, एम्बुलेंस, या डॉक्टर से परामर्श की स्थिति में पूरी जिम्मेदारी मेरी / हमारी होगी।",
      "patient_point4":
          "4️⃣ कंपनी या उसके स्टाफ मरीज की चिकित्सकीय स्थिति के कारण होने वाली जटिलताओं, अचानक स्वास्थ्य परिवर्तन, या मृत्यु के लिए उत्तरदायी नहीं होंगे।",

      "services_title":
          "🏥 सेवाएँ शामिल हो सकती हैं\n(डॉक्टर की सलाह और कंपनी के दायरे के अनुसार)",
      "patient_point5": "5️⃣ डॉक्टर द्वारा निर्धारित दवाओं का प्रशासन।",
      "patient_point6": "6️⃣ वाइटल मॉनिटरिंग (बीपी, शुगर, नाड़ी, तापमान)।",
      "patient_point7":
          "7️⃣ घाव ड्रेसिंग / इंजेक्शन / कैथेटर / राइल्स ट्यूब की देखभाल (केवल अधिकृत नर्सिंग स्टाफ द्वारा)।",
      "patient_point8": "8️⃣ सामान्य नर्सिंग देखभाल और मरीज की सहायता।",

      "patient_caretaker_title": "🧑‍🦽 केयर टेकर / कॉम्बो स्टाफ कार्य क्षेत्र",
      "patient_point9":
          "9️⃣ मरीज की दैनिक गतिविधियों में सहायता जैसे गतिशीलता, भोजन कराना, स्नान, शौचालय, और स्वच्छता देखभाल।",
      "patient_point10":
          "🔟 बिस्तर बनाना, स्थिति बदलना, आरामदायक देखभाल, और मरीज क्षेत्र के आसपास की बुनियादी सफाई।",
      "patient_point11":
          "1️⃣1️⃣ निर्देशानुसार नर्सिंग स्टाफ की सहायता करना (कॉम्बो स्टाफ के लिए), बिना अनधिकृत चिकित्सकीय प्रक्रियाएँ किए।",

      "legal_title": "⚠️ कानूनी एवं व्यवहार संबंधी शर्तें",
      "patient_point12":
          "1️⃣2️⃣ मैं / हम स्टाफ के लिए सुरक्षित, स्वच्छ और सम्मानजनक वातावरण बनाए रखेंगे।",
      "patient_point13":
          "1️⃣3️⃣ स्टाफ के साथ दुर्व्यवहार, गाली, धमकी या उत्पीड़न IPC 294 / 504 / 506 के अंतर्गत दंडनीय है।",

      "nonsolicitation_title": "🚫 गैर-प्रलोभन एवं दंड",
      "patient_point14":
          "1️⃣4️⃣ मैं / हम कंपनी द्वारा प्रदान किए गए किसी भी स्टाफ को प्रत्यक्ष या अप्रत्यक्ष रूप से नियुक्त, बनाए रखने या संलग्न नहीं करेंगे।",
      "patient_point15":
          "1️⃣5️⃣ उल्लंघन पर:\n• ₹1,00,000/- का दंड\n• IPC 406 / 420 के अंतर्गत कानूनी वसूली एवं FIR",
      "patient_point16":
          "1️⃣6️⃣ यह शर्त सेवा अवधि के दौरान और सेवा समाप्ति के बाद 12 महीने तक लागू रहेगी।",

      "confidentiality_title": "🔒 गोपनीयता एवं डेटा संरक्षण",
      "patient_point17":
          "1️⃣7️⃣ मरीज के डेटा, फोटो, वीडियो या रिपोर्ट का दुरुपयोग या लीक नहीं किया जाएगा।\nउल्लंघन IT Act 2000 – धारा 43 एवं 66 के अंतर्गत दंडनीय है।",

      "payment_title": "💰 भुगतान संबंधी शर्तें",
      "patient_point18":
          "1️⃣8️⃣ सभी सेवा भुगतान केवल कंपनी को चालान के अनुसार किए जाएँगे।",
      "patient_point19": "1️⃣9️⃣ स्टाफ को प्रत्यक्ष भुगतान करना सख्त मना है।",

      "declaration":
          "✍️ घोषणा\n2️⃣0️⃣ मैं / हमने उपरोक्त सभी नियमों और शर्तों को पढ़ा, समझा और स्वेच्छा से स्वीकार किया है।",

      "patient_fee_title": "👨‍👩‍👧 पेशेंट रिलेटिव एक्सेस फी",
      "patient_fee_content":
          "• पेशेंट रिलेटिव सॉफ्टवेयर एक्सेस फी: ₹199/-\n"
          "• वैधता: भुगतान की तारीख से 6 महीने (केवल 1 व्यक्ति के लिए)\n"
          "• एक्सेस में शामिल:\n  – मरीज की वाइटल मॉनिटरिंग\n  – ऐप / सॉफ्टवेयर में मरीज अपडेट्स\n"
          "• फी प्रकार: एक बार, गैर-वापसी योग्य\n"
          "एक बार भुगतान सफल होने पर फी वापस नहीं होगी।",

      // UI strings
      "upload_signature": "अपना हस्ताक्षर अपलोड करें",
      "tap_upload": "हस्ताक्षर अपलोड करने के लिए टैप करें",
      "submit": "सबमिट एवं साइन करें",
      "camera": "कैमरा",
      "gallery": "गैलरी",
      "upload_title": "हस्ताक्षर अपलोड करें",
      "success": "हस्ताक्षर सफलतापूर्वक अपलोड हो गया!",
      "please_upload": "कृपया हस्ताक्षर अपलोड करें",
      "signup_done":
          "साइनअप पूरा हुआ ✅\nएडमिन अप्रूवल का इंतज़ार करें।\nवेरिफिकेशन के बाद आपको ईमेल मिलेगा।",
    },

    // ────────────────────────────────────────────────
    //                   GUJARATI
    // ────────────────────────────────────────────────
    AppLanguage.gujarati: {
      // Original Staff Declaration
      "title":
          "👩‍⚕️👨‍⚕️ સ્ટાફ કાનૂની ઘોષણા અને ખાતરી\n(નર્સિંગ સ્ટાફ / કેર ટેકર / કોમ્બો સ્ટાફ માટે લાગુ)",
      "point1":
          "1️⃣ હું જાહેર કરું છું કે મારા દ્વારા સબમિટ કરાયેલા તમામ દસ્તાવેજો સાચા અને અધિકૃત છે.\nખોટી માહિતી આપવી IPC 177 / 191 / 420 હેઠળ દંડનીય છે.",
      "point2":
          "2️⃣ હું કંપનીના તમામ નિયમોનું પાલન કરીશ જેમાં ડ્યુટીનો સમય, ટ્રાન્સફર, શિસ્ત, યુનિફોર્મ અને વર્તન નીતિનો સમાવેશ થાય છે.",
      "point3":
          "3️⃣ હું દર્દીની કોઈપણ તબીબી માહિતી, ફોટો, વીડિયો કે રિપોર્ટનો દુરુપયોગ કે લીક નહીં કરું.\nઉલ્લંઘન IPC 406 અને IT Act 2000 (કલમ 43, 66) હેઠળ દંડનીય છે.",
      "point4":
          "4️⃣ કંપનીની લેખિત પરવાનગી વિના દર્દી કે તેમના સંબંધીઓ પાસેથી સીધી ચુકવણી, ટિપ્સ, ભેટ કે ખાનગી કામ લેવું સખત પ્રતિબંધિત છે.\nઉલ્લંઘન પર નોકરી રદ, કાનૂની કાર્યવાહી અને આર્થિક દંડ થઈ શકે છે.",
      "point5":
          "5️⃣ પૂર્વ સૂચના વિના ડ્યુટી છોડવાથી કંપનીને આર્થિક નુકસાન થઈ શકે છે અને દંડ કે નોકરી રદ થઈ શકે છે.",
      "point6":
          "6️⃣ ડ્યુટી દરમિયાન કે દર્દીના સ્થળે ધૂમ્રપાન, દારૂ, તમાકુ કે ડ્રગ્સનો ઉપયોગ સખત પ્રતિબંધિત છે અને તાત્કાલિક નોકરી રદ તેમજ પોલીસ કાર્યવાહી થઈ શકે છે.",
      "point7":
          "7️⃣ દર્દીઓ કે સંબંધીઓ સાથે ખરાબ વર્તન, ગાળા, ધમકી કે હેરાનગતિ IPC 294 / 504 / 506 હેઠળ દંડનીય છે.",
      "point8":
          "8️⃣ દર્દી કે કંપનીની સંપત્તિની ચોરી, છેતરપિંડી, ઠગાઈ કે નુકસાન IPC 380 / 406 / 420 હેઠળ દંડનીય છે.",
      "point9":
          "9️⃣ કંપની કે દર્દીની ગોપનીય માહિતીનો દુરુપયોગ, દર્દીને કંપની વિરુદ્ધ ભડકાવવું કે સ્ટાફને ટ્રાન્સફર કરાવવું સખત પ્રતિબંધિત છે અને સિવિલ તેમજ ક્રિમિનલ કાર્યવાહી થઈ શકે છે.",
      "point10":
          "🔟 પોલીસ વેરિફિકેશન નિષ્ફળ થવાથી નોટિસ વિના સેવા સમાપ્ત કરી શકાય છે.",
      "point11":
          "1️⃣1️⃣ દર્દી કે તેમના અધિકૃત વ્યક્તિની સંમતિથી સેવા દરમિયાન સ્ટાફનું લાઇવ લોકેશન ટ્રેકિંગ થઈ શકે છે (માત્ર નિરીક્ષણ અને સુરક્ષા માટે).",

      "caretaker_title": "🧑‍⚕️ કેર ટેકર / કોમ્બો સ્ટાફનું કાર્ય ક્ષેત્ર",
      "point12":
          "1️⃣2️⃣ દર્દીને રોજિંદા પ્રવૃત્તિઓમાં મદદ જેમ કે ચાલવું-ફરવું, ખવડાવવું, નાહવું, શૌચાલય મદદ અને સ્વચ્છતા સંભાળ.",
      "point13":
          "1️⃣3️⃣ બેડ બનાવવું, દર્દીની આરામ, પોઝિશન બદલવું અને દર્દી વિસ્તારની મૂળભૂત સફાઈ.",
      "point14":
          "1️⃣4️⃣ નર્સિંગ સ્ટાફના આદેશ મુજબ મદદ કરવી (કોમ્બો સ્ટાફ માટે), અનધિકૃત તબીબી પ્રક્રિયા વિના.",
      "point15":
          "1️⃣5️⃣ દર્દીની સ્થિતિમાં કોઈપણ ફેરફાર તરત જ કંપની કે નિયુક્ત સુપરવાઇઝરને જાણ કરવી.",

      "confidential_title": "🔒 ગોપનીયતા અને શિસ્ત",
      "confidential":
          "દર્દી અને કંપનીના ડેટાનો કોઈપણ રીતે દુરુપયોગ કે શેર કરવો પ્રતિબંધિત છે.\nઉલ્લંઘન પર IT Act, 2000 અને લાગુ ભારતીય કાયદાઓ હેઠળ શિસ્તભંગ અને કાનૂની કાર્યવાહી થશે।",

      "fee_title": "💼 જોબ અરજી ફી",
      "fee_content":
          "• જોબ અરજી / રજિસ્ટ્રેશન ફી: ₹199/-\n"
          "• માન્યતા: ચુકવણીની તારીખથી 12 મહિના\n"
          "• ફી પ્રકાર: એક વખત, બિન-રિફંડેબલ\n"
          "• લાગુ: જોબ અરજી અને પ્રોફાઇલ એક્ટિવેશન માટે",

      // Patient / Guardian Declaration
      "patient_title":
          "🧑‍⚖️ દર્દી / વાલી ઘોષણા\n(નર્સિંગ સ્ટાફ / કેર ટેકર / કોમ્બો નર્સિંગ સ્ટાફ – GNM રનિંગ સ્ટાફ માટે લાગુ)",
      "patient_point1":
          "1️⃣ હું / અમે સ્વેચ્છાએ કંપનીને મારા નિવાસ પર નર્સિંગ સ્ટાફ / કેર ટેકર / કોમ્બો નર્સિંગ સ્ટાફ (GNM રનિંગ સ્ટાફ) સેવાઓ પૂરી પાડવાની મંજૂરી આપીએ છીએ।",
      "patient_point2":
          "2️⃣ હું / અમે સમજીએ છીએ કે નર્સિંગ સ્ટાફ તાલીમ પ્રાપ્ત સંભાળ રાખનાર છે, ડોક્ટર નથી।",
      "patient_point3":
          "3️⃣ ઇમરજન્સી, સ્થિતિ બગડવી, હોસ્પિટલમાં દાખલ, એમ્બ્યુલન્સ અથવા ડોક્ટરની સલાહના કિસ્સામાં સંપૂર્ણ જવાબદારી મારી / અમારી રહેશે।",
      "patient_point4":
          "4️⃣ કંપની અથવા તેના સ્ટાફ દર્દીની તબીબી સ્થિતિને કારણે થતી જટિલતાઓ, અચાનક આરોગ્ય ફેરફાર અથવા મૃત્યુ માટે જવાબદાર રહેશે નહીં।",

      "services_title":
          "🏥 સેવાઓમાં સમાવેશ થઈ શકે છે\n(ડોક્ટરની સલાહ અને કંપનીના વિસ્તાર મુજબ)",
      "patient_point5": "5️⃣ ડોક્ટર દ્વારા નિર્ધારિત દવાઓનું સેવન કરાવવું।",
      "patient_point6": "6️⃣ વાઇટલ મોનિટરિંગ (બીપી, શુગર, નાડી, તાપમાન)।",
      "patient_point7":
          "7️⃣ ઘા ડ્રેસિંગ / ઇન્જેક્શન / કેથેટર / રાઇલ્સ ટ્યુબની સંભાળ (માત્ર અધિકૃત નર્સિંગ સ્ટાફ દ્વારા)।",
      "patient_point8": "8️⃣ સામાન્ય નર્સિંગ સંભાળ અને દર્દીની મદદ।",

      "patient_caretaker_title":
          "🧑‍🦽 કેર ટેકર / કોમ્બો સ્ટાફનું કાર્ય ક્ષેત્ર",
      "patient_point9":
          "9️⃣ દર્દીને રોજિંદા પ્રવૃત્તિઓમાં મદદ જેમ કે ચાલવું-ફરવું, ખવડાવવું, નાહવું, શૌચાલય મદદ અને સ્વચ્છતા સંભાળ।",
      "patient_point10":
          "🔟 બેડ બનાવવું, સ્થિતિ બદલવી, આરામદાયક સંભાળ અને દર્દી વિસ્તારની આસપાસની મૂળભૂત સફાઈ।",
      "patient_point11":
          "1️⃣1️⃣ સૂચના મુજબ નર્સિંગ સ્ટાફની મદદ કરવી (કોમ્બો સ્ટાફ માટે), અનધિકૃત તબીબી પ્રક્રિયા વિના।",

      "legal_title": "⚠️ કાનૂની અને વર્તન સંબંધિત શરતો",
      "patient_point12":
          "1️⃣2️⃣ હું / અમે સ્ટાફ માટે સુરક્ષિત, સ્વચ્છ અને સન્માનજનક વાતાવરણ જાળવીશું।",
      "patient_point13":
          "1️⃣3️⃣ સ્ટાફ સાથે ખરાબ વર્તન, ગાળા, ધમકી અથવા હેરાનગતિ IPC 294 / 504 / 506 હેઠળ દંડનીય છે।",

      "nonsolicitation_title": "🚫 ગેર-પ્રલોભન અને દંડ",
      "patient_point14":
          "1️⃣4️⃣ હું / અમે કંપની દ્વારા આપેલા કોઈપણ સ્ટાફને સીધો કે પરોક્ષ રીતે નોકરી, રાખવા અથવા જોડવાનું કરીશું નહીં।",
      "patient_point15":
          "1️⃣5️⃣ ઉલ્લંઘન પર:\n• ₹1,00,000/- દંડ\n• IPC 406 / 420 હેઠળ કાનૂની વસૂલી અને FIR",
      "patient_point16":
          "1️⃣6️⃣ આ શરત સેવા અવધિ દરમિયાન અને સેવા સમાપ્તિ પછી 12 મહિના સુધી લાગુ રહેશે।",

      "confidentiality_title": "🔒 ગોપનીયતા અને ડેટા સુરક્ષા",
      "patient_point17":
          "1️⃣7️⃣ દર્દીના ડેટા, ફોટો, વીડિયો અથવા રિપોર્ટનો દુરુપયોગ કે લીક નહીં કરવામાં આવે।\nઉલ્લંઘન IT Act 2000 – કલમ 43 અને 66 હેઠળ દંડનીય છે।",

      "payment_title": "💰 ચુકવણી સંબંધિત શરતો",
      "patient_point18":
          "1️⃣8️⃣ તમામ સેવા ચુકવણી માત્ર કંપનીને ઇન્વોઇસ મુજબ કરવામાં આવશે।",
      "patient_point19": "1️⃣9️⃣ સ્ટાફને સીધી ચુકવણી કરવી સખત પ્રતિબંધિત છે।",

      "declaration":
          "✍️ ઘોષણા\n2️⃣0️⃣ હું / અમે ઉપરોક્ત તમામ નિયમો અને શરતો વાંચી, સમજી અને સ્વેચ્છાએ સ્વીકાર કરી છે।",

      "patient_fee_title": "👨‍👩‍👧 પેશન્ટ રિલેટિવ એક્સેસ ફી",
      "patient_fee_content":
          "• પેશન્ટ રિલેટિવ સોફ્ટવેર એક્સેસ ફી: ₹199/-\n"
          "• માન્યતા: ચુકવણીની તારીખથી 6 મહિના (માત્ર 1 વ્યક્તિ માટે)\n"
          "• એક્સેસમાં સમાવેશ:\n  – દર્દીનું વાઇટલ મોનિટરિંગ\n  – એપ / સોફ્ટવેરમાં દર્દી અપડેટ્સ\n"
          "• ફી પ્રકાર: એક વખત, બિન-રિફંડેબલ\n"
          "એક વાર ચુકવણી સફળ થયા પછી ફી પરત નહીં થાય।",

      // UI strings
      "upload_signature": "તમારી સહી અપલોડ કરો",
      "tap_upload": "સહી અપલોડ કરવા માટે ટેપ કરો",
      "submit": "સબમિટ અને સાઇન કરો",
      "camera": "કેમેરા",
      "gallery": "ગેલેરી",
      "upload_title": "સહી અપલોડ કરો",
      "success": "સહી સફળતાપૂર્વક અપલોડ થઈ!",
      "please_upload": "કૃપા કરીને સહી અપલોડ કરો",
      "signup_done":
          "સાઇનઅપ પૂર્ણ થયું ✅\nએડમિન મંજૂરીની રાહ જુઓ.\nવેરિફિકેશન પછી તમને ઇમેઇલ મળશે।",
    },

    // ────────────────────────────────────────────────
    //                   MARATHI
    // ────────────────────────────────────────────────
    AppLanguage.marathi: {
      // Original Staff Declaration
      "title":
          "👩‍⚕️👨‍⚕️ कर्मचारी कायदेशीर घोषणा आणि हमी\n(नर्सिंग स्टाफ / केअर टेकर / कॉम्बो स्टाफ साठी लागू)",
      "point1":
          "1️⃣ मी घोषित करतो/करते की माझ्याकडून सादर केलेले सर्व कागदपत्रे खरी आणि वैध आहेत.\nखोटी माहिती देणे IPC 177 / 191 / 420 अंतर्गत दंडनीय आहे.",
      "point2":
          "2️⃣ मी कंपनीचे सर्व नियम पाळेन ज्यात ड्युटीचा वेळ, ट्रान्सफर, शिस्त, युनिफॉर्म आणि वर्तन धोरण यांचा समावेश आहे।",
      "point3":
          "3️⃣ मी रुग्णाच्या वैद्यकीय माहिती, फोटो, व्हिडिओ किंवा अहवालाचा गैरवापर किंवा लीक करणार नाही.\nउल्लंघन IPC 406 आणि IT Act 2000 (कलम 43, 66) अंतर्गत दंडनीय आहे।",
      "point4":
          "4️⃣ कंपनीच्या लेखी परवानगीशिवाय रुग्ण किंवा त्यांच्या नातेवाइकांकडून थेट पेमेंट, टिप्स, भेटवस्तू किंवा खाजगी काम घेणे काटेकोरपणे प्रतिबंधित आहे।\nउल्लंघनामुळे नोकरी संपुष्टात, कायदेशीर कारवाई आणि आर्थिक दंड होऊ शकतो।",
      "point5":
          "5️⃣ पूर्व सूचनेशिवाय ड्युटी सोडल्यास कंपनीला आर्थिक नुकसान होऊ शकते आणि दंड किंवा नोकरी संपुष्टात येऊ शकते।",
      "point6":
          "6️⃣ ड्युटीदरम्यान किंवा रुग्णाच्या परिसरात धूम्रपान, मद्य, तंबाखू किंवा ड्रग्सचा वापर काटेकोरपणे प्रतिबंधित आहे आणि तात्काळ नोकरी संपुष्टात व पोलिस कारवाई होऊ शकते।",
      "point7":
          "7️⃣ रुग्ण किंवा नातेवाइकांसोबत दुर्व्यवहार, शिवीगाळ, धमकी किंवा छळ IPC 294 / 504 / 506 अंतर्गत दंडनीय आहे।",
      "point8":
          "8️⃣ रुग्ण किंवा कंपनीच्या मालमत्तेची चोरी, फसवणूक, ठगी किंवा नुकसान IPC 380 / 406 / 420 अंतर्गत दंडनीय आहे।",
      "point9":
          "9️⃣ कंपनी किंवा रुग्णाच्या गोपनीय डेटाचा गैरवापर, रुग्णांना कंपनीविरुद्ध भडकावणे किंवा स्टाफला ट्रान्सफर करणे काटेकोरपणे प्रतिबंधित आहे आणि सिव्हिल व क्रिमिनल कारवाई होऊ शकते।",
      "point10":
          "🔟 पोलिस पडताळणी अयशस्वी झाल्यास नोटीसशिवाय सेवा संपुष्टात केली जाऊ शकते।",
      "point11":
          "1️⃣1️⃣ रुग्ण किंवा त्यांच्या अधिकृत व्यक्तीच्या संमतीने सेवा कालावधीत स्टाफचे लाइव्ह लोकेशन ट्रॅकिंग केले जाऊ शकते (फक्त निरीक्षण आणि सुरक्षिततेसाठी)।",

      "caretaker_title": "🧑‍⚕️ केअर टेकर / कॉम्बो स्टाफचे कार्य क्षेत्र",
      "point12":
          "1️⃣2️⃣ रुग्णाला दैनंदिन क्रियांमध्ये मदत जसे चालणे-फिरणे, जेवण खाणे, आंघोळ, शौचालय मदत आणि स्वच्छता काळजी।",
      "point13":
          "1️⃣3️⃣ बेड बनवणे, रुग्णाची सोय, स्थिती बदलणे आणि रुग्ण क्षेत्राची मूलभूत स्वच्छता।",
      "point14":
          "1️⃣4️⃣ नर्सिंग स्टाफच्या सूचनेनुसार मदत करणे (कॉम्बो स्टाफसाठी), अनधिकृत वैद्यकीय प्रक्रिया न करता।",
      "point15":
          "1️⃣5️⃣ रुग्णाच्या स्थितीत कोणताही बदल तात्काळ कंपनी किंवा नियुक्त सुपरवायझरला कळवणे।",

      "confidential_title": "🔒 गोपनीयता आणि शिस्त",
      "confidential":
          "रुग्ण आणि कंपनीच्या डेटाचा कोणत्याही प्रकारे गैरवापर किंवा शेअर करणे प्रतिबंधित आहे।\nउल्लंघनामुळे IT Act, 2000 आणि लागू भारतीय कायद्यांतर्गत शिस्तभंग आणि कायदेशीर कारवाई होईल।",

      "fee_title": "💼 जॉब अर्ज शुल्क",
      "fee_content":
          "• जॉब अर्ज / नोंदणी शुल्क: ₹199/-\n"
          "• वैधता: पेमेंट तारखेपासून 12 महिने\n"
          "• शुल्क प्रकार: एकदाच, परतावा न होणारे\n"
          "• लागू: जॉब अर्ज आणि प्रोफाइल अॅक्टिव्हेशनसाठी",

      // Patient / Guardian Declaration
      "patient_title":
          "🧑‍⚖️ रुग्ण / पालक घोषणा\n(नर्सिंग स्टाफ / केअर टेकर / कॉम्बो नर्सिंग स्टाफ – GNM रनिंग स्टाफ साठी लागू)",
      "patient_point1":
          "1️⃣ मी / आम्ही स्वेच्छेने कंपनीला माझ्या निवासस्थानी नर्सिंग स्टाफ / केअर टेकर / कॉम्बो नर्सिंग स्टाफ (GNM रनिंग स्टाफ) सेवा देण्याची परवानगी देतो/देतो।",
      "patient_point2":
          "2️⃣ मी / आम्ही समजतो की नर्सिंग स्टाफ प्रशिक्षित काळजीवाहू आहेत, डॉक्टर नाहीत।",
      "patient_point3":
          "3️⃣ आणीबाणी, स्थिती बिघडणे, रुग्णालयात दाखल, रुग्णवाहिका किंवा डॉक्टरांचा सल्ला यासारख्या परिस्थितीत संपूर्ण जबाबदारी माझी / आमची असेल।",
      "patient_point4":
          "4️⃣ कंपनी किंवा त्यांच्या स्टाफला रुग्णाच्या वैद्यकीय स्थितीमुळे होणाऱ्या गुंतागुंती, अचानक आरोग्य बदल किंवा मृत्यूसाठी जबाबदार धरले जाणार नाही।",

      "services_title":
          "🏥 सेवा समाविष्ट असू शकतात\n(डॉक्टरांच्या सल्ल्यानुसार आणि कंपनीच्या व्याप्तीनुसार)",
      "patient_point5": "5️⃣ डॉक्टरांनी सांगितलेल्या औषधांचे प्रशासन।",
      "patient_point6": "6️⃣ व्हायटल मॉनिटरिंग (बीपी, साखर, नाडी, तापमान)।",
      "patient_point7":
          "7️⃣ जखम ड्रेसिंग / इंजेक्शन / कॅथेटर / राइल्स ट्यूबची काळजी (फक्त अधिकृत नर्सिंग स्टाफद्वारे)।",
      "patient_point8": "8️⃣ सामान्य नर्सिंग काळजी आणि रुग्णाला मदत।",

      "patient_caretaker_title": "🧑‍🦽 केअर टेकर / कॉम्बो स्टाफ कार्य क्षेत्र",
      "patient_point9":
          "9️⃣ रुग्णाला दैनंदिन क्रियांमध्ये मदत जसे हालचाल, जेवण खाणे, आंघोळ, शौचालय मदत आणि स्वच्छता काळजी।",
      "patient_point10":
          "🔟 बेड बनवणे, स्थिती बदलणे, आरामदायक काळजी आणि रुग्ण क्षेत्राभोवती मूलभूत स्वच्छता।",
      "patient_point11":
          "1️⃣1️⃣ सूचनेनुसार नर्सिंग स्टाफला मदत करणे (कॉम्बो स्टाफसाठी), अनधिकृत वैद्यकीय प्रक्रिया न करता।",

      "legal_title": "⚠️ कायदेशीर आणि वर्तन संबंधित अटी",
      "patient_point12":
          "1️⃣2️⃣ मी / आम्ही स्टाफसाठी सुरक्षित, स्वच्छ आणि आदरपूर्ण वातावरण राखू।",
      "patient_point13":
          "1️⃣3️⃣ स्टाफसोबत दुर्व्यवहार, शिवीगाळ, धमकी किंवा छळ IPC 294 / 504 / 506 अंतर्गत दंडनीय आहे।",

      "nonsolicitation_title": "🚫 गैर-प्रलोभन आणि दंड",
      "patient_point14":
          "1️⃣4️⃣ मी / आम्ही कंपनीने दिलेल्या कोणत्याही स्टाफला थेट किंवा अप्रत्यक्षपणे नियुक्त, ठेवणे किंवा जोडणे करणार नाही।",
      "patient_point15":
          "1️⃣5️⃣ उल्लंघनावर:\n• ₹1,00,000/- दंड\n• IPC 406 / 420 अंतर्गत कायदेशीर वसुली आणि FIR",
      "patient_point16":
          "1️⃣6️⃣ ही अट सेवा कालावधीत आणि सेवा समाप्तीनंतर 12 महिने लागू राहील।",

      "confidentiality_title": "🔒 गोपनीयता आणि डेटा संरक्षण",
      "patient_point17":
          "1️⃣7️⃣ रुग्णाच्या डेटा, फोटो, व्हिडिओ किंवा रिपोर्टचा गैरवापर किंवा लीक केला जाणार नाही।\nउल्लंघन IT Act 2000 – कलम 43 आणि 66 अंतर्गत दंडनीय आहे।",

      "payment_title": "💰 पेमेंट संबंधित अटी",
      "patient_point18":
          "1️⃣8️⃣ सर्व सेवा पेमेंट फक्त कंपनीला इन्व्हॉइसनुसार केले जाईल।",
      "patient_point19":
          "1️⃣9️⃣ स्टाफला थेट पेमेंट करणे काटेकोरपणे प्रतिबंधित आहे।",

      "declaration":
          "✍️ घोषणा\n2️⃣0️⃣ मी / आम्ही वरील सर्व अटी व नियम वाचले, समजले आणि स्वेच्छेने स्वीकारले आहेत।",

      "patient_fee_title": "👨‍👩‍👧 पेशंट रिलेटिव्ह ॲक्सेस फी",
      "patient_fee_content":
          "• पेशंट रिलेटिव्ह सॉफ्टवेअर ॲक्सेस फी: ₹199/-\n"
          "• वैधता: पेमेंट तारखेपासून 6 महिने (फक्त 1 व्यक्तीसाठी)\n"
          "• ॲक्सेसमध्ये समावेश:\n  – रुग्णाचे व्हायटल मॉनिटरिंग\n  – ॲप / सॉफ्टवेअरमध्ये रुग्ण अपडेट्स\n"
          "• फी प्रकार: एकदाच, परतावा न होणारे\n"
          "एकदा पेमेंट यशस्वी झाल्यानंतर फी परत मिळणार नाही।",

      // UI strings
      "upload_signature": "तुमची सही अपलोड करा",
      "tap_upload": "सही अपलोड करण्यासाठी टॅप करा",
      "submit": "सबमिट आणि साइन करा",
      "camera": "कॅमेरा",
      "gallery": "गॅलरी",
      "upload_title": "सही अपलोड करा",
      "success": "सही यशस्वीरित्या अपलोड झाली!",
      "please_upload": "कृपया सही अपलोड करा",
      "signup_done":
          "साइनअप पूर्ण झाले ✅\nअॅडमिन मंजुरीची वाट पाहा.\nव्हेरिफिकेशन नंतर तुम्हाला ईमेल मिळेल।",
    },

    // ────────────────────────────────────────────────
    //                   KANNADA
    // ────────────────────────────────────────────────
    AppLanguage.kannada: {
      // Original Staff Declaration
      "title":
          "👩‍⚕️👨‍⚕️ ಸಿಬ್ಬಂದಿ ಕಾನೂನು ಘೋಷಣೆ ಮತ್ತು ಖಚಿತಪಡಿಸಿಕೊಳ್ಳುವಿಕೆ\n(ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿ / ಕೇರ್ ಟೇಕರ್ / ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಗೆ ಅನ್ವಯಿಸುತ್ತದೆ)",
      "point1":
          "1️⃣ ನಾನು ಘೋಷಿಸುತ್ತೇನೆ/ಘೋಷಿಸುತ್ತೇನೆ ನನ್ನಿಂದ ಸಲ್ಲಿಸಲಾದ ಎಲ್ಲಾ ದಾಖಲೆಗಳು ನಿಜ ಮತ್ತು ಮಾನ್ಯವಾಗಿವೆ.\nತಪ್ಪು ಮಾಹಿತಿ ನೀಡುವುದು IPC 177 / 191 / 420 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ।",
      "point2":
          "2️⃣ ನಾನು ಕಂಪನಿಯ ಎಲ್ಲಾ ನಿಯಮಗಳನ್ನು ಪಾಲಿಸುತ್ತೇನೆ ಇದರಲ್ಲಿ ಡ್ಯೂಟಿ ಸಮಯ, ವರ್ಗಾವಣೆ, ಶಿಸ್ತು, ಯೂನಿಫಾರ್ಮ್ ಮತ್ತು ವರ್ತನೆ ನೀತಿಯನ್ನು ಒಳಗೊಂಡಿದೆ।",
      "point3":
          "3️⃣ ನಾನು ರೋಗಿಯ ಯಾವುದೇ ವೈದ್ಯಕೀಯ ಮಾಹಿತಿ, ಫೋಟೋ, ವೀಡಿಯೊ ಅಥವಾ ವರದಿಯನ್ನು ದುರುಪಯೋಗ ಅಥವಾ ಸೋರಿಕೆ ಮಾಡುವುದಿಲ್ಲ.\nಉಲ್ಲಂಘನೆ IPC 406 ಮತ್ತು IT Act 2000 (ಕಲಂ 43, 66) ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ।",
      "point4":
          "4️⃣ ಕಂಪನಿಯ ಲಿಖಿತ ಅನುಮತಿಯಿಲ್ಲದೆ ರೋಗಿ ಅಥವಾ ಅವರ ಸಂಬಂಧಿಕರಿಂದ ನೇರ ಪಾವತಿ, ಟಿಪ್ಸ್, ಉಡುಗೊರೆ ಅಥವಾ ಖಾಸಗಿ ಕೆಲಸ ತೆಗೆದುಕೊಳ್ಳುವುದು ಕಟ್ಟುನಿಟ್ಟಾಗಿ ನಿಷೇಧಿಸಲಾಗಿದೆ।\nಉಲ್ಲಂಘನೆಗೆ ಉದ್ಯೋಗ ರದ್ದು, ಕಾನೂನು ಕ್ರಮ ಮತ್ತು ಆರ್ಥಿಕ ದಂಡ ಆಗಬಹುದು।",
      "point5":
          "5️⃣ ಮುಂಚಿತ ಸೂಚನೆಯಿಲ್ಲದೆ ಡ್ಯೂಟಿ ಬಿಡುವುದರಿಂದ ಕಂಪನಿಗೆ ಆರ್ಥಿಕ ನಷ್ಟವಾಗಬಹುದು ಮತ್ತು ದಂಡ ಅಥವಾ ಉದ್ಯೋಗ ರದ್ದಾಗಬಹುದು।",
      "point6":
          "6️⃣ ಡ್ಯೂಟಿ ಸಮಯದಲ್ಲಿ ಅಥವಾ ರೋಗಿಯ ಪರಿಸರದಲ್ಲಿ ಧೂಮಪಾನ, ಮದ್ಯ, ತಂಬಾಕು ಅಥವಾ ಡ್ರಗ್ಸ್ ಬಳಕೆ ಕಟ್ಟುನಿಟ್ಟಾಗಿ ನಿಷೇಧಿಸಲಾಗಿದೆ ಮತ್ತು ತಕ್ಷಣ ಉದ್ಯೋಗ ರದ್ದು ಮತ್ತು ಪೊಲೀಸ್ ಕ್ರಮ ಆಗಬಹುದು।",
      "point7":
          "7️⃣ ರೋಗಿಗಳು ಅಥವಾ ಸಂಬಂಧಿಕರೊಂದಿಗೆ ದುರ್ವರ್ತನೆ, ದುರುಪಯೋಗ, ಬೆದರಿಕೆ ಅಥವಾ ಹಿಂಸೆ IPC 294 / 504 / 506 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ।",
      "point8":
          "8️⃣ ರೋಗಿ ಅಥವಾ ಕಂಪನಿಯ ಆಸ್ತಿಯ ಕಳ್ಳತನ, ಮೋಸ, ಠಕ್ಕರಿ ಅಥವಾ ಹಾನಿ IPC 380 / 406 / 420 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ।",
      "point9":
          "9️⃣ ಕಂಪನಿ ಅಥವಾ ರೋಗಿಯ ಗೌಪ್ಯ ಡೇಟಾದ ದುರುಪಯೋಗ, ರೋಗಿಗಳನ್ನು ಕಂಪನಿಯ ವಿರುದ್ಧ ಭಡಕಾಯಿಸುವುದು ಅಥವಾ ಸಿಬ್ಬಂದಿಯನ್ನು ವರ್ಗಾಯಿಸುವುದು ಕಟ್ಟುನಿಟ್ಟಾಗಿ ನಿಷೇಧಿಸಲಾಗಿದೆ ಮತ್ತು ಸಿವಿಲ್ ಹಾಗೂ ಕ್ರಿಮಿನಲ್ ಕ್ರಮ ಆಗಬಹುದು।",
      "point10":
          "🔟 ಪೊಲೀಸ್ ಪರಿಶೀಲನೆ ವಿಫಲವಾದರೆ ನೋಟಿಸ್ ಇಲ್ಲದೆ ಸೇವೆ ರದ್ದು ಮಾಡಬಹುದು।",
      "point11":
          "1️⃣1️⃣ ರೋಗಿ ಅಥವಾ ಅವರ ಅಧಿಕೃತ ವ್ಯಕ್ತಿಯ ಸಮ್ಮತಿಯೊಂದಿಗೆ ಸೇವಾ ಅವಧಿಯಲ್ಲಿ ಸಿಬ್ಬಂದಿಯ ಲೈವ್ ಲೊಕೇಶನ್ ಟ್ರ್ಯಾಕಿಂಗ್ ಮಾಡಬಹುದು (ಕೇವಲ ಮೇಲ್ವಿಚಾರಣೆ ಮತ್ತು ಸುರಕ್ಷತೆಗಾಗಿ)।",

      "caretaker_title": "🧑‍⚕️ ಕೇರ್ ಟೇಕರ್ / ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಯ ಕೆಲಸ ವ್ಯಾಪ್ತಿ",
      "point12":
          "1️⃣2️⃣ ರೋಗಿಗೆ ದೈನಂದಿನ ಚಟುವಟಿಕೆಗಳಲ್ಲಿ ಸಹಾಯ ಉದಾ. ಚಲನೆ, ಆಹಾರ ನೀಡುವುದು, ಸ್ನಾನ, ಶೌಚಾಲಯ ಸಹಾಯ ಮತ್ತು ಸ್ವಚ್ಛತೆ ಕಾಳಜಿ।",
      "point13":
          "1️⃣3️⃣ ಹಾಸಿಗೆ ಮಾಡುವುದು, ರೋಗಿಯ ಆರಾಮ, ಸ್ಥಾನ ಬದಲಾವಣೆ ಮತ್ತು ರೋಗಿ ಪ್ರದೇಶದ ಮೂಲಭೂತ ಸ್ವಚ್ಛತೆ।",
      "point14":
          "1️⃣4️⃣ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿಯ ಸೂಚನೆಯಂತೆ ಸಹಾಯ ಮಾಡುವುದು (ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಗೆ), ಅನಧಿಕೃತ ವೈದ್ಯಕೀಯ ಕಾರ್ಯವಿಧಾನಗಳನ್ನು ಮಾಡದೆ।",
      "point15":
          "1️⃣5️⃣ ರೋಗಿಯ ಸ್ಥಿತಿಯಲ್ಲಿ ಯಾವುದೇ ಬದಲಾವಣೆಯನ್ನು ತಕ್ಷಣ ಕಂಪನಿ ಅಥವಾ ನಿಯೋಜಿತ ಸೂಪರ್ವೈಸರ್‌ಗೆ ವರದಿ ಮಾಡುವುದು।",

      "confidential_title": "🔒 ಗೌಪ್ಯತೆ ಮತ್ತು ಶಿಸ್ತು",
      "confidential":
          "ರೋಗಿ ಮತ್ತು ಕಂಪನಿಯ ಡೇಟಾವನ್ನು ಯಾವುದೇ ರೂಪದಲ್ಲಿ ದುರುಪಯೋಗ ಅಥವಾ ಹಂಚಿಕೊಳ್ಳುವುದು ನಿಷೇಧಿಸಲಾಗಿದೆ।\nಉಲ್ಲಂಘನೆಗೆ IT Act, 2000 ಮತ್ತು ಭಾರತೀಯ ಕಾನೂನುಗಳ ಅಡಿಯಲ್ಲಿ ಶಿಸ್ತುಭಂಗ ಮತ್ತು ಕಾನೂನು ಕ್ರಮಗಳು ಆಗುತ್ತವೆ।",

      "fee_title": "💼 ಉದ್ಯೋಗ ಅರ್ಜಿ ಶುಲ್ಕ",
      "fee_content":
          "• ಉದ್ಯೋಗ ಅರ್ಜಿ / ನೋಂದಣಿ ಶುಲ್ಕ: ₹199/-\n"
          "• ಮಾನ್ಯತೆ: ಪಾವತಿ ದಿನಾಂಕದಿಂದ 12 ತಿಂಗಳು\n"
          "• ಶುಲ್ಕ ಪ್ರಕಾರ: ಒಂದು ಬಾರಿ, ಮರುಪಾವತಿ ಯೋಗ್ಯವಲ್ಲ\n"
          "• ಅನ್ವಯ: ಉದ್ಯೋಗ ಅರ್ಜಿ ಮತ್ತು ಪ್ರೊಫೈಲ್ ಸಕ್ರಿಯಗೊಳಿಸುವಿಕೆಗೆ",

      // Patient / Guardian Declaration
      "patient_title":
          "🧑‍⚖️ ರೋಗಿ / ಪೋಷಕ ಘೋಷಣೆ\n(ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿ / ಕೇರ್ ಟೇಕರ್ / ಕಾಂಬೋ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿ – GNM ರನ್ನಿಂಗ್ ಸಿಬ್ಬಂದಿಗೆ ಅನ್ವಯಿಸುತ್ತದೆ)",
      "patient_point1":
          "1️⃣ ನಾನು / ನಾವು ಸ್ವಯಂಪ್ರೇರಣೆಯಿಂದ ಕಂಪನಿಯನ್ನು ನನ್ನ ನಿವಾಸದಲ್ಲಿ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿ / ಕೇರ್ ಟೇಕರ್ / ಕಾಂಬೋ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿ (GNM ರನ್ನಿಂಗ್ ಸಿಬ್ಬಂದಿ) ಸೇವೆಗಳನ್ನು ಒದಗಿಸಲು ಅನುಮತಿಸುತ್ತೇವೆ।",
      "patient_point2":
          "2️⃣ ನಾನು / ನಾವು ಅರ್ಥಮಾಡಿಕೊಂಡಿದ್ದೇವೆ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿ ತರಬೇತಿ ಪಡೆದ ಕಾಳಜಿಗಾರರು, ವೈದ್ಯರು ಅಲ್ಲ।",
      "patient_point3":
          "3️⃣ ತುರ್ತು ಪರಿಸ್ಥಿತಿ, ಸ್ಥಿತಿ ಹದಗೆಡುವಿಕೆ, ಆಸ್ಪತ್ರೆಗೆ ದಾಖಲು, ಆಂಬುಲೆನ್ಸ್ ಅಥವಾ ವೈದ್ಯರ ಸಲಹೆಯ ಸಂದರ್ಭದಲ್ಲಿ ಸಂಪೂರ್ಣ ಜವಾಬ್ದಾರಿ ನನ್ನ / ನಮ್ಮದಾಗಿರುತ್ತದೆ।",
      "patient_point4":
          "4️⃣ ಕಂಪನಿ ಅಥವಾ ಅದರ ಸಿಬ್ಬಂದಿ ರೋಗಿಯ ವೈದ್ಯಕೀಯ ಸ್ಥಿತಿಗೆ ಸಂಬಂಧಿಸಿದ ತೊಂದರೆಗಳು, ಹಠಾತ್ ಆರೋಗ್ಯ ಬದಲಾವಣೆ ಅಥವಾ ಮರಣಕ್ಕೆ ಜವಾಬ್ದಾರರಾಗಿರುವುದಿಲ್ಲ।",

      "services_title":
          "🏥 ಸೇವೆಗಳು ಸೇರಿರಬಹುದು\n(ವೈದ್ಯರ ಸಲಹೆ ಮತ್ತು ಕಂಪನಿಯ ವ್ಯಾಪ್ತಿಯ ಪ್ರಕಾರ)",
      "patient_point5": "5️⃣ ವೈದ್ಯರು ಸೂಚಿಸಿದ ಔಷಧಿಗಳ ನಿರ್ವಹಣೆ।",
      "patient_point6": "6️⃣ ವೈಟಲ್ ಮಾನಿಟರಿಂಗ್ (ಬಿಪಿ, ಸಕ್ಕರೆ, ನಾಡಿ, ತಾಪಮಾನ)।",
      "patient_point7":
          "7️⃣ ಗಾಯ ಡ್ರೆಸ್ಸಿಂಗ್ / ಇಂಜೆಕ್ಷನ್ / ಕ್ಯಾಥೆಟರ್ / ರೈಲ್ಸ್ ಟ್ಯೂಬ್ ಕಾಳಜಿ (ಕೇವಲ ಅಧಿಕೃತ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿಯಿಂದ)।",
      "patient_point8": "8️⃣ ಸಾಮಾನ್ಯ ನರ್ಸಿಂಗ್ ಕಾಳಜಿ ಮತ್ತು ರೋಗಿಗೆ ಸಹಾಯ।",

      "patient_caretaker_title":
          "🧑‍🦽 ಕೇರ್ ಟೇಕರ್ / ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಯ ಕೆಲಸ ವ್ಯಾಪ್ತಿ",
      "patient_point9":
          "9️⃣ ರೋಗಿಗೆ ದೈನಂದಿನ ಚಟುವಟಿಕೆಗಳಲ್ಲಿ ಸಹಾಯ ಉದಾ. ಚಲನೆ, ಆಹಾರ ನೀಡುವುದು, ಸ್ನಾನ, ಶೌಚಾಲಯ ಸಹಾಯ ಮತ್ತು ಸ್ವಚ್ಛತೆ ಕಾಳಜಿ।",
      "patient_point10":
          "🔟 ಹಾಸಿಗೆ ಮಾಡುವುದು, ಸ್ಥಾನ ಬದಲಾವಣೆ, ಆರಾಮದಾಯಕ ಕಾಳಜಿ ಮತ್ತು ರೋಗಿ ಪ್ರದೇಶದ ಸುತ್ತಮುತ್ತಲಿನ ಮೂಲಭೂತ ಸ್ವಚ್ಛತೆ।",
      "patient_point11":
          "1️⃣1️⃣ ಸೂಚನೆಯಂತೆ ನರ್ಸಿಂಗ್ ಸಿಬ್ಬಂದಿಗೆ ಸಹಾಯ ಮಾಡುವುದು (ಕಾಂಬೋ ಸಿಬ್ಬಂದಿಗೆ), ಅನಧಿಕೃತ ವೈದ್ಯಕೀಯ ಕಾರ್ಯವಿಧಾನಗಳನ್ನು ಮಾಡದೆ।",

      "legal_title": "⚠️ ಕಾನೂನು ಮತ್ತು ವರ್ತನೆ ಸಂಬಂಧಿತ ನಿಯಮಗಳು",
      "patient_point12":
          "1️⃣2️⃣ ನಾನು / ನಾವು ಸಿಬ್ಬಂದಿಗಾಗಿ ಸುರಕ್ಷಿತ, ಸ್ವಚ್ಛ ಮತ್ತು ಗೌರವಯುತ ವಾತಾವರಣವನ್ನು ಕಾಪಾಡುತ್ತೇವೆ।",
      "patient_point13":
          "1️⃣3️⃣ ಸಿಬ್ಬಂದಿಯೊಂದಿಗೆ ದುರ್ವರ್ತನೆ, ದುರುಪಯೋಗ, ಬೆದರಿಕೆ ಅಥವಾ ಹಿಂಸೆ IPC 294 / 504 / 506 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ।",

      "nonsolicitation_title": "🚫 ಗೈರ್-ಪ್ರಲೋಭನ ಮತ್ತು ದಂಡ",
      "patient_point14":
          "1️⃣4️⃣ ನಾನು / ನಾವು ಕಂಪನಿಯಿಂದ ನೀಡಲಾದ ಯಾವುದೇ ಸಿಬ್ಬಂದಿಯನ್ನು ನೇರವಾಗಿ ಅಥವಾ ಪರೋಕ್ಷವಾಗಿ ನೇಮಿಸುವುದು, ಇರಿಸಿಕೊಳ್ಳುವುದು ಅಥವಾ ಭಾಗವಹಿಸುವುದಿಲ್ಲ।",
      "patient_point15":
          "1️⃣5️⃣ ಉಲ್ಲಂಘನೆಗೆ:\n• ₹1,00,000/- ದಂಡ\n• IPC 406 / 420 ಅಡಿಯಲ್ಲಿ ಕಾನೂನು ವಸೂಲಿ ಮತ್ತು FIR",
      "patient_point16":
          "1️⃣6️⃣ ಈ ನಿಯಮ ಸೇವಾ ಅವಧಿಯಲ್ಲಿ ಮತ್ತು ಸೇವಾ ಸಮಾಪ್ತಿಯ ನಂತರ 12 ತಿಂಗಳುವರೆಗೆ ಅನ್ವಯಿಸುತ್ತದೆ।",

      "confidentiality_title": "🔒 ಗೌಪ್ಯತೆ ಮತ್ತು ಡೇಟಾ ರಕ್ಷಣೆ",
      "patient_point17":
          "1️⃣7️⃣ ರೋಗಿಯ ಡೇಟಾ, ಫೋಟೋ, ವೀಡಿಯೊ ಅಥವಾ ವರದಿಯ ದುರುಪಯೋಗ ಅಥವಾ ಸೋರಿಕೆ ಮಾಡಲಾಗುವುದಿಲ್ಲ।\nಉಲ್ಲಂಘನೆ IT Act 2000 – ಕಲಂ 43 ಮತ್ತು 66 ಅಡಿಯಲ್ಲಿ ಶಿಕ್ಷಾರ್ಹವಾಗಿದೆ।",

      "payment_title": "💰 ಪಾವತಿ ಸಂಬಂಧಿತ ನಿಯಮಗಳು",
      "patient_point18":
          "1️⃣8️⃣ ಎಲ್ಲಾ ಸೇವಾ ಪಾವತಿಗಳು ಇನ್ವಾಯ್ಸ್ ಪ್ರಕಾರ ಕೇವಲ ಕಂಪನಿಗೆ ಮಾಡಬೇಕು।",
      "patient_point19":
          "1️⃣9️⃣ ಸಿಬ್ಬಂದಿಗೆ ನೇರ ಪಾವತಿ ಮಾಡುವುದು ಕಟ್ಟುನಿಟ್ಟಾಗಿ ನಿಷೇಧಿಸಲಾಗಿದೆ।",

      "declaration":
          "✍️ ಘೋಷಣೆ\n2️⃣0️⃣ ನಾನು / ನಾವು ಮೇಲಿನ ಎಲ್ಲಾ ನಿಯಮಗಳನ್ನು ಓದಿ, ಅರ್ಥಮಾಡಿಕೊಂಡು ಸ್ವಯಂಪ್ರೇರಣೆಯಿಂದ ಸ್ವೀಕರಿಸಿದ್ದೇವೆ।",

      "patient_fee_title": "👨‍👩‍👧 ರೋಗಿ ಸಂಬಂಧಿಕ ಆ್ಯಕ್ಸೆಸ್ ಶುಲ್ಕ",
      "patient_fee_content":
          "• ರೋಗಿ ಸಂಬಂಧಿಕ ಸಾಫ್ಟ್‌ವೇರ್ ಆ್ಯಕ್ಸೆಸ್ ಶುಲ್ಕ: ₹199/-\n"
          "• ಮಾನ್ಯತೆ: ಪಾವತಿ ದಿನಾಂಕದಿಂದ 6 ತಿಂಗಳು (ಕೇವಲ 1 ವ್ಯಕ್ತಿಗೆ)\n"
          "• ಆ್ಯಕ್ಸೆಸ್‌ನಲ್ಲಿ ಸೇರ್ಪಡೆ:\n  – ರೋಗಿಯ ವೈಟಲ್ ಮಾನಿಟರಿಂಗ್\n  – ಆ್ಯಪ್ / ಸಾಫ್ಟ್‌ವೇರ್‌ನಲ್ಲಿ ರೋಗಿ ಅಪ್‌ಡೇಟ್‌ಗಳು\n"
          "• ಶುಲ್ಕ ಪ್ರಕಾರ: ಒಂದು ಬಾರಿ, ಮರುಪಾವತಿ ಯೋಗ್ಯವಲ್ಲ\n"
          "ಒಮ್ಮೆ ಪಾವತಿ ಯಶಸ್ವಿಯಾದ ನಂತರ ಶುಲ್ಕ ಮರುಪಾವತಿಯಾಗುವುದಿಲ್ಲ।",

      // UI strings
      "upload_signature": "ನಿಮ್ಮ ಸಹಿಯನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
      "tap_upload": "ಸಹಿ ಅಪ್‌ಲೋಡ್ ಮಾಡಲು ಟ್ಯಾಪ್ ಮಾಡಿ",
      "submit": "ಸಲ್ಲಿಸಿ ಮತ್ತು ಸಹಿ ಮಾಡಿ",
      "camera": "ಕ್ಯಾಮೆರಾ",
      "gallery": "ಗ್ಯಾಲರಿ",
      "upload_title": "ಸಹಿ ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
      "success": "ಸಹಿ ಯಶಸ್ವಿಯಾಗಿ ಅಪ್‌ಲೋಡ್ ಆಯಿತು!",
      "please_upload": "ದಯವಿಟ್ಟು ಸಹಿಯನ್ನು ಅಪ್‌ಲೋಡ್ ಮಾಡಿ",
      "signup_done":
          "ಸೈನ್‌ಅಪ್ ಪೂರ್ಣಗೊಂಡಿದೆ ✅\nಆಡ್ಮಿನ್ ಅನುಮೋದನೆಗಾಗಿ ನಿರೀಕ್ಷಿಸಿ.\nಪರಿಶೀಲನೆ ನಂತರ ನಿಮಗೆ ಇಮೇಲ್ ಸಿಗುತ್ತದೆ।",
    },
  };

  static String t(String key) {
    final currentMap = strings[current];
    if (currentMap != null && currentMap.containsKey(key)) {
      return currentMap[key]!;
    }

    final englishMap = strings[AppLanguage.english];
    if (englishMap != null && englishMap.containsKey(key)) {
      return englishMap[key]!;
    }

    debugPrint("⚠️ Missing translation key: $key  (lang = ${current.name})");
    return key;
  }
}
