import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/theme/app_text_style.dart';

class CategoryOverview extends StatelessWidget {
  final List<IconData> icons;
  final List<String> labels;
  final List<String>? categoryIds;

  const CategoryOverview({
    super.key,
    required this.icons,
    required this.labels,
    this.categoryIds,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = icons.length < labels.length
        ? icons.length
        : labels.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shop by category',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSizes.space4),
                  Text(
                    'Find the right parts faster',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.bodySmall.copyWith(
                      color: AppColors.onSurfaceMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppSizes.space12),
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.space12,
                vertical: AppSizes.space8,
              ),
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(AppSizes.radiusPill),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.18),
                ),
              ),
              child: Text(
                '$itemCount groups',
                style: AppTextStyle.bodySmall.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSizes.space16),
        SizedBox(
          height: 132,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: itemCount,
            separatorBuilder: (_, __) =>
                const SizedBox(width: AppSizes.space12),
            itemBuilder: (context, index) {
              final categoryId =
                  categoryIds != null && categoryIds!.length > index
                  ? categoryIds![index]
                  : null;

              return _CategoryTile(
                icon: icons[index],
                label: labels[index],
                isEnabled: categoryId != null,
                onTap: () {
                  if (categoryId == null) return;

                  context.pushNamed(
                    'category_products',
                    pathParameters: {'id': categoryId},
                    extra: labels[index],
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CategoryTile extends StatefulWidget {
  final IconData icon;
  final String label;
  final bool isEnabled;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.icon,
    required this.label,
    required this.isEnabled,
    required this.onTap,
  });

  @override
  State<_CategoryTile> createState() => _CategoryTileState();
}

class _CategoryTileState extends State<_CategoryTile> {
  bool _isPressed = false;

  void _setPressed(bool value) {
    if (_isPressed == value) return;
    setState(() => _isPressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.96 : 1,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      child: SizedBox(
        width: 132,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
            onTap: widget.isEnabled ? widget.onTap : null,
            onTapDown: widget.isEnabled ? (_) => _setPressed(true) : null,
            onTapCancel: widget.isEnabled ? () => _setPressed(false) : null,
            onTapUp: widget.isEnabled ? (_) => _setPressed(false) : null,
            child: Ink(
              padding: const EdgeInsets.all(AppSizes.space12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(AppSizes.radiusLarge),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.surfaceVariant.withValues(alpha: 0.9),
                    AppColors.brandBlueContainer.withValues(alpha: 0.44),
                  ],
                ),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(
                            AppSizes.radiusMedium,
                          ),
                        ),
                        child: Icon(
                          widget.icon,
                          color: widget.isEnabled
                              ? AppColors.primary
                              : AppColors.onSurfaceMuted,
                          size: 26,
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.onSurfaceMuted,
                        size: 14,
                      ),
                    ],
                  ),
                  Text(
                    widget.label,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyle.titleMedium.copyWith(
                      color: widget.isEnabled
                          ? AppColors.onSurface
                          : AppColors.onSurfaceMuted,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
