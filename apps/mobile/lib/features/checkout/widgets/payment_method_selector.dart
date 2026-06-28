import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_context.dart';

class PaymentMethodSelector extends StatelessWidget {
  final String selectedMethod;
  final ValueChanged<String> onChanged;

  const PaymentMethodSelector({
    super.key,
    required this.selectedMethod,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Select Payment Method',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: context.sizes.space16),
        _buildPaymentCard(
          context: context,
          id: 'abapay_khqr',
          title: 'ABA PAY / KHQR',
          subtitle: 'Scan and pay instantly using ABA Mobile App',
          icon: Icons.qr_code_scanner_rounded,
        ),
        SizedBox(height: context.sizes.space12),
        _buildPaymentCard(
          context: context,
          id: 'cards',
          title: 'Credit / Debit Card',
          subtitle: 'Supports Visa, MasterCard, and UnionPay',
          icon: Icons.credit_card_rounded,
        ),
        SizedBox(height: context.sizes.space12),
        _buildPaymentCard(
          context: context,
          id: 'cod',
          title: 'Cash on Delivery (COD)',
          subtitle: 'Pay with cash upon delivery of items',
          icon: Icons.delivery_dining_rounded,
        ),
      ],
    );
  }

  Widget _buildPaymentCard({
    required BuildContext context,
    required String id,
    required String title,
    required String subtitle,
    required IconData icon,
  }) {
    final bool isSelected = selectedMethod == id;

    return GestureDetector(
      onTap: () => onChanged(id),
      child: Container(
        padding: EdgeInsets.all(context.sizes.space16),
        decoration: BoxDecoration(
          color: isSelected
              ? context.colorScheme.primary.withValues(alpha: 0.08)
              : context.colorScheme.surfaceVariant.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
          border: Border.all(
            color: isSelected
                ? context.colorScheme.primary
                : context.colorScheme.outline.withValues(alpha: 0.2),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? context.colorScheme.primary : context.colorScheme.outline,
              size: 28,
            ),
            SizedBox(width: context.sizes.space16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? context.colorScheme.primary : context.colorScheme.onSurface,
                    ),
                  ),
                  SizedBox(height: context.sizes.space4),
                  Text(
                    subtitle,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Radio<String>(
              value: id,
              groupValue: selectedMethod,
              activeColor: context.colorScheme.primary,
              onChanged: (value) {
                if (value != null) {
                  onChanged(value);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
