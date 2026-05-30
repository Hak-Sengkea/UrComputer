import 'package:flutter/material.dart';
import 'package:mobile/features/auth/widgets/neon_button.dart';
import '../../../theme/app_theme.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
     return Container(
      decoration: BoxDecoration(
        gradient: AppGradients.background
      ),
      child: child,
     );
  }

}

class AppGradients {
  static Gradient? get background => null;
}
