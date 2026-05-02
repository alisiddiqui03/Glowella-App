import 'package:get/get.dart';
import '../../../../app/services/order_service.dart';
import '../../../../app/data/models/glow_order.dart';

class AdminDashboardController extends GetxController {
  static AdminDashboardController get to => Get.find<AdminDashboardController>();

  final _orders = OrderService.to;

  List<GlowOrder> get orders => _orders.orders;
  bool get isLoading => _orders.isOrdersLoading.value;

  double get totalRevenue => _orders.totalRevenue;
  int get totalOrders => orders.length;
  int get pendingCount => _orders.pendingCount;
  int get deliveredCount => _orders.deliveredCount;
  int get unpaidBankCount => _orders.unpaidBankTransferCount;

  // Revenue for last 7 days
  Map<String, double> get dailyRevenue {
    final Map<String, double> map = {};
    final now = DateTime.now();
    for (int i = 6; i >= 0; i--) {
      final d = now.subtract(Duration(days: i));
      final key = '${d.month}/${d.day}';
      map[key] = 0;
    }
    for (final o in orders) {
      if (o.status == OrderStatus.delivered) {
        final d = o.createdAt;
        final diff = now.difference(d).inDays;
        if (diff <= 6) {
          final key = '${d.month}/${d.day}';
          map[key] = (map[key] ?? 0) + o.total;
        }
      }
    }
    return map;
  }
}
