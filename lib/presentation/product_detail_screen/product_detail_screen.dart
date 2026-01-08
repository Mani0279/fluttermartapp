import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import './widgets/add_to_cart_button_widget.dart';
import './widgets/product_info_card_widget.dart';
import './widgets/quantity_selector_widget.dart';

/// Product Detail Screen - Comprehensive product information with touch-optimized interactions
///
/// Features:
/// - Image carousel with swipe gestures and page indicators
/// - Reddit-style card layout for product information
/// - Quantity selector with plus/minus controls
/// - Full-width add to cart button in bottom safe area
/// - Smooth animations for quantity changes and cart additions
/// - Native back button (Android) and swipe-back gesture (iOS) support
/// - Cart badge count visibility in header
/// - Haptic feedback on cart addition success
class ProductDetailScreen extends StatefulWidget {
  const ProductDetailScreen({Key? key}) : super(key: key);

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  int _quantity = 1;
  bool _isAddingToCart = false;
  int _cartItemCount = 0;

  // Mock product data
  final Map<String, dynamic> _productData = {
    "id": 1,
    "name": "Premium Wireless Headphones",
    "price": "\$299.99",
    "description":
    "Experience crystal-clear audio with our premium wireless headphones. Featuring active noise cancellation, 30-hour battery life, and premium comfort padding. Perfect for music lovers, commuters, and professionals who demand the best audio quality. Bluetooth 5.0 connectivity ensures stable connection up to 30 feet. Includes carrying case and charging cable.",
    "images": [
      {
        "url":
        "https://img.rocket.new/generatedImages/rocket_gen_img_13e126511-1765030295691.png",
        "semanticLabel":
        "Black wireless over-ear headphones with silver accents on white background, showing side profile with cushioned ear cups",
      },
      {
        "url":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1091940e8-1767108446171.png",
        "semanticLabel":
        "Close-up view of black wireless headphones showing padded headband and adjustable metal frame",
      },
      {
        "url": "https://images.unsplash.com/photo-1531505336954-5d4ad6a4b4d7",
        "semanticLabel":
        "Black wireless headphones folded flat on wooden surface, displaying compact design",
      },
    ],
    "rating": 4.5,
    "reviewCount": 1247,
  };

  @override
  void initState() {
    super.initState();
    _loadCartCount();
  }

  void _loadCartCount() {
    // Simulate loading cart count from state management
    setState(() {
      _cartItemCount = 3;
    });
  }

  void _incrementQuantity() {
    if (_quantity < 10) {
      setState(() {
        _quantity++;
      });
    }
  }

  void _decrementQuantity() {
    if (_quantity > 1) {
      setState(() {
        _quantity--;
      });
    }
  }

  Future<void> _addToCart() async {
    setState(() {
      _isAddingToCart = true;
    });

    // Simulate adding to cart with animation delay
    await Future.delayed(const Duration(milliseconds: 800));

    setState(() {
      _isAddingToCart = false;
      _cartItemCount += _quantity;
    });

    // Show success feedback
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Added $_quantity item${_quantity > 1 ? 's' : ''} to cart',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: 'VIEW CART',
            onPressed: () {
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

  void _navigateToCart() {
    Navigator.of(context, rootNavigator: true).pushNamed('/cart-screen');
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = (_productData["images"] as List)
        .cast<Map<String, dynamic>>();

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        foregroundColor: theme.appBarTheme.foregroundColor,
        elevation: 0,
        scrolledUnderElevation: 2.0,
        leading: IconButton(
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color:
            theme.appBarTheme.foregroundColor ??
                theme.colorScheme.onSurface,
            size: 24,
          ),
          onPressed: () => Navigator.of(context).pop(),
          tooltip: 'Back',
        ),
        title: Text('Product Details', style: theme.appBarTheme.titleTextStyle),
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  icon: CustomIconWidget(
                    iconName: 'shopping_cart_outlined',
                    color:
                    theme.appBarTheme.foregroundColor ??
                        theme.colorScheme.onSurface,
                    size: 24,
                  ),
                  onPressed: _navigateToCart,
                  tooltip: 'Shopping cart',
                  padding: EdgeInsets.all(3.w),
                ),
                if (_cartItemCount > 0)
                  Positioned(
                    right: 2.w,
                    top: 2.h,
                    child: Container(
                      padding: EdgeInsets.all(1.w),
                      constraints: BoxConstraints(
                        minWidth: 4.w,
                        minHeight: 2.h,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.tertiary,
                        borderRadius: BorderRadius.circular(2.w),
                        boxShadow: [
                          BoxShadow(
                            color: theme.shadowColor.withValues(alpha: 0.3),
                            blurRadius: 2,
                            offset: const Offset(0, 1),
                          ),
                        ],
                      ),
                      child: Text(
                        _cartItemCount > 99 ? '99+' : _cartItemCount.toString(),
                        style: theme.textTheme.labelSmall?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.0,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image Carousel
                  Container(
                    width: double.infinity,
                    height: 40.h,
                    color: theme.colorScheme.surface,
                    child: Stack(
                      children: [
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 40.h,
                            viewportFraction: 1.0,
                            enableInfiniteScroll: images.length > 1,
                            autoPlay: false,
                            enlargeCenterPage: false,
                            onPageChanged: (index, reason) {
                              setState(() {
                                _currentImageIndex = index;
                              });
                            },
                          ),
                          items: images.map((image) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface,
                                  ),
                                  child: CustomImageWidget(
                                    imageUrl: image["url"] as String,
                                    width: double.infinity,
                                    height: 40.h,
                                    fit: BoxFit.contain,
                                    semanticLabel:
                                    image["semanticLabel"] as String,
                                  ),
                                );
                              },
                            );
                          }).toList(),
                        ),
                        if (images.length > 1)
                          Positioned(
                            bottom: 2.h,
                            left: 0,
                            right: 0,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(
                                images.length,
                                    (index) => Container(
                                  width: 2.w,
                                  height: 2.w,
                                  margin: EdgeInsets.symmetric(horizontal: 1.w),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _currentImageIndex == index
                                        ? theme.colorScheme.primary
                                        : theme.colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  SizedBox(height: 2.h),
                  // Product Information Card
                  ProductInfoCardWidget(productData: _productData),
                  SizedBox(height: 2.h),
                  // Quantity Selector
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: QuantitySelectorWidget(
                      quantity: _quantity,
                      onIncrement: _incrementQuantity,
                      onDecrement: _decrementQuantity,
                    ),
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
          // Add to Cart Button (Fixed at bottom)
          AddToCartButtonWidget(
            isLoading: _isAddingToCart,
            quantity: _quantity,
            price: _productData["price"] as String,
            onPressed: _addToCart,
          ),
        ],
      ),
    );
  }
}
