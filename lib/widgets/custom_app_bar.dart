import 'package:flutter/material.dart';

/// Custom app bar widget for e-commerce app
/// Implements clean top navigation with consistent styling
///
/// Features:
/// - Parameterized title and actions for flexibility
/// - Optional leading widget (back button, menu, etc.)
/// - Integrated cart badge support
/// - Elevation on scroll for visual hierarchy
/// - Theme-aware styling
///
/// Usage:
/// ```dart
/// CustomAppBar(
///   title: 'Product Listing',
///   showCartBadge: true,
///   cartItemCount: 3,
///   onCartTap: () => Navigator.pushNamed(context, '/cart-screen'),
/// )
/// ```
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  /// App bar title text
  final String title;

  /// Optional leading widget (defaults to back button if canPop is true)
  final Widget? leading;

  /// Whether to show the cart badge icon
  final bool showCartBadge;

  /// Number of items in cart (shown on badge)
  final int cartItemCount;

  /// Callback when cart icon is tapped
  final VoidCallback? onCartTap;

  /// Additional action widgets (placed after cart icon)
  final List<Widget>? actions;

  /// Whether to center the title
  final bool centerTitle;

  /// Custom background color (defaults to theme color)
  final Color? backgroundColor;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.leading,
    this.showCartBadge = false,
    this.cartItemCount = 0,
    this.onCartTap,
    this.actions,
    this.centerTitle = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build actions list with cart badge
    final List<Widget> appBarActions = [];

    if (showCartBadge) {
      appBarActions.add(_buildCartBadge(context, theme));
    }

    if (actions != null) {
      appBarActions.addAll(actions!);
    }

    return AppBar(
      title: Text(title),
      leading: leading,
      centerTitle: centerTitle,
      backgroundColor: backgroundColor ?? theme.appBarTheme.backgroundColor,
      foregroundColor: theme.appBarTheme.foregroundColor,
      elevation: theme.appBarTheme.elevation,
      scrolledUnderElevation: theme.appBarTheme.scrolledUnderElevation,
      actions: appBarActions.isNotEmpty ? appBarActions : null,
    );
  }

  /// Builds cart badge with item count
  Widget _buildCartBadge(BuildContext context, ThemeData theme) {
    return Padding(
      padding: const EdgeInsets.only(right: 8.0),
      child: Stack(
        alignment: Alignment.center,
        children: [
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            iconSize: 24,
            tooltip: 'Shopping cart',
            onPressed:
            onCartTap ??
                    () {
                  Navigator.pushNamed(context, '/cart-screen');
                },
            padding: const EdgeInsets.all(12),
            constraints: const BoxConstraints(minWidth: 48, minHeight: 48),
          ),
          if (cartItemCount > 0)
            Positioned(
              right: 8,
              top: 8,
              child: Container(
                padding: const EdgeInsets.all(4),
                constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                decoration: BoxDecoration(
                  color:
                  theme.colorScheme.tertiary, // Accent color for cart badge
                  borderRadius: BorderRadius.circular(9),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withValues(alpha: 0.3),
                      blurRadius: 2,
                      offset: const Offset(0, 1),
                    ),
                  ],
                ),
                child: Text(
                  cartItemCount > 99 ? '99+' : cartItemCount.toString(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.onTertiary,
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    height: 1.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
