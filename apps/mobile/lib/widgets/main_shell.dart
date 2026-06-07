import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  int _getSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    
    // ✅ Fix: Match your actual routes
    if (location == '/' || location.isEmpty) return 0;  // Home is '/', not '/home'
    if (location == '/builder') return 1;
    if (location == '/cart') return 2;
    if (location == '/support') return 3;
    if (location == '/settings') return 4;
    
    return 0;
  }

  void _onTap(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');  // ✅ Fix: Use '/' not '/home'
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
    
    // Get theme colors
    final selectedColor = Theme.of(context).colorScheme.primary;
    final unselectedColor = Theme.of(context).iconTheme.color ?? Colors.grey;
    
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) => _onTap(context, index),
        height: 65,  // ✅ Add fixed height to prevent cutoff
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.computer_outlined),
            selectedIcon: Icon(Icons.computer),
            label: 'Builder',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.support_agent_outlined),  // ✅ Fixed: Better icon for Support
            selectedIcon: Icon(Icons.support_agent),
            label: 'Support',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
      ),
    );
  }
}