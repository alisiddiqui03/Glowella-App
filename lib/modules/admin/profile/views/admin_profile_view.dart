import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/services/auth_service.dart';
import '../../../../app/routes/app_pages.dart';

class AdminProfileView extends StatelessWidget {
  const AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final user = AuthService.to.currentUser.value;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('Admin Profile', style: AppTextStyles.titleLarge),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Avatar and Info
            Center(
              child: Column(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.primary, width: 2),
                    ),
                    child: const Icon(
                      Icons.admin_panel_settings_rounded,
                      size: 50,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    user?.displayName ?? 'Admin',
                    style: AppTextStyles.headlineLarge.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    user?.email ?? 'admin@glowella.com',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Options
            _buildOption(
              icon: Icons.email_outlined,
              label: 'Email',
              value: user?.email ?? 'N/A',
            ),
            _buildOption(
              icon: Icons.verified_user_outlined,
              label: 'Role',
              value: 'Master Administrator',
            ),
            _buildOption(
              icon: Icons.app_settings_alt_outlined,
              label: 'App Version',
              value: '1.0.0 (Glowella)',
            ),

            const SizedBox(height: 40),

            // Logout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () => _showLogoutDialog(),
                icon: const Icon(Icons.logout_rounded),
                label: const Text('Logout Session'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.danger,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.primary, size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: AppTextStyles.caption),
              Text(
                value,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog() {
    Get.dialog(
      AlertDialog(
        title: const Text('Logout'),
        content: const Text(
          'Are you sure you want to logout?',
          style: TextStyle(color: Colors.black),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await AuthService.to.signOut();
              Get.offAllNamed(Routes.AUTH);
            },
            child: const Text(
              'Logout',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
  }
}
