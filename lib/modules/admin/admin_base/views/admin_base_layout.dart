import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:glowella/modules/admin/orders/views/admin_orders_view.dart';
import '../../../../app/theme/app_colors.dart';
import '../controllers/admin_base_controller.dart';
import '../../dashboard/views/admin_dashboard_view.dart';
import '../../profile/views/admin_profile_view.dart';

class AdminBaseLayout extends GetView<AdminBaseController> {
  const AdminBaseLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = [
      const AdminDashboardView(),
      const AdminOrdersView(),
      const AdminProfileView(),
    ];

    return Obx(
      () => Scaffold(
        body: IndexedStack(
          index: controller.currentIndex.value,
          children: pages,
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: controller.changePage,
          backgroundColor: Colors.white,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.navInactive,
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard_rounded),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long_rounded),
              label: 'Orders',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded),
              activeIcon: Icon(Icons.person_rounded),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}
