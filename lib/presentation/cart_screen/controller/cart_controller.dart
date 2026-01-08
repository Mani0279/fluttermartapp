import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Cart Controller - Manages cart state and operations
///
/// Features:
/// - Cart items management with GetX reactive state
/// - Quantity updates with validation
/// - Item removal with confirmation
/// - Cart total calculation
/// - Clear all functionality
/// - Pull-to-refresh support
class CartController extends GetxController {
  // Observable cart items list
  final RxList<Map<String, dynamic>> cartItems = <Map<String, dynamic>>[].obs;

  // Loading state for refresh operations
  final RxBool isLoading = false.obs;

  // Cart totals
  final RxDouble subtotal = 0.0.obs;
  final RxDouble tax = 0.0.obs;
  final RxDouble total = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    _loadCartItems();
  }

  /// Loads initial cart items with mock data
  void _loadCartItems() {
    isLoading.value = true;

    // Mock cart items data
    cartItems.value = [
      {
        "id": 1,
        "name": "Premium Wireless Headphones",
        "price": 299.99,
        "quantity": 1,
        "image":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1119295e3-1765076790006.png",
        "semanticLabel":
        "Black wireless over-ear headphones with cushioned ear cups on white background",
      },
      {
        "id": 2,
        "name": "Smart Fitness Watch",
        "price": 199.99,
        "quantity": 2,
        "image":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1dd51548c-1764641911784.png",
        "semanticLabel":
        "Silver smartwatch with black band displaying fitness metrics on screen",
      },
      {
        "id": 3,
        "name": "Leather Laptop Bag",
        "price": 89.99,
        "quantity": 1,
        "image": "https://images.unsplash.com/photo-1679038138004-4162c92209e9",
        "semanticLabel":
        "Brown leather messenger bag with metal buckles and adjustable strap",
      },
      {
        "id": 4,
        "name": "Portable Bluetooth Speaker",
        "price": 79.99,
        "quantity": 1,
        "image":
        "https://img.rocket.new/generatedImages/rocket_gen_img_1e0d00680-1766384379855.png",
        "semanticLabel":
        "Compact cylindrical bluetooth speaker in matte black finish with control buttons",
      },
    ];

    _calculateTotals();
    isLoading.value = false;
  }

  /// Updates item quantity with validation
  void updateQuantity(int itemId, int newQuantity) {
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

    final index = cartItems.indexWhere((item) => item['id'] == itemId);
    if (index != -1) {
      cartItems[index]['quantity'] = newQuantity;
      cartItems.refresh();
      _calculateTotals();

      Fluttertoast.showToast(
        msg: "Quantity updated",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
    }
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

  /// Performs actual item removal
  void _performRemoval(int itemId) {
    cartItems.removeWhere((item) => item['id'] == itemId);
    _calculateTotals();

    Fluttertoast.showToast(
      msg: "Item removed from cart",
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Clears all items from cart
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
              cartItems.clear();
              _calculateTotals();

              Fluttertoast.showToast(
                msg: "Cart cleared",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
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

  /// Calculates cart totals
  void _calculateTotals() {
    double calculatedSubtotal = 0.0;

    for (var item in cartItems) {
      calculatedSubtotal +=
          (item['price'] as double) * (item['quantity'] as int);
    }

    subtotal.value = calculatedSubtotal;
    tax.value = calculatedSubtotal * 0.08; // 8% tax
    total.value = subtotal.value + tax.value;
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

  /// Proceeds to checkout
  void proceedToCheckout(BuildContext context) {
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

    Navigator.of(
      context,
      rootNavigator: true,
    ).pushNamed('/checkout-step-1-user-details');
  }
}
