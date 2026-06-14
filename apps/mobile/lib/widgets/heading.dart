import 'package:flutter/material.dart';
import 'package:mobile/theme/app_colors.dart';

class Heading extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget>? actions;
  final VoidCallback? onMenuPressed;

  const Heading({super.key, this.actions, this.onMenuPressed});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: theme.colorScheme.surface,
      foregroundColor: theme.colorScheme.onSurface,
      elevation: 0,
      leading: IconButton(
        icon: const Icon(Icons.menu),
        onPressed:
            onMenuPressed ??
            () {
              Scaffold.of(context).openDrawer();
            },
      ),
      title: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          'UrComputer',
          style: theme.textTheme.titleLarge?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      centerTitle: false,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
