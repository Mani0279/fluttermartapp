import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import './widgets/credit_card_form_widget.dart';
import './widgets/order_summary_card_widget.dart';
import './widgets/payment_option_card_widget.dart';
import './widgets/progress_indicator_widget.dart';

/// Checkout Step 3 - Payment Method Screen
/// Final step in checkout process with payment method selection
/// Features mock payment options, credit card form, and order placement
class CheckoutStep3PaymentMethod extends StatefulWidget {
  const CheckoutStep3PaymentMethod({Key? key}) : super(key: key);

  @override
  State<CheckoutStep3PaymentMethod> createState() =>
      _CheckoutStep3PaymentMethodState();
}

class _CheckoutStep3PaymentMethodState
    extends State<CheckoutStep3PaymentMethod> {
  String _selectedPaymentMethod = '';
  bool _isProcessing = false;
  Map<String, String> _cardDetails = {};

  final List<Map<String, dynamic>> _mockCartItems = [
    {
      "id": 1,
      "name": "Wireless Headphones",
      "price": 79.99,
      "quantity": 1,
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1119295e3-1765076790006.png",
      "semanticLabel":
      "Black wireless over-ear headphones with cushioned ear cups on white background",
    },
    {
      "id": 2,
      "name": "Smart Watch",
      "price": 199.99,
      "quantity": 1,
      "image": "https://images.unsplash.com/photo-1575125069494-6a0c5819d340",
      "semanticLabel":
      "Modern silver smartwatch with black band displaying time on white surface",
    },
    {
      "id": 3,
      "name": "Laptop Stand",
      "price": 49.99,
      "quantity": 2,
      "image":
      "https://img.rocket.new/generatedImages/rocket_gen_img_1f9ea2001-1764658995251.png",
      "semanticLabel":
      "Aluminum laptop stand with ergonomic design on wooden desk",
    },
  ];

  final Map<String, String> _mockShippingAddress = {
    "address": "123 Main Street, Apt 4B",
    "city": "New York",
    "state": "NY",
    "pincode": "10001",
  };

  double get _subtotal {
    return _mockCartItems.fold(
      0.0,
          (sum, item) =>
      sum + ((item['price'] as double) * (item['quantity'] as int)),
    );
  }

  double get _shipping => 9.99;
  double get _tax => _subtotal * 0.08;
  double get _total => _subtotal + _shipping + _tax;

  List<Map<String, dynamic>> get _paymentOptions {
    final options = [
      {
        "method": "Credit Card",
        "icon": "credit_card",
        "description": "Pay securely with your credit card",
      },
      {
        "method": "PayPal",
        "icon": "account_balance_wallet",
        "description": "Fast and secure PayPal checkout",
      },
      {
        "method": "Cash on Delivery",
        "icon": "local_shipping",
        "description": "Pay when you receive your order",
      },
    ];

    if (defaultTargetPlatform == TargetPlatform.iOS) {
      options.insert(2, {
        "method": "Apple Pay",
        "icon": "apple",
        "description": "Quick checkout with Apple Pay",
      });
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      options.insert(2, {
        "method": "Google Pay",
        "icon": "g_mobiledata",
        "description": "Fast payment with Google Pay",
      });
    }

    return options;
  }

  void _handlePaymentSelection(String method) {
    setState(() {
      _selectedPaymentMethod = method;
      if (method != 'Credit Card') {
        _cardDetails = {};
      }
    });
  }

  void _handleCardDetailsChanged(Map<String, String> details) {
    setState(() {
      _cardDetails = details;
    });
  }

  bool _validatePaymentMethod() {
    if (_selectedPaymentMethod.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Please select a payment method'),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
      return false;
    }

    if (_selectedPaymentMethod == 'Credit Card') {
      if (_cardDetails.isEmpty ||
          _cardDetails['cardNumber']?.isEmpty == true ||
          _cardDetails['expiry']?.isEmpty == true ||
          _cardDetails['cvv']?.isEmpty == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please complete all card details'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
        return false;
      }
    }

    return true;
  }

  Future<void> _handlePlaceOrder() async {
    if (!_validatePaymentMethod()) return;

    setState(() {
      _isProcessing = true;
    });

    await Future.delayed(Duration(seconds: 2));

    if (mounted) {
      setState(() {
        _isProcessing = false;
      });

      Navigator.of(
        context,
        rootNavigator: true,
      ).pushReplacementNamed('/order-confirmation-screen');
    }
  }

  void _handleBackToShipping() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Method'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _handleBackToShipping,
        ),
      ),
      body: Column(
        children: [
          ProgressIndicatorWidget(currentStep: 3, totalSteps: 3),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),
                  OrderSummaryCardWidget(
                    cartItems: _mockCartItems,
                    shippingAddress: _mockShippingAddress,
                    subtotal: _subtotal,
                    shipping: _shipping,
                    tax: _tax,
                    total: _total,
                  ),
                  SizedBox(height: 2.h),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4.w),
                    child: Text(
                      'Select Payment Method',
                      style: theme.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: _paymentOptions.length,
                    itemBuilder: (context, index) {
                      final option = _paymentOptions[index];
                      return PaymentOptionCardWidget(
                        paymentMethod: option['method'] as String,
                        selectedPaymentMethod: _selectedPaymentMethod,
                        icon: option['icon'] as String,
                        description: option['description'] as String,
                        onSelect: _handlePaymentSelection,
                        expandedContent:
                        option['method'] == 'Credit Card' &&
                            _selectedPaymentMethod == 'Credit Card'
                            ? CreditCardFormWidget(
                          onCardDetailsChanged: _handleCardDetailsChanged,
                        )
                            : null,
                      );
                    },
                  ),
                  SizedBox(height: 10.h),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: theme.shadowColor.withValues(alpha: 0.1),
              blurRadius: 8,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: double.infinity,
                height: 6.h,
                child: ElevatedButton(
                  onPressed: _isProcessing ? null : _handlePlaceOrder,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary,
                    foregroundColor: theme.colorScheme.onPrimary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isProcessing
                      ? SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        theme.colorScheme.onPrimary,
                      ),
                    ),
                  )
                      : Text(
                    'Place Order - \$${_total.toStringAsFixed(2)}',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.onPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 1.h),
              TextButton(
                onPressed: _isProcessing ? null : _handleBackToShipping,
                child: Text(
                  'Back to Shipping',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
