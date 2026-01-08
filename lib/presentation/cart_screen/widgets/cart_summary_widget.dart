import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';
import '../controller/cart_controller.dart';

/// Cart Summary Widget - Sticky footer with cart totals and checkout button
///
/// Features:
/// - Subtotal, tax, and total display
/// - Clear typography hierarchy
/// - Full-width checkout button
/// - Smooth animations for total updates
/// - Safe area handling
class CartSummaryWidget extends StatelessWidget {
  final VoidCallback onCheckout;

  const CartSummaryWidget({Key? key, required this.onCheckout})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final controller = Get.find<CartController>();

    return Container(
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSummaryRow(
                theme: theme,
                label: 'Subtotal',
                value: controller.subtotal,
                isTotal: false,
              ),
              SizedBox(height: 8),
              _buildSummaryRow(
                theme: theme,
                label: 'Tax (8%)',
                value: controller.tax,
                isTotal: false,
              ),
              Divider(height: 24, thickness: 1),
              _buildSummaryRow(
                theme: theme,
                label: 'Total',
                value: controller.total,
                isTotal: true,
              ),
              SizedBox(height: 16),
              _buildCheckoutButton(theme),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds summary row with label and value
  Widget _buildSummaryRow({
    required ThemeData theme,
    required String label,
    required RxDouble value,
    required bool isTotal,
  }) {
    return Obx(
          () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: isTotal
                ? theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
            )
                : theme.textTheme.bodyLarge,
          ),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: ScaleTransition(scale: animation, child: child),
            ),
            child: Text(
              '\$${value.value.toStringAsFixed(2)}',
              key: ValueKey(value.value),
              style: isTotal
                  ? theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              )
                  : theme.textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds checkout button
  Widget _buildCheckoutButton(ThemeData theme) {
    return SizedBox(
      width: double.infinity,
      height: 6.h,
      child: ElevatedButton(
        onPressed: onCheckout,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Proceed to Checkout',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontSize: 16,
              ),
            ),
            SizedBox(width: 8),
            CustomIconWidget(
              iconName: 'arrow_forward',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }
}
