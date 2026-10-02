import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';

final punchProvider = Provider((ref) => PunchService());

class PunchService {
  /// Punch In with location
  Future<void> inDuty({
    required String staffId,
    required String location,
  }) async {
    await ApiClient.post("/staff/$staffId/punch-in?location=$location", {});
  }

  /// Punch Out
  Future<void> outDuty(String staffId) async {
    await ApiClient.post("/staff/$staffId/punch-out", {});
  }
}
