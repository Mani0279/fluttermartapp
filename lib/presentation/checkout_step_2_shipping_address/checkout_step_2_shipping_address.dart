import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../checkout_step_3_payment_method/widgets/progress_indicator_widget.dart';
import '../checkout_step_1_user_details/controller/checkout_controller.dart';
import './widgets/shipping_address_form_widget.dart';
import './widgets/user_info_summary_widget.dart';

/// Checkout Step 2 - Shipping Address Screen
/// Second step in checkout process with address information collection
/// Features address validation, data persistence, and location services
class CheckoutStep2ShippingAddress extends StatefulWidget {
  const CheckoutStep2ShippingAddress({Key? key}) : super(key: key);

  @override
  State<CheckoutStep2ShippingAddress> createState() =>
      _CheckoutStep2ShippingAddressState();
}

class _CheckoutStep2ShippingAddressState
    extends State<CheckoutStep2ShippingAddress> {
  final CheckoutController _controller = Get.find<CheckoutController>();
  final _formKey = GlobalKey<FormState>();

  final _streetAddressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateProvinceController = TextEditingController();
  final _postalCodeController = TextEditingController();
  final _deliveryInstructionsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    _streetAddressController.text = _controller.streetAddress.value;
    _cityController.text = _controller.city.value;
    _stateProvinceController.text = _controller.stateProvince.value;
    _postalCodeController.text = _controller.postalCode.value;
    _deliveryInstructionsController.text =
        _controller.deliveryInstructions.value;
  }

  @override
  void dispose() {
    _streetAddressController.dispose();
    _cityController.dispose();
    _stateProvinceController.dispose();
    _postalCodeController.dispose();
    _deliveryInstructionsController.dispose();
    super.dispose();
  }

  void _handleContinueToPayment() {
    if (_formKey.currentState?.validate() ?? false) {
      _controller.streetAddress.value = _streetAddressController.text.trim();
      _controller.city.value = _cityController.text.trim();
      _controller.stateProvince.value = _stateProvinceController.text.trim();
      _controller.postalCode.value = _postalCodeController.text.trim();
      _controller.deliveryInstructions.value = _deliveryInstructionsController
          .text
          .trim();

      if (_controller.validateShippingAddress()) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed('/checkout-step-3-payment-method');
      }
    }
  }

  void _handleBackToDetails() {
    _controller.streetAddress.value = _streetAddressController.text.trim();
    _controller.city.value = _cityController.text.trim();
    _controller.stateProvince.value = _stateProvinceController.text.trim();
    _controller.postalCode.value = _postalCodeController.text.trim();
    _controller.deliveryInstructions.value = _deliveryInstructionsController
        .text
        .trim();

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Shipping Address'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _handleBackToDetails,
        ),
      ),
      body: Column(
        children: [
          ProgressIndicatorWidget(currentStep: 2, totalSteps: 3),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Checkout - Shipping Address',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Where should we deliver your order?',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    UserInfoSummaryWidget(controller: _controller),
                    SizedBox(height: 2.h),
                    ShippingAddressFormWidget(
                      formKey: _formKey,
                      streetAddressController: _streetAddressController,
                      cityController: _cityController,
                      stateProvinceController: _stateProvinceController,
                      postalCodeController: _postalCodeController,
                      deliveryInstructionsController:
                      _deliveryInstructionsController,
                      controller: _controller,
                    ),
                    SizedBox(height: 12.h),
                  ],
                ),
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
                child: ElevatedButton(
                  onPressed: _handleContinueToPayment,
                  child: Text('Continue to Payment'),
                ),
              ),
              SizedBox(height: 1.h),
              TextButton(
                onPressed: _handleBackToDetails,
                child: Text('Back to Details'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}