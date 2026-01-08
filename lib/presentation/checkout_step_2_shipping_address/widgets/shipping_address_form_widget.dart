import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sizer/sizer.dart';

import '../../checkout_step_1_user_details/controller/checkout_controller.dart';

/// Shipping Address Form Widget
/// Displays form fields for address information collection
class ShippingAddressFormWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController streetAddressController;
  final TextEditingController cityController;
  final TextEditingController stateProvinceController;
  final TextEditingController postalCodeController;
  final TextEditingController deliveryInstructionsController;
  final CheckoutController controller;

  const ShippingAddressFormWidget({
    Key? key,
    required this.formKey,
    required this.streetAddressController,
    required this.cityController,
    required this.stateProvinceController,
    required this.postalCodeController,
    required this.deliveryInstructionsController,
    required this.controller,
  }) : super(key: key);

  String? _validateStreetAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Street address is required';
    }
    if (value.trim().length < 5) {
      return 'Please enter a complete address';
    }
    return null;
  }

  String? _validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'City is required';
    }
    if (value.trim().length < 2) {
      return 'Please enter a valid city name';
    }
    return null;
  }

  String? _validateStateProvince(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'State/Province is required';
    }
    return null;
  }

  String? _validatePostalCode(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Postal code is required';
    }
    final cleaned = value.replaceAll(RegExp(r'[^0-9A-Za-z]'), '');
    if (cleaned.length < 3) {
      return 'Please enter a valid postal code';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final List<String> countries = [
      'United States',
      'Canada',
      'United Kingdom',
      'Australia',
      'Germany',
      'France',
      'Japan',
      'India',
      'Brazil',
      'Mexico',
    ];

    return Form(
      key: formKey,
      child: Card(
        elevation: 2.0,
        child: Padding(
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Shipping Address',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 2.h),
              TextFormField(
                controller: streetAddressController,
                decoration: InputDecoration(
                  labelText: 'Street Address',
                  hintText: '123 Main Street, Apt 4B',
                  prefixIcon: Icon(Icons.home_outlined),
                ),
                keyboardType: TextInputType.streetAddress,
                textCapitalization: TextCapitalization.words,
                maxLines: 2,
                validator: _validateStreetAddress,
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextFormField(
                      controller: cityController,
                      decoration: InputDecoration(
                        labelText: 'City',
                        hintText: 'New York',
                        prefixIcon: Icon(Icons.location_city_outlined),
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.words,
                      validator: _validateCity,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      controller: stateProvinceController,
                      decoration: InputDecoration(
                        labelText: 'State',
                        hintText: 'NY',
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(3),
                        FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z]')),
                      ],
                      validator: _validateStateProvince,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: postalCodeController,
                      decoration: InputDecoration(
                        labelText: 'Postal Code',
                        hintText: '10001',
                        prefixIcon: Icon(Icons.markunread_mailbox_outlined),
                      ),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      inputFormatters: [
                        LengthLimitingTextInputFormatter(10),
                        FilteringTextInputFormatter.allow(
                          RegExp(r'[0-9A-Za-z\-\s]'),
                        ),
                      ],
                      validator: _validatePostalCode,
                    ),
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    flex: 2,
                    child: Obx(
                          () => DropdownButtonFormField<String>(
                        value: controller.country.value,
                        decoration: InputDecoration(
                          labelText: 'Country',
                          prefixIcon: Icon(Icons.public_outlined),
                        ),
                        items: countries.map((country) {
                          return DropdownMenuItem(
                            value: country,
                            child: Text(
                              country,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        }).toList(),
                        onChanged: (value) {
                          if (value != null) {
                            controller.country.value = value;
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 2.h),
              Divider(),
              SizedBox(height: 2.h),
              Text(
                'Delivery Preferences',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 1.h),
              TextFormField(
                controller: deliveryInstructionsController,
                decoration: InputDecoration(
                  labelText: 'Special Instructions (Optional)',
                  hintText: 'e.g., Leave at front door, Ring doorbell',
                  prefixIcon: Icon(Icons.note_outlined),
                  alignLabelWithHint: true,
                ),
                keyboardType: TextInputType.multiline,
                textCapitalization: TextCapitalization.sentences,
                maxLines: 3,
                maxLength: 200,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
