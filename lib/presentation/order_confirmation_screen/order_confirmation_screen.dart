import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/order_details_card_widget.dart';
import './widgets/order_summary_card_widget.dart';
import './widgets/shipping_address_card_widget.dart';

/// Order Confirmation Screen - Success celebration after checkout completion
///
/// Features:
/// - Success checkmark animation with congratulatory message
/// - Generated order number and purchase details
/// - Comprehensive order summary with items and totals
/// - Shipping address confirmation
/// - Mock tracking information
/// - Continue shopping CTA with cart state reset
/// - Stack navigation replacing checkout flow
/// - Prevents back navigation to payment processing
///
/// Navigation:
/// - Primary: Returns to Product Listing Screen with cleared cart
/// - Secondary: Prepares for future order history functionality
class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({Key? key}) : super(key: key);

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  // Mock order data - would come from GetX controller in production
  final String _orderNumber =
      'ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
  final DateTime _purchaseDate = DateTime.now();
  final DateTime _estimatedDelivery = DateTime.now().add(
    const Duration(days: 5),
  );

  // Mock order items
  final List<Map<String, dynamic>> _orderItems = [
    {
      "id": 1,
      "name": "Premium Wireless Headphones",
      "quantity": 1,
      "price": 299.99,
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1119295e3-1765076790006.png",
      "semanticLabel":
      "Black wireless over-ear headphones with cushioned ear cups on white background",
    },
    {
      "id": 2,
      "name": "Smart Fitness Watch",
      "quantity": 2,
      "price": 199.99,
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1dd51548c-1764641911784.png",
      "semanticLabel":
      "Modern silver smartwatch with black sport band displaying fitness metrics",
    },
    {
      "id": 3,
      "name": "Portable Bluetooth Speaker",
      "quantity": 1,
      "price": 79.99,
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1aae88582-1764660840888.png",
      "semanticLabel":
      "Compact cylindrical bluetooth speaker in matte black finish",
    },
  ];

  // Mock shipping address
  final Map<String, String> _shippingAddress = {
    "name": "John Smith",
    "addressLine": "123 Main Street, Apt 4B",
    "city": "New York",
    "state": "NY",
    "pincode": "10001",
    "phone": "+1 (555) 123-4567",
  };

  double get _subtotal => _orderItems.fold(
    0.0,
        (sum, item) =>
    sum + ((item["price"] as double) * (item["quantity"] as int)),
  );
  double get _shipping => 9.99;
  double get _tax => _subtotal * 0.08;
  double get _total => _subtotal + _shipping + _tax;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _animationController.forward();
  }

  void _setupAnimations() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.3, 1.0, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: theme.scaffoldBackgroundColor,
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // Success Header
              SliverToBoxAdapter(child: _buildSuccessHeader(theme)),

              // Order Details Card
              SliverToBoxAdapter(
                child: OrderDetailsCardWidget(
                  orderNumber: _orderNumber,
                  purchaseDate: _purchaseDate,
                  estimatedDelivery: _estimatedDelivery,
                  fadeAnimation: _fadeAnimation,
                ),
              ),

              // Order Summary Card
              SliverToBoxAdapter(
                child: OrderSummaryCardWidget(
                  orderItems: _orderItems,
                  subtotal: _subtotal,
                  shipping: _shipping,
                  tax: _tax,
                  total: _total,
                  fadeAnimation: _fadeAnimation,
                ),
              ),

              // Shipping Address Card
              SliverToBoxAdapter(
                child: ShippingAddressCardWidget(
                  shippingAddress: _shippingAddress,
                  fadeAnimation: _fadeAnimation,
                ),
              ),

              // Mock Tracking Section
              SliverToBoxAdapter(child: _buildTrackingSection(theme)),

              // Bottom Spacing
              SliverToBoxAdapter(child: SizedBox(height: 10.h)),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomActions(theme),
      ),
    );
  }

  Widget _buildSuccessHeader(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 4.h),
      child: Column(
        children: [
          // Success Checkmark Animation
          ScaleTransition(
            scale: _scaleAnimation,
            child: Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Container(
                  width: 16.w,
                  height: 16.w,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.tertiary,
                    shape: BoxShape.circle,
                  ),
                  child: CustomIconWidget(
                    iconName: 'check',
                    color: theme.colorScheme.onTertiary,
                    size: 8.w,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(height: 3.h),

          // Congratulatory Message
          FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              children: [
                Text(
                  'Order Placed Successfully!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 1.h),
                Text(
                  'Thank you for your purchase',
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrackingSection(ThemeData theme) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 2.h),
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
            Row(
              children: [
                CustomIconWidget(
                  iconName: 'local_shipping',
                  color: theme.colorScheme.primary,
                  size: 6.w,
                ),
                SizedBox(width: 3.w),
                Text(
                  'Track Your Order',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            SizedBox(height: 2.h),
            Text(
              'Your order is being prepared for shipment. You will receive a tracking number via email once it ships.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Tracking feature coming soon!'),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  );
                },
                icon: CustomIconWidget(
                  iconName: 'location_on',
                  color: theme.colorScheme.primary,
                  size: 5.w,
                ),
                label: Text('Track Order'),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomActions(ThemeData theme) {
    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Continue Shopping Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Clear cart state and navigate to product listing
                  Navigator.of(
                    context,
                    rootNavigator: true,
                  ).pushNamedAndRemoveUntil(
                    '/product-listing-screen',
                        (route) => false,
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 2.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text('Continue Shopping'),
              ),
            ),
            SizedBox(height: 1.h),
            // View Order History Link
            TextButton(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: const Text('Order history feature coming soon!'),
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
              child: Text('View Order History'),
            ),
          ],
        ),
      ),
    );
  }
}
