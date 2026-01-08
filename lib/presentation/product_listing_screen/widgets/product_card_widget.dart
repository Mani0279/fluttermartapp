import 'package:flutter/material.dart';

import '../../../core/app_export.dart';

/// Product Card Widget - Reddit-inspired card design with swipe gesture
///
/// Features:
/// - Elevated card with rounded corners
/// - Product image with semantic labels
/// - Product name and price display
/// - Rating and review count
/// - Swipe-right gesture for quick cart addition
/// - Tap gesture for navigation to details
/// - Visual feedback for interactions
class ProductCardWidget extends StatefulWidget {
  final Map<String, dynamic> product;
  final bool isInCart;
  final VoidCallback onTap;
  final VoidCallback onSwipeRight;

  const ProductCardWidget({
    Key? key,
    required this.product,
    required this.isInCart,
    required this.onTap,
    required this.onSwipeRight,
  }) : super(key: key);

  @override
  State<ProductCardWidget> createState() => _ProductCardWidgetState();
}

class _ProductCardWidgetState extends State<ProductCardWidget> {
  double _dragOffset = 0.0;
  bool _isDragging = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return GestureDetector(
      onTap: widget.onTap,
      onHorizontalDragStart: (_) {
        setState(() {
          _isDragging = true;
        });
      },
      onHorizontalDragUpdate: (details) {
        setState(() {
          _dragOffset += details.delta.dx;
          if (_dragOffset < 0) _dragOffset = 0;
          if (_dragOffset > screenWidth * 0.2) {
            _dragOffset = screenWidth * 0.2;
          }
        });
      },
      onHorizontalDragEnd: (details) {
        if (_dragOffset > screenWidth * 0.15) {
          widget.onSwipeRight();
        }
        setState(() {
          _dragOffset = 0.0;
          _isDragging = false;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        transform: Matrix4.translationValues(_dragOffset, 0, 0),
        child: Card(
          elevation: _isDragging ? 8.0 : 2.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildProductImage(theme, screenWidth, screenHeight),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(screenWidth * 0.03),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildProductName(theme),
                      SizedBox(height: screenHeight * 0.005),
                      _buildRatingRow(theme, screenWidth),
                      const Spacer(),
                      _buildPriceRow(theme, screenWidth),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds product image section
  Widget _buildProductImage(ThemeData theme, double screenWidth, double screenHeight) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12.0)),
          child: CustomImageWidget(
            imageUrl: widget.product["image"] as String,
            width: double.infinity,
            height: screenHeight * 0.18,
            fit: BoxFit.cover,
            semanticLabel: widget.product["semanticLabel"] as String,
          ),
        ),
        if (widget.isInCart)
          Positioned(
            top: screenHeight * 0.01,
            right: screenWidth * 0.02,
            child: Container(
              padding: EdgeInsets.all(screenWidth * 0.01),
              decoration: BoxDecoration(
                color: theme.colorScheme.tertiary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: theme.shadowColor.withValues(alpha: 0.3),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CustomIconWidget(
                iconName: 'check',
                color: theme.colorScheme.onTertiary,
                size: 16,
              ),
            ),
          ),
      ],
    );
  }

  /// Builds product name
  Widget _buildProductName(ThemeData theme) {
    return Flexible(
      child: Text(
        widget.product["name"] as String,
        style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }

  /// Builds rating and review count row
  Widget _buildRatingRow(ThemeData theme, double screenWidth) {
    final rating = widget.product["rating"] as double;
    final reviews = widget.product["reviews"] as int;

    return Row(
      children: [
        CustomIconWidget(iconName: 'star', color: Colors.amber, size: 14),
        SizedBox(width: screenWidth * 0.01),
        Text(
          rating.toString(),
          style: theme.textTheme.bodySmall?.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: screenWidth * 0.01),
        Flexible(
          child: Text(
            '($reviews)',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  /// Builds price row with add to cart indicator
  Widget _buildPriceRow(ThemeData theme, double screenWidth) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Text(
            widget.product["price"] as String,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        if (!widget.isInCart)
          Container(
            padding: EdgeInsets.all(screenWidth * 0.01),
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: CustomIconWidget(
              iconName: 'add_shopping_cart',
              color: theme.colorScheme.primary,
              size: 18,
            ),
          ),
      ],
    );
  }
}