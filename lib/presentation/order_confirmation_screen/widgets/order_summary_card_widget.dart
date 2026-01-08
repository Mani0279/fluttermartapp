import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Order Summary Card Widget
///
/// Displays comprehensive order summary with items list,
/// quantities, prices, and total calculation
class OrderSummaryCardWidget extends StatelessWidget {
  final List<Map<String, dynamic>> orderItems;
  final double subtotal;
  final double shipping;
  final double tax;
  final double total;
  final Animation<double> fadeAnimation;

  const OrderSummaryCardWidget({
    Key? key,
    required this.orderItems,
    required this.subtotal,
    required this.shipping,
    required this.tax,
    required this.total,
    required this.fadeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                  iconName: 'shopping_bag',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Order Summary',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),

            // Order Items List
            ...orderItems.map((item) => _buildOrderItem(theme, item)),

            // Divider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 2.h),
              child: Divider(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                thickness: 1,
              ),
            ),

            // Price Breakdown
            _buildPriceRow(
              theme: theme,
              label: 'Subtotal',
              value: '\$${subtotal.toStringAsFixed(2)}',
            ),
            SizedBox(height: 1.h),
            _buildPriceRow(
              theme: theme,
              label: 'Shipping',
              value: '\$${shipping.toStringAsFixed(2)}',
            ),
            SizedBox(height: 1.h),
            _buildPriceRow(
              theme: theme,
              label: 'Tax',
              value: '\$${tax.toStringAsFixed(2)}',
            ),

            // Total Divider
            Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: Divider(color: theme.colorScheme.outline, thickness: 2),
            ),

            // Total Amount
            _buildPriceRow(
              theme: theme,
              label: 'Total',
              value: '\$${total.toStringAsFixed(2)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderItem(ThemeData theme, Map<String, dynamic> item) {
    return Container(
      margin: EdgeInsets.only(bottom: 2.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: CustomImageWidget(
              imageUrl: item["image"] as String,
              width: 16.w,
              height: 16.w,
              fit: BoxFit.cover,
              semanticLabel: item["semanticLabel"] as String,
            ),
          ),
          SizedBox(width: 3.w),

          // Product Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item["name"] as String,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Qty: ${item["quantity"]}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),

          // Price
          Text(
            '\$${((item["price"] as double) * (item["quantity"] as int)).toStringAsFixed(2)}',
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow({
    required ThemeData theme,
    required String label,
    required String value,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          )
              : theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: isTotal
              ? theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          )
              : theme.textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
