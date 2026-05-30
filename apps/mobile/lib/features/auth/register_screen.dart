import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/gradient_background.dart';
import 'widgets/neon_button.dart';
import 'widgets/social_button.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_style.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  Future<void> _handleRegister() async {
    if (_emailController.text.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }
    
    if (_passwordController.text.isEmpty) {
      _showSnackBar('Please enter a password');
      return;
    }
    
    if (_passwordController.text != _confirmPasswordController.text) {
      _showSnackBar('Passwords do not match');
      return;
    }
    
    if (!_acceptedTerms) {
      _showSnackBar('Please accept the Terms and Conditions');
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      // Show success message
      _showSnackBar('Registration successful!', isError: false);
      
      // Go back to login screen after a delay
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.go('/login'); // Navigate back to login
        }
      });
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyle.bodyMedium),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GradientBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              // Go back to login using go_router
              context.go('/login');
            },
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildHeader(),
                const SizedBox(height: 40),
                _buildRegisterForm(),
                const SizedBox(height: 30),
                _buildSocialSection(),
                const SizedBox(height: 20),
                _buildLoginLink(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [AppTheme.neonCyan, AppTheme.neonPurple],
          ).createShader(bounds),
          child: Text(
            'UrComputer',
            style: AppTextStyle.headlineLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'REGISTRATION',
          style: AppTextStyle.labelLarge.copyWith(
            color: AppTheme.neonPurple,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'ESTABLISH NEW LINK',
          style: AppTextStyle.labelSmall.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }

  Widget _buildRegisterForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _emailController,
          label: 'EMAIL',
          hint: 'Enter your email...',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _passwordController,
          label: 'PASSWORD',
          hint: 'Enter your password',
          icon: Icons.lock_outline,
          obscureText: _obscurePassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscurePassword ? Icons.visibility_off : Icons.visibility,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
          ),
        ),
        const SizedBox(height: 20),
        _buildTextField(
          controller: _confirmPasswordController,
          label: 'CONFIRM PASSWORD',
          hint: 'Confirm your password',
          icon: Icons.lock_outline,
          obscureText: _obscureConfirmPassword,
          suffixIcon: IconButton(
            icon: Icon(
              _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
              color: AppTheme.textSecondary,
              size: 20,
            ),
            onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
          ),
        ),
        const SizedBox(height: 20),
        _buildTermsCheckbox(),
        const SizedBox(height: 30),
        NeonButton(
          text: 'REGISTER',
          onPressed: _handleRegister,
          isLoading: _isLoading,
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool obscureText = false,
    Widget? suffixIcon,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTextStyle.labelSmall.copyWith(
            color: AppTheme.textSecondary,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              // ignore: deprecated_member_use
              color: Colors.white.withOpacity(0.1),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: AppTextStyle.bodyLarge,
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: AppTextStyle.bodyMedium.copyWith(
                // ignore: deprecated_member_use
                color: AppTheme.textSecondary?.withOpacity(0.5),
              ),
              prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 20),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: Checkbox(
            value: _acceptedTerms,
            onChanged: (value) => setState(() => _acceptedTerms = value ?? false),
            fillColor: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return AppTheme.neonPurple;
              }
              return Colors.transparent;
            }),
            side: BorderSide(color: AppTheme.textSecondary ?? Colors.transparent),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Accept ',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                  ),
                ),
                TextSpan(
                  text: 'Protocol Terms and Conditions',
                  style: AppTextStyle.labelMedium.copyWith(
                    color: AppTheme.neonPurple,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSocialSection() {
    return Column(
      children: [
        Row(
          children: [
            // ignore: deprecated_member_use
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'OR LINK WITH',
                style: AppTextStyle.labelSmall.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            // ignore: deprecated_member_use
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SocialButton(
              label: 'Facebook',
              onPressed: () => _showSnackBar('Facebook link coming soon'),
            ),
            const SizedBox(width: 12),
            SocialButton(
              label: 'Google',
              onPressed: () => _showSnackBar('Google link coming soon'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLoginLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            // Go back to login using go_router
            context.go('/login');
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            'Login Here',
            style: AppTextStyle.labelMedium.copyWith(
              color: AppTheme.neonCyan,
            ),
          ),
        ),
      ],
    );
  }
}