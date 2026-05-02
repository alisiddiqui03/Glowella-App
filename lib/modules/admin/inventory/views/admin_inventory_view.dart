import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../controllers/admin_inventory_controller.dart';
import '../../../../app/data/models/glow_product.dart';

class AdminInventoryView extends GetView<AdminInventoryController> {
  const AdminInventoryView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Inventory', style: AppTextStyles.titleLarge),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            onPressed: controller.loadProducts,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.openAddProduct,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: Text(
          'Add Product',
          style: AppTextStyles.buttonText.copyWith(fontSize: 13),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        if (controller.products.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.inventory_2_outlined,
                  size: 64,
                  color: AppColors.textMuted,
                ),
                const SizedBox(height: 12),
                Text('No products yet', style: AppTextStyles.titleMedium),
                const SizedBox(height: 8),
                ElevatedButton.icon(
                  onPressed: controller.openAddProduct,
                  icon: const Icon(Icons.add),
                  label: const Text('Add First Product'),
                ),
              ],
            ),
          );
        }
        return ListView.separated(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
          itemCount: controller.products.length,
          separatorBuilder: (_, __) => const SizedBox(height: 10),
          itemBuilder: (_, i) => _ProductTile(product: controller.products[i]),
        );
      }),
    );
  }
}

class _ProductTile extends GetView<AdminInventoryController> {
  final GlowProduct product;
  const _ProductTile({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Row(
        children: [
          // Image
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left: Radius.circular(16),
            ),
            child: SizedBox(
              width: 80,
              height: 90,
              child:
                  product.imageUrl.isNotEmpty
                      ? CachedNetworkImage(
                        imageUrl: product.imageUrl,
                        fit: BoxFit.cover,
                        placeholder:
                            (_, __) => Container(color: AppColors.shimmer),
                        errorWidget:
                            (_, __, ___) => Container(
                              color: AppColors.shimmer,
                              child: const Icon(
                                Icons.spa_rounded,
                                color: AppColors.primaryLight,
                              ),
                            ),
                      )
                      : Container(
                        color: AppColors.shimmer,
                        child: const Icon(
                          Icons.spa_rounded,
                          color: AppColors.primaryLight,
                        ),
                      ),
            ),
          ),
          const SizedBox(width: 12),
          // Info
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'PKR ${product.price.toStringAsFixed(0)}',
                    style: AppTextStyles.price.copyWith(fontSize: 13),
                  ),
                  Text(
                    'Stock: ${product.stock}',
                    style: AppTextStyles.bodySmall,
                  ),
                ],
              ),
            ),
          ),
          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Switch(
                  value: product.isActive,
                  onChanged: (_) => controller.toggleActive(product),
                  activeTrackColor: AppColors.primary.withValues(alpha: 0.5),
                  activeThumbColor: AppColors.primary,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(
                        Icons.edit_outlined,
                        color: AppColors.primary,
                        size: 20,
                      ),
                      onPressed: () => controller.openEditProduct(product),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        color: AppColors.danger,
                        size: 20,
                      ),
                      onPressed:
                          () => Get.dialog(
                            AlertDialog(
                              title: const Text('Delete Product'),
                              content: Text('Delete "${product.name}"?'),
                              actions: [
                                TextButton(
                                  onPressed: Get.back,
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Get.back();
                                    controller.deleteProduct(product);
                                  },
                                  child: const Text(
                                    'Delete',
                                    style: TextStyle(color: AppColors.danger),
                                  ),
                                ),
                              ],
                            ),
                          ),
                      constraints: const BoxConstraints(),
                      padding: const EdgeInsets.all(4),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
