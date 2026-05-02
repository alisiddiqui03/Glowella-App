import 'package:get/get.dart';
import '../../../../app/services/discount_service.dart';
import '../../../../app/services/ad_service.dart';

class DiscountController extends GetxController {
  static DiscountController get to => Get.find<DiscountController>();

  final _discount = DiscountService.to;
  final RxBool isLoadingAd = false.obs;

  double get currentDiscount => _discount.adDiscount.value;
  int get adCount => _discount.adProgressCount.value;
  bool get adsEnabled => _discount.adsRewardEnabled.value;

  Future<void> watchAd() async {
    if (!adsEnabled) {
      Get.snackbar('Ads Disabled', 'Ad rewards are currently disabled');
      return;
    }
    if (currentDiscount >= 20) {
      Get.snackbar('Maximum Reached', 'You have reached the 20% discount cap!');
      return;
    }
    isLoadingAd.value = true;
    try {
      bool shown = await AdService.instance.showRewardedAd(
        onRewarded: () async {
          await _discount.applyAdReward();
        },
      );
      if (!shown) {
        Get.snackbar('Ad Not Ready', 'Please try again in a moment');
      }
    } finally {
      isLoadingAd.value = false;
    }
  }

  int get adsNeededForNext {
    final d = currentDiscount;
    if (d < 5) return 1;
    if (d < 10) return 2;
    if (d < 15) return 4;
    return 8;
  }

  double get progressToNextTier {
    final d = currentDiscount;
    if (d >= 20) return 1.0;
    final tiers = [5.0, 10.0, 15.0, 20.0];
    for (final tier in tiers) {
      if (d < tier) {
        final prev = tier - 5;
        return (d - prev) / 5;
      }
    }
    return 1.0;
  }
}
