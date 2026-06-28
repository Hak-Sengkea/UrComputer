import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'package:mobile/theme/theme_context.dart';
import 'package:mobile/providers/cart_provider.dart';
import 'package:mobile/providers/auth_provider.dart';
import 'package:mobile/providers/order_provider.dart';
import 'package:mobile/models/order.dart';

import 'widgets/shipping_address_form.dart';
import 'widgets/payment_method_selector.dart';
import 'widgets/order_summary_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedPaymentMethod = 'abapay_khqr'; // 'abapay_khqr', 'cards', 'cod'
  bool _isProcessing = false;
  
  // Cache the active order created in this checkout session to prevent duplicates on retries
  Order? _activeOrder;

  // Form Controllers
  final _addressController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _addressController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _zipController.dispose();
    super.dispose();
  }

  void _handlePlaceOrder() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isProcessing = true);

    try {
      final cartProvider = context.read<CartProvider>();
      final authProvider = context.read<AuthProvider>();
      final orderProvider = context.read<OrderProvider>();

      final double totalAmount = cartProvider.totalPrice * 1.08; // Total + 8% VAT

      // 1. Retrieve cached order or create a new one if it doesn't exist
      Order? order = _activeOrder;
      
      if (order == null) {
        order = await orderProvider.checkout(
          userId: authProvider.currentUser!.id,
          cartId: cartProvider.cartId!,
          cartItems: cartProvider.cartItems,
          totalAmount: totalAmount,
          address: _addressController.text.trim(),
          city: _cityController.text.trim(),
          state: _stateController.text.trim().isEmpty ? null : _stateController.text.trim(),
          zip: _zipController.text.trim().isEmpty ? null : _zipController.text.trim(),
          paymentMethod: _selectedPaymentMethod,
        );
        _activeOrder = order;
      }

      if (order == null) {
        throw Exception(orderProvider.errorMessage ?? 'Failed to create order record.');
      }

      // 2. Direct user flow based on selected payment method
      if (_selectedPaymentMethod == 'cod') {
        // Cash on Delivery is completed immediately without gateway redirection
        if (mounted) {
          _finalizePayment(context);
        }
      } else {
        // 3. For online payments, invoke the remote Supabase Edge Function
        final response = await Supabase.instance.client.functions.invoke(
          'orderCheckout', // Remote function name
          body: {
            'orderId': order.id,
            'amount': totalAmount,
            'email': authProvider.currentUser?.email ?? 'guest@urcomputer.com',
            'paymentOption': _selectedPaymentMethod, // 'abapay_khqr' or 'cards'
          },
        );

        if (response.status != 200 || response.data == null) {
          throw Exception('Failed to contact remote payment gateway.');
        }

        final data = response.data as Map<String, dynamic>;

        // Print response payload to debug console
        debugPrint('PayWay Response Payload: $data');

        if (_selectedPaymentMethod == 'abapay_khqr') {
          // Handle ABA KHQR
          final status = data['status'];
          if (status != null && status is Map) {
            final code = status['code']?.toString();
            final message = status['message']?.toString();
            if (code != '0' && code != '00') {
              throw Exception('Gateway Error: $message (Code: $code)');
            }
          }

          final qrString = data['qrString'];
          final deeplink = data['abapay_deeplink'];

          if (qrString != null && mounted) {
            _showKHQRDialog(qrString, deeplink);
          } else {
            throw Exception('No QR code returned. Details: $data');
          }
        } else if (_selectedPaymentMethod == 'cards') {
          // Handle Card payment
          final status = data['status'];
          if (status != null && status is Map) {
            final code = status['code']?.toString();
            final message = status['message']?.toString();
            if (code != '0' && code != '00') {
              throw Exception('Gateway Error: $message (Code: $code)');
            }
          }

          final checkoutUrl = data['checkoutUrl'];
          final params = data['params'] as Map<String, dynamic>?;

          if (checkoutUrl != null && params != null && mounted) {
            _openCardCheckoutWebView(checkoutUrl, params);
          } else {
            throw Exception('Invalid card transaction response. Details: $data');
          }
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: context.colorScheme.error,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  // Displays the ABA KHQR Code dialog and "Pay via ABA App" button
  void _showKHQRDialog(String qrString, String? deeplink) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return Container(
          decoration: BoxDecoration(
            color: context.colorScheme.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(context.sizes.radiusLarge)),
          ),
          padding: EdgeInsets.all(context.sizes.space24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: context.colorScheme.outline.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              SizedBox(height: context.sizes.space16),
              Text(
                'ABA PAYWAY KHQR',
                style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: context.sizes.space24),
              
              // Generate and show QR Code
              Container(
                padding: EdgeInsets.all(context.sizes.space16),
                decoration: BoxDecoration(
                  color: Colors.white, // QR needs a light background to scan reliably
                  borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
                ),
                child: QrImageView(
                  data: qrString,
                  version: QrVersions.auto,
                  size: 200.0,
                ),
              ),
              SizedBox(height: context.sizes.space16),
              Text(
                'Scan this KHQR with your banking app to authorize payment.',
                style: context.textTheme.bodySmall?.copyWith(color: context.colorScheme.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: context.sizes.space24),

              // Button to launch ABA app on the phone directly
              if (deeplink != null)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[900], // ABA Brand Red
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
                      ),
                    ),
                    onPressed: () async {
                      final Uri url = Uri.parse(deeplink);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url, mode: LaunchMode.externalApplication);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Could not open ABA Mobile app.')),
                        );
                      }
                    },
                    icon: const Icon(Icons.account_balance_wallet_outlined),
                    label: const Text('Pay with ABA Mobile App'),
                  ),
                ),
              SizedBox(height: context.sizes.space12),
              
              TextButton(
                onPressed: () {
                  Navigator.of(sheetContext).pop();
                  _finalizePayment(context);
                },
                child: const Text('I Have Completed Payment'),
              ),
            ],
          ),
        );
      },
    );
  }

  // Opens Credit Card Hosted checkout page in a WebView POST request
  void _openCardCheckoutWebView(String checkoutUrl, Map<String, dynamic> params) {
    // Generates a self-submitting HTML form to execute a POST request inside the WebView
    final htmlForm = '''
      <html>
        <body onload="document.forms['payway_form'].submit()">
          <form id="payway_form" method="post" action="$checkoutUrl">
            ${params.entries.map((e) => '<input type="hidden" name="${e.key}" value="${e.value}"/>').join('\n')}
          </form>
        </body>
      </html>
    ''';

    final controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (url) {
            // Listen for ABA's redirection to success or cancel URLs
            if (url.contains('success') || url.contains('status=0')) {
              Navigator.pop(context); // Close WebView
              _finalizePayment(context);
            } else if (url.contains('cancel') || url.contains('fail')) {
              Navigator.pop(context); // Close WebView
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Payment was cancelled or failed.')),
              );
            }
          },
        ),
      )
      ..loadHtmlString(htmlForm);

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('Secure Card Payment'),
            backgroundColor: context.colorScheme.primary,
            foregroundColor: context.colorScheme.onPrimary,
          ),
          body: WebViewWidget(controller: controller),
        ),
      ),
    );
  }

  void _finalizePayment(BuildContext context) async {
    setState(() => _isProcessing = true);
    try {
      final cartProvider = context.read<CartProvider>();
      await cartProvider.clearCart(); // Delete cart from DB and clear local items list
      if (mounted) {
        _showSuccessDialog();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to clear cart: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          backgroundColor: context.colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(context.sizes.radiusLarge),
          ),
          title: Column(
            children: [
              Icon(
                Icons.check_circle_outline_rounded,
                color: context.customColors.success,
                size: 64,
              ),
              SizedBox(height: context.sizes.space16),
              Text(
                'Order Placed!',
                style: context.textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.colorScheme.onSurface,
                ),
              ),
            ],
          ),
          content: Text(
            'Your order has been placed successfully. Thank you for shopping with UrComputer!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.colorScheme.onSurfaceVariant,
            ),
          ),
          actionsAlignment: MainAxisAlignment.center,
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: context.colorScheme.primary,
                foregroundColor: context.colorScheme.onPrimary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: context.sizes.space24,
                  vertical: context.sizes.space12,
                ),
              ),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Dismiss Dialog
                Navigator.of(context).pop(); // Back to Cart Screen
                // Redirect back to Home route
                Navigator.of(context).pushReplacementNamed('/home');
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final cartProvider = context.watch<CartProvider>();
    final double subtotal = cartProvider.totalPrice;
    final double tax = subtotal * 0.08;
    final double total = subtotal + tax;

    return Scaffold(
      backgroundColor: context.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Checkout',
          style: context.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: context.colorScheme.onSurface,
      ),
      body: _isProcessing
          ? Center(
              child: CircularProgressIndicator(
                color: context.colorScheme.primary,
              ),
            )
          : SingleChildScrollView(
              padding: EdgeInsets.all(context.sizes.space16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1. Shipping Details Form Widget
                    ShippingAddressForm(
                      addressController: _addressController,
                      cityController: _cityController,
                      stateController: _stateController,
                      zipController: _zipController,
                    ),

                    SizedBox(height: context.sizes.space24),
                    const Divider(),
                    SizedBox(height: context.sizes.space16),

                    // 2. Payment Selector Widget
                    PaymentMethodSelector(
                      selectedMethod: _selectedPaymentMethod,
                      onChanged: (method) {
                        setState(() => _selectedPaymentMethod = method);
                      },
                    ),

                    SizedBox(height: context.sizes.space24),
                    const Divider(),
                    SizedBox(height: context.sizes.space16),

                    // 3. Order Summary Card Widget
                    OrderSummaryCard(
                      subtotal: subtotal,
                      tax: tax,
                      total: total,
                    ),

                    SizedBox(height: context.sizes.space32),

                    // 4. Pay Button
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: context.colorScheme.primary,
                          foregroundColor: context.colorScheme.onPrimary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
                          ),
                          elevation: 2,
                        ),
                        onPressed: _handlePlaceOrder,
                        child: Text(
                          _selectedPaymentMethod == 'cod'
                              ? 'Confirm Order (COD)'
                              : _selectedPaymentMethod == 'abapay_khqr'
                                  ? 'Pay with ABA KHQR'
                                  : 'Proceed to Card Payment',
                          style: context.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: context.sizes.space24),
                  ],
                ),
              ),
            ),
    );
  }
}
