import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/theme/app_theme.dart';
import '../../config/localization/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';
import '../../utils/validators.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/error_message.dart';
import '../../widgets/language_selector.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleLogin(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        // Navigation will be handled by the main.dart based on isAuthenticated
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Login successful!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language Selector - Top Right
                Align(
                  alignment: Alignment.topRight,
                  child: LanguageSelector(isCompact: true),
                ),
                const SizedBox(height: 32),

                // Header
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      localizations.appName,
                      style: Theme.of(context).textTheme.displayMedium?.copyWith(
                        color: AppTheme.primaryColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.tagline,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 48),

                // Form
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Email Field
                      CustomTextField(
                        label: localizations.emailLabel,
                        hint: localizations.emailHint,
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        validator: Validators.validateEmail,
                        prefixIcon: const Icon(Icons.email_outlined),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 20),

                      // Password Field
                      CustomTextField(
                        label: localizations.passwordLabel,
                        hint: localizations.passwordHint,
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        validator: Validators.validatePassword,
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                          child: Icon(
                            _obscurePassword
                                ? Icons.visibility_off_outlined
                                : Icons.visibility_outlined,
                          ),
                        ),
                        textInputAction: TextInputAction.done,
                      ),
                      const SizedBox(height: 28),

                      // Error Message
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          if (authProvider.errorMessage != null) {
                            return Column(
                              children: [
                                ErrorMessage(
                                  message: authProvider.errorMessage!,
                                  onDismiss: () {
                                    authProvider.clearError();
                                  },
                                ),
                                const SizedBox(height: 20),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      // Login Button
                      Consumer<AuthProvider>(
                        builder: (context, authProvider, _) {
                          return CustomButton(
                            label: localizations.loginButton,
                            onPressed: () => _handleLogin(context),
                            isLoading: authProvider.isLoading,
                            isEnabled: !authProvider.isLoading,
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Divider
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppTheme.borderColor,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        localizations.or,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Expanded(
                      child: Container(
                        height: 1,
                        color: AppTheme.borderColor,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Register Link
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      localizations.dontHaveAccount,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        localizations.registerLink,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
