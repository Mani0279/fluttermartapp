import 'package:flutter/material.dart';

import '../../../../core/app_export.dart';
import '../../../widgets/custom_icon_widget.dart';

/// Product Information Card Widget
///
/// Displays product details in Reddit-style card layout:
/// - Product name in large typography
/// - Price prominently featured
/// - Rating and review count
/// - Description in readable chunks
class ProductInfoCardWidget extends StatelessWidget {
  final Map<String, dynamic> productData;

  const ProductInfoCardWidget({Key? key, required this.productData})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: screenWidth * 0.04),
      padding: EdgeInsets.all(screenWidth * 0.04),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(screenWidth * 0.03),
        boxShadow: [
          BoxShadow(
            color: theme.shadowColor.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Name
          Text(
            productData["name"] as String,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          // Rating and Reviews
          Row(
            children: [
              CustomIconWidget(
                iconName: 'star',
                color: Colors.amber,
                size: 18,
              ),
              SizedBox(width: screenWidth * 0.01),
              Text(
                '${productData["rating"]}',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.onSurface,
                ),
              ),
              SizedBox(width: screenWidth * 0.02),
              Text(
                '(${productData["reviewCount"]} reviews)',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: screenHeight * 0.02),
          // Price
          Text(
            productData["price"] as String,
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          SizedBox(height: screenHeight * 0.02),
          // Divider
          Divider(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
            thickness: 1,
          ),
          SizedBox(height: screenHeight * 0.02),
          // Description Label
          Text(
            'Description',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: theme.colorScheme.onSurface,
            ),
          ),
          SizedBox(height: screenHeight * 0.01),
          // Description Text
          Text(
            productData["description"] as String,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}