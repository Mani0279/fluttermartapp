import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Enhanced Cart Controller - Single Source of Truth for Cart Management
///
/// Features:
/// - Global cart state with GetX reactive state
/// - Product tracking to prevent duplicates
/// - Quantity updates with validation
/// - Item removal with confirmation
/// - Cart total calculation
/// - Real-time synchronization across screens
/// - Comprehensive edge case handling
class CartController extends GetxController {
  // Observable cart items list
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  // Track which product IDs are in cart (for quick lookups)
  final RxSet<int> cartProductIds = <int>{}.obs;

  // Cart item count for badge display
  final RxInt cartItemCount = 0.obs;

  // Loading state for refresh operations
  final RxBool isLoading = false.obs;

  // Cart totals
  final RxDouble subtotal = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble total = 0.0.obs;
  final RxString appliedCoupon = ''.obs;
  final RxDouble discountAmount = 0.0.obs;
  final RxString couponError = ''.obs;
  final RxDouble finalTotal = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _initializeCart();
    everAll([subtotal, appliedCoupon], (_) => _calculateFinalTotal());
    _calculateTotals();
  }

  /// Initializes empty cart (no mock data by default)
  void _initializeCart() {
    isLoading.value = true;

    // Start with empty cart - user will add items via product listing
    cartItems.clear();
    cartProductIds.clear();
    cartItemCount.value = 0;

    _calculateTotals();
    isLoading.value = false;
  }

  /// Checks if a product is already in the cart
  bool isInCart(int productId) {
    return cartProductIds.contains(productId);
  }

  /// Adds product to cart with validation and edge case handling
  void addToCart(Map<String, dynamic> product) {
    try {
      final productId = product['id'] as int;

      // Edge Case 1: Check if product already exists in cart
      if (isInCart(productId)) {
        Fluttertoast.showToast(
          msg: "Already in cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.orange,
          textColor: Colors.white,
        );
        return;
      }

      // Edge Case 2: Validate required fields
      if (!product.containsKey('name') ||
          !product.containsKey('price') ||
          !product.containsKey('image')) {
        Fluttertoast.showToast(
          msg: "Invalid product data",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Convert price from string format "$89.99" to double 89.99
      double priceValue;
      final priceStr = product['price'] as String;

      try {
        priceValue = double.parse(priceStr.replaceAll('\$', '').replaceAll(',', ''));
      } catch (e) {
        print('Error parsing price: $e');
        Fluttertoast.showToast(
          msg: "Invalid price format",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Create cart item with consistent structure
      final cartItem = {
        'id': productId,
        'name': product['name'],
        'price': priceValue, // Store as double, not string
        'quantity': 1, // Default quantity
        'image': product['image'],
        'semanticLabel': product['semanticLabel'] ?? 'Product image',
      };

      // Add to cart
      cartItems.add(cartItem);
      cartProductIds.add(productId);
      cartItemCount.value = cartItems.length;

      // Trigger reactive updates
      cartItems.refresh();
      cartProductIds.refresh();

      _calculateTotals();

      // Success feedback
      Fluttertoast.showToast(
        msg: "${product['name']} added to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

    } catch (e) {
      print('Error adding to cart: $e');
      Fluttertoast.showToast(
        msg: "Failed to add to cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }

  /// Updates item quantity with validation
  void updateQuantity(int itemId, int newQuantity) {
    // Edge Case 1: Minimum quantity validation
    if (newQuantity < 1) {
      Fluttertoast.showToast(
        msg: "Quantity must be at least 1",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Edge Case 2: Maximum quantity validation
    if (newQuantity > 10) {
      Fluttertoast.showToast(
        msg: "Maximum quantity is 10",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    // Edge Case 3: Item not found
    final index = cartItems.indexWhere((item) => item['id'] == itemId);
    if (index == -1) {
      Fluttertoast.showToast(
        msg: "Item not found in cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    // Update quantity
    cartItems[index]['quantity'] = newQuantity;
    cartItems.refresh();
    _calculateTotals();
    _revalidateCouponAfterChange();
    Fluttertoast.showToast(
      msg: "Quantity updated",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  /// Removes item from cart with confirmation
  void removeItem(BuildContext context, int itemId) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Remove Item', style: theme.dialogTheme.titleTextStyle),
        content: Text(
          'Are you sure you want to remove this item from your cart?',
          style: theme.dialogTheme.contentTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performRemoval(itemId);
            },
            child: Text(
              'Remove',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Performs actual item removal with state synchronization
  void _performRemoval(int itemId) {
    try {
      // Edge Case: Check if item exists before removal
      if (!cartProductIds.contains(itemId)) {
        Fluttertoast.showToast(
          msg: "Item not found in cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }

      // Remove from cart items
      cartItems.removeWhere((item) => item['id'] == itemId);

      // Remove from product ID tracking
      cartProductIds.remove(itemId);

      // Update count
      cartItemCount.value = cartItems.length;

      // Trigger reactive updates
      cartItems.refresh();
      cartProductIds.refresh();

      _calculateTotals();
      _revalidateCouponAfterChange();

      Fluttertoast.showToast(
        msg: "Item removed from cart",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );
    } catch (e) {
      print('Error removing item: $e');
      Fluttertoast.showToast(
        msg: "Failed to remove item",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    }
  }
  // Apply coupon logic (dummy rules)
  void applyCoupon(String code) {
    couponError.value = '';
    final input = code.trim().toUpperCase();

    if (input.isEmpty) {
      couponError.value = "Please enter a coupon code";
      return;
    }

    double newDiscount = 0.0;
    String successMsg = '';

    switch (input) {
      case 'SAVE10':
        newDiscount = subtotal.value * 0.10;
        successMsg = '10% discount applied!';
        break;

      case 'FLAT100':
        if (subtotal.value >= 500) {
          newDiscount = 100.0;
          successMsg = '₹100 flat discount applied!';
        } else {
          couponError.value = 'Cart total must be ≥ ₹500 for FLAT100';
          return;
        }
        break;

      default:
        couponError.value = 'Invalid coupon code';
        return;
    }

    // Success path
    appliedCoupon.value = input;
    discountAmount.value = newDiscount;
    Fluttertoast.showToast(
      msg: successMsg,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );

    _calculateFinalTotal();
  }

  // Remove / clear coupon
  void removeCoupon() {
    appliedCoupon.value = '';
    discountAmount.value = 0.0;
    couponError.value = '';
    Fluttertoast.showToast(
      msg: "Coupon removed",
      backgroundColor: Colors.grey[800],
      textColor: Colors.white,
    );
    _calculateFinalTotal();
  }

  // Called when subtotal or coupon changes
  void _calculateFinalTotal() {
    finalTotal.value = subtotal.value + tax.value - discountAmount.value;

    // Prevent negative total (edge case)
    if (finalTotal.value < 0) finalTotal.value = 0.0;
  }

  /// Clears all items from cart with confirmation
  void clearCart(BuildContext context) {
    final theme = Theme.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Cart', style: theme.dialogTheme.titleTextStyle),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: theme.dialogTheme.contentTextStyle,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _performClearCart();
            },
            child: Text(
              'Clear All',
              style: TextStyle(color: theme.colorScheme.error),
            ),
          ),
        ],
      ),
    );
  }

  /// Performs cart clearing with state synchronization
  void _performClearCart() {
    cartItems.clear();
    cartProductIds.clear();
    cartItemCount.value = 0;

    cartItems.refresh();
    cartProductIds.refresh();

    _calculateTotals();

    Fluttertoast.showToast(
      msg: "Cart cleared",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Calculates cart totals with proper validation
  void _calculateTotals() {
    double calculatedSubtotal = 0.0;

    try {
      for (var item in cartItems) {
        // Edge Case: Validate item structure
        if (!item.containsKey('price') || !item.containsKey('quantity')) {
          print('Warning: Cart item missing price or quantity');
          continue;
        }

        final price = item['price'] as double;
        final quantity = item['quantity'] as int;
        calculatedSubtotal += price * quantity;
      }

      subtotal.value = calculatedSubtotal;
      tax.value = calculatedSubtotal * 0.08; // 8% tax
      total.value = subtotal.value + tax.value;
    } catch (e) {
      print('Error calculating totals: $e');
      subtotal.value = 0.0;
      tax.value = 0.0;
      total.value = 0.0;
    }
  }

  /// Refreshes cart data (pull-to-refresh)
  Future<void> refreshCart() async {
    await Future.delayed(Duration(seconds: 1));
    _calculateTotals();

    Fluttertoast.showToast(
      msg: "Cart refreshed",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
    );
  }

  void _revalidateCouponAfterChange() {
    if (appliedCoupon.value.isEmpty) return;

    if (appliedCoupon.value == 'FLAT100' && subtotal.value < 500) {
      Fluttertoast.showToast(
        msg: "FLAT100 no longer valid (total < ₹500)",
        backgroundColor: Colors.orange,
      );
      removeCoupon();
    }
    // You can add more revalidation rules for other coupons here
  }


  /// Proceeds to checkout with validation
  void proceedToCheckout(BuildContext context) {
    // Edge Case: Empty cart validation
    if (cartItems.isEmpty) {
      Fluttertoast.showToast(
        msg: "Your cart is empty",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    // Edge Case: Validate cart items before checkout
    for (var item in cartItems) {
      if (item['quantity'] < 1) {
        Fluttertoast.showToast(
          msg: "Invalid quantity in cart",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red,
          textColor: Colors.white,
        );
        return;
      }
    }

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/checkout-step-1-user-details');
  }

  /// Debug method to print cart state
  void printCartState() {
    print('=== CART STATE ===');
    print('Items: ${cartItems.length}');
    print('Product IDs: $cartProductIds');
    print('Count: ${cartItemCount.value}');
    print('Subtotal: \$${subtotal.value.toStringAsFixed(2)}');
    print('Total: \$${total.value.toStringAsFixed(2)}');
    print('==================');
  }
}