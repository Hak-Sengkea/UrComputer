import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'widgets/gradient_background.dart';
import 'widgets/neon_button.dart';
import 'widgets/social_button.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_style.dart';
import '../../providers/auth_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    if (email.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }
    
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar('Please enter a valid email address');
      return;
    }
    
    if (password.isEmpty) {
      _showSnackBar('Please enter your password');
      return;
    }
    
    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }
    
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.login(email, password);
    
    if (success && mounted) {
      context.go('/');
    } else if (mounted) {
      _showSnackBar(authProvider.errorMessage ?? 'Login failed. Please try again.');
    }
  }

  void _showSnackBar(String message, {bool isError = true}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: AppTextStyle.bodyMedium),
        backgroundColor: isError ? Colors.red : Colors.green,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
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
                    _buildLoginForm(authProvider),
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
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ShaderMask(
          shaderCallback: (bounds) => const LinearGradient(
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
            color: AppTheme.textSecondary.withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginForm(AuthProvider authProvider) {
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
        const SizedBox(height: 30),
        NeonButton(
          text: 'LOGIN',
          onPressed: _handleLogin,
          isLoading: authProvider.isLoading,
        ),
        if (authProvider.errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              // ignore: deprecated_member_use
              color: Colors.red.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              // ignore: deprecated_member_use
              border: Border.all(color: Colors.red.withOpacity(0.3)),
            ),
            child: Row(
              children: [
                const Icon(Icons.error_outline, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    authProvider.errorMessage!,
                    style: AppTextStyle.bodySmall.copyWith(color: Colors.red),
                  ),
                ),
              ],
            ),
          ),
        ],
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
            style: const TextStyle(
              color: Colors.white, 
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[500],  
                fontSize: 14,
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
                'OR SYNC VIA',
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
          decoration: const BoxDecoration(
            color: AppTheme.textSecondary,
            shape: BoxShape.circle,
          ),
        ),
        _buildBottomLink('Support'),
        Container(
          width: 4,
          height: 4,
          margin: const EdgeInsets.symmetric(horizontal: 12),
          decoration: const BoxDecoration(
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
          color: AppTheme.textSecondary.withOpacity(0.7),
        ),
      ),
    );
  }
}