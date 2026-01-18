import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/cart_controller.dart';

class CartSummaryWidget extends StatelessWidget {
  final VoidCallback onCheckout;

  const CartSummaryWidget({Key? key, required this.onCheckout}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();
    final theme = Theme.of(context);

    // ── MediaQuery values ──
    final mq = MediaQuery.of(context);
    final screenHeight = mq.size.height;
    final keyboardHeight = mq.viewInsets.bottom;
    final isVerySmallScreen = screenHeight < 600;

    // Dynamic spacing based on screen height and keyboard visibility
    final verticalSpacing = isVerySmallScreen || keyboardHeight > 0 ? 8.0 : 16.0;
    final sectionSpacing = isVerySmallScreen || keyboardHeight > 0 ? 8.0 : 16.0;
    final priceRowSpacing = isVerySmallScreen || keyboardHeight > 0 ? 4.0 : 8.0;

    // Slightly smaller fonts on tiny screens or when keyboard is open
    final baseFontSize = isVerySmallScreen || keyboardHeight > 0 ? 13.0 : 15.0;
    final totalFontSize = isVerySmallScreen || keyboardHeight > 0 ? 16.0 : 20.0;

    return Container(
      padding: EdgeInsets.only(
        left: isVerySmallScreen ? 12 : 16,
        right: isVerySmallScreen ? 12 : 16,
        top: isVerySmallScreen ? 8 : 12,
        bottom: isVerySmallScreen ? 8 : 12,
      ),
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
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Coupon Section
              _buildCouponSection(controller, theme),

              SizedBox(height: sectionSpacing),
              const Divider(height: 1),

              SizedBox(height: verticalSpacing),

              // Price Breakdown
              Obx(() => _buildPriceRow(
                'Subtotal',
                controller.subtotal.value,
                fontSize: baseFontSize,
              )),
              SizedBox(height: priceRowSpacing),

              Obx(() {
                if (controller.discountAmount.value > 0) {
                  return Column(
                    children: [
                      _buildPriceRow(
                        'Discount (${controller.appliedCoupon.value})',
                        -controller.discountAmount.value,
                        isDiscount: true,
                        fontSize: baseFontSize,
                      ),
                      SizedBox(height: priceRowSpacing),
                    ],
                  );
                }
                return const SizedBox.shrink();
              }),

              Obx(() => _buildPriceRow(
                'Tax (8%)',
                controller.tax.value,
                fontSize: baseFontSize,
              )),
              SizedBox(height: verticalSpacing),
              const Divider(height: 1, thickness: 1.5),
              SizedBox(height: verticalSpacing),

              Obx(() => _buildPriceRow(
                'Total Amount',
                controller.finalTotal.value,
                bold: true,
                large: true,
                fontSize: totalFontSize,
              )),

              SizedBox(height: verticalSpacing),

              // Checkout Button - Hide when keyboard is visible to save space
              if (keyboardHeight == 0)
                ElevatedButton(
                  onPressed: onCheckout,
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: isVerySmallScreen ? 12 : 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    'Proceed to Checkout',
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: isVerySmallScreen ? 15 : 16,
                    ),
                  ),
                )
              else
              // Show minimal button when keyboard is open
                SizedBox(
                  height: 40,
                  child: ElevatedButton(
                    onPressed: onCheckout,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text(
                      'Checkout',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCouponSection(CartController controller, ThemeData theme) {
    // Create a local observable for tracking text changes
    final RxString couponText = ''.obs;
    final TextEditingController couponCtrl = TextEditingController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Have a coupon?',
          style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 6),

        // Row with proper constraints to prevent RenderFlex overflow
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField in Flexible to handle overflow
            Flexible(
              flex: 3,
              child: Obx(() => TextField(
                controller: couponCtrl,
                onChanged: (value) {
                  couponText.value = value;
                  // Clear error when user starts typing
                  if (controller.couponError.isNotEmpty) {
                    controller.couponError.value = '';
                  }
                },
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Code',
                  hintStyle: const TextStyle(fontSize: 13),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  errorText: controller.couponError.value.isNotEmpty
                      ? controller.couponError.value
                      : null,
                  errorStyle: const TextStyle(fontSize: 11),
                  errorMaxLines: 1,
                  isDense: true,
                ),
                textCapitalization: TextCapitalization.characters,
              )),
            ),
            const SizedBox(width: 6),

            // Apply button with fixed width
            Obx(() {
              final isEnabled = couponText.value.trim().isNotEmpty &&
                  controller.appliedCoupon.value.isEmpty;

              return SizedBox(
                height: 42,
                child: ElevatedButton(
                  onPressed: isEnabled
                      ? () {
                    // Dismiss keyboard first
                    FocusManager.instance.primaryFocus?.unfocus();

                    controller.applyCoupon(couponText.value);
                    couponText.value = '';
                    couponCtrl.clear();
                  }
                      : null,
                  style: ElevatedButton.styleFrom(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                  ),
                  child: const Text('Apply', style: TextStyle(fontSize: 13)),
                ),
              );
            }),
          ],
        ),

        // Applied coupon chip with remove option
        Obx(() {
          if (controller.appliedCoupon.value.isNotEmpty) {
            return Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Chip(
                      label: Text(
                        '${controller.appliedCoupon.value} applied',
                        style: const TextStyle(color: Colors.green, fontSize: 12),
                      ),
                      backgroundColor: Colors.green[50],
                      deleteIcon: const Icon(Icons.close, size: 16, color: Colors.red),
                      onDeleted: () {
                        controller.removeCoupon();
                        couponText.value = '';
                        couponCtrl.clear();
                      },
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        }),
      ],
    );
  }

  Widget _buildPriceRow(
      String label,
      double amount, {
        bool bold = false,
        bool large = false,
        bool isDiscount = false,
        double fontSize = 15.0,
      }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              fontSize: large ? fontSize + 3 : fontSize,
              fontWeight: bold ? FontWeight.bold : FontWeight.w500,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          isDiscount
              ? "- ₹${amount.abs().toStringAsFixed(2)}"
              : "₹${amount.toStringAsFixed(2)}",
          style: TextStyle(
            fontSize: large ? fontSize + 5 : fontSize + 1,
            fontWeight: bold ? FontWeight.bold : FontWeight.w600,
            color: isDiscount ? Colors.green[700] : null,
          ),
        ),
      ],
    );
  }
}