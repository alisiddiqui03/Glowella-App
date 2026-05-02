import 'package:get/get.dart';
import '../controllers/admin_base_controller.dart';
import '../../dashboard/controllers/admin_dashboard_controller.dart';
import '../../inventory/controllers/admin_inventory_controller.dart';
import '../../orders/controllers/admin_orders_controller.dart';

class AdminBaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminBaseController>(() => AdminBaseController());
    Get.lazyPut<AdminDashboardController>(() => AdminDashboardController());
    Get.lazyPut<AdminInventoryController>(() => AdminInventoryController());
    Get.lazyPut<AdminOrdersController>(() => AdminOrdersController());
  }
}
