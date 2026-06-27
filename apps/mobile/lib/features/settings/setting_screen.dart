import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile/features/settings/widgets/settings_title.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/theme_provider.dart';
import '../../theme/app_theme.dart';
import 'widgets/profile_card.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  bool _notificationsEnabled = true;
  String _selectedLanguage = 'English';
  String _selectedCurrency = 'USD';

  void _safePop() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        if (Navigator.canPop(context)) {
          Navigator.pop(context);
        } else {
          context.go('/home');
        }
      }
    });
  }

  void _safePush(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.push(route);
      }
    });
  }

  void _safeGo(String route) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.go(route);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final user = authProvider.currentUser;
    
    
    final isDark = themeProvider.isDarkMode;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey[100],
      appBar: AppBar(
        title: const Text(
          'Settings',
          style: TextStyle(
            fontFamily: 'SpaceMono',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: isDark ? Colors.black : Colors.grey[100],
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: isDark ? Colors.white : Colors.black),
          onPressed: _safePop,
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Profile Card
            ProfileCard(
              userName: user?.fullName,
              userEmail: user?.email,
              onEditPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Edit profile coming soon')),
                );
              },
            ),
            const SizedBox(height: 24),

            // Preferences Section
            SettingsSection(
              title: 'PREFERENCES',
              icon: Icons.settings,
              children: [
                SettingsTile(
                  title: 'Push Notifications',
                  subtitle: 'Receive updates about your builds',
                  isSwitch: true,
                  switchValue: _notificationsEnabled,
                  onSwitchChanged: (value) {
                    setState(() => _notificationsEnabled = value);
                  },
                ),
                SettingsTile(
                  title: 'Dark Mode',
                  subtitle: 'Use dark theme throughout the app',
                  isSwitch: true,
                  switchValue: themeProvider.isDarkMode,  
                  onSwitchChanged: (value) {
                    themeProvider.toggleTheme();  
                  },
                ),
                SettingsTile(
                  title: 'Language',
                  subtitle: _selectedLanguage,
                  leadingIcon: Icons.language,
                  onTap: () => _showLanguageDialog(),
                ),
                SettingsTile(
                  title: 'Currency',
                  subtitle: _selectedCurrency,
                  leadingIcon: Icons.attach_money,
                  onTap: () => _showCurrencyDialog(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Account Section
            SettingsSection(
              title: 'ACCOUNT',
              icon: Icons.account_circle,
              children: [
                SettingsTile(
                  title: 'My Builds',
                  subtitle: 'View all your saved PC builds',
                  leadingIcon: Icons.computer,
                  onTap: () => _safePush('/my-builds'),
                ),
                SettingsTile(
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  leadingIcon: Icons.lock_outline,
                  onTap: () => _showChangePasswordDialog(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // About Section
            SettingsSection(
              title: 'ABOUT',
              icon: Icons.info,
              children: [
                SettingsTile(
                  title: 'Version',
                  subtitle: '1.0.0',
                  leadingIcon: Icons.code,
                  onTap: () => _showVersionDialog(),
                ),
                SettingsTile(
                  title: 'Terms of Service',
                  leadingIcon: Icons.description,
                  onTap: () => _showTermsDialog(),
                ),
                SettingsTile(
                  title: 'Privacy Policy',
                  leadingIcon: Icons.privacy_tip,
                  onTap: () => _showPrivacyDialog(),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Danger Zone Section
            SettingsSection(
              title: 'DANGER ZONE',
              icon: Icons.warning,
              iconColor: Colors.red,
              children: [
                SettingsTile(
                  title: 'Logout',
                  subtitle: 'Sign out of your account',
                  leadingIcon: Icons.logout,
                  iconColor: Colors.red,
                  titleColor: Colors.red,
                  trailing: Icon(Icons.logout, color: Colors.red, size: 20),
                  onTap: () => _showLogoutDialog(authProvider),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              trailing: _selectedLanguage == 'English'
                  ? Icon(Icons.check, color: AppTheme.neonCyan)
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = 'English');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Khmer'),
              trailing: _selectedLanguage == 'Khmer'
                  ? Icon(Icons.check, color: AppTheme.neonCyan)
                  : null,
              onTap: () {
                setState(() => _selectedLanguage = 'Khmer');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        backgroundColor: Colors.grey[900],
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('USD (\$)'),
              trailing: _selectedCurrency == 'USD'
                  ? Icon(Icons.check, color: AppTheme.neonCyan)
                  : null,
              onTap: () {
                setState(() => _selectedCurrency = 'USD');
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('RIEL (៛)'),
              trailing: _selectedCurrency == 'RIEL'
                  ? Icon(Icons.check, color: AppTheme.neonCyan)
                  : null,
              onTap: () {
                setState(() => _selectedCurrency = 'RIEL');
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showChangePasswordDialog() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Change password coming soon')),
    );
  }

  void _showVersionDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Version'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('UrComputer App'),
            SizedBox(height: 8),
            Text('Version 1.0.0'),
            SizedBox(height: 8),
            Text('Built with Flutter & Supabase'),
          ],
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms of Service'),
        content: const SingleChildScrollView(
          child: Text(
            'Terms of Service content here...\n\n'
            '1. Use of the Service\n'
            '2. User Accounts\n'
            '3. Privacy\n'
            '4. Termination\n\n'
            'By using this app, you agree to these terms.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy Policy'),
        content: const SingleChildScrollView(
          child: Text(
            'Privacy Policy content here...\n\n'
            'We collect information to provide better services.\n'
            'Your data is stored securely in Supabase.\n'
            'We do not share your personal information.',
            style: TextStyle(fontSize: 14),
          ),
        ),
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        backgroundColor: Colors.grey[900],
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              await authProvider.logout();
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted) {
                  context.go('/login');
                }
              });
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}