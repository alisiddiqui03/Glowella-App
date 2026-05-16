import 'package:get/get.dart';
import '../controllers/user_base_controller.dart';
import '../../home/controllers/home_controller.dart';
import '../../cart/controllers/cart_controller.dart';
import '../../routines/controllers/routines_controller.dart';
import '../../profile/controllers/profile_controller.dart';

class UserBaseBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserBaseController>(() => UserBaseController());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.put<CartController>(CartController(), permanent: true);
    Get.lazyPut<RoutinesController>(() => RoutinesController());
    Get.lazyPut<ProfileController>(() => ProfileController());
  }
}
