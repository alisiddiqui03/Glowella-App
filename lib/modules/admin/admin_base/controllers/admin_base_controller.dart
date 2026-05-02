import 'package:get/get.dart';

class AdminBaseController extends GetxController {
  static AdminBaseController get to => Get.find<AdminBaseController>();
  final RxInt currentIndex = 0.obs;
  void changePage(int i) => currentIndex.value = i;
}
