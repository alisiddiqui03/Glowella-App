import 'package:get/get.dart';
import '../../../../app/services/auth_service.dart';
import '../../../../app/services/order_service.dart';
import '../../../../app/data/models/glow_order.dart';

class OrdersController extends GetxController {
  static OrdersController get to => Get.find<OrdersController>();

  final RxList<GlowOrder> orders = <GlowOrder>[].obs;
  final RxBool isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final uid = AuthService.to.currentUser.value?.uid;
    if (uid == null) return;
    isLoading.value = true;
    try {
      orders.assignAll(await OrderService.to.fetchUserOrders(uid));
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => _loadOrders();
}
