import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Empty Cart Widget - Displays when cart has no items
///
/// Features:
/// - Friendly illustration
/// - Clear messaging
/// - Continue shopping CTA
/// - Centered layout
class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildEmptyCartIcon(theme),
            SizedBox(height: 24),
            _buildEmptyCartTitle(theme),
            SizedBox(height: 12),
            _buildEmptyCartMessage(theme),
            SizedBox(height: 32),
            _buildContinueShoppingButton(context, theme),
          ],
        ),
      ),
    );
  }

  /// Builds empty cart icon
  Widget _buildEmptyCartIcon(ThemeData theme) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: theme.colorScheme.primaryContainer,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: CustomIconWidget(
          iconName: 'shopping_cart_outlined',
          color: theme.colorScheme.primary,
          size: 20.w,
        ),
      ),
    );
  }

  /// Builds empty cart title
  Widget _buildEmptyCartTitle(ThemeData theme) {
    return Text(
      'Your Cart is Empty',
      style: theme.textTheme.headlineSmall?.copyWith(
        fontWeight: FontWeight.w700,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Builds empty cart message
  Widget _buildEmptyCartMessage(ThemeData theme) {
    return Text(
      'Looks like you haven\'t added anything to your cart yet. Start shopping to fill it up!',
      style: theme.textTheme.bodyLarge?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
      textAlign: TextAlign.center,
    );
  }

  /// Builds continue shopping button
  Widget _buildContinueShoppingButton(BuildContext context, ThemeData theme) {
    return SizedBox(
      width: 70.w,
      height: 6.h,
      child: ElevatedButton(
        onPressed: () => Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed('/product-listing-screen'),
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CustomIconWidget(
              iconName: 'shopping_bag_outlined',
              color: theme.colorScheme.onPrimary,
              size: 20,
            ),
            SizedBox(width: 8),
            Text(
              'Continue Shopping',
              style: theme.textTheme.labelLarge?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
