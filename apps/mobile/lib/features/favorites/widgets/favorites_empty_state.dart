import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/theme/theme_context.dart';

class FavoritesEmptyState extends StatelessWidget {
  const FavoritesEmptyState({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: context.sizes.edgeMarginMobile,
          vertical: context.sizes.space32,
        ),
        child: Container(
          padding: EdgeInsets.all(context.sizes.space32),
          decoration: BoxDecoration(
            color: context.customColors.cardBg.withValues(alpha: 0.4),
            borderRadius: BorderRadius.circular(context.sizes.radiusLarge),
            border: Border.all(
              color: context.colorScheme.outline.withValues(alpha: 0.1),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Stylized Dotted/Pink Heart Icon
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: context.customColors.neonPink.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Icon(
                    Icons.favorite_border_rounded,
                    color: context.customColors.neonPink,
                    size: 48,
                  ),
                ),
              ),
              SizedBox(height: context.sizes.space24),
              Text(
                'Your Wishlist is Empty',
                textAlign: TextAlign.center,
                style: context.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
              ),
              SizedBox(height: context.sizes.space12),
              Text(
                'Explore our premium collection of computers and components to build your dream PC setup!',
                textAlign: TextAlign.center,
                style: context.textTheme.bodyMedium?.copyWith(
                  color: context.colorScheme.onSurfaceVariant,
                  height: 1.5,
                ),
              ),
              SizedBox(height: context.sizes.space32),
              // Premium Gradient Button
              Container(
                decoration: BoxDecoration(
                  gradient: context.customColors.primaryGradient,
                  borderRadius: BorderRadius.circular(context.sizes.radiusPill),
                  boxShadow: [
                    BoxShadow(
                      color: context.customColors.neonCyan.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/home');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.sizes.space32,
                      vertical: context.sizes.space16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(context.sizes.radiusPill),
                    ),
                  ),
                  child: Text(
                    'Explore Products',
                    style: context.textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
