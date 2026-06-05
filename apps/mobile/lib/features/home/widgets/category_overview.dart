import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/theme/app_text_style.dart';

class CategoryOverview extends StatelessWidget {
  final List<IconData> icons;
  final List<String> labels;

  const CategoryOverview({
    super.key,
    required this.icons,
    required this.labels,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Categories',
              style: AppTextStyle.titleMedium.copyWith(
                color: AppColors.outline,
                fontWeight: FontWeight.w700,
              ),
            ),
            TextButton(
              onPressed: () {
                context.push('/');
              },
              child: Text(
                'See All',
                style: AppTextStyle.titleMedium.copyWith(
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.space12),
        SizedBox(
          height: 250,
          child: GridView.builder(
            itemCount: icons.length,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3,
              mainAxisSpacing: AppSizes.space8,
              crossAxisSpacing: AppSizes.space8,
            ),
            itemBuilder: (context, index) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 72,
                    height: 72,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceVariant,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icons[index],
                      size: 32,
                      color: AppColors.primary,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    labels[index],
                    style: AppTextStyle.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
