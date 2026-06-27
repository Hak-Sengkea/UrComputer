import 'package:flutter/material.dart';
import 'package:mobile/providers/app_state_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/brand_provider.dart';
import 'package:mobile/providers/category_provider.dart';
import 'package:mobile/providers/product_provider.dart';
import 'package:mobile/providers/user_provider.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/providers/favorites_provider.dart';
import 'package:mobile/data/repository/cart_repository.dart';
import 'package:provider/provider.dart';
import 'providers/pc_builder_provider.dart';
import 'providers/theme_provider.dart'; 
import 'router/app_router.dart';
import 'theme/app_theme.dart';

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
        ChangeNotifierProvider(create: (_) => ThemeProvider()), 
      ],
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, child) {
          return Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return MaterialApp.router(
                title: 'UrComputer',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.lightTheme,
                darkTheme: AppTheme.darkTheme,
                themeMode: themeProvider.themeMode,  
                routerConfig: createRouter(authProvider),
              );
            },
          );
        },
      ),
    );
  }
}