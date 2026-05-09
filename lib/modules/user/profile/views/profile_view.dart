import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/routes/app_pages.dart';
import '../../../../app/data/models/glow_order.dart';
import '../../../../app/services/auth_service.dart';
import '../controllers/profile_controller.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('My Profile', style: AppTextStyles.titleLarge),
        automaticallyImplyLeading: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textPrimary),
            onPressed: () => Get.dialog(AlertDialog(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              title: const Text('Sign Out',
                  style: TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
              content: const Text('Are you sure you want to sign out?',
                  style: TextStyle(color: AppColors.textSecondary)),
              actions: [
                TextButton(
                    onPressed: Get.back,
                    child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted))),
                TextButton(
                  onPressed: controller.signOut,
                  child: const Text('Sign Out',
                      style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
                ),
              ],
            )),
          ),
        ],
      ),
      body: Obx(() => RefreshIndicator(
            color: AppColors.primary,
            onRefresh: controller.loadOrders,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildProfileCard(),
                  const SizedBox(height: 20),
                  _buildStatsRow(),
                  const SizedBox(height: 20),
                  _buildQuickLinks(),
                  const SizedBox(height: 24),
                  _buildRecentOrders(),
                ],
              ),
            ),
          )),
    );
  }

  Widget _buildProfileCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.primary, AppColors.primaryLight],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.3),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.3),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                controller.displayName.isNotEmpty
                    ? controller.displayName[0].toUpperCase()
                    : 'G',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        controller.displayName,
                        style: AppTextStyles.titleMedium.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (controller.isVip) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD700),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Text(
                          '⭐ VIP',
                          style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: Colors.brown),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  controller.email,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: Colors.white70),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      children: [
        Expanded(
          child: _statCard(
            label: 'Points',
            value: '${controller.points}',
            icon: Icons.stars_rounded,
            color: AppColors.routineMorning,
            iconColor: Colors.orange,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            label: 'Wallet',
            value: 'PKR ${controller.walletBalance.toStringAsFixed(0)}',
            icon: Icons.account_balance_wallet_rounded,
            color: AppColors.routineMaster,
            iconColor: AppColors.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _statCard(
            label: 'Orders',
            value: '${controller.userOrders.length}',
            icon: Icons.shopping_bag_rounded,
            color: AppColors.routineNight.withValues(alpha: 0.4),
            iconColor: AppColors.routineNight,
          ),
        ),
      ],
    );
  }

  Widget _statCard({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
    required Color iconColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: iconColor, size: 24),
          const SizedBox(height: 6),
          Text(value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis),
          Text(label,
              style: AppTextStyles.bodySmall
                  .copyWith(color: AppColors.textSecondary)),
        ],
      ),
    );
  }

  Widget _buildQuickLinks() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: Column(
        children: [
          _quickLink(Icons.receipt_long_rounded, 'Order History',
              () => Get.toNamed(Routes.ORDERS)),
          const Divider(height: 1, color: AppColors.divider),
          _quickLink(Icons.percent_rounded, 'Discount & Ads',
              () => Get.toNamed(Routes.DISCOUNT)),
          const Divider(height: 1, color: AppColors.divider),
          _quickLink(Icons.location_on_outlined, 'Edit Saved Address',
              () => _showAddressDialog()),
          const Divider(height: 1, color: AppColors.divider),
          _quickLink(Icons.help_outline_rounded, 'Help & Support', () {
            _showInfoDialog(
              title: '❔ Help & Support (FAQs)',
              content: 'Orders & Payments\n\n'
                  'What payment methods do you accept?\n'
                  'We offer Cash on Delivery (COD) and Bank Transfer. For orders exceeding PKR 10,000, we highly recommend Bank Transfer.\n\n'
                  'How do I pay via Bank Transfer?\n'
                  'At checkout, select "Bank Transfer" and you will get an automatic 5% discount. You will be provided with our account details. Once you have transferred the amount, simply upload a screenshot of your payment receipt directly in the app to verify your order.\n\n'
                  'How much is delivery?\n'
                  'For COD, delivery is PKR 500 within Karachi, and PKR 350 outside Karachi. Bank Transfer orders enjoy a flat 5% discount.\n\n'
                  'Discounts & Rewards\n\n'
                  'How does the discount feature work?\n'
                  'All users can earn points on their purchases and watch short video ads in the "Discount & Ads" section to boost their discount percentage up to 20%.\n\n'
                  'General Support\n\n'
                  'How can I contact customer service?\n'
                  'You can reach out to us on our official Instagram/Facebook or email us at umair.1917@gmail.com.\n\n'
                  'What is Glowella?\n'
                  'Glowella is a premium skincare brand by MD Scents, specializing in top-tier dermatologically tested products.',
            );
          }),
          const Divider(height: 1, color: AppColors.divider),
          _quickLink(Icons.privacy_tip_outlined, 'Privacy Policy', () {
            _showInfoDialog(
              title: '🛡️ Privacy Policy',
              content: 'Effective Date: 11 April 2026\n\n'
                  'Glowella (by MD Scents) values your privacy and is committed to protecting your personal data.\n\n'
                  '1. Information We Collect\n'
                  'Account Information: Name, email address, and contact details via Google or email login.\n'
                  'Transaction Data: Delivery address, billing details, and payment proof screenshots. We do NOT collect or store your credit/debit card details.\n'
                  'App Activity: Order history and wallet data.\n\n'
                  '2. How We Use Your Information\n'
                  'To process and deliver your orders, manage your account, and provide customer support.\n\n'
                  '3. Third-Party Services\n'
                  'We use Firebase (by Google) for authentication and database management. We may use AdMob to display ads. We do not share your personal identifiable information with advertisers.\n\n'
                  '4. Data Deletion\n'
                  'You may request the complete deletion of your account and data at any time via the "Delete Account" button in your profile.\n\n'
                  '5. Contact Us\n'
                  'For any privacy concerns, email: umair.1917@gmail.com',
            );
          }),
          const Divider(height: 1, color: AppColors.divider),
          _quickLink(Icons.info_outline_rounded, 'About Glowella', () {
            Get.dialog(AlertDialog(
              title: const Text('About Glowella', style: TextStyle(color: AppColors.textPrimary)),
              content: const Text('Glowella is a premium skincare application by MD Scents, bringing you top-tier skincare products right to your doorstep.', style: TextStyle(color: AppColors.textSecondary)),
              actions: [TextButton(onPressed: Get.back, child: const Text('Close'))],
            ));
          }),
          const Divider(height: 1, color: AppColors.divider),
          _quickLink(Icons.explore_outlined, 'Discover MD Scents', () async {
            final url = Uri.parse('https://play.google.com/store/apps/details?id=com.mdscents.perfumes');
            if (await canLaunchUrl(url)) {
              await launchUrl(url, mode: LaunchMode.externalApplication);
            }
          }),
          const Divider(height: 1, color: AppColors.divider),
          _quickLink(
            Icons.delete_forever_rounded,
            'Delete Account',
            () => _showDeleteAccountDialog(),
            textColor: AppColors.danger,
            iconColor: AppColors.danger,
          ),
        ],
      ),
    );
  }

  void _showInfoDialog({required String title, required String content}) {
    Get.dialog(AlertDialog(
      backgroundColor: Colors.white,
      title: Text(title, style: AppTextStyles.titleMedium),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Text(
            content,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary, height: 1.5),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text('Close', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
        ),
      ],
    ));
  }

  void _showDeleteAccountDialog() {
    Get.dialog(AlertDialog(
      title: const Text('Delete Account', style: TextStyle(color: AppColors.danger, fontWeight: FontWeight.bold)),
      content: const Text('Are you sure you want to permanently delete your account? This action cannot be undone and all your points and history will be lost.', style: TextStyle(color: AppColors.textSecondary)),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            controller.deleteAccount();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.danger, foregroundColor: Colors.white),
          child: const Text('Delete Forever'),
        ),
      ],
    ));
  }

  Widget _quickLink(IconData icon, String label, VoidCallback onTap,
      {Color? textColor, Color? iconColor}) {
    return ListTile(
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: iconColor ?? AppColors.primary, size: 20),
      ),
      title: Text(label,
          style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.w600,
              color: textColor ?? AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right_rounded,
          color: AppColors.textMuted),
      onTap: onTap,
    );
  }


  Widget _buildRecentOrders() {
    if (controller.ordersLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: AppColors.primary),
      );
    }
    if (controller.userOrders.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            const Icon(Icons.shopping_bag_outlined,
                size: 40, color: AppColors.textMuted),
            const SizedBox(height: 8),
            Text('No orders yet', style: AppTextStyles.bodyMedium),
          ],
        ),
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent Orders', style: AppTextStyles.titleMedium),
            TextButton(
              onPressed: () => Get.toNamed(Routes.ORDERS),
              child: Text('View All',
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ...controller.userOrders
            .take(3)
            .map((o) => _OrderTile(order: o))
            ,
      ],
    );
  }

  void _showAddressDialog() {
    final user = Get.find<AuthService>().currentUser.value;
    final phoneCtrl = TextEditingController(text: user?.phone ?? '');
    final streetCtrl = TextEditingController(text: user?.street ?? '');
    final cityCtrl = TextEditingController(text: user?.city ?? '');
    final postalCtrl = TextEditingController(text: user?.postalCode ?? '');

    Get.dialog(
      AlertDialog(
        backgroundColor: Colors.white,
        title: Text('Edit Address', style: AppTextStyles.titleMedium),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _field(phoneCtrl, 'Phone Number'),
              const SizedBox(height: 12),
              _field(streetCtrl, 'Street Address'),
              const SizedBox(height: 12),
              _field(cityCtrl, 'City'),
              const SizedBox(height: 12),
              _field(postalCtrl, 'Postal Code'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel', style: TextStyle(color: AppColors.textMuted)),
          ),
          ElevatedButton(
            onPressed: () {
              controller.updateAddress(
                phoneCtrl.text.trim(),
                streetCtrl.text.trim(),
                cityCtrl.text.trim(),
                postalCtrl.text.trim(),
              );
              Get.back();
              Get.snackbar(
                'Success',
                'Address updated successfully',
                backgroundColor: AppColors.primary,
                colorText: Colors.white,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, foregroundColor: Colors.white),
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController ctrl, String label) {
    return TextField(
      controller: ctrl,
      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.divider),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: AppColors.primary),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
  }
}

class _OrderTile extends StatelessWidget {
  final GlowOrder order;
  const _OrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
    final statusColors = {
      OrderStatus.pending: Colors.orange,
      OrderStatus.packed: Colors.blue,
      OrderStatus.shipped: Colors.purple,
      OrderStatus.delivered: AppColors.primary,
      OrderStatus.cancelled: AppColors.danger,
    };

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 6)],
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child:
                const Icon(Icons.receipt_long_rounded, color: AppColors.primary, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${order.items.length} item(s)',
                  style: AppTextStyles.bodyMedium
                      .copyWith(fontWeight: FontWeight.w600, color: AppColors.textPrimary),
                ),
                Text(
                  DateFormat('MMM dd, yyyy').format(order.createdAt),
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'PKR ${order.total.toStringAsFixed(0)}',
                style: AppTextStyles.price.copyWith(fontSize: 13),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: (statusColors[order.status] ?? Colors.grey)
                      .withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  order.status.name.capitalizeFirst!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: statusColors[order.status] ?? Colors.grey,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
