import 'package:intl/intl.dart';
import 'package:healthcare/core/network/base.dart';

/// ===========================================================================
///  FACE ATTENDANCE - DATA MODELS
///
///  Backend live hai aur usme koi change nahi karna hai, isliye ye models
///  "tolerant" likhe gaye hain: har field ke liye kuch common key-spellings
///  accept hoti hain (snake_case / camelCase / chhote naam). Agar backend
///  thodi alag key bheje to app crash nahi hoga - value bas null rahegi aur
///  UI apna fallback dikha dega.
///
///  Sabhi timestamps backend se IST me aate hain -> yahan device ke LOCAL
///  time me convert karke dikhate hain (IstTime class).
/// ===========================================================================

/// In keys me se jo pehle mile wahi value return karo.
dynamic pickValue(Map? map, List<String> keys) {
  if (map == null) return null;
  for (final k in keys) {
    final v = map[k];
    if (v != null) return v;
  }
  return null;
}

bool? asBoolOrNull(dynamic v) {
  if (v == null) return null;
  if (v is bool) return v;
  if (v is num) return v != 0;
  final s = v.toString().trim().toLowerCase();
  if (s == 'true' || s == '1' || s == 'yes' || s == 'y') return true;
  if (s == 'false' || s == '0' || s == 'no' || s == 'n') return false;
  return null;
}

int? asIntOrNull(dynamic v) {
  if (v == null) return null;
  if (v is int) return v;
  if (v is num) return v.toInt();
  return int.tryParse(v.toString().trim());
}

double? asDoubleOrNull(dynamic v) {
  if (v == null) return null;
  if (v is num) return v.toDouble();
  return double.tryParse(v.toString().trim());
}

String? asStringOrNull(dynamic v) {
  if (v == null) return null;
  final s = v.toString().trim();
  return s.isEmpty ? null : s;
}

Map<String, dynamic>? asMapOrNull(dynamic v) {
  if (v is Map) return Map<String, dynamic>.from(v);
  return null;
}

/// Backend relative path deta hai (`uploads/face/abc.jpg`) ->
/// usko full URL bana do (`https://domain/uploads/face/abc.jpg`).
String? absoluteMediaUrl(dynamic raw) {
  final path = asStringOrNull(raw);
  if (path == null) return null;
  if (path.startsWith('http://') || path.startsWith('https://')) return path;
  if (path.startsWith('data:')) return path;
  final base = baseUrlApi.endsWith('/')
      ? baseUrlApi.substring(0, baseUrlApi.length - 1)
      : baseUrlApi;
  final clean = path.startsWith('/') ? path.substring(1) : path;
  return '$base/$clean';
}

/// ===========================================================================
///  IST -> LOCAL TIME
/// ===========================================================================
class IstTime {
  static const Duration offset = Duration(hours: 5, minutes: 30);

  /// Backend IST bhejta hai. Agar string me timezone nahi hai to use IST
  /// maankar device ke local time me convert karte hain.
  static DateTime? toLocal(dynamic raw) {
    final input = asStringOrNull(raw);
    if (input == null) return null;

    // "2026-10-05 09:14:33" -> "2026-10-05T09:14:33"
    var s = input.replaceFirst(' ', 'T');

    // Sirf time aaya ho: "09:14" ya "09:14:33"
    final onlyTime = RegExp(r'^(\d{1,2}):(\d{2})(?::(\d{2}))?$').firstMatch(s);
    if (onlyTime != null) {
      final nowIst = DateTime.now().toUtc().add(offset);
      final utc = DateTime.utc(
        nowIst.year,
        nowIst.month,
        nowIst.day,
        int.parse(onlyTime.group(1)!),
        int.parse(onlyTime.group(2)!),
        int.parse(onlyTime.group(3) ?? '0'),
      ).subtract(offset);
      return utc.toLocal();
    }

    // Epoch seconds / millis
    final asNum = num.tryParse(s);
    if (asNum != null && s.length >= 9) {
      final ms = s.length > 11 ? asNum.toInt() : asNum.toInt() * 1000;
      return DateTime.fromMillisecondsSinceEpoch(ms).toLocal();
    }

    final parsed = DateTime.tryParse(s);
    if (parsed == null) return null;

    final hasZone = RegExp(r'(Z|z|[+-]\d{2}:?\d{2})$').hasMatch(s);
    if (hasZone) return parsed.toLocal();

    // Timezone nahi mila => backend ne IST bheja hai.
    final utc = DateTime.utc(
      parsed.year,
      parsed.month,
      parsed.day,
      parsed.hour,
      parsed.minute,
      parsed.second,
    ).subtract(offset);
    return utc.toLocal();
  }

  /// "09:14 AM" (device local time)
  static String clock(dynamic raw, {String fallback = '--:--'}) {
    final d = toLocal(raw);
    if (d == null) return fallback;
    return DateFormat('hh:mm a').format(d);
  }

  static String clockOf(DateTime? d, {String fallback = '--:--'}) {
    if (d == null) return fallback;
    return DateFormat('hh:mm a').format(d);
  }
}

