import 'package:get/get.dart';
import '../controllers/admin_inventory_controller.dart';

class AdminInventoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminInventoryController>(() => AdminInventoryController());
  }
}
