import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Order Details Card Widget
///
/// Displays order number, purchase date, and estimated delivery
/// in a Reddit-inspired card layout
class OrderDetailsCardWidget extends StatelessWidget {
  final String orderNumber;
  final DateTime purchaseDate;
  final DateTime estimatedDelivery;
  final Animation<double> fadeAnimation;

  const OrderDetailsCardWidget({
    Key? key,
    required this.orderNumber,
    required this.purchaseDate,
    required this.estimatedDelivery,
    required this.fadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final dateFormat = DateFormat('MMM dd, yyyy');

    return FadeTransition(
      opacity: fadeAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Card Header
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'receipt',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Order Details',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Order Number
            _buildDetailRow(
              theme: theme,
              label: 'Order Number',
              value: orderNumber,
              icon: 'tag',
            ),
            SizedBox(height: 1.5.h),

            // Purchase Date
            _buildDetailRow(
              theme: theme,
              label: 'Purchase Date',
              value: dateFormat.format(purchaseDate),
              icon: 'calendar_today',
            ),
            SizedBox(height: 1.5.h),

            // Estimated Delivery
            _buildDetailRow(
              theme: theme,
              label: 'Estimated Delivery',
              value: dateFormat.format(estimatedDelivery),
              icon: 'local_shipping',
              valueColor: theme.colorScheme.tertiary,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required ThemeData theme,
    required String label,
    required String value,
    required String icon,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 10.w,
          height: 10.w,
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: CustomIconWidget(
              iconName: icon,
              color: theme.colorScheme.primary,
              size: 5.w,
            ),
          ),
        ),
        SizedBox(width: 3.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                value,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: valueColor ?? theme.colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
