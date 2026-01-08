import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

/// Checkout Controller - Manages checkout state across all steps
///
/// Features:
/// - Multi-step form data persistence
/// - User details validation
/// - Shipping address validation
/// - Data retention between navigation steps
/// - Form completion tracking
class CheckoutController extends GetxController {
  // Step 1: User Details
  final RxString fullName = ''.obs;
  final RxString email = ''.obs;
  final RxString phoneNumber = ''.obs;
  final RxBool marketingOptIn = false.obs;

  // Step 2: Shipping Address
  final RxString streetAddress = ''.obs;
  final RxString city = ''.obs;
  final RxString stateProvince = ''.obs;
  final RxString postalCode = ''.obs;
  final RxString country = 'United States'.obs;
  final RxString deliveryInstructions = ''.obs;

  // Form completion tracking
  final RxBool isStep1Complete = false.obs;
  final RxBool isStep2Complete = false.obs;

  /// Validates user details (Step 1)
  bool validateUserDetails() {
    if (fullName.value.trim().isEmpty) {
      _showError('Please enter your full name');
      return false;
    }

    if (fullName.value.trim().length < 2) {
      _showError('Name must be at least 2 characters');
      return false;
    }

    if (email.value.trim().isEmpty) {
      _showError('Please enter your email address');
      return false;
    }

    if (!_isValidEmail(email.value.trim())) {
      _showError('Please enter a valid email address');
      return false;
    }

    if (phoneNumber.value.trim().isEmpty) {
      _showError('Please enter your phone number');
      return false;
    }

    if (!_isValidPhone(phoneNumber.value.trim())) {
      _showError('Please enter a valid phone number');
      return false;
    }

    isStep1Complete.value = true;
    return true;
  }

  /// Validates shipping address (Step 2)
  bool validateShippingAddress() {
    if (streetAddress.value.trim().isEmpty) {
      _showError('Please enter your street address');
      return false;
    }

    if (city.value.trim().isEmpty) {
      _showError('Please enter your city');
      return false;
    }

    if (stateProvince.value.trim().isEmpty) {
      _showError('Please enter your state/province');
      return false;
    }

    if (postalCode.value.trim().isEmpty) {
      _showError('Please enter your postal code');
      return false;
    }

    if (!_isValidPostalCode(postalCode.value.trim())) {
      _showError('Please enter a valid postal code');
      return false;
    }

    if (country.value.trim().isEmpty) {
      _showError('Please select your country');
      return false;
    }

    isStep2Complete.value = true;
    return true;
  }

  /// Email validation
  bool _isValidEmail(String email) {
    return email.contains('@');
  }

  /// Phone validation (supports various formats)
  bool _isValidPhone(String phone) {
    final cleaned = phone.replaceAll(RegExp(r'[^0-9]'), '');
    return cleaned.length >= 10 && cleaned.length <= 15;
  }

  /// Postal code validation
  bool _isValidPostalCode(String postalCode) {
    final cleaned = postalCode.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    return cleaned.length >= 3 && cleaned.length <= 10;
  }

  /// Shows error toast
  void _showError(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.red,
      textColor: Colors.white,
    );
  }

  /// Shows success toast
  void showSuccess(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: Colors.green,
      textColor: Colors.white,
    );
  }

  /// Resets all checkout data
  void resetCheckout() {
    fullName.value = '';
    email.value = '';
    phoneNumber.value = '';
    marketingOptIn.value = false;
    streetAddress.value = '';
    city.value = '';
    stateProvince.value = '';
    postalCode.value = '';
    country.value = 'United States';
    deliveryInstructions.value = '';
    isStep1Complete.value = false;
    isStep2Complete.value = false;
  }

  /// Gets formatted address for display
  String getFormattedAddress() {
    return '$streetAddress\n$city, $stateProvince $postalCode\n$country';
  }
}
