import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../providers/auth_provider.dart';
import '../../config/theme/app_theme.dart';

import '../dashboard/member_dashboard.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {

  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() =>
      _LoginScreenState();
}

class _LoginScreenState
    extends State<LoginScreen> {

  final phoneController =
      TextEditingController();

  final passwordController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor:
          AppTheme.backgroundColor,

      body: SafeArea(

        child: Padding(

          padding: const EdgeInsets.all(24),

          child: Column(

            mainAxisAlignment:
                MainAxisAlignment.center,

            children: [

              const Icon(
                Icons.health_and_safety,
                size: 80,
                color: AppTheme.primaryColor,
              ),

              const SizedBox(height: 20),

              Text(
                'SwasthyaSetu',
                style: Theme.of(context)
                    .textTheme
                    .displaySmall
                    ?.copyWith(
                      fontWeight:
                          FontWeight.bold,
                    ),
              ),

              const SizedBox(height: 40),

              TextField(
                controller: phoneController,

                keyboardType:
                    TextInputType.phone,

                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon:
                      Icon(Icons.phone),
                ),
              ),

              const SizedBox(height: 20),

              TextField(
                controller: passwordController,

                obscureText: true,

                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon:
                      Icon(Icons.lock),
                ),
              ),

              const SizedBox(height: 30),

              Consumer<AuthProvider>(
                builder:
                    (context, authProvider, _) {

                  return SizedBox(

                    width: double.infinity,

                    child: ElevatedButton(

                      onPressed:
                          authProvider.isLoading
                              ? null
                              : () async {

                                  final success =
                                      await authProvider
                                          .login(

                                    phone:
                                        phoneController
                                            .text,

                                    password:
                                        passwordController
                                            .text,
                                  );

                                  if (success &&
                                      mounted) {

                                    Navigator.pushReplacement(

                                      context,

                                      MaterialPageRoute(

                                        builder:
                                            (_) =>
                                                const MemberDashboard(),
                                      ),
                                    );
                                  } else if (mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(authProvider.errorMessage ?? 'Login failed'),
                                        backgroundColor: AppTheme.errorColor,
                                      ),
                                    );
                                  }
                                },

                      child:
                          authProvider.isLoading
                              ? const CircularProgressIndicator(
                                  color:
                                      Colors.white,
                                )
                              : const Text(
                                  'Login',
                                ),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              TextButton(

                onPressed: () {

                  Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder:
                          (_) =>
                              const RegisterScreen(),
                    ),
                  );
                },

                child: const Text(
                  'Create Account',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}