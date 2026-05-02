import 'package:get/get.dart';
import '../data/routines_data.dart';

class RoutinesController extends GetxController {
  static RoutinesController get to => Get.find<RoutinesController>();

  List<RoutineData> get routines => glowRoutines;
}
