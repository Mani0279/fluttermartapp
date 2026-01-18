import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/cart_controller.dart';
import 'widgets/cart_item_widget.dart';
import 'widgets/cart_summary_widget.dart';
import 'widgets/empty_cart_widget.dart';

/// Cart Screen Using Stack - Prevents RenderFlex Overflow
///
/// Stack approach benefits:
/// - Cart summary floats above cart items
/// - No overflow issues with keyboard
/// - Smooth scrolling behavior
/// - Summary always visible at bottom
class CartScreen extends StatelessWidget {
  const CartScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Shopping Cart (${controller.cartItemCount.value})')),
        actions: [
          Obx(() {
            if (controller.cartItems.isNotEmpty) {
              return TextButton(
                onPressed: () => controller.clearCart(context),
                child: Text(
                  'Clear All',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const EmptyCartWidget();
        }

        // ✅ STACK APPROACH: Prevents RenderFlex overflow
        return Stack(
          children: [
            // Background: Cart items list (full screen)
            RefreshIndicator(
              onRefresh: controller.refreshCart,
              child: ListView.builder(
                // ✅ Add bottom padding equal to summary height to prevent overlap
                padding: const EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: 280, // Space for summary widget (adjust as needed)
                ),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemWidget(
                    item: item,
                    onQuantityChanged: (newQty) {
                      controller.updateQuantity(item['id'], newQty);
                    },
                    onRemove: () {
                      controller.removeItem(context, item['id']);
                    },
                  );
                },
              ),
            ),

            // Foreground: Cart summary (positioned at bottom)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CartSummaryWidget(
                onCheckout: () => controller.proceedToCheckout(context),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Alternative Stack Implementation with Dynamic Bottom Padding
class CartScreenDynamic extends StatelessWidget {
  const CartScreenDynamic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final theme = Theme.of(context);
    final keyboardHeight = MediaQuery.of(context).viewInsets.bottom;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Shopping Cart (${controller.cartItemCount.value})')),
        actions: [
          Obx(() {
            if (controller.cartItems.isNotEmpty) {
              return TextButton(
                onPressed: () => controller.clearCart(context),
                child: Text(
                  'Clear All',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const EmptyCartWidget();
        }

        return Stack(
          children: [
            // Cart items with dynamic padding based on keyboard
            RefreshIndicator(
              onRefresh: controller.refreshCart,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  // ✅ Dynamic bottom padding: more when keyboard is closed
                  bottom: keyboardHeight > 0 ? 200 : 280,
                ),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemWidget(
                    item: item,
                    onQuantityChanged: (newQty) {
                      controller.updateQuantity(item['id'], newQty);
                    },
                    onRemove: () {
                      controller.removeItem(context, item['id']);
                    },
                  );
                },
              ),
            ),

            // Summary positioned at bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: CartSummaryWidget(
                onCheckout: () => controller.proceedToCheckout(context),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Advanced Stack with Animated Transitions
class CartScreenAnimated extends StatelessWidget {
  const CartScreenAnimated({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final theme = Theme.of(context);
    final mq = MediaQuery.of(context);
    final keyboardHeight = mq.viewInsets.bottom;
    final isKeyboardOpen = keyboardHeight > 0;

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Shopping Cart (${controller.cartItemCount.value})')),
        actions: [
          Obx(() {
            if (controller.cartItems.isNotEmpty) {
              return TextButton(
                onPressed: () => controller.clearCart(context),
                child: Text(
                  'Clear All',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const EmptyCartWidget();
        }

        return Stack(
          children: [
            // Cart items list
            RefreshIndicator(
              onRefresh: controller.refreshCart,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: isKeyboardOpen ? 220 : 300,
                ),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemWidget(
                    item: item,
                    onQuantityChanged: (newQty) {
                      controller.updateQuantity(item['id'], newQty);
                    },
                    onRemove: () {
                      controller.removeItem(context, item['id']);
                    },
                  );
                },
              ),
            ),

            // ✅ Animated summary with smooth transitions
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              left: 0,
              right: 0,
              bottom: 0,
              child: CartSummaryWidget(
                onCheckout: () => controller.proceedToCheckout(context),
              ),
            ),
          ],
        );
      }),
    );
  }
}

// Gesture-Based Stack with Draggable Summary (Bonus)
class CartScreenWithDraggable extends StatefulWidget {
  const CartScreenWithDraggable({Key? key}) : super(key: key);

  @override
  State<CartScreenWithDraggable> createState() => _CartScreenWithDraggableState();
}

class _CartScreenWithDraggableState extends State<CartScreenWithDraggable> {
  bool _isSummaryExpanded = true;

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text('Shopping Cart (${controller.cartItemCount.value})')),
        actions: [
          Obx(() {
            if (controller.cartItems.isNotEmpty) {
              return TextButton(
                onPressed: () => controller.clearCart(context),
                child: Text(
                  'Clear All',
                  style: TextStyle(color: theme.colorScheme.error),
                ),
              );
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      body: Obx(() {
        if (controller.cartItems.isEmpty) {
          return const EmptyCartWidget();
        }

        return Stack(
          children: [
            // Cart items
            RefreshIndicator(
              onRefresh: controller.refreshCart,
              child: ListView.builder(
                padding: EdgeInsets.only(
                  top: 8,
                  left: 8,
                  right: 8,
                  bottom: _isSummaryExpanded ? 300 : 80,
                ),
                itemCount: controller.cartItems.length,
                itemBuilder: (context, index) {
                  final item = controller.cartItems[index];
                  return CartItemWidget(
                    item: item,
                    onQuantityChanged: (newQty) {
                      controller.updateQuantity(item['id'], newQty);
                    },
                    onRemove: () {
                      controller.removeItem(context, item['id']);
                    },
                  );
                },
              ),
            ),

            // Draggable summary
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: GestureDetector(
                onVerticalDragUpdate: (details) {
                  if (details.delta.dy < -5) {
                    setState(() => _isSummaryExpanded = true);
                  } else if (details.delta.dy > 5) {
                    setState(() => _isSummaryExpanded = false);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: _isSummaryExpanded ? null : 80,
                  child: _isSummaryExpanded
                      ? CartSummaryWidget(
                    onCheckout: () => controller.proceedToCheckout(context),
                  )
                      : _buildCollapsedSummary(controller, theme),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildCollapsedSummary(CartController controller, ThemeData theme) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Total', style: TextStyle(fontSize: 14)),
                Obx(() => Text(
                  '₹${controller.finalTotal.value.toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                )),
              ],
            ),
            ElevatedButton(
              onPressed: () => controller.proceedToCheckout(context),
              child: const Text('Checkout'),
            ),
          ],
        ),
      ),
    );
  }
}