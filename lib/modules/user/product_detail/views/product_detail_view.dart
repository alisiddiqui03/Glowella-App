import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/data/models/glow_product.dart';
import '../../../../app/routes/app_pages.dart';
import '../../cart/controllers/cart_controller.dart';
import '../controllers/product_detail_controller.dart';

class ProductDetailView extends GetView<ProductDetailController> {
  const ProductDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    final product = controller.product;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(product),
          SliverToBoxAdapter(
            child: _buildProductInfo(product),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(product),
    );
  }

  Widget _buildSliverAppBar(GlowProduct product) {
    final PageController pageController = PageController();
    final RxInt currentPage = 0.obs;

    return SliverAppBar(
      expandedHeight: 400,
      pinned: true,
      backgroundColor: AppColors.background,
      leading: Padding(
        padding: const EdgeInsets.all(8.0),
        child: CircleAvatar(
          backgroundColor: Colors.white,
          child: IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded,
                color: AppColors.textPrimary, size: 18),
            onPressed: () => Get.back(),
          ),
        ),
      ),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            child: IconButton(
              icon: Obx(() {
                final count = Get.find<CartController>().totalItems;
                return Stack(
                  clipBehavior: Clip.none,
                  children: [
                    const Icon(Icons.shopping_bag_outlined,
                        color: AppColors.textPrimary, size: 20),
                    if (count > 0)
                      Positioned(
                        right: -4,
                        top: -4,
                        child: Container(
                          padding: const EdgeInsets.all(3),
                          decoration: const BoxDecoration(
                            color: AppColors.danger,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 14,
                            minHeight: 14,
                          ),
                          child: Text(
                            count > 9 ? '9+' : '$count',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.w800,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              }),
              onPressed: () => Get.toNamed(Routes.CART),
            ),
          ),
        ),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            PageView.builder(
              controller: pageController,
              itemCount: product.imageUrls.length,
              onPageChanged: (index) => currentPage.value = index,
              itemBuilder: (context, index) {
                return Hero(
                  tag: 'product_${product.id}',
                  child: Container(
                    color: Colors.white,
                    child: Image.asset(
                      product.imageUrls[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => Center(
                        child: Icon(Icons.spa_rounded,
                            size: 80,
                            color: AppColors.primary.withValues(alpha: 0.2)),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (product.imageUrls.length > 1)
              Positioned(
                bottom: 20,
                left: 0,
                right: 0,
                child: Obx(() => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        product.imageUrls.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: currentPage.value == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: currentPage.value == index
                                ? AppColors.primary
                                : AppColors.primary.withValues(alpha: 0.3),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    )),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductInfo(GlowProduct product) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.category.toUpperCase(),
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(product.name, style: AppTextStyles.headlineMedium),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'PKR ${product.price.toStringAsFixed(0)}',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          _sectionTitle('Description'),
          const SizedBox(height: 12),
          Text(
            product.description,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 32),
          _sectionTitle('Why Glowella?'),
          const SizedBox(height: 16),
          _buildBenefitRow(Icons.verified_user_outlined, 'Dermatologically Tested'),
          _buildBenefitRow(Icons.eco_outlined, 'Natural & Safe Ingredients'),
          _buildBenefitRow(Icons.favorite_border_rounded, 'Cruelty Free'),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.w700),
    );
  }

  Widget _buildBenefitRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 20),
          const SizedBox(width: 12),
          Text(text, style: AppTextStyles.bodyMedium),
        ],
      ),
    );
  }

  Widget _buildBottomBar(GlowProduct product) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            height: 52,
            width: 52,
            decoration: BoxDecoration(
              color: AppColors.background,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.divider),
            ),
            child: IconButton(
              icon: const Icon(Icons.favorite_border_rounded,
                  color: AppColors.textPrimary),
              onPressed: () {},
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: SizedBox(
              height: 52,
              child: ElevatedButton(
                onPressed: () => Get.find<CartController>().addToCart(product),
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text('Add to Cart', style: AppTextStyles.buttonText),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
