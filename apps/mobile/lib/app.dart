import 'package:flutter/material.dart';
import 'package:mobile/providers/app_state_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/brand_provider.dart';
import 'package:mobile/providers/category_provider.dart';
import 'package:mobile/providers/compare_provider.dart';
import 'package:mobile/providers/product_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/providers/favorites_provider.dart';
import 'package:mobile/providers/order_provider.dart';
import 'package:mobile/providers/support_provider.dart';
import 'package:mobile/data/repository/cart_repository.dart';
import 'package:provider/provider.dart';
import 'package:mobile/providers/pc_builder_provider.dart';
import 'package:mobile/router/app_router.dart';
import 'package:mobile/theme/app_theme.dart';

class UrComputerApp extends StatelessWidget {
  const UrComputerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AppStateProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()..loadAllUsers()),
        ChangeNotifierProvider(
          create: (_) => ProductProvider()..loadAllProducts(),
        ),
        ChangeNotifierProvider(
          create: (_) => CategoryProvider()..loadAllCategories(),
        ),
        ChangeNotifierProvider(create: (_) => BrandProvider()..loadAllBrands()),
        ChangeNotifierProvider(
          create: (_) => CartProvider(cartRepository: CartRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..loadFavorites(),
        ),
        ChangeNotifierProvider(create: (_) => PCBuilderProvider()),
        ChangeNotifierProvider(create: (_) => CompareProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => SupportProvider()),
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return MaterialApp.router(
            title: 'UrComputer',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: ThemeMode.dark,
            routerConfig: createRouter(authProvider),
          );
        },
      ),
    );
  }
}