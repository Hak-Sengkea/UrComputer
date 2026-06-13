import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class SettingsSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final Color? iconColor;

  const SettingsSection({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: iconColor ?? AppTheme.neonCyan,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: iconColor ?? AppTheme.neonCyan,
                ),
              ),
            ],
          ),
          const Divider(color: Colors.grey, height: 24),
          ...children,
        ],
      ),
    );
  }
}