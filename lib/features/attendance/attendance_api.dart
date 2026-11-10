import 'package:healthcare/core/network/api_client.dart';
import 'attendance_models.dart';

/// ===========================================================================
///  FACE ATTENDANCE - API LAYER
///
///  Backend already live hai, usme koi change nahi kiya gaya.
///
///  Endpoints
///  ---------
///   GET    /nurse/face/status                 -> AttendanceStatus
///   POST   /nurse/face/enroll                 -> 6 photos enroll
///   DELETE /nurse/face/enroll                 -> enrollment hatao
///   POST   /nurse/face/punch                  -> PunchResult
///   GET    /nurse/face/history?month=YYYY-MM  -> List<AttendanceDay>
///
///  Images hamesha is format me jaati hain:
///     "data:image/jpeg;base64,<....>"
///  (long side <= 720px, JPEG quality ~80, normally ~60-130 KB)
///
///  ⚠️ SECURITY: base64 image aur JWT token kabhi log nahi hote.
///     Isiliye punch/enroll ke liye ApiClient.postNoLog() use hota hai,
///     jo sirf status code print karta hai - request body nahi.
///
///  NOTE ON KEY NAMES: request body me kuch aliases bhi bheje jaate hain
///  (jaise `type` + `punch_type`, `latitude` + `lat`). FastAPI by default
///  extra fields ignore kar deta hai, isliye ye safe hai aur backend ki
///  exact naming jo bhi ho, request first try me match ho jaati hai.
/// ===========================================================================

class FaceAttendanceApi {
  static const String _status = '/nurse/face/status';
  static const String _enroll = '/nurse/face/enroll';
  static const String _punch = '/nurse/face/punch';
  static const String _history = '/nurse/face/history';

  /// Aaj ka attendance + face enrollment state.
  static Future<AttendanceStatus> fetchStatus() async {
    final res = await ApiClient.get(_status);
    return AttendanceStatus.fromJson(res);
  }

  /// 6 face photos enroll karo.
  static Future<String?> enrollFaces(List<String> dataUris) async {
    final res = await ApiClient.postNoLog(_enroll, {
      'images': dataUris,
      // alias - agar backend dusra naam expect kare
      'photos': dataUris,
    });
    final map = asMapOrNull(res);
    return asStringOrNull(pickValue(map, ['message', 'detail', 'msg']));
  }

  /// Enrollment delete karo (dobara enroll karne se pehle).
  static Future<void> deleteEnrollment() async {
    await ApiClient.delete(_enroll, {});
  }

  /// Face + GPS ke saath punch in/out.
  ///
  /// [type] - "in" ya "out"
  /// [imageDataUri] - "data:image/jpeg;base64,..."
  static Future<PunchResult> punch({
    required String type,
    required String imageDataUri,
    required double latitude,
    required double longitude,
    double? accuracy,
  }) async {
    final body = <String, dynamic>{
      'image': imageDataUri,
      'type': type,
      'latitude': latitude,
      'longitude': longitude,
      // aliases
      'punch_type': type,
      'lat': latitude,
      'lng': longitude,
      if (accuracy != null) 'accuracy': accuracy,
    };

    final res = await ApiClient.postNoLog(_punch, body);
    return PunchResult.fromJson(res, fallbackType: type);
  }

  /// Mahine ki attendance history. [month] = "YYYY-MM"
  static Future<AttendanceHistory> fetchHistory(String month) async {
    final res = await ApiClient.get('$_history?month=$month');

    List<dynamic> rawDays = const [];
    dynamic summaryRaw;

    if (res is List) {
      rawDays = res;
    } else {
      final map = asMapOrNull(res) ?? <String, dynamic>{};
      final root = asMapOrNull(pickValue(map, ['data', 'result'])) ?? map;
      final list = pickValue(root, [
        'days',
        'history',
        'attendance',
        'records',
        'items',
        'data',
      ]);
      if (list is List) rawDays = list;
      summaryRaw = pickValue(root, ['summary', 'stats', 'totals']);
    }

    final days = rawDays.map(AttendanceDay.fromJson).toList()
      ..sort((a, b) {
        final ad = a.date, bd = b.date;
        if (ad == null || bd == null) return 0;
        return bd.compareTo(ad); // naye din upar
      });

    return AttendanceHistory(
      days: days,
      summary: AttendanceSummary.from(summaryRaw, days),
    );
  }
}

class AttendanceHistory {
  final List<AttendanceDay> days;
  final AttendanceSummary summary;

  const AttendanceHistory({required this.days, required this.summary});
}

/// ApiClient `Exception("<detail>")` throw karta hai.
/// UI me "Exception: " prefix nahi dikhana chahiye - backend ka Hindi
/// message jaisa hai waisa hi dikhana hai.
String apiErrorText(Object error) {
  var msg = error.toString().trim();
  if (msg.startsWith('Exception:')) {
    msg = msg.substring('Exception:'.length).trim();
  }
  if (msg.isEmpty) return 'Kuch galat ho gaya. Dobara koshish karein.';

  final lower = msg.toLowerCase();
  if (lower.contains('socketexception') ||
      lower.contains('failed host lookup') ||
      lower.contains('network is unreachable') ||
      lower.contains('connection refused') ||
      lower.contains('clientexception')) {
    return 'Internet connection check karein, phir dobara try karein.';
  }
  if (lower.contains('timeoutexception') || lower.contains('timed out')) {
    return 'Server se jawab nahi mila. Dobara koshish karein.';
  }
  return msg;
}
