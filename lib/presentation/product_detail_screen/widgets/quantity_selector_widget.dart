import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Quantity Selector Widget
///
/// Features:
/// - Plus/minus buttons in thumb-friendly size
/// - Current quantity displayed between buttons
/// - Smooth animations for quantity changes
/// - Disabled state when limits reached
class QuantitySelectorWidget extends StatelessWidget {
  final int quantity;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;

  const QuantitySelectorWidget({
    Key? key,
    required this.quantity,
    required this.onIncrement,
    required this.onDecrement,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(3.w),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            'Quantity',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const Spacer(),
          // Decrement Button
          Container(
            width: 12.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: quantity > 1
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: IconButton(
              icon: CustomIconWidget(
                iconName: 'remove',
                color: quantity > 1
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20.sp,
              ),
              onPressed: quantity > 1 ? onDecrement : null,
              tooltip: 'Decrease quantity',
            ),
          ),
          SizedBox(width: 4.w),
          // Quantity Display
          Container(
            width: 12.w,
            height: 6.h,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              border: Border.all(
                color: theme.colorScheme.outline.withValues(alpha: 0.3),
                width: 1,
              ),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 200),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(scale: animation, child: child);
              },
              child: Text(
                quantity.toString(),
                key: ValueKey<int>(quantity),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
          ),
          SizedBox(width: 4.w),
          // Increment Button
          Container(
            width: 12.w,
            height: 6.h,
            decoration: BoxDecoration(
              color: quantity < 10
                  ? theme.colorScheme.primary.withValues(alpha: 0.1)
                  : theme.colorScheme.onSurface.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(2.w),
            ),
            child: IconButton(
              icon: CustomIconWidget(
                iconName: 'add',
                color: quantity < 10
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.3),
                size: 20.sp,
              ),
              onPressed: quantity < 10 ? onIncrement : null,
              tooltip: 'Increase quantity',
            ),
          ),
        ],
      ),
    );
  }
}
