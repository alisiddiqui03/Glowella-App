import 'package:get/get.dart';
import '../controllers/routines_controller.dart';

class RoutinesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RoutinesController>(() => RoutinesController());
  }
}
