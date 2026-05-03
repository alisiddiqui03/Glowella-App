import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../modules/user/auth/bindings/auth_binding.dart';
import '../../modules/user/auth/views/auth_view.dart';
import '../../modules/user/user_base/bindings/user_base_binding.dart';
import '../../modules/user/user_base/views/user_base_layout.dart';
import '../../modules/user/home/bindings/home_binding.dart';
import '../../modules/user/home/views/home_view.dart';
import '../../modules/user/product_detail/bindings/product_detail_binding.dart';
import '../../modules/user/product_detail/views/product_detail_view.dart';
import '../../modules/user/cart/bindings/cart_binding.dart';
import '../../modules/user/cart/views/cart_view.dart';
import '../../modules/user/checkout/bindings/checkout_binding.dart';
import '../../modules/user/checkout/views/checkout_view.dart';
import '../../modules/user/routines/bindings/routines_binding.dart';
import '../../modules/user/routines/views/routines_view.dart';
import '../../modules/user/routines/views/routine_detail_view.dart';
import '../../modules/user/discount/bindings/discount_binding.dart';
import '../../modules/user/discount/views/discount_view.dart';
import '../../modules/user/profile/bindings/profile_binding.dart';
import '../../modules/user/profile/views/profile_view.dart';
import '../../modules/user/orders/bindings/orders_binding.dart';
import '../../modules/user/orders/views/orders_view.dart';
import '../../modules/user/order_confirm/views/order_confirm_view.dart';
import '../../modules/admin/admin_base/bindings/admin_base_binding.dart';
import '../../modules/admin/admin_base/views/admin_base_layout.dart';
import '../../modules/admin/dashboard/bindings/admin_dashboard_binding.dart';
import '../../modules/admin/dashboard/views/admin_dashboard_view.dart';
import '../../modules/admin/inventory/bindings/admin_inventory_binding.dart';
import '../../modules/admin/inventory/views/admin_inventory_view.dart';
import '../../modules/admin/inventory/views/admin_product_form_view.dart';
import '../../modules/admin/orders/bindings/admin_orders_binding.dart';
import '../../modules/admin/orders/views/admin_orders_view.dart';
import 'middleware/role_middleware.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.ROOT;

  static final routes = <GetPage>[
    GetPage(
      name: _Paths.ROOT,
      page: () => const _SplashPage(),
      middlewares: [RoleMiddleware()],
    ),
    GetPage(
      name: _Paths.AUTH,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
    GetPage(
      name: _Paths.USER_BASE,
      page: () => const UserBaseLayout(),
      binding: UserBaseBinding(),
    ),
    GetPage(
      name: _Paths.USER_HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.PRODUCT_DETAIL,
      page: () => const ProductDetailView(),
      binding: ProductDetailBinding(),
    ),
    GetPage(
      name: _Paths.CART,
      page: () => const CartView(),
      binding: CartBinding(),
    ),
    GetPage(
      name: _Paths.CHECKOUT,
      page: () => const CheckoutView(),
      binding: CheckoutBinding(),
    ),
    GetPage(
      name: _Paths.ROUTINES,
      page: () => const RoutinesView(),
      binding: RoutinesBinding(),
    ),
    GetPage(name: _Paths.ROUTINE_DETAIL, page: () => const RoutineDetailView()),
    GetPage(
      name: _Paths.DISCOUNT,
      page: () => const DiscountView(),
      binding: DiscountBinding(),
    ),
    GetPage(
      name: _Paths.PROFILE,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
    GetPage(
      name: _Paths.ORDERS,
      page: () => const OrdersView(),
      binding: OrdersBinding(),
    ),
    GetPage(name: _Paths.ORDER_CONFIRM, page: () => const OrderConfirmView()),
    // Admin
    GetPage(
      name: _Paths.ADMIN_BASE,
      page: () => const AdminBaseLayout(),
      binding: AdminBaseBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_DASHBOARD,
      page: () => const AdminDashboardView(),
      binding: AdminDashboardBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_INVENTORY,
      page: () => const AdminInventoryView(),
      binding: AdminInventoryBinding(),
    ),
    GetPage(
      name: _Paths.ADMIN_PRODUCT_FORM,
      page: () => const AdminProductFormView(),
    ),
    GetPage(
      name: _Paths.ADMIN_ORDERS,
      page: () => const AdminOrdersView(),
      binding: AdminOrdersBinding(),
    ),
  ];
}

// Minimal splash shown during middleware route resolution
class _SplashPage extends StatelessWidget {
  const _SplashPage();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.asset(
                  'assets/images/logo.png',
                  fit: BoxFit.contain,
                  errorBuilder:
                      (_, __, ___) => const Icon(
                        Icons.spa_rounded,
                        color: AppColors.primary,
                        size: 60,
                      ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            const CircularProgressIndicator(
              color: AppColors.primary,
              strokeWidth: 2,
            ),
          ],
        ),
      ),
    );
  }
}
