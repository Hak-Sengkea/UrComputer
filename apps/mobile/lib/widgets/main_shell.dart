import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    // Match the actual routes used by `_onTap`.
    if (location == '/home' || location.isEmpty) return 0;
    if (location.startsWith('/builder')) return 1;
    if (location.startsWith('/cart')) return 2;
    if (location.startsWith('/support')) return 3;
    if (location.startsWith('/settings')) return 4;

    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/home');
        break;
      case 1:
        context.go('/builder');
        break;
      case 2:
        context.go('/cart');
        break;
      case 3:
        context.go('/support');
        break;
      case 4:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(context);

    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).iconTheme.color ?? Colors.grey;

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined, color: unselectedColor),
            selectedIcon: Icon(Icons.home, color: selectedColor),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.computer_outlined, color: unselectedColor),
            selectedIcon: Icon(Icons.computer, color: selectedColor),
            label: 'Builder',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined, color: unselectedColor),
            selectedIcon: Icon(Icons.shopping_cart, color: selectedColor),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.build_outlined, color: unselectedColor),
            selectedIcon: Icon(Icons.build, color: selectedColor),
            label: 'Support',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined, color: unselectedColor),
            selectedIcon: Icon(Icons.settings, color: selectedColor),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}