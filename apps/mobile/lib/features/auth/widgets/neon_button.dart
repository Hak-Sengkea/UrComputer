// lib/features/auth/widgets/neon_button.dart
import 'package:flutter/material.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/app_text_style.dart';

class NeonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  
  const NeonButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    // Fix: Use Theme.of(context) as fallback
    final neonCyan = AppTheme.neonCyan ?? Colors.cyan;
    final neonPurple = AppTheme.neonPurple ?? Colors.purple;
    
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [neonCyan, neonPurple],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: neonCyan.withOpacity(0.3), // Now this won't be null
            blurRadius: 15,
            spreadRadius: 0,
          ),
        ],
      ),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Text(
                text,
                style: AppTextStyle.labelLarge.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                ),
              ),
      ),
    );
  }
}