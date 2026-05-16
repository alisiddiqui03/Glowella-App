import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/routes/app_pages.dart';
import '../controllers/cart_controller.dart';

class CartView extends GetView<CartController> {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Cart', style: AppTextStyles.titleLarge),
        actions: [
          Obx(
            () =>
                controller.items.isNotEmpty
                    ? TextButton(
                      onPressed:
                          () => Get.dialog(
                            AlertDialog(
                              title: const Text('Clear Cart'),
                              content: Text(
                                'Remove all items?',
                                style: TextStyle(color: AppColors.danger),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: Get.back,
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    controller.clear();
                                    Get.back();
                                  },
                                  child: const Text(
                                    'Clear',
                                    style: TextStyle(color: AppColors.danger),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      child: Text(
                        'Clear',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.danger,
                        ),
                      ),
                    )
                    : const SizedBox(),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.items.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.shopping_bag_outlined,
                    size: 48,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text('Your cart is empty', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                Text(
                  'Add products to get started',
                  style: AppTextStyles.bodyMedium,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => Get.offAllNamed(Routes.USER_BASE),
                  child: const Text('Browse Products'),
                ),
              ],
            ),
          );
        }

        return Column(
          children: [
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.items.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, i) {
                  final item = controller.items[i];
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.shadow,
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: AppColors.shimmer,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.spa_rounded,
                            color: AppColors.primaryLight,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.product.name,
                                style: AppTextStyles.bodyMedium.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                                maxLines: 2,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'PKR ${item.product.price.toStringAsFixed(0)}',
                                style: AppTextStyles.price.copyWith(
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Row(
                              children: [
                                _qtyBtn(
                                  icon: Icons.remove,
                                  onTap:
                                      () =>
                                          controller.decrement(item.product.id),
                                ),
                                Obx(() {
                                  final idx = controller.items.indexWhere(
                                    (it) => it.product.id == item.product.id,
                                  );
                                  final qty =
                                      idx >= 0
                                          ? controller.items[idx].quantity
                                          : 0;
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                    ),
                                    child: Text(
                                      '$qty',
                                      style: AppTextStyles.titleMedium,
                                    ),
                                  );
                                }),
                                _qtyBtn(
                                  icon: Icons.add,
                                  onTap:
                                      () =>
                                          controller.increment(item.product.id),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            GestureDetector(
                              onTap: () => controller.remove(item.product.id),
                              child: const Icon(
                                Icons.delete_outline,
                                color: AppColors.danger,
                                size: 20,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            _buildSummary(),
          ],
        );
      }),
    );
  }

  Widget _qtyBtn({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: AppColors.primary),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -4),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Total', style: AppTextStyles.titleMedium),
              Obx(
                () => Text(
                  'PKR ${controller.subtotal.toStringAsFixed(0)}',
                  style: AppTextStyles.headlineMedium.copyWith(
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () => Get.toNamed(Routes.CHECKOUT),
              child: Text(
                'Proceed to Checkout',
                style: AppTextStyles.buttonText,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
