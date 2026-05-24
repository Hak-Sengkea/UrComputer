import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/products/builder_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/support/support_screen.dart';
import '../widgets/main_shell.dart';
import '../features/settings/setting_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/builder',
          builder: (context, state) => const BuilderScreen(),
        ),
        GoRoute(
          path: '/cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/support',
          builder: (context, state) => const SupportScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingScreen(),
        ),
      ],
    ),
  ],
);