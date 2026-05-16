import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/home_controller.dart';
import '../../../../app/data/models/glow_product.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(child: _buildHeader()),
              SliverToBoxAdapter(child: _buildWelcomeBanner()),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
              if (controller.products.isEmpty)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.inventory_2_outlined,
                          size: 64,
                          color: AppColors.textMuted,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'No products yet',
                          style: AppTextStyles.bodyMedium,
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  sliver: SliverGrid(
                    delegate: SliverChildBuilderDelegate(
                      (ctx, i) => _ProductCard(product: controller.products[i]),
                      childCount: controller.products.length,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.58,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                  ),
                ),
              const SliverToBoxAdapter(child: SizedBox(height: 24)),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 32,
            errorBuilder:
                (_, __, ___) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'GLOWELLA',
                      style: AppTextStyles.logoText.copyWith(
                        fontSize: 18,
                        letterSpacing: 2,
                      ),
                    ),
                    Text(
                      'PREMIUM SKINCARE',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.5,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
          ),
          Row(
            children: [
              _iconBtn(
                icon: Icons.percent_rounded,
                onTap: () => Get.toNamed(Routes.DISCOUNT),
                badge: null,
              ),
              const SizedBox(width: 8),
              Obx(() {
                final count = Get.find<CartController>().totalItems;
                return _iconBtn(
                  icon: Icons.shopping_bag_outlined,
                  onTap: () => Get.toNamed(Routes.CART),
                  badge: count > 0 ? '$count' : null,
                );
              }),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconBtn({
    required IconData icon,
    required VoidCallback onTap,
    String? badge,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Center(child: Icon(icon, color: AppColors.primary, size: 22)),
            if (badge != null)
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3),
                  decoration: const BoxDecoration(
                    color: AppColors.danger,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    badge,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildWelcomeBanner() {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        gradient: LinearGradient(
          colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.2),
            blurRadius: 15,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white24,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'SUMMER SALE',
              style: AppTextStyles.bodySmall.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 10,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Your Daily Glow\nStarts Here',
            style: AppTextStyles.headlineMedium.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.toNamed(Routes.ROUTINES),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(
              'Explore Routines',
              style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final GlowProduct product;
  const _ProductCard({required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.toNamed(Routes.PRODUCT_DETAIL, arguments: product),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow.withValues(alpha: 0.4),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Image Area
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                child: Stack(
                  children: [
                    SizedBox.expand(
                      child:
                          product.imageUrls.isNotEmpty
                              ? Image.asset(
                                product.imageUrls[0],
                                fit: BoxFit.cover,
                                errorBuilder:
                                    (_, __, ___) => Container(
                                      color: AppColors.shimmer,
                                      child: const Icon(
                                        Icons.spa_rounded,
                                        color: AppColors.primaryLight,
                                        size: 40,
                                      ),
                                    ),
                              )
                              : Container(
                                color: AppColors.shimmer,
                                child: const Icon(
                                  Icons.spa_rounded,
                                  color: AppColors.primaryLight,
                                  size: 40,
                                ),
                              ),
                    ),
                    if (product.stock <= 0)
                      Positioned(
                        top: 10,
                        right: 10,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.danger.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Text(
                            'Sold Out',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            // Details Area
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.category.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      fontSize: 9,
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    product.name,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'PKR ${product.price.toStringAsFixed(0)}',
                    style: AppTextStyles.price.copyWith(fontSize: 14),
                  ),
                  const SizedBox(height: 12),
                  // Add to Cart Button
                  SizedBox(
                    height: 40,
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed:
                          product.stock > 0
                              ? () =>
                                  Get.find<CartController>().addToCart(product)
                              : null,
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 4,
                        shadowColor: AppColors.primary.withValues(alpha: 0.3),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.shopping_bag_outlined,
                            size: 16,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Add to Cart',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
