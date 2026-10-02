class DashboardResponse {
  final Nurse nurse;
  final List<TodayVisit> visits;
  final List<WeeklyHour> weeklyHours;

  DashboardResponse({
    required this.nurse,
    required this.visits,
    required this.weeklyHours,
  });

  factory DashboardResponse.fromJson(Map<String, dynamic> json) {
    return DashboardResponse(
      nurse: Nurse.fromJson(json["nurse"]),
      visits: (json["today_visits"] as List)
          .map((e) => TodayVisit.fromJson(e))
          .toList(),
      weeklyHours: (json["weekly_hours"] as List)
          .map((e) => WeeklyHour.fromJson(e))
          .toList(),
    );
  }
}

class Nurse {
  final String name;
  final String type;
  final String status;
  final String workedTime;

  Nurse.fromJson(Map<String, dynamic> json)
      : name = json["name"],
        type = json["nurse_type"],
        status = json["status"],
        workedTime = json["worked_time"];
}

class TodayVisit {
  final String patient;
  final String room;
  final String type;

  TodayVisit.fromJson(Map<String, dynamic> json)
      : patient = json["patient_name"],
        room = "${json["ward"]} • ${json["room_no"]}",
        type = json["visit_type"];
}

class WeeklyHour {
  final String day;
  final double hours;

  WeeklyHour.fromJson(Map<String, dynamic> json)
      : day = json["day"],
        hours = (json["hours"] as num).toDouble();
}
