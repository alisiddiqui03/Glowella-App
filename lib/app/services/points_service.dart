import 'package:get/get.dart';
import '../data/models/points_history.dart';
import 'firestore_service.dart';

class PointsService extends GetxService {
  PointsService();

  static PointsService get to => Get.find<PointsService>();

  /// Normal: 1 point per 200 PKR. VIP: 2 points per 200 PKR.
  int calculateEarnedPoints({
    required double orderPaidTotal,
    required bool isVip,
  }) {
    final base = (orderPaidTotal / 200).floor();
    if (base <= 0) return 0;
    return isVip ? base * 2 : base;
  }

  Future<List<PointHistoryItem>> fetchHistory(String uid) async {
    final snap = await FirestoreService.usersPointsHistoryRef(uid)
        .where('source', isEqualTo: 'glowvella')
        .orderBy('createdAt', descending: true)
        .get();
    return snap.docs
        .map((d) => PointHistoryItem.fromMap(d.id, d.data()))
        .toList();
  }
}
