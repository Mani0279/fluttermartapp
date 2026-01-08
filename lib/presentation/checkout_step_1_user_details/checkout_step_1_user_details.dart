import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../checkout_step_3_payment_method/widgets/progress_indicator_widget.dart';
import './controller/checkout_controller.dart';
import './widgets/user_details_form_widget.dart';

/// Checkout Step 1 - User Details Screen
/// First step in checkout process with personal information collection
/// Features form validation, data persistence, and progress tracking
class CheckoutStep1UserDetails extends StatefulWidget {
  const CheckoutStep1UserDetails({Key? key}) : super(key: key);

  @override
  State<CheckoutStep1UserDetails> createState() =>
      _CheckoutStep1UserDetailsState();
}

class _CheckoutStep1UserDetailsState extends State<CheckoutStep1UserDetails> {
  final CheckoutController _controller = Get.put(CheckoutController());
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  void _loadSavedData() {
    _fullNameController.text = _controller.fullName.value;
    _emailController.text = _controller.email.value;
    _phoneController.text = _controller.phoneNumber.value;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleContinueToShipping() {
    if (_formKey.currentState?.validate() ?? false) {
      _controller.fullName.value = _fullNameController.text.trim();
      _controller.email.value = _emailController.text.trim();
      _controller.phoneNumber.value = _phoneController.text.trim();

      if (_controller.validateUserDetails()) {
        Navigator.of(
          context,
          rootNavigator: true,
        ).pushNamed('/checkout-step-2-shipping-address');
      }
    }
  }

  void _handleBackToCart() {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Personal Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: _handleBackToCart,
        ),
      ),
      body: Column(
        children: [
          ProgressIndicatorWidget(currentStep: 1, totalSteps: 3),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 2.h),
                    Text(
                      'Checkout - Personal Details',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Please provide your contact information to continue',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 3.h),
                    UserDetailsFormWidget(
                      formKey: _formKey,
                      fullNameController: _fullNameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
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
                  onPressed: _handleContinueToShipping,
                  child: Text('Continue to Shipping'),
                ),
              ),
              SizedBox(height: 1.h),
              TextButton(
                onPressed: _handleBackToCart,
                child: Text('Back to Cart'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}