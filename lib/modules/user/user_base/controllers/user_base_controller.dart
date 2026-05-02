import 'package:get/get.dart';

class UserBaseController extends GetxController {
  static UserBaseController get to => Get.find<UserBaseController>();
  final RxInt currentIndex = 0.obs;

  void changePage(int index) => currentIndex.value = index;
}
