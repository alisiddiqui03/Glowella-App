import 'package:get/get.dart';
import '../controllers/user_base_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../routines/controllers/routines_controller.dart';
import '../../profile/controllers/profile_controller.dart';
import '../../../../app/services/product_service.dart';

class UserBaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserBaseController>(() => UserBaseController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CartController>(() => CartController(), fenix: true);
    Get.lazyPut<RoutinesController>(() => RoutinesController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
