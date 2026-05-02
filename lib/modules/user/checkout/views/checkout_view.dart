import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/services/wallet_service.dart';
import '../controllers/checkout_controller.dart';

class CheckoutView extends GetView<CheckoutController> {
  const CheckoutView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Checkout', style: AppTextStyles.titleLarge),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _sectionTitle('Delivery Details'),
            const SizedBox(height: 12),
            _buildDeliveryForm(),
            const SizedBox(height: 24),
            _sectionTitle('Payment Method'),
            const SizedBox(height: 12),
            _buildPaymentMethod(),
            const SizedBox(height: 24),
            _buildWalletOption(),
            const SizedBox(height: 24),
            _sectionTitle('Order Summary'),
            const SizedBox(height: 12),
            _buildOrderSummary(),
            const SizedBox(height: 24),
            _buildPlaceOrderBtn(),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _sectionTitle(String title) =>
      Text(title, style: AppTextStyles.titleMedium);

  Widget _buildDeliveryForm() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: Column(
        children: [
          _field(controller.nameCtrl, 'Full Name',
              Icons.person_outline_rounded),
          const SizedBox(height: 12),
          _field(controller.emailCtrl, 'Email', Icons.email_outlined,
              type: TextInputType.emailAddress),
          const SizedBox(height: 12),
          _field(controller.phoneCtrl, 'Phone Number',
              Icons.phone_outlined,
              type: TextInputType.phone),
          const SizedBox(height: 12),
          _field(
              controller.streetCtrl, 'Street Address', Icons.home_outlined),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _field(controller.cityCtrl, 'City',
                    Icons.location_city_outlined),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _field(controller.postalCtrl, 'Postal Code',
                    Icons.pin_drop_outlined,
                    type: TextInputType.number),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _field(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    TextInputType type = TextInputType.text,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: type,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Obx(() => Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
          ),
          child: Column(
            children: [
              _paymentTile(
                title: 'Cash on Delivery (COD)',
                subtitle: 'Pay when delivered (max PKR 10,000)',
                icon: Icons.payments_outlined,
                selected: controller.isCod.value,
                onTap: () => controller.isCod.value = true,
              ),
              const Divider(height: 1, color: AppColors.divider),
              _paymentTile(
                title: 'Bank Transfer',
                subtitle: 'Get extra 5% discount',
                icon: Icons.account_balance_outlined,
                selected: !controller.isCod.value,
                onTap: () => controller.isCod.value = false,
              ),
              if (!controller.isCod.value) ...[
                const Divider(height: 1, color: AppColors.divider),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color:
                              AppColors.primary.withValues(alpha: 0.07),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                              color: AppColors.primary
                                  .withValues(alpha: 0.2)),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Bank Details',
                              style: AppTextStyles.bodyMedium.copyWith(
                                fontWeight: FontWeight.w700,
                                color: AppColors.primary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            _bankDetail(
                                'Bank', 'HBL / Meezan Bank'),
                            _bankDetail('Account Name',
                                'Glowella by MD Scents'),
                            _bankDetail(
                                'Account No', '0123-456789-0123'),
                            _bankDetail('IBAN',
                                'PK00XXXX0000000000000000'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),
                      Text('Upload Payment Receipt',
                          style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 8),
                      Obx(() => GestureDetector(
                            onTap: controller.pickReceipt,
                            child: Container(
                              height: 80,
                              decoration: BoxDecoration(
                                color: AppColors.background,
                                borderRadius:
                                    BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.divider,
                                    width: 1.5),
                              ),
                              alignment: Alignment.center,
                              child:
                                  controller.receiptFile.value != null
                                      ? Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                                Icons.check_circle,
                                                color:
                                                    AppColors.primary),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Receipt uploaded ✓',
                                              style: AppTextStyles
                                                  .bodySmall
                                                  .copyWith(
                                                color: AppColors.primary,
                                                fontWeight:
                                                    FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        )
                                      : Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            const Icon(
                                                Icons.upload_file_rounded,
                                                color: AppColors.textMuted,
                                                size: 28),
                                            const SizedBox(height: 4),
                                            Text('Tap to upload',
                                                style:
                                                    AppTextStyles.bodySmall),
                                          ],
                                        ),
                            ),
                          )),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ));
  }

  Widget _paymentTile({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.1)
                    : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textMuted,
                  size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      )),
                  Text(subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            Radio<bool>(
              value: true,
              groupValue: selected,
              activeColor: AppColors.primary,
              onChanged: (_) => onTap(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bankDetail(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ',
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
          Flexible(
            child: Text(value,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                )),
          ),
        ],
      ),
    );
  }

  Widget _buildWalletOption() {
    return Obx(() {
      final balance = Get.find<WalletService>().walletBalance.value;
      if (balance <= 0) return const SizedBox();
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: AppColors.shadow, blurRadius: 8)
          ],
        ),
        child: Row(
          children: [
            const Icon(Icons.account_balance_wallet_outlined,
                color: AppColors.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Use Wallet Balance',
                      style: AppTextStyles.bodyMedium
                          .copyWith(fontWeight: FontWeight.w600)),
                  Text(
                      'Available: PKR ${balance.toStringAsFixed(0)}',
                      style: AppTextStyles.bodySmall
                          .copyWith(color: AppColors.primary)),
                ],
              ),
            ),
            Switch(
              value: controller.useWallet.value,
              onChanged: (v) => controller.useWallet.value = v,
              activeColor: AppColors.primary,
            ),
          ],
        ),
      );
    });
  }

  Widget _buildOrderSummary() {
    return Obx(() => Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(color: AppColors.shadow, blurRadius: 8)
            ],
          ),
          child: Column(
            children: [
              _summaryRow('Subtotal',
                  'PKR ${controller.subtotal.toStringAsFixed(0)}'),
              _summaryRow(
                'Discount (${controller.discountPct.toStringAsFixed(0)}%)',
                '- PKR ${controller.discountAmt.toStringAsFixed(0)}',
                color: AppColors.primary,
              ),
              if (!controller.isCod.value)
                _summaryRow(
                  'Bank Transfer Bonus (-5%)',
                  '- PKR ${controller.bankBonus.toStringAsFixed(0)}',
                  color: AppColors.primary,
                ),
              if (controller.useWallet.value &&
                  controller.walletDeduction > 0)
                _summaryRow(
                  'Wallet Applied',
                  '- PKR ${controller.walletDeduction.toStringAsFixed(0)}',
                  color: AppColors.primary,
                ),
              const Divider(color: AppColors.divider),
              _summaryRow(
                'Total',
                'PKR ${controller.finalTotal.toStringAsFixed(0)}',
                bold: true,
              ),
            ],
          ),
        ));
  }

  Widget _summaryRow(String label, String value,
      {Color? color, bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: bold
                  ? AppTextStyles.titleMedium
                  : AppTextStyles.bodyMedium),
          Text(
            value,
            style: (bold
                    ? AppTextStyles.titleMedium
                    : AppTextStyles.bodyMedium)
                .copyWith(
              color: color ?? AppColors.textPrimary,
              fontWeight: bold ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBtn() {
    return Obx(() => SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed:
                controller.isLoading.value ? null : controller.placeOrder,
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                        color: Colors.white, strokeWidth: 2),
                  )
                : Text(
                    'Place Order — PKR ${controller.finalTotal.toStringAsFixed(0)}',
                    style: AppTextStyles.buttonText,
                  ),
          ),
        ));
  }
}
