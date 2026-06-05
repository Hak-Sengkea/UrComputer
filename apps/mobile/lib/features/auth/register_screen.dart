import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'widgets/gradient_background.dart';
import 'widgets/neon_button.dart';
import 'widgets/social_button.dart';
import '../../theme/app_theme.dart';
import '../../theme/app_text_style.dart';
import '../../providers/auth_provider.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  int _currentStep = 0; // 0 for Personal Details, 1 for Security Details

  final _emailController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleNextStep() {
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();

    if (firstName.isEmpty) {
      _showSnackBar('Please enter your first name');
      return;
    }

    if (lastName.isEmpty) {
      _showSnackBar('Please enter your last name');
      return;
    }

    setState(() {
      _currentStep = 1;
    });
  }

  Future<void> _handleRegister() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;
    final firstName = _firstNameController.text.trim();
    final lastName = _lastNameController.text.trim();
    final phone = _phoneController.text.trim();
    
    // Step 2 validations
    if (email.isEmpty) {
      _showSnackBar('Please enter your email');
      return;
    }
    
    if (!email.contains('@') || !email.contains('.')) {
      _showSnackBar('Please enter a valid email address');
      return;
    }
    
    if (password.isEmpty) {
      _showSnackBar('Please enter a password');
      return;
    }
    
    if (password.length < 6) {
      _showSnackBar('Password must be at least 6 characters');
      return;
    }
    
    if (password != confirmPassword) {
      _showSnackBar('Passwords do not match');
      return;
    }
    
    if (!_acceptedTerms) {
      _showSnackBar('Please accept the Terms and Conditions');
      return;
    }
    
    // Attempt registration with metadata fields
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final success = await authProvider.register(
      email, 
      password, 
      confirmPassword,
      firstName: firstName,
      lastName: lastName,
      phone: phone,
    );
    
    if (success && mounted) {
      _showSnackBar('Registration successful!', isError: false);
      
      // Navigate to the app after successful registration.
      Future.delayed(const Duration(seconds: 1), () {
        if (mounted) {
          context.go('/home');
        }
      });
    } else if (mounted) {
      _showSnackBar(authProvider.errorMessage ?? 'Registration failed. Please try again.');
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
    final activeColor = _currentStep == 0 ? AppTheme.neonCyan : AppTheme.neonPurple;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return GradientBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () {
                  if (_currentStep == 1) {
                    setState(() => _currentStep = 0);
                  } else {
                    context.go('/');
                  }
                },
              ),
            ),
            body: SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 20),
                    _buildProgressIndicator(),
                    const SizedBox(height: 24),
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeInOut,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13161C),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: activeColor.withValues(alpha: 0.35),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: activeColor.withValues(alpha: 0.08),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.08, 0),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: _currentStep == 0
                            ? _buildPersonalStep()
                            : _buildSecurityStep(authProvider),
                      ),
                    ),
                    if (_currentStep == 0) ...[
                      const SizedBox(height: 20),
                      _buildSocialSection(),
                    ],
                    const SizedBox(height: 24),
                    _buildLoginLink(),
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
            style: AppTextStyle.headlineLarge.copyWith(
              fontWeight: FontWeight.w700,
            ),
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

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF13161C).withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.05),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          _buildStepCircle(
            step: 0,
            icon: Icons.person_outline,
            title: 'PROFILE',
            isActive: _currentStep >= 0,
            isCompleted: _currentStep > 0,
            activeColor: AppTheme.neonCyan,
          ),
          Expanded(
            child: Container(
              height: 2,
              margin: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.neonCyan.withValues(alpha: _currentStep > 0 ? 0.8 : 0.2),
                    AppTheme.neonPurple.withValues(alpha: _currentStep > 0 ? 0.8 : 0.1),
                  ],
                ),
              ),
            ),
          ),
          _buildStepCircle(
            step: 1,
            icon: Icons.lock_outline,
            title: 'SECURITY',
            isActive: _currentStep >= 1,
            isCompleted: false,
            activeColor: AppTheme.neonPurple,
          ),
        ],
      ),
    );
  }

  Widget _buildStepCircle({
    required int step,
    required IconData icon,
    required String title,
    required bool isActive,
    required bool isCompleted,
    required Color activeColor,
  }) {
    return Row(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isCompleted
                ? activeColor
                : isActive
                    ? activeColor.withValues(alpha: 0.15)
                    : const Color(0xFF1C1F26),
            shape: BoxShape.circle,
            border: Border.all(
              color: isCompleted || isActive
                  ? activeColor
                  : Colors.white.withValues(alpha: 0.1),
              width: 1.5,
            ),
            boxShadow: isCompleted || isActive
                ? [
                    BoxShadow(
                      color: activeColor.withValues(alpha: 0.35),
                      blurRadius: 8,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
          child: Icon(
            isCompleted ? Icons.check : icon,
            color: isCompleted
                ? Colors.black
                : isActive
                    ? Colors.white
                    : AppTheme.textSecondary,
            size: 14,
          ),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'STEP 0${step + 1}',
              style: TextStyle(
                fontFamily: AppTextStyle.headingFontFamily,
                fontSize: 8,
                color: isCompleted || isActive ? activeColor : AppTheme.textSecondary,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
            Text(
              title,
              style: AppTextStyle.labelSmall.copyWith(
                fontSize: 10,
                color: isCompleted || isActive ? Colors.white : AppTheme.textSecondary,
                fontWeight: isCompleted || isActive ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPersonalStep() {
    return Column(
      key: const ValueKey(0),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: _buildTextField(
                controller: _firstNameController,
                label: 'FIRST NAME',
                hint: 'First name',
                icon: Icons.person_outline,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildTextField(
                controller: _lastNameController,
                label: 'LAST NAME',
                hint: 'Last name',
                icon: Icons.person_outline,
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _phoneController,
          label: 'PHONE NUMBER (OPTIONAL)',
          hint: 'Enter your phone number...',
          icon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 20),
        NeonButton(
          text: 'NEXT STEP',
          onPressed: _handleNextStep,
        ),
      ],
    );
  }

  Widget _buildSecurityStep(AuthProvider authProvider) {
    return Column(
      key: const ValueKey(1),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTextField(
          controller: _emailController,
          label: 'EMAIL ADDRESS',
          hint: 'Enter your email...',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
        ),
        const SizedBox(height: 14),
        _buildTextField(
          controller: _passwordController,
          label: 'PASSWORD',
          hint: 'Enter password (min. 6 characters)',
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
        const SizedBox(height: 14),
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
        const SizedBox(height: 16),
        _buildTermsCheckbox(),
        const SizedBox(height: 20),
        Row(
          children: [
            Expanded(
              flex: 1,
              child: OutlinedButton(
                onPressed: () => setState(() => _currentStep = 0),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: AppTheme.neonPurple),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'BACK',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              flex: 2,
              child: NeonButton(
                text: 'REGISTER',
                onPressed: _handleRegister,
                isLoading: authProvider.isLoading,
              ),
            ),
          ],
        ),
        if (authProvider.errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
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
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          decoration: BoxDecoration(
            color: AppTheme.cardBg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.08),
              width: 1,
            ),
          ),
          child: TextField(
            controller: controller,
            obscureText: obscureText,
            keyboardType: keyboardType,
            style: const TextStyle(
              color: Colors.white,  
              fontSize: 15,
              fontWeight: FontWeight.w400,
            ),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: TextStyle(
                color: Colors.grey[500], 
                fontSize: 13,
              ),
              prefixIcon: Icon(icon, color: AppTheme.textSecondary, size: 18),
              suffixIcon: suffixIcon,
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
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
            side: const BorderSide(color: AppTheme.textSecondary),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Accept ',
                  style: AppTextStyle.bodyMedium.copyWith(
                    color: AppTheme.textSecondary,
                    fontSize: 13,
                  ),
                ),
                TextSpan(
                  text: 'Protocol Terms and Conditions',
                  style: AppTextStyle.labelMedium.copyWith(
                    color: AppTheme.neonPurple,
                    fontSize: 13,
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
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.08))),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Text(
                'OR LINK WITH',
                style: AppTextStyle.labelSmall.copyWith(
                  color: AppTheme.textSecondary,
                  letterSpacing: 1.5,
                ),
              ),
            ),
            Expanded(child: Divider(color: Colors.white.withValues(alpha: 0.08))),
          ],
        ),
        const SizedBox(height: 12),
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
          // Ignore deprecated withOpacity
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
