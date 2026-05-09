import 'dart:async';
import 'package:get/get.dart';

import 'auth_service.dart';
import 'firestore_service.dart';

class WalletService extends GetxService {
  WalletService();

  static WalletService get to => Get.find<WalletService>();

  final RxDouble walletBalance = 0.0.obs;

  StreamSubscription? _walletSub;

  @override
  void onInit() {
    super.onInit();
    ever(AuthService.to.currentUser, (_) => _bindStream());
    _bindStream();
  }

  @override
  void onClose() {
    _walletSub?.cancel();
    super.onClose();
  }

  void _bindStream() {
    _walletSub?.cancel();
    
    final uid = AuthService.to.currentUser.value?.uid;
    if (uid == null) {
      walletBalance.value = 0;
      return;
    }
    
    _walletSub = FirestoreService.usersCollection.doc(uid).snapshots().listen(
      (snap) {
        if (!snap.exists) return;
        final data = snap.data() ?? {};
        // Support both wallet.balance and walletBalance fields
        final w = data['wallet'];
        if (w is Map) {
          walletBalance.value = (w['balance'] as num?)?.toDouble() ?? 0;
        } else {
          walletBalance.value =
              (data['walletBalance'] as num?)?.toDouble() ?? 0;
        }
      },
      onError: (e) {
        // Ignore permission denied errors that might happen during logout transition
      },
    );
  }

  Future<void> deductWallet(String uid, double amount) async {
    if (amount <= 0) return;
    final userRef = FirestoreService.usersCollection.doc(uid);
    await FirestoreService.instance.runTransaction((txn) async {
      final snap = await txn.get(userRef);
      final data = snap.data() ?? {};
      final w = data['wallet'];
      double bal = 0;
      if (w is Map) {
        bal = (w['balance'] as num?)?.toDouble() ?? 0;
      } else {
        bal = (data['walletBalance'] as num?)?.toDouble() ?? 0;
      }
      final newBal = (bal - amount).clamp(0.0, double.infinity);
      txn.update(userRef, {
        'wallet': {'balance': newBal, 'pendingRewards': 0.0},
        'walletBalance': newBal,
      });
    });
  }
}
