import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './controller/cart_controller.dart';
import './widgets/cart_item_widget.dart';
import './widgets/cart_summary_widget.dart';
import './widgets/empty_cart_widget.dart';

/// Cart Screen - Shopping cart management with swipe gestures
///
/// Features:
/// - Vertical list of cart items with Reddit-inspired card design
/// - Swipe-left gesture for item removal with confirmation
/// - Quantity adjustment with plus/minus buttons
/// - Real-time cart total calculation with animations
/// - Sticky footer with cart summary
/// - Empty cart state with continue shopping CTA
/// - Pull-to-refresh for pricing updates
/// - Smooth removal animations
class CartScreen extends StatelessWidget {
  CartScreen({Key? key}) : super(key: key);

  final CartController controller = Get.put(CartController());

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: _buildAppBar(context, theme),
      body: Obx(
            () => controller.isLoading.value
            ? Center(child: CircularProgressIndicator())
            : controller.cartItems.isEmpty
            ? EmptyCartWidget()
            : _buildCartContent(context, theme),
      ),
    );
  }

  /// Builds app bar with cart item count and clear all action
  PreferredSizeWidget _buildAppBar(BuildContext context, ThemeData theme) {
    return AppBar(
      title: Obx(
            () => Text(
          'Shopping Cart (${controller.cartItems.length})',
          style: theme.appBarTheme.titleTextStyle,
        ),
      ),
      backgroundColor: theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      leading: IconButton(
        icon: CustomIconWidget(
          iconName: 'arrow_back',
          color:
          theme.appBarTheme.foregroundColor ?? theme.colorScheme.onSurface,
          size: 24,
        ),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
        tooltip: 'Back',
      ),
      actions: [
        Obx(
              () => controller.cartItems.isNotEmpty
              ? TextButton(
            onPressed: () => controller.clearCart(context),
            child: Text(
              'Clear All',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.error,
              ),
            ),
          )
              : SizedBox.shrink(),
        ),
        SizedBox(width: 8),
      ],
    );
  }

  /// Builds main cart content with refresh capability
  Widget _buildCartContent(BuildContext context, ThemeData theme) {
    return Column(
      children: [
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.refreshCart,
            color: theme.colorScheme.primary,
            child: Obx(
                  () => ListView.separated(
                padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                itemCount: controller.cartItems.length,
                separatorBuilder: (context, index) => SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemWidget(
                    item: item,
                    onQuantityChanged: (newQuantity) =>
                        controller.updateQuantity(item['id'], newQuantity),
                    onRemove: () => controller.removeItem(context, item['id']),
                  );
                },
              ),
            ),
          ),
        ),
        CartSummaryWidget(
          onCheckout: () => controller.proceedToCheckout(context),
        ),
      ],
    );
  }
}