/// ===========================================================================
///  AttendanceToday
/// ===========================================================================
enum AttendanceState { notPunchedIn, onDuty, completed }

class AttendanceToday {
  final DateTime? punchIn;
  final DateTime? punchOut;
  final bool canPunchIn;
  final bool canPunchOut;
  final String? rawStatus;
  final double? workedHours;

  const AttendanceToday({
    this.punchIn,
    this.punchOut,
    required this.canPunchIn,
    required this.canPunchOut,
    this.rawStatus,
    this.workedHours,
  });

  static const AttendanceToday empty = AttendanceToday(
    canPunchIn: true,
    canPunchOut: false,
  );

  factory AttendanceToday.fromJson(Map? json) {
    if (json == null) return empty;

    final inAt = IstTime.toLocal(
      pickValue(json, [
        'punch_in_time',
        'punch_in',
        'punchInTime',
        'in_time',
        'check_in',
        'checkin_time',
      ]),
    );
    final outAt = IstTime.toLocal(
      pickValue(json, [
        'punch_out_time',
        'punch_out',
        'punchOutTime',
        'out_time',
        'check_out',
        'checkout_time',
      ]),
    );

    // Backend bheje to wahi maano, warna time se khud derive kar lo.
    final canIn =
        asBoolOrNull(pickValue(json, ['can_punch_in', 'canPunchIn'])) ??
        (inAt == null);
    final canOut =
        asBoolOrNull(pickValue(json, ['can_punch_out', 'canPunchOut'])) ??
        (inAt != null && outAt == null);

    return AttendanceToday(
      punchIn: inAt,
      punchOut: outAt,
      canPunchIn: canIn,
      canPunchOut: canOut,
      rawStatus: asStringOrNull(pickValue(json, ['status', 'state'])),
      workedHours: asDoubleOrNull(
        pickValue(json, ['worked_hours', 'hours', 'total_hours']),
      ),
    );
  }

  AttendanceState get state {
    if (punchIn != null && punchOut != null) return AttendanceState.completed;
    if (punchIn != null) return AttendanceState.onDuty;
    return AttendanceState.notPunchedIn;
  }

  String get stateLabel {
    switch (state) {
      case AttendanceState.completed:
        return 'Completed';
      case AttendanceState.onDuty:
        return 'On duty';
      case AttendanceState.notPunchedIn:
        return 'Not punched in';
    }
  }

  String get punchInText => IstTime.clockOf(punchIn);
  String get punchOutText => IstTime.clockOf(punchOut);
}

/// ===========================================================================
///  AttendanceStatus  (GET /nurse/face/status)
/// ===========================================================================
class AttendanceStatus {
  final bool enrolled;
  final int enrolledImages;
  final AttendanceToday today;
  final String? message;

  const AttendanceStatus({
    required this.enrolled,
    required this.enrolledImages,
    required this.today,
    this.message,
  });

  factory AttendanceStatus.fromJson(dynamic raw) {
    final json = asMapOrNull(raw) ?? <String, dynamic>{};

    // Kuch backends payload ko "data" ke andar wrap karte hain.
    final root = asMapOrNull(pickValue(json, ['data', 'result'])) ?? json;

    final todayMap = asMapOrNull(
      pickValue(root, ['today', 'today_attendance', 'attendance']),
    );

    return AttendanceStatus(
      enrolled:
          asBoolOrNull(
            pickValue(root, [
              'enrolled',
              'is_enrolled',
              'face_enrolled',
              'has_face',
            ]),
          ) ??
          false,
      enrolledImages:
          asIntOrNull(
            pickValue(root, [
              'images',
              'image_count',
              'enrolled_images',
              'samples',
              'total_images',
            ]),
          ) ??
          0,
      today: AttendanceToday.fromJson(todayMap ?? root),
      message: asStringOrNull(pickValue(root, ['message', 'msg'])),
    );
  }
}

/// ===========================================================================
///  PunchResult  (POST /nurse/face/punch)
/// ===========================================================================
class PunchResult {
  final String type; // "in" | "out"
  final DateTime? time;
  final double? distanceMeters;
  final String? message;

  const PunchResult({
    required this.type,
    this.time,
    this.distanceMeters,
    this.message,
  });

  factory PunchResult.fromJson(dynamic raw, {required String fallbackType}) {
    final json = asMapOrNull(raw) ?? <String, dynamic>{};
    final root = asMapOrNull(pickValue(json, ['data', 'result'])) ?? json;

    // Distance metre me ho sakti hai ya km me.
    double? metres = asDoubleOrNull(
      pickValue(root, [
        'distance_m',
        'distance_meters',
        'distance_metres',
        'distance',
      ]),
    );
    final km = asDoubleOrNull(pickValue(root, ['distance_km']));
    if (metres == null && km != null) metres = km * 1000;

    return PunchResult(
      type:
          asStringOrNull(pickValue(root, ['type', 'punch_type', 'action'])) ??
          fallbackType,
      time: IstTime.toLocal(
        pickValue(root, [
          'time',
          'punch_time',
          'punch_in_time',
          'punch_out_time',
          'timestamp',
          'at',
        ]),
      ),
      distanceMeters: metres,
      message: asStringOrNull(
        pickValue(root, ['message', 'msg', 'detail', 'status_message']),
      ),
    );
  }

