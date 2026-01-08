import 'package:flutter/material.dart';
import '../presentation/cart_screen/cart_screen.dart';
import '../presentation/product_detail_screen/product_detail_screen.dart';
import '../presentation/product_listing_screen/product_listing_screen.dart';
import '../presentation/order_confirmation_screen/order_confirmation_screen.dart';
import '../presentation/checkout_step_3_payment_method/checkout_step_3_payment_method.dart';
import '../presentation/checkout_step_1_user_details/checkout_step_1_user_details.dart';
import '../presentation/checkout_step_2_shipping_address/checkout_step_2_shipping_address.dart';

class AppRoutes {
  // TODO: Add your routes here
  static const String initial = '/';
  static const String cart = '/cart-screen';
  static const String productDetail = '/product-detail-screen';
  static const String productListing = '/product-listing-screen';
  static const String orderConfirmation = '/order-confirmation-screen';
  static const String checkoutStep3PaymentMethod =
      '/checkout-step-3-payment-method';
  static const String checkoutStep1UserDetails =
      '/checkout-step-1-user-details';
  static const String checkoutStep2ShippingAddress =
      '/checkout-step-2-shipping-address';

  static Map<String, WidgetBuilder> routes = {
    initial: (context) => const ProductListingScreen(),
    cart: (context) => CartScreen(),
    productDetail: (context) => const ProductDetailScreen(),
    productListing: (context) => const ProductListingScreen(),
    orderConfirmation: (context) => const OrderConfirmationScreen(),
    checkoutStep3PaymentMethod: (context) => const CheckoutStep3PaymentMethod(),
    checkoutStep1UserDetails: (context) => const CheckoutStep1UserDetails(),
    checkoutStep2ShippingAddress: (context) =>
    const CheckoutStep2ShippingAddress(),
    // TODO: Add your other routes here
  };
}
