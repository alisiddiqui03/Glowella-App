import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../data/models/glow_order.dart';
import '../data/models/points_history.dart';
import 'auth_service.dart';
import 'firestore_service.dart';
import 'points_service.dart';

class OrderService extends GetxService {
  OrderService();

  static OrderService get to => Get.find<OrderService>();

  final RxList<GlowOrder> orders = <GlowOrder>[].obs;
  final RxBool isOrdersLoading = true.obs;

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _adminSub;

  @override
  void onInit() {
    super.onInit();
    _bindAdminStream();
    ever(AuthService.to.currentUser, (_) => _bindAdminStream());
  }

  @override
  void onClose() {
    _adminSub?.cancel();
    super.onClose();
  }

  void _bindAdminStream() {
    _adminSub?.cancel();
    _adminSub = null;
    if (!AuthService.to.isAdmin) {
      orders.clear();
      isOrdersLoading.value = false;
      return;
    }
    isOrdersLoading.value = true;
    _adminSub = FirestoreService.ordersCollectionGroup
        .orderBy('createdAt', descending: true)
        .snapshots()
        .listen(
      (snap) {
        orders.assignAll(snap.docs.map((d) => GlowOrder.fromMap(
              d.id,
              d.data(),
              firestorePath: d.reference.path,
            )));
        isOrdersLoading.value = false;
      },
      onError: (_) => isOrdersLoading.value = false,
    );
  }

  Future<List<GlowOrder>> fetchUserOrders(String uid) async {
    final snap = await FirestoreService.usersOrdersRef(uid)
        .where('app', isEqualTo: 'glowvella')
        .orderBy('createdAt', descending: true)
        .get(const GetOptions(source: Source.server));
    return snap.docs
        .map((d) => GlowOrder.fromMap(d.id, d.data()))
        .toList();
  }

  Stream<List<GlowOrder>> userOrdersStream(String uid) {
    return FirestoreService.usersOrdersRef(uid)
        .where('app', isEqualTo: 'glowvella')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((s) => s.docs
            .map((d) => GlowOrder.fromMap(d.id, d.data()))
            .toList());
  }

  Future<String> createOrder(GlowOrder order) async {
    final uid = order.userId;
    if (uid == null) throw StateError('Order must have userId');
    final col = FirestoreService.usersOrdersRef(uid);
    final doc = await col.add(order.toMap());
    return doc.id;
  }

  Future<void> updateStatus(GlowOrder order, OrderStatus status) async {
    final path = order.firestorePath;
    if (path == null) return;
    final ref = FirestoreService.instance.doc(path);

    final updates = <String, dynamic>{'status': status.name};
    if (status == OrderStatus.delivered) {
      updates['deliveredAt'] = FieldValue.serverTimestamp();
    }
    await ref.update(updates);

    // Trigger points when delivered
    if (status == OrderStatus.delivered) {
      await _grantPointsOnDelivery(order);
    }
  }

  Future<void> _grantPointsOnDelivery(GlowOrder order) async {
    final uid = order.userId;
    if (uid == null || uid.isEmpty) return;
    try {
      await FirestoreService.instance.runTransaction((txn) async {
        final userRef = FirestoreService.usersCollection.doc(uid);
        final userSnap = await txn.get(userRef);
        final userData = userSnap.data() ?? {};

        final isVip = userData['isVip'] as bool? ?? false;
        final currentPoints = (userData['points'] as num?)?.toInt() ?? 0;
        final earned = PointsService.to.calculateEarnedPoints(
          orderPaidTotal: order.total,
          isVip: isVip,
        );
        if (earned <= 0) return;

        final newPoints = currentPoints + earned;
        txn.update(userRef, {'points': newPoints});

        final histRef = FirestoreService.usersPointsHistoryRef(uid).doc();
        final hist = PointHistoryItem(
          id: histRef.id,
          type: 'order',
          points: earned,
          createdAt: DateTime.now(),
          referenceId: order.id,
          source: 'glowvella',
        );
        txn.set(histRef, hist.toMap());
      });
    } catch (e) {
      // Non-fatal
    }
  }

  Future<void> updatePaidStatus(GlowOrder order, bool isPaid) async {
    final path = order.firestorePath;
    if (path == null) return;
    await FirestoreService.instance.doc(path).update({'isPaid': isPaid});
  }

  Future<void> cancelOrder(GlowOrder order, String reason) async {
    final path = order.firestorePath;
    if (path == null) throw StateError('Order path missing');
    if (order.status == OrderStatus.cancelled) {
      throw StateError('Order is already cancelled');
    }
    await FirestoreService.instance.doc(path).update({
      'status': OrderStatus.cancelled.name,
      'cancellationReason': reason.trim(),
      'cancelledAt': FieldValue.serverTimestamp(),
      'cancellationUnreadForUser': true,
    });
  }

  // Dashboard aggregates
  double get totalRevenue => orders.fold(0, (s, o) => s + o.total);
  int get pendingCount =>
      orders.where((o) => o.status == OrderStatus.pending).length;
  int get deliveredCount =>
      orders.where((o) => o.status == OrderStatus.delivered).length;
  int get unpaidBankTransferCount => orders
      .where((o) => !o.isCod && !o.isPaid && o.status != OrderStatus.cancelled)
      .length;
}