  String get timeText => IstTime.clockOf(time, fallback: '');

  String? get distanceText {
    final d = distanceMeters;
    if (d == null) return null;
    if (d < 1000) return '${d.round()} m';
    return '${(d / 1000).toStringAsFixed(2)} km';
  }

  /// Snackbar me dikhane wali line.
  String get successLine {
    final label = type.toLowerCase().contains('out')
        ? 'Punch Out'
        : 'Punch In';
    final buf = StringBuffer('$label successful');
    if (timeText.isNotEmpty) buf.write(' - $timeText');
    final dist = distanceText;
    if (dist != null) buf.write(' ($dist door)');
    return buf.toString();
  }
}

/// ===========================================================================
///  AttendanceDay  (GET /nurse/face/history?month=YYYY-MM)
/// ===========================================================================
class AttendanceDay {
  final DateTime? date;
  final DateTime? punchIn;
  final DateTime? punchOut;
  final String status;
  final double? workedHours;
  final String? inPhoto;
  final String? outPhoto;

  const AttendanceDay({
    this.date,
    this.punchIn,
    this.punchOut,
    required this.status,
    this.workedHours,
    this.inPhoto,
    this.outPhoto,
  });

  factory AttendanceDay.fromJson(dynamic raw) {
    final json = asMapOrNull(raw) ?? <String, dynamic>{};

    final inAt = IstTime.toLocal(
      pickValue(json, [
        'punch_in_time',
        'punch_in',
        'in_time',
        'check_in',
        'punchInTime',
      ]),
    );
    final outAt = IstTime.toLocal(
      pickValue(json, [
        'punch_out_time',
        'punch_out',
        'out_time',
        'check_out',
        'punchOutTime',
      ]),
    );

    var day = IstTime.toLocal(pickValue(json, ['date', 'day', 'attendance_date']));
    // Agar "day" sirf number ho (1..31) to date banane ke liye use nahi karenge.
    day ??= inAt ?? outAt;

    var st =
        asStringOrNull(pickValue(json, ['status', 'state', 'type'])) ??
        (inAt != null ? 'present' : 'absent');

    return AttendanceDay(
      date: day,
      punchIn: inAt,
      punchOut: outAt,
      status: st.toLowerCase(),
      workedHours: asDoubleOrNull(
        pickValue(json, ['worked_hours', 'hours', 'total_hours', 'duration']),
      ),
      inPhoto: absoluteMediaUrl(
        pickValue(json, ['punch_in_image', 'in_image', 'in_photo', 'image_in']),
      ),
      outPhoto: absoluteMediaUrl(
        pickValue(json, [
          'punch_out_image',
          'out_image',
          'out_photo',
          'image_out',
        ]),
      ),
    );
  }

  String get dayNumber => date == null ? '--' : DateFormat('dd').format(date!);
  String get weekday => date == null ? '' : DateFormat('EEE').format(date!);
  String get monthShort => date == null ? '' : DateFormat('MMM').format(date!);

  String get hoursText {
    if (workedHours != null) {
      final h = workedHours!.floor();
      final m = ((workedHours! - h) * 60).round();
      return '${h}h ${m}m';
    }
    if (punchIn != null && punchOut != null) {
      final diff = punchOut!.difference(punchIn!);
      return '${diff.inHours}h ${diff.inMinutes % 60}m';
    }
    return '-';
  }
}

/// History screen ka summary (backend bheje to wahi, warna khud gin lo).
class AttendanceSummary {
  final int present;
  final int absent;
  final int half;
  final int totalDays;

  const AttendanceSummary({
    required this.present,
    required this.absent,
    required this.half,
    required this.totalDays,
  });

  factory AttendanceSummary.from(dynamic raw, List<AttendanceDay> days) {
    final json = asMapOrNull(raw);
    if (json != null && json.isNotEmpty) {
      return AttendanceSummary(
        present: asIntOrNull(pickValue(json, ['present', 'present_days'])) ?? 0,
        absent: asIntOrNull(pickValue(json, ['absent', 'absent_days'])) ?? 0,
        half: asIntOrNull(pickValue(json, ['half', 'half_day', 'half_days'])) ?? 0,
        totalDays:
            asIntOrNull(pickValue(json, ['total_days', 'total'])) ?? days.length,
      );
    }
    var p = 0, a = 0, h = 0;
    for (final d in days) {
      if (d.status.startsWith('half')) {
        h++;
      } else if (d.status.startsWith('p')) {
        p++;
      } else {
        a++;
      }
    }
    return AttendanceSummary(
      present: p,
      absent: a,
      half: h,
      totalDays: days.length,
    );
  }
}
