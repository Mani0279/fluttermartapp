import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Payment option card widgets for displaying individual payment methods
/// Features radio button selection with expandable credit card form
class PaymentOptionCardWidget extends StatelessWidget {
  final String paymentMethod;
  final String selectedPaymentMethod;
  final String icon;
  final String description;
  final Function(String) onSelect;
  final Widget? expandedContent;

  const PaymentOptionCardWidget({
    Key? key,
    required this.paymentMethod,
    required this.selectedPaymentMethod,
    required this.icon,
    required this.description,
    required this.onSelect,
    this.expandedContent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSelected = selectedPaymentMethod == paymentMethod;

    return Card(
      margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.h),
      elevation: isSelected ? 4.0 : 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: isSelected
              ? theme.colorScheme.primary
              : theme.colorScheme.outline,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: InkWell(
        onTap: () => onSelect(paymentMethod),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Radio<String>(
                    value: paymentMethod,
                    groupValue: selectedPaymentMethod,
                    onChanged: (value) {
                      if (value != null) onSelect(value);
                    },
                    activeColor: theme.colorScheme.primary,
                  ),
                  SizedBox(width: 2.w),
                  CustomIconWidget(
                    iconName: icon,
                    size: 24,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: 3.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          paymentMethod,
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.w500,
                            color: isSelected
                                ? theme.colorScheme.primary
                                : theme.colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 0.5.h),
                        Text(
                          description,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    CustomIconWidget(
                      iconName: 'check_circle',
                      size: 24,
                      color: theme.colorScheme.primary,
                    ),
                ],
              ),
              if (isSelected && expandedContent != null) ...[
                SizedBox(height: 2.h),
                expandedContent!,
              ],
            ],
          ),
        ),
      ),
    );
  }
}
