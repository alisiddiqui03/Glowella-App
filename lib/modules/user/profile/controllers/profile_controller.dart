import 'package:get/get.dart';
import '../../../../app/services/auth_service.dart';
import '../../../../app/services/wallet_service.dart';
import '../../../../app/services/order_service.dart';
import '../../../../app/data/models/glow_order.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  static ProfileController get to => Get.find<ProfileController>();

  final _auth = AuthService.to;
  final _wallet = WalletService.to;
  final _orders = OrderService.to;

  final RxList<GlowOrder> userOrders = <GlowOrder>[].obs;
  final RxBool ordersLoading = true.obs;

  String get displayName =>
      _auth.currentUser.value?.displayName ?? 'Glowella User';
  String get email => _auth.currentUser.value?.email ?? '';
  int get points => _auth.currentUser.value?.points ?? 0;
  double get walletBalance => _wallet.walletBalance.value;
  bool get isVip => _auth.currentUser.value?.isVipActive ?? false;

  @override
  void onInit() {
    super.onInit();
    loadOrders();
    ever(_auth.currentUser, (_) => loadOrders());
  }

  Future<void> loadOrders() async {
    final uid = _auth.currentUser.value?.uid;
    if (uid == null) return;
    ordersLoading.value = true;
    try {
      userOrders.assignAll(await _orders.fetchUserOrders(uid));
    } catch (_) {
    } finally {
      ordersLoading.value = false;
    }
  }

  Future<void> updateAddress(String phone, String street, String city, String postal) async {
    final user = _auth.currentUser.value;
    if (user == null) return;
    
    try {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
        'phone': phone,
        'street': street,
        'city': city,
        'postalCode': postal,
      });
      // Refresh user profile
      await _auth.refreshProfile();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update address');
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
    Get.offAllNamed('/auth');
  }

  Future<void> deleteAccount() async {
    try {
      await _auth.deleteAccount();
      Get.offAllNamed('/auth');
      Get.snackbar('Success', 'Your account has been deleted.',
          snackPosition: SnackPosition.BOTTOM);
    } catch (e) {
      Get.snackbar('Notice', e.toString(),
          snackPosition: SnackPosition.BOTTOM, duration: const Duration(seconds: 4));
    }
  }
}
