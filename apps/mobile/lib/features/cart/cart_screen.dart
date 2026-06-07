import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mobile/const/app_sizes.dart';
import 'package:mobile/features/cart/widgets/item_cart.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/theme/app_colors.dart';
import 'package:mobile/theme/app_text_style.dart';
import 'package:mobile/widgets/heading.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    // Fetch cart items when the page is opened, if the user is logged in
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.isLoggedIn) {
        context.read<CartProvider>().initializeCart(
          authProvider.currentUser!.id,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final cartProvider = context.watch<CartProvider>();

    // // If user is not logged in, show a sign-in prompt
    // if (!authProvider.isLoggedIn) {
    //   return Scaffold(
    //     appBar: const Heading(),
    //     body: Center(
    //       child: Padding(
    //         padding: const EdgeInsets.all(AppSizes.space24),
    //         child: Column(
    //           mainAxisAlignment: MainAxisAlignment.center,
    //           children: [
    //             const Icon(
    //               Icons.shopping_bag_outlined,
    //               size: 64,
    //               color: AppColors.outline,
    //             ),
    //             const SizedBox(height: AppSizes.space16),
    //             Text(
    //               'Please sign in to view your cart',
    //               style: AppTextStyle.titleMedium.copyWith(
    //                 color: AppColors.onSurface,
    //               ),
    //             ),
    //             const SizedBox(height: AppSizes.space24),
    //             ElevatedButton(
    //               onPressed: () {
    //                 // Navigate to auth screen
    //                 Navigator.pushNamed(context, '/login');
    //               },
    //               style: ElevatedButton.styleFrom(
    //                 backgroundColor: AppColors.brandBlue,
    //                 foregroundColor: AppColors.brandBlueDark,
    //               ),
    //               child: const Text('Sign In'),
    //             ),
    //           ],
    //         ),
    //       ),
    //     ),
    //   );
    // }

    return Scaffold(
      // Reuse the Heading component as our AppBar
      appBar: Heading(
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurface),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: cartProvider.isLoading && cartProvider.cartItems.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: AppColors.brandBlue),
            )
          : cartProvider.cartItems.isEmpty
          ? _buildEmptyState(context)
          : _buildCartContent(context, cartProvider),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSizes.space24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.remove_shopping_cart_outlined,
              size: 64,
              color: AppColors.outline,
            ),
            const SizedBox(height: AppSizes.space16),
            Text(
              'Your cart is empty',
              style: AppTextStyle.titleMedium.copyWith(
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppSizes.space8),
            Text(
              'Explore products to add items to your cart.',
              style: AppTextStyle.bodySmall.copyWith(
                color: AppColors.onSurfaceMuted,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.space24),
            ElevatedButton(
              onPressed: () {
                // Redirect back to main store
                Navigator.pushNamed(context, '/home');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandBlue,
                foregroundColor: AppColors.brandBlueDark,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
              child: const Text('Explore Products'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartContent(BuildContext context, CartProvider cartProvider) {
    final subtotal = cartProvider.totalPrice;
    final taxRate = 0.08; // 8% VAT
    final tax = subtotal * taxRate;
    final total = subtotal + tax;

    return Column(
      children: [
        // 1. Header showing item count
        Padding(
          padding: const EdgeInsets.all(AppSizes.space16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                'Shopping Cart (${cartProvider.itemCount})',
                style: AppTextStyle.headlineSmall.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // 2. Cart Items list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: AppSizes.space16),
            itemCount: cartProvider.cartItems.length,
            itemBuilder: (context, index) {
              final item = cartProvider.cartItems[index];
              return ItemCart(
                item: item,
                onIncrement: () {
                  cartProvider.updateQuantity(item.id, item.quantity + 1);
                },
                onDecrement: () {
                  cartProvider.updateQuantity(item.id, item.quantity - 1);
                },
                onRemove: () {
                  cartProvider.removeFromCart(item.id);
                },
              );
            },
          ),
        ),

        // 3. Order Summary & Checkout Card
        _buildOrderSummaryCard(context, subtotal, tax, total, cartProvider),
      ],
    );
  }

  Widget _buildOrderSummaryCard(
    BuildContext context,
    double subtotal,
    double tax,
    double total,
    CartProvider cartProvider,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSizes.space16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(
            color: AppColors.surfaceVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Summary',
              style: AppTextStyle.titleMedium.copyWith(
                color: AppColors.onSurface,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppSizes.space12),

            // Subtotal
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subtotal',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
                Text(
                  '\$${subtotal.toStringAsFixed(2)}',
                  style: AppTextStyle.titleSmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.space8),

            // Shipping
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Shipping',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
                Text(
                  'Free',
                  style: AppTextStyle.titleSmall.copyWith(
                    color: AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSizes.space8),

            // Tax
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Tax (8%)',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppColors.onSurfaceMuted,
                  ),
                ),
                Text(
                  '\$${tax.toStringAsFixed(2)}',
                  style: AppTextStyle.titleSmall.copyWith(
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            const Divider(
              color: AppColors.surfaceVariant,
              height: AppSizes.space24,
            ),

            // Total
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: AppTextStyle.titleMedium.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '\$${total.toStringAsFixed(2)}',
                      style: AppTextStyle.headlineSmall.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Inclusive of VAT',
                      style: AppTextStyle.labelSmall.copyWith(
                        color: AppColors.onSurfaceMuted,
                        fontSize: 9,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: AppSizes.space16),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  // PASSING PARAMETERS EFFICIENTLY:
                  // Instead of sending the list of cart items or prices in the router arguments,
                  // we just navigate. The CheckoutScreen listens to the same CartProvider globally!
                  Navigator.pushNamed(context, '/checkout');
                },
                icon: const Icon(Icons.shopping_bag_outlined),
                label: const Text('Checkout'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.brandBlue,
                  foregroundColor: AppColors.brandBlueDark,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppSizes.radiusMedium),
                  ),
                  textStyle: AppTextStyle.titleMedium.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(height: AppSizes.space12),

            // Security Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.gpp_good_outlined,
                  color: AppColors.success,
                  size: 16,
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    'Secure 256-bit encrypted checkout with buyer protection guarantee.',
                    style: AppTextStyle.labelSmall.copyWith(
                      color: AppColors.onSurfaceMuted,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
