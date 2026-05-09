import 'dart:async';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'firestore_service.dart';

class DiscountService extends GetxService {
  DiscountService();

  static DiscountService get to => Get.find<DiscountService>();

  final RxDouble adDiscount = 5.0.obs;    // starts at 5% (welcome)
  final RxInt adProgressCount = 0.obs;
  final RxBool adsRewardEnabled = true.obs;

  StreamSubscription? _discountSub;

  @override
  void onInit() {
    super.onInit();
    ever(AuthService.to.currentUser, (_) => _bindUserDiscount());
    _bindUserDiscount();
    _fetchAdminAdControl();
  }

  @override
  void onClose() {
    _discountSub?.cancel();
    super.onClose();
  }

  void _bindUserDiscount() {
    _discountSub?.cancel();
    final uid = AuthService.to.currentUser.value?.uid;
    if (uid == null) return;
    _discountSub = FirestoreService.usersCollection
        .doc(uid)
        .snapshots()
        .listen(
      (snap) {
        if (!snap.exists) return;
        final d = snap.data() ?? {};
        adDiscount.value = (d['glowAdDiscount'] as num?)?.toDouble() ?? 5.0;
        adProgressCount.value = (d['glowAdProgressCount'] as num?)?.toInt() ?? 0;
      },
      onError: (e) {
        // Ignore permission denied errors during logout
      },
    );
  }

  Future<void> _fetchAdminAdControl() async {
    try {
      final snap = await FirestoreService.instance
          .collection('discounts')
          .doc('glowvella_ads')
          .get();
      if (snap.exists) {
        adsRewardEnabled.value =
            snap.data()?['adsRewardEnabled'] as bool? ?? true;
      }
    } catch (_) {}
  }

  /// Called after a rewarded ad is watched.
  Future<void> applyAdReward() async {
    if (!adsRewardEnabled.value) return;
    final uid = AuthService.to.currentUser.value?.uid;
    if (uid == null) return;

    final currentDiscount = adDiscount.value;
    if (currentDiscount >= 20) return; // already at cap

    // Watch-count required per tier
    int requiredWatches;
    if (currentDiscount < 5) {
      requiredWatches = 1;
    } else if (currentDiscount < 10) {
      requiredWatches = 2;
    } else if (currentDiscount < 15) {
      requiredWatches = 4;
    } else {
      requiredWatches = 8;
    }

    final newCount = adProgressCount.value + 1;
    double newDiscount = currentDiscount;

    if (newCount % requiredWatches == 0) {
      newDiscount = (currentDiscount + 1).clamp(0.0, 20.0);
    }

    await FirestoreService.usersCollection.doc(uid).update({
      'glowAdDiscount': newDiscount,
      'glowAdProgressCount': newCount,
    });
  }

  double get currentDiscount => adDiscount.value;

  double totalDiscount({bool isBankTransfer = false}) {
    double total = adDiscount.value;
    if (isBankTransfer) total += 5;
    return total.clamp(0.0, 30.0);
  }
}
