import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/theme/app_text_style.dart';

class QuantityButton extends StatelessWidget {
  final int quantity;
  final VoidCallback? onIncrement;
  final VoidCallback? onDecrement;
  const QuantityButton({
    super.key,
    required this.quantity,
    this.onIncrement,
    this.onDecrement,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSizes.space8),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(AppSizes.radiusSmall),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onDecrement,
            icon: const Icon(Icons.remove),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          Text(quantity.toString(), style: AppTextStyle.titleSmall),
          IconButton(
            onPressed: onIncrement,
            icon: const Icon(Icons.add),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
