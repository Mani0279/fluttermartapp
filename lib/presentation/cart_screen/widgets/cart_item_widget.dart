import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:sizer/sizer.dart';

import '../../../core/app_export.dart';

/// Cart Item Widget - Individual cart item card with swipe actions
///
/// Features:
/// - Reddit-inspired card design
/// - Product image, name, and price display
/// - Quantity adjustment controls
/// - Swipe-left to delete with confirmation
/// - Long-press for additional options
/// - Smooth animations
class CartItemWidget extends StatelessWidget {
  final Map<String, dynamic> item;
  final Function(int) onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemWidget({
    Key? key,
    required this.item,
    required this.onQuantityChanged,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final quantity = item['quantity'] as int;
    final price = item['price'] as double;
    final itemTotal = price * quantity;

    return Slidable(
      key: ValueKey(item['id']),
      endActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () => onRemove()),
        children: [
          SlidableAction(
            onPressed: (context) => onRemove(),
            backgroundColor: theme.colorScheme.error,
            foregroundColor: theme.colorScheme.onError,
            icon: Icons.delete_outline,
            label: 'Delete',
            borderRadius: BorderRadius.circular(12),
          ),
        ],
      ),
      child: GestureDetector(
        onLongPress: () => _showItemOptions(context, theme),
        child: Card(
          elevation: theme.cardTheme.elevation,
          shape: theme.cardTheme.shape,
          margin: EdgeInsets.zero,
          child: Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProductImage(theme),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildProductName(theme),
                      SizedBox(height: 4),
                      _buildProductPrice(theme, price),
                      SizedBox(height: 8),
                      _buildQuantityControls(theme, quantity),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                _buildItemTotal(theme, itemTotal),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Builds product image
  Widget _buildProductImage(ThemeData theme) {
    return Container(
      width: 20.w,
      height: 20.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: theme.colorScheme.surface,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: CustomImageWidget(
          imageUrl: item['image'] as String,
          width: 20.w,
          height: 20.w,
          fit: BoxFit.cover,
          semanticLabel: item['semanticLabel'] as String,
        ),
      ),
    );
  }

  /// Builds product name
  Widget _buildProductName(ThemeData theme) {
    return Text(
      item['name'] as String,
      style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  /// Builds product price
  Widget _buildProductPrice(ThemeData theme, double price) {
    return Text(
      '\$${price.toStringAsFixed(2)}',
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }

  /// Builds quantity adjustment controls
  Widget _buildQuantityControls(ThemeData theme, int quantity) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: theme.colorScheme.outline, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildQuantityButton(
            theme: theme,
            icon: 'remove',
            onPressed: () => onQuantityChanged(quantity - 1),
          ),
          Container(
            width: 12.w,
            padding: EdgeInsets.symmetric(vertical: 8),
            child: Text(
              quantity.toString(),
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          _buildQuantityButton(
            theme: theme,
            icon: 'add',
            onPressed: () => onQuantityChanged(quantity + 1),
          ),
        ],
      ),
    );
  }

  /// Builds quantity adjustment button
  Widget _buildQuantityButton({
    required ThemeData theme,
    required String icon,
    required VoidCallback onPressed,
  }) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        width: 10.w,
        height: 10.w,
        alignment: Alignment.center,
        child: CustomIconWidget(
          iconName: icon,
          color: theme.colorScheme.primary,
          size: 20,
        ),
      ),
    );
  }

  /// Builds item total price
  Widget _buildItemTotal(ThemeData theme, double itemTotal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          '\$${itemTotal.toStringAsFixed(2)}',
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }

  /// Shows item options on long press
  void _showItemOptions(BuildContext context, ThemeData theme) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: CustomIconWidget(
                iconName: 'bookmark_outline',
                color: theme.colorScheme.onSurface,
                size: 24,
              ),
              title: Text('Save for Later', style: theme.textTheme.bodyLarge),
              onTap: () {
                Navigator.pop(context);
                // Save for later functionality
              },
            ),
            ListTile(
              leading: CustomIconWidget(
                iconName: 'delete_outline',
                color: theme.colorScheme.error,
                size: 24,
              ),
              title: Text(
                'Remove from Cart',
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: theme.colorScheme.error,
                ),
              ),
              onTap: () {
                Navigator.pop(context);
                onRemove();
              },
            ),
          ],
        ),
      ),
    );
  }
}
