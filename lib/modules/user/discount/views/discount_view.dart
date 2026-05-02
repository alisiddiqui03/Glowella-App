import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../controllers/discount_controller.dart';

class DiscountView extends GetView<DiscountController> {
  const DiscountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Discount Hub', style: AppTextStyles.titleLarge),
      ),
      body: Obx(() => SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                _buildCurrentDiscount(),
                const SizedBox(height: 24),
                _buildProgressBar(),
                const SizedBox(height: 24),
                _buildWatchAdCard(),
                const SizedBox(height: 24),
                _buildTierInfo(),
              ],
            ),
          )),
    );
  }

  Widget _buildCurrentDiscount() {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          const Icon(Icons.percent_rounded, color: Colors.white54, size: 36),
          const SizedBox(height: 8),
          Text(
            '${controller.currentDiscount.toStringAsFixed(0)}%',
            style: const TextStyle(
              fontSize: 64,
              fontWeight: FontWeight.w800,
              color: Colors.white,
              height: 1,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your Current Discount',
            style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            controller.currentDiscount >= 20
                ? '🏆 Maximum discount reached!'
                : 'Watch ads to increase your discount',
            style: AppTextStyles.bodySmall.copyWith(color: Colors.white60),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Discount Progression', style: AppTextStyles.titleMedium),
              Obx(() => Text(
                    '${controller.currentDiscount.toStringAsFixed(0)}% / 20%',
                    style: AppTextStyles.bodySmall
                        .copyWith(color: AppColors.primary, fontWeight: FontWeight.w600),
                  )),
            ],
          ),
          const SizedBox(height: 16),
          // 4 tier markers
          Row(
            children: [5, 10, 15, 20].map((tier) {
              final reached = controller.currentDiscount >= tier;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          gradient: reached
                              ? const LinearGradient(colors: [
                                  AppColors.primary,
                                  AppColors.primaryLight
                                ])
                              : null,
                          color: reached ? null : AppColors.divider,
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$tier%',
                        style: AppTextStyles.bodySmall.copyWith(
                          color: reached
                              ? AppColors.primary
                              : AppColors.textMuted,
                          fontWeight: reached
                              ? FontWeight.w700
                              : FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWatchAdCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.routineMorning.withValues(alpha: 0.4),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.play_circle_fill_rounded,
                size: 48, color: AppColors.textPrimary),
          ),
          const SizedBox(height: 16),
          Text('Watch Ad for +1% Discount',
              style: AppTextStyles.titleMedium),
          const SizedBox(height: 8),
          Obx(() => Text(
                controller.currentDiscount >= 20
                    ? 'You have reached the maximum 20% discount!'
                    : 'Watch ${controller.adsNeededForNext} more ad(s) at this tier to unlock next %',
                style: AppTextStyles.bodySmall,
                textAlign: TextAlign.center,
              )),
          const SizedBox(height: 20),
          Obx(() => SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton.icon(
                  onPressed: controller.currentDiscount >= 20 ||
                          controller.isLoadingAd.value
                      ? null
                      : controller.watchAd,
                  icon: controller.isLoadingAd.value
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(
                              color: Colors.white, strokeWidth: 2),
                        )
                      : const Icon(Icons.play_arrow_rounded),
                  label: Text(
                    controller.isLoadingAd.value
                        ? 'Loading Ad...'
                        : controller.currentDiscount >= 20
                            ? 'Max Discount Reached'
                            : 'Watch Ad (+1%)',
                    style: AppTextStyles.buttonText,
                  ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildTierInfo() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('How It Works', style: AppTextStyles.titleMedium),
          const SizedBox(height: 16),
          _tierRow('5% → 10%', '1 ad per 1%', AppColors.routineMaster),
          _tierRow('10% → 15%', '2 ads per 1%', AppColors.routineMorning),
          _tierRow('15% → 20%', '4 ads per 1%', AppColors.routineNight),
          const Divider(height: 20, color: AppColors.divider),
          Row(
            children: [
              const Icon(Icons.info_outline_rounded,
                  color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Bank Transfer gives an extra 5% discount at checkout!',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tierRow(String tier, String requirement, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 12),
          Text(tier,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
          const Spacer(),
          Text(requirement, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
