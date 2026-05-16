import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/data/models/glow_order.dart';
import '../controllers/admin_dashboard_controller.dart';

class AdminDashboardView extends GetView<AdminDashboardController> {
  const AdminDashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('GLOWELLA Admin', style: AppTextStyles.titleLarge),
            Text('Dashboard Overview', style: AppTextStyles.bodySmall),
          ],
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }
        return RefreshIndicator(
          color: AppColors.primary,
          onRefresh: () async {},
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Overview', style: AppTextStyles.headlineMedium),
                const SizedBox(height: 16),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.4,
                  children: [
                    _StatCard(
                      label: 'Total Revenue',
                      value:
                          'PKR ${controller.totalRevenue.toStringAsFixed(0)}',
                      icon: Icons.monetization_on_rounded,
                      color: AppColors.routineMaster,
                      iconColor: AppColors.primary,
                    ),
                    _StatCard(
                      label: 'Total Orders',
                      value: '${controller.totalOrders}',
                      icon: Icons.receipt_long_rounded,
                      color: AppColors.primary.withValues(alpha: 0.15),
                      iconColor: AppColors.primary,
                    ),
                    _StatCard(
                      label: 'Pending Orders',
                      value: '${controller.pendingCount}',
                      icon: Icons.access_time_rounded,
                      color: const Color(0xFFFFF3E0),
                      iconColor: Colors.orange,
                    ),
                    _StatCard(
                      label: 'Unpaid Transfers',
                      value: '${controller.unpaidBankCount}',
                      icon: Icons.account_balance_outlined,
                      color: AppColors.routineNight.withValues(alpha: 0.3),
                      iconColor: AppColors.routineNight,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                Text('Revenue (Last 7 Days)', style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                _buildRevenueChart(),
                const SizedBox(height: 24),
                Text('Recent Orders', style: AppTextStyles.titleMedium),
                const SizedBox(height: 12),
                ...controller.orders
                    .take(5)
                    .map((o) => _RecentOrderTile(order: o)),
                if (controller.orders.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        'No orders yet',
                        style: AppTextStyles.bodyMedium,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildRevenueChart() {
    final data = controller.dailyRevenue;
    if (data.isEmpty) return const SizedBox();

    final entries = data.entries.toList();
    entries.fold<double>(0, (m, e) => e.value > m ? e.value : m);
    final spots = List.generate(entries.length, (i) {
      return FlSpot(i.toDouble(), entries[i].value);
    });

    return Container(
      height: 220,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 10)],
      ),
      child: LineChart(
        LineChartData(
          gridData: const FlGridData(show: false),
          titlesData: FlTitlesData(
            rightTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            topTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            leftTitles: const AxisTitles(
              sideTitles: SideTitles(showTitles: false),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (val, meta) {
                  int i = val.toInt();
                  if (i >= 0 && i < entries.length) {
                    return Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        entries[i].key,
                        style: AppTextStyles.caption.copyWith(fontSize: 8),
                      ),
                    );
                  }
                  return const SizedBox();
                },
                reservedSize: 22,
              ),
            ),
          ),
          borderData: FlBorderData(show: false),
          lineBarsData: [
            LineChartBarData(
              spots: spots,
              isCurved: true,
              color: AppColors.primary,
              barWidth: 3,
              isStrokeCapRound: true,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(
                show: true,
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final Color iconColor;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(icon, color: iconColor, size: 28),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: AppTextStyles.titleLarge.copyWith(
                  fontWeight: FontWeight.w800,
                ),
                overflow: TextOverflow.ellipsis,
              ),
              Text(label, style: AppTextStyles.bodySmall),
            ],
          ),
        ],
      ),
    );
  }
}

class _RecentOrderTile extends StatelessWidget {
  final GlowOrder order;
  const _RecentOrderTile({required this.order});

  @override
  Widget build(BuildContext context) {
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
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customerName.isNotEmpty
                      ? order.customerName
                      : 'Customer',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  DateFormat('MMM dd, hh:mm a').format(order.createdAt),
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
              _StatusChip(order.status),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final OrderStatus status;
  const _StatusChip(this.status);

  Color get color {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.packed:
        return Colors.blue;
      case OrderStatus.shipped:
        return Colors.purple;
      case OrderStatus.delivered:
        return AppColors.primary;
      case OrderStatus.cancelled:
        return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status.name.capitalizeFirst!,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}
