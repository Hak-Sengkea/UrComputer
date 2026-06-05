import 'package:go_router/go_router.dart';
import 'package:mobile/features/auth/login_screen.dart';
import 'package:mobile/features/auth/register_screen.dart';
import 'package:mobile/features/cart/cart_screen.dart';
import 'package:mobile/features/home/home_screen.dart';
import 'package:mobile/features/landing/landing_screen.dart';
import 'package:mobile/features/products/builder_screen.dart';
import 'package:mobile/features/settings/setting_screen.dart';
import 'package:mobile/features/support/support_screen.dart';
import 'package:mobile/features/testing/test_load_data.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/widgets/main_shell.dart';

GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/',
    refreshListenable: authProvider,
    redirect: (context, state) {
      final location = state.matchedLocation;
      final isLoggedIn = authProvider.isLoggedIn;
      
      // Public routes (no login required)
      final isPublicRoute = location == '/' ||
          location == '/login' ||
          location == '/register';

      // If logged in and trying to access landing page, go to home
      if (isLoggedIn && location == '/') {
        return '/home';
      }
      
      // If logged in and trying to access login/register, go to home
      if (isLoggedIn && (location == '/login' || location == '/register')) {
        return '/home';
      }

      // If not logged in and trying to access protected routes, go to login
      if (!isLoggedIn && !isPublicRoute) {
        return '/login';
      }

      return null;
    },
    routes: [
      // Public routes (no bottom navigation)
      GoRoute(
        path: '/',
        name: 'landing',
        builder: (context, state) => const LandingScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      
      // Protected routes (with bottom navigation)
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/home',
            name: 'home',
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
          GoRoute(
            path: '/testing',
            name: 'testing',
            builder: (context, state) => const TestPage(),
          ),
        ],
      ),
    ],
  );
}