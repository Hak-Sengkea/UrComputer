import 'package:go_router/go_router.dart';
import '../features/home/home_screen.dart';
import '../features/products/builder_screen.dart';
import '../features/cart/cart_screen.dart';
import '../features/support/support_screen.dart';
import '../widgets/main_shell.dart';
import '../features/settings/setting_screen.dart';
import '../features/auth/login_screen.dart';
import '../features/auth/register_screen.dart';
import '../features/testing/test_load_data.dart';
import '../providers/auth_provider.dart';

// Change from final appRouter to a function
GoRouter createRouter(AuthProvider authProvider) {
  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      // Use the authProvider passed in
      final isLoggedIn = authProvider.isLoggedIn;
      final isAuthRoute = state.matchedLocation == '/login' || 
                          state.matchedLocation == '/register';
      
      if (isLoggedIn && isAuthRoute) {
        return '/';
      }
      
      if (!isLoggedIn && !isAuthRoute) {
        return '/login';
      }
      
      return null;
    },
    routes: [
      // Auth routes
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
      
      // Protected routes
      ShellRoute(
        builder: (context, state, child) {
          return MainShell(child: child);
        },
        routes: [
          GoRoute(
            path: '/',
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