import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/gradient_background.dart';
import 'widgets/neon_button.dart';
import 'widgets/social_button.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_style.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _obscurePassword = true;

  Future<void> _handleLogin() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Please fill in all fields');
      return;
    }
    
    setState(() => _isLoading = true);
    
    // Simulate API call
    await Future.delayed(const Duration(seconds: 2));
    
    setState(() => _isLoading = false);
    
    if (mounted) {
      context.go('/');  
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
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                _buildHeader(),
                const SizedBox(height: 60),
                _buildLoginForm(),
                const SizedBox(height: 30),
                _buildSocialSection(),
                const SizedBox(height: 20),
                _buildFooter(),
                const SizedBox(height: 20),
                _buildBottomNav(),
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
            style: AppTextStyle.displayLarge.copyWith(
              fontSize: 40,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Welcome back!',
          style: AppTextStyle.titleMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Please login to continue',
          style: AppTextStyle.bodyMedium.copyWith(
            // ignore: deprecated_member_use
            color: AppTheme.textSecondary?.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'LOGIN',
          style: AppTextStyle.headlineSmall.copyWith(
            color: AppTheme.neonCyan,
            fontFamily: AppTextStyle.headingFontFamily,
          ),
        ),
        const SizedBox(height: 20),
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
          hint: '**********',
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
        const SizedBox(height: 30),
        NeonButton(
          text: 'LOGIN',
          onPressed: _handleLogin,
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
                'OR VIA BY',
                style: AppTextStyle.labelSmall.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withOpacity(0.1))),
          ],
        ),
        const SizedBox(height: 20),
        Row(
          children: [
            SocialButton(
              label: 'Facebook',
              onPressed: () => _showSnackBar('Facebook login coming soon'),
            ),
            const SizedBox(width: 12),
            SocialButton(
              label: 'Google',
              onPressed: () => _showSnackBar('Google login coming soon'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Unregistered entity? ',
          style: AppTextStyle.bodyMedium.copyWith(
            color: AppTheme.textSecondary,
          ),
        ),
        TextButton(
          onPressed: () {
            // Navigate to register using go_router
            context.push('/register');
          },
          style: TextButton.styleFrom(padding: EdgeInsets.zero),
          child: Text(
            'Register Now',
            style: AppTextStyle.labelMedium.copyWith(
              color: AppTheme.neonCyan,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildBottomLink('Secure'),
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
        _buildBottomLink('Support'),
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: AppTheme.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
        _buildBottomLink('Terms'),
      ],
    );
  }

  Widget _buildBottomLink(String text) {
    return GestureDetector(
      onTap: () {
        if (text == 'Support') {
          context.push('/support');
        } else {
          _showSnackBar('$text page coming soon');
        }
      },
      child: Text(
        text,
        style: AppTextStyle.labelSmall.copyWith(
          // ignore: deprecated_member_use
          color: AppTheme.textSecondary?.withOpacity(0.7),
        ),
      ),
    );
  }
}