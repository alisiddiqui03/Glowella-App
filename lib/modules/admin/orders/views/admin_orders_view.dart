import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../app/theme/app_colors.dart';
import '../../../../app/theme/app_text_styles.dart';
import '../../../../app/data/models/glow_order.dart';
import '../controllers/admin_orders_controller.dart';

class AdminOrdersView extends GetView<AdminOrdersController> {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final statuses = ['all', 'pending', 'packed', 'shipped', 'delivered', 'cancelled'];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text('All Orders', style: AppTextStyles.titleLarge),
      ),
      body: Column(
        children: [
          // Filter chips
          Obx(() => SizedBox(
                height: 48,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  children: statuses
                      .map((s) => _FilterChip(
                            label: s.capitalizeFirst!,
                            isSelected:
                                controller.filterStatus.value == s,
                            onTap: () => controller.filterStatus.value = s,
                          ))
                      .toList(),
                ),
              )),
          Expanded(
            child: Obx(() {
              if (controller.isLoading) {
                return const Center(
                    child: CircularProgressIndicator(
                        color: AppColors.primary));
              }
              if (controller.filteredOrders.isEmpty) {
                return Center(
                  child: Text('No orders found',
                      style: AppTextStyles.bodyMedium),
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: controller.filteredOrders.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                itemBuilder: (_, i) =>
                    _AdminOrderCard(order: controller.filteredOrders[i]),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _FilterChip(
      {required this.label,
      required this.isSelected,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primary : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: isSelected ? AppColors.primary : AppColors.divider),
        ),
        child: Text(
          label,
          style: AppTextStyles.bodySmall.copyWith(
            color: isSelected ? Colors.white : AppColors.textSecondary,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}

class _AdminOrderCard extends GetView<AdminOrdersController> {
  final GlowOrder order;
  const _AdminOrderCard({required this.order});

  Color get _statusColor {
    switch (order.status) {
      case OrderStatus.pending: return Colors.orange;
      case OrderStatus.packed: return Colors.blue;
      case OrderStatus.shipped: return Colors.purple;
      case OrderStatus.delivered: return AppColors.primary;
      case OrderStatus.cancelled: return AppColors.danger;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: AppColors.shadow, blurRadius: 8)],
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order.customerName.isNotEmpty
                            ? order.customerName
                            : 'Unknown',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(order.customerEmail,
                          style: AppTextStyles.bodySmall,
                          overflow: TextOverflow.ellipsis),
                      Text(
                        DateFormat('MMM dd, yyyy · hh:mm a')
                            .format(order.createdAt),
                        style: AppTextStyles.caption,
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('PKR ${order.total.toStringAsFixed(0)}',
                        style: AppTextStyles.price),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: _statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        order.status.name.capitalizeFirst!,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: _statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Items
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: order.items
                  .map((i) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          children: [
                            const Icon(Icons.spa_rounded,
                                size: 12, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Expanded(
                                child: Text(i.productName,
                                    style: AppTextStyles.bodySmall)),
                            Text('x${i.quantity}',
                                style: AppTextStyles.bodySmall),
                            const SizedBox(width: 8),
                            Text('PKR ${i.lineTotal.toStringAsFixed(0)}',
                                style: AppTextStyles.bodySmall.copyWith(
                                    fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ),

          const Divider(height: 16, color: AppColors.divider),

          // Payment badge + status actions
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Column(
              children: [
                Row(
                  children: [
                    _badge(
                      order.isCod ? 'COD' : 'Bank Transfer',
                      order.isCod ? Colors.orange : Colors.blue,
                    ),
                    const SizedBox(width: 6),
                    _badge(
                      order.isPaid ? 'PAID ✓' : 'UNPAID',
                      order.isPaid ? AppColors.primary : AppColors.danger,
                    ),
                    if (!order.isCod && !order.isPaid) ...[
                      const Spacer(),
                      TextButton(
                        onPressed: () => controller.markPaid(order),
                        style: TextButton.styleFrom(
                          backgroundColor:
                              AppColors.primary.withValues(alpha: 0.1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 4),
                        ),
                        child: Text('Mark Paid',
                            style: AppTextStyles.bodySmall.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600)),
                      ),
                    ],
                  ],
                ),
                if (order.status != OrderStatus.cancelled &&
                    order.status != OrderStatus.delivered) ...[
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Text('Move to: ',
                          style: AppTextStyles.bodySmall),
                      const SizedBox(width: 6),
                      ..._nextStatuses(order.status).map(
                        (s) => Padding(
                          padding: const EdgeInsets.only(right: 6),
                          child: OutlinedButton(
                            onPressed: () =>
                                controller.updateStatus(order, s),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(
                                  color: AppColors.primary),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                            ),
                            child: Text(s.name.capitalizeFirst!,
                                style: AppTextStyles.bodySmall.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () => _showCancelDialog(order),
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                        ),
                        child: Text('Cancel',
                            style: AppTextStyles.bodySmall
                                .copyWith(color: AppColors.danger)),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<OrderStatus> _nextStatuses(OrderStatus current) {
    switch (current) {
      case OrderStatus.pending:
        return [OrderStatus.packed];
      case OrderStatus.packed:
        return [OrderStatus.shipped];
      case OrderStatus.shipped:
        return [OrderStatus.delivered];
      default:
        return [];
    }
  }

  Widget _badge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  void _showCancelDialog(GlowOrder order) {
    final reasonCtrl = TextEditingController();
    Get.dialog(AlertDialog(
      title: const Text('Cancel Order'),
      content: TextField(
        controller: reasonCtrl,
        decoration: const InputDecoration(
          labelText: 'Cancellation reason',
        ),
        maxLines: 2,
      ),
      actions: [
        TextButton(onPressed: Get.back, child: const Text('Back')),
        TextButton(
          onPressed: () {
            if (reasonCtrl.text.trim().isEmpty) {
              Get.snackbar('Required', 'Please enter a reason');
              return;
            }
            Get.back();
            controller.cancelOrder(order, reasonCtrl.text.trim());
          },
          child: const Text('Cancel Order',
              style: TextStyle(color: AppColors.danger)),
        ),
      ],
    ));
  }
}
