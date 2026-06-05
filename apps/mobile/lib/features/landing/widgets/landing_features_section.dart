import 'package:flutter/material.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/theme/app_colors.dart';

class LandingFeaturesSection extends StatelessWidget {
  const LandingFeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Why Choose Us',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.outline,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSizes.space12),
        SizedBox(
          height: 110,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: const [
              LandingFeatureCard(
                icon: Icons.local_shipping,
                title: 'Fast Delivery',
                subtitle: '1-3 days',
              ),
              SizedBox(width: AppSizes.space12),
              LandingFeatureCard(
                icon: Icons.verified,
                title: 'Authentic',
                subtitle: '100% genuine',
              ),
              SizedBox(width: AppSizes.space12),
              LandingFeatureCard(
                icon: Icons.support_agent,
                title: '24/7 Support',
                subtitle: 'Always on',
              ),
              SizedBox(width: AppSizes.space12),
              LandingFeatureCard(
                icon: Icons.discount,
                title: 'Best Prices',
                subtitle: 'Top deals',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LandingFeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const LandingFeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: 160,
      padding: const EdgeInsets.all(AppSizes.space12),
      decoration: BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
        border: Border.all(color: AppColors.outline.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(height: AppSizes.space8),
          Text(
            title,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.onSurface.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
