import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';

class ProfileCard extends StatelessWidget {
  final String? userName;
  final String? userEmail;
  final VoidCallback? onEditPressed;

  const ProfileCard({
    super.key,
    this.userName,
    this.userEmail,
    this.onEditPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[900],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.neonCyan.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: AppGradients.primaryButton,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Icon(
                Icons.person,
                size: 30,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(width: 16),
          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName ?? 'User',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  userEmail ?? 'user@example.com',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                  ),
                ),
              ],
            ),
          ),
          // Edit Profile Button
          OutlinedButton(
            onPressed: onEditPressed,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: AppTheme.neonCyan),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: const Text('Edit'),
          ),
        ],
      ),
    );
  }
}

class AppGradients {
  static Gradient? get primaryButton => null;
}