import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../services/auth_service.dart';
import '../app_pages.dart';

class RoleMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final auth = Get.find<AuthService>();

    if (!auth.isLoggedIn) {
      return const RouteSettings(name: Routes.AUTH);
    }

    if (auth.isAdmin) {
      return const RouteSettings(name: Routes.ADMIN_BASE);
    }

    return const RouteSettings(name: Routes.USER_BASE);
  }
}
