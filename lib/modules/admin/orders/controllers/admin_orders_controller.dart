import 'package:get/get.dart';
import '../../../../app/data/models/glow_order.dart';
import '../../../../app/services/order_service.dart';

class AdminOrdersController extends GetxController {
  static AdminOrdersController get to => Get.find<AdminOrdersController>();

  final _orderService = OrderService.to;
  final RxString filterStatus = 'all'.obs;

  List<GlowOrder> get orders => _orderService.orders;
  bool get isLoading => _orderService.isOrdersLoading.value;

  List<GlowOrder> get filteredOrders {
    if (filterStatus.value == 'all') return orders;
    return orders.where((o) => o.status.name == filterStatus.value).toList();
  }

  Future<void> updateStatus(GlowOrder order, OrderStatus status) async {
    await _orderService.updateStatus(order, status);
    Get.snackbar('Updated', 'Order status set to ${status.name}');
  }

  Future<void> markPaid(GlowOrder order) async {
    await _orderService.updatePaidStatus(order, true);
    Get.snackbar('Verified', 'Bank transfer marked as paid');
  }

  Future<void> cancelOrder(GlowOrder order, String reason) async {
    await _orderService.cancelOrder(order, reason);
    Get.snackbar('Cancelled', 'Order cancelled');
  }
}
