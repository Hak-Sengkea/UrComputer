import 'package:go_router/go_router.dart';

import '../features/home/home_screen.dart';
import '../features/products/builder_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/support/support_screen.dart';
import '../widgets/main_shell.dart';
import '../features/settings/setting_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/login',  // ✅ CHANGE THIS from '/' to '/login'
  routes: [
    GoRoute(
      path: '/login',
      name: 'login',  // Optional: add name for named navigation
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/register',
      name: 'register',  // Optional: add name for named navigation
      builder: (context, state) => const RegisterScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return MainShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/',
          name: 'home',  // Optional: add name for named navigation
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/builder',
          name: 'builder',
          builder: (context, state) => const BuilderScreen(),
        ),
        GoRoute(
          path: '/cart',
          name: 'cart',
          builder: (context, state) => const CartScreen(),
        ),
        GoRoute(
          path: '/support',
          name: 'support',
          builder: (context, state) => const SupportScreen(),
        ),
        GoRoute(
          path: '/settings',
          name: 'settings',
          builder: (context, state) => const SettingScreen(),
        ),
      ],
    ),
  ],
);