import 'package:flutter/material.dart';

/// Custom bottom navigation bar widget for e-commerce app
/// Implements bottom-heavy action placement for mobile-first shopping experience
///
/// Features:
/// - Parameterized with currentIndex and onTap callback for reusability
/// - Fixed type for consistent layout across all screens
/// - Touch-optimized with 48dp minimum touch targets
/// - Platform-aware styling with theme integration
///
/// Usage:
/// ```dart
/// CustomBottomBar(
///   currentIndex: _currentIndex,
///   onTap: (index) {
///     setState(() => _currentIndex = index);
///     // Handle navigation
///   },
/// )
/// ```
class CustomBottomBar extends StatelessWidget {
  /// Current selected index (0-based)
  final int currentIndex;

  /// Callback when navigation item is tapped
  /// Receives the index of the tapped item
  final Function(int) onTap;

  const CustomBottomBar({
    Key? key,
    required this.currentIndex,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      type: BottomNavigationBarType.fixed,
      backgroundColor: theme.bottomNavigationBarTheme.backgroundColor,
      selectedItemColor: theme.bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor: theme.bottomNavigationBarTheme.unselectedItemColor,
      selectedLabelStyle: theme.bottomNavigationBarTheme.selectedLabelStyle,
      unselectedLabelStyle: theme.bottomNavigationBarTheme.unselectedLabelStyle,
      elevation: 8.0,
      selectedFontSize: 12,
      unselectedFontSize: 12,
      items: [
        // Product Grid - Main discovery screen
        BottomNavigationBarItem(
          icon: Icon(Icons.grid_view_outlined, size: 24),
          activeIcon: Icon(Icons.grid_view, size: 24),
          label: 'Shop',
          tooltip: 'Browse products',
        ),

        // Shopping Cart - Cart management interface
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_outlined, size: 24),
          activeIcon: Icon(Icons.shopping_cart, size: 24),
          label: 'Cart',
          tooltip: 'View shopping cart',
        ),

        // Order Success - Order history and confirmations
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt_long_outlined, size: 24),
          activeIcon: Icon(Icons.receipt_long, size: 24),
          label: 'Orders',
          tooltip: 'View order history',
        ),
      ],
    );
  }
}
