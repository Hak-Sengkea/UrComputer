import 'package:flutter/material.dart';
import 'package:mobile/theme/theme_context.dart';

class ShippingAddressForm extends StatelessWidget {
  final TextEditingController addressController;
  final TextEditingController cityController;
  final TextEditingController stateController;
  final TextEditingController zipController;

  const ShippingAddressForm({
    super.key,
    required this.addressController,
    required this.cityController,
    required this.stateController,
    required this.zipController,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: context.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: context.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: context.sizes.space12),
        _buildTextField(
          context: context,
          controller: addressController,
          label: 'Street Address',
          icon: Icons.home_outlined,
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Please enter your street address' : null,
        ),
        SizedBox(height: context.sizes.space12),
        _buildTextField(
          context: context,
          controller: cityController,
          label: 'City',
          icon: Icons.location_city_outlined,
          validator: (value) =>
              value == null || value.trim().isEmpty ? 'Please enter your city' : null,
        ),
        SizedBox(height: context.sizes.space12),
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                context: context,
                controller: stateController,
                label: 'State / Province (Opt)',
                icon: Icons.map_outlined,
              ),
            ),
            SizedBox(width: context.sizes.space12),
            Expanded(
              child: _buildTextField(
                context: context,
                controller: zipController,
                label: 'ZIP / Postal Code (Opt)',
                icon: Icons.pin_drop_outlined,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTextField({
    required BuildContext context,
    required TextEditingController controller,
    required String label,
    required IconData icon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      validator: validator,
      style: context.textTheme.bodyMedium?.copyWith(color: context.colorScheme.onSurface),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: context.colorScheme.onSurfaceVariant),
        prefixIcon: Icon(icon, color: context.colorScheme.outline),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
          borderSide: BorderSide(color: context.colorScheme.outline),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
          borderSide: BorderSide(color: context.colorScheme.outline.withValues(alpha: 0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(context.sizes.radiusMedium),
          borderSide: BorderSide(color: context.colorScheme.primary, width: 2),
        ),
        filled: true,
        fillColor: context.colorScheme.surfaceVariant.withValues(alpha: 0.1),
      ),
    );
  }
}
