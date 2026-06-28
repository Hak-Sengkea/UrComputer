import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_context.dart';

class OrderSummaryCard extends StatelessWidget {
  final double subtotal;
  final double tax;
  final double total;

  const OrderSummaryCard({
    super.key,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: context.sizes.space12),
        Container(
          padding: EdgeInsets.all(context.sizes.space16),
          decoration: BoxDecoration(
            color: context.colorScheme.surfaceVariant.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
            border: Border.all(
              color: context.colorScheme.outline.withValues(alpha: 0.15),
            ),
          ),
          child: Column(
            children: [
              _buildSummaryRow(context, 'Subtotal', '\$${subtotal.toStringAsFixed(2)}'),
              SizedBox(height: context.sizes.space8),
              _buildSummaryRow(context, 'Shipping', 'Free', isFree: true),
              SizedBox(height: context.sizes.space8),
              _buildSummaryRow(context, 'Estimated Tax (8%)', '\$${tax.toStringAsFixed(2)}'),
              Padding(
                padding: EdgeInsets.symmetric(vertical: context.sizes.space12),
                child: const Divider(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total Amount',
                    style: context.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: context.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value, {
    bool isFree = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: context.textTheme.bodyMedium?.copyWith(
            color: context.colorScheme.onSurfaceVariant,
          ),
        ),
        Text(
          value,
          style: context.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isFree ? context.customColors.success : context.colorScheme.onSurface,
          ),
        ),
      ],
    );
  }
}
