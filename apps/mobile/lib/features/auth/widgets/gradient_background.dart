import 'package:flutter/material.dart';
import '../../../theme/theme_context.dart';

class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});
  
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: context.customColors.backgroundGradient,
      ),
      child: child,
    );
  }
}
