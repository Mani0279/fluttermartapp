import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_icon_widget.dart';
import '../cart_screen/controller/cart_controller.dart';
import './widgets/product_card_widget.dart';

/// Product Listing Screen - Main shopping hub with global cart integration
///
/// Features:
/// - Grid layout (2 columns on phones, 3 on tablets)
/// - Swipe-right gesture on cards for quick cart addition
/// - Tap navigation to product details
/// - Real-time cart badge updates via CartController
/// - Pull-to-refresh functionality
/// - Reddit-inspired card design
/// - Single source of truth for cart state
class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({Key? key}) : super(key: key);

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  // Global cart controller - single source of truth
  late final CartController _cartController;

  bool _isRefreshing = false;

  // Mock product data
  final List<Map<String, dynamic>> _products = [
    {
      "id": 1,
      "name": "Wireless Headphones",
      "price": "\$89.99",
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1119295e3-1765076790006.png",
      "semanticLabel":
      "Black wireless over-ear headphones with cushioned ear cups on white background",
      "description":
      "Premium wireless headphones with active noise cancellation and 30-hour battery life. Perfect for music lovers and professionals.",
      "rating": 4.5,
      "reviews": 128,
    },
    {
      "id": 2,
      "name": "Smart Watch Pro",
      "price": "\$299.99",
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1dd51548c-1764641911784.png",
      "semanticLabel":
      "Silver smartwatch with black band displaying fitness metrics on screen",
      "description":
      "Advanced fitness tracking, heart rate monitoring, and smartphone notifications. Water-resistant up to 50 meters.",
      "rating": 4.7,
      "reviews": 256,
    },
    {
      "id": 3,
      "name": "Leather Backpack",
      "price": "\$129.99",
      "image": "https://images.unsplash.com/photo-1657603726278-a9f12ca2c8d7",
      "semanticLabel":
      "Brown leather backpack with multiple compartments and adjustable straps",
      "description":
      "Handcrafted genuine leather backpack with laptop compartment. Durable and stylish for daily commute.",
      "rating": 4.3,
      "reviews": 89,
    },
    {
      "id": 4,
      "name": "Portable Speaker",
      "price": "\$59.99",
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_13203e38b-1766833020843.png",
      "semanticLabel":
      "Compact black portable Bluetooth speaker with metallic grille",
      "description":
      "360-degree sound with deep bass. Waterproof design perfect for outdoor adventures. 12-hour battery life.",
      "rating": 4.6,
      "reviews": 342,
    },
    {
      "id": 5,
      "name": "Running Shoes",
      "price": "\$119.99",
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1981c1905-1764664587892.png",
      "semanticLabel":
      "Red and white athletic running shoes with breathable mesh upper",
      "description":
      "Lightweight running shoes with responsive cushioning and breathable mesh. Designed for marathon runners.",
      "rating": 4.8,
      "reviews": 512,
    },
    {
      "id": 6,
      "name": "Coffee Maker",
      "price": "\$79.99",
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_120b9e727-1765320021928.png",
      "semanticLabel":
      "Stainless steel coffee maker with glass carafe on kitchen counter",
      "description":
      "Programmable coffee maker with thermal carafe. Brew up to 12 cups with customizable strength settings.",
      "rating": 4.4,
      "reviews": 167,
    },
    {
      "id": 7,
      "name": "Desk Lamp",
      "price": "\$45.99",
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1e7a14a69-1764656591353.png",
      "semanticLabel":
      "Modern adjustable LED desk lamp with touch controls in matte black finish",
      "description":
      "LED desk lamp with adjustable brightness and color temperature. USB charging port included for convenience.",
      "rating": 4.2,
      "reviews": 94,
    },
    {
      "id": 8,
      "name": "Yoga Mat",
      "price": "\$34.99",
      "image": "https://images.unsplash.com/photo-1726140050260-bb302b255e8d",
      "semanticLabel": "Purple non-slip yoga mat rolled up with carrying strap",
      "description":
      "Extra thick yoga mat with non-slip surface. Eco-friendly materials with carrying strap included.",
      "rating": 4.5,
      "reviews": 203,
    },
  ];

  @override
  void initState() {
    super.initState();
    // Initialize or find existing CartController
    try {
      _cartController = Get.find<CartController>();
    } catch (e) {
      // If not found, create new instance
      _cartController = Get.put(CartController());
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppBar(
        title: 'FlutterMart',
        showCartBadge: true,
        // Use Obx to reactively update cart badge
        cartItemCount: _cartController.cartItemCount.value,
        onCartTap: () {
          Navigator.of(context, rootNavigator: true).pushNamed('/cart-screen');
        },
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        color: theme.colorScheme.primary,
        child: _isRefreshing
            ? Center(
          child: CircularProgressIndicator(
            color: theme.colorScheme.primary,
          ),
        )
            : _buildProductGrid(theme),
      ),
    );
  }

  /// Builds the product grid layout with reactive cart state
  Widget _buildProductGrid(ThemeData theme) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine grid columns based on screen width
    final int crossAxisCount = screenWidth > 600 ? 3 : 2;

    return GridView.builder(
      padding: EdgeInsets.symmetric(
        horizontal: screenWidth * 0.04,
        vertical: screenHeight * 0.02,
      ),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: 0.65,
        crossAxisSpacing: screenWidth * 0.03,
        mainAxisSpacing: screenHeight * 0.02,
      ),
      itemCount: _products.length,
      itemBuilder: (context, index) {
        final product = _products[index];
        final productId = product["id"] as int;

        // Use Obx to reactively check if product is in cart
        return Obx(
              () => ProductCardWidget(
            product: product,
            isInCart: _cartController.isInCart(productId),
            onTap: () => _navigateToProductDetail(product),
            onSwipeRight: () => _addToCart(product),
          ),
        );
      },
    );
  }

  /// Handles pull-to-refresh gesture
  Future<void> _handleRefresh() async {
    setState(() {
      _isRefreshing = true;
    });

    // Simulate refresh delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isRefreshing = false;
    });

    // Show feedback
    if (mounted) {
      final theme = Theme.of(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Products refreshed',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onInverseSurface,
            ),
          ),
          duration: const Duration(seconds: 1),
          behavior: SnackBarBehavior.floating,
          backgroundColor: theme.colorScheme.inverseSurface,
        ),
      );
    }
  }

  /// Navigates to product detail screen
  void _navigateToProductDetail(Map<String, dynamic> product) {
    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/product-detail-screen', arguments: product);
  }

  /// Adds product to cart using CartController (single source of truth)
  void _addToCart(Map<String, dynamic> product) {
    final productId = product["id"] as int;

    // Check if already in cart before showing success message
    if (_cartController.isInCart(productId)) {
      // CartController will show "Already in cart" toast
      _cartController.addToCart(product);
      return;
    }

    // Add to cart via controller
    _cartController.addToCart(product);

    // Show success feedback with 4-second auto-dismiss timer
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            CustomIconWidget(
              iconName: 'check_circle',
              color: theme.colorScheme.tertiary,
              size: 20,
            ),
            SizedBox(width: screenWidth * 0.02),
            Expanded(
              child: Text(
                '${product["name"]} added to cart',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onInverseSurface,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        duration: const Duration(seconds: 4), // Auto-dismiss after 4 seconds
        behavior: SnackBarBehavior.floating,
        backgroundColor: theme.colorScheme.inverseSurface,
        action: SnackBarAction(
          label: 'VIEW',
          textColor: theme.colorScheme.tertiary,
          onPressed: () {
            // Dismiss snackbar immediately and navigate
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            Navigator.of(
              context,
              rootNavigator: true,
            ).pushNamed('/cart-screen');
          },
        ),
      ),
    );
  }
}