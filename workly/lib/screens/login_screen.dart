import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/auth/cubit/auth_cubit.dart';
import 'package:projects_flutter/auth/cubit/auth_state.dart';

import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/languge/cubit/language_cubit.dart';
import 'package:projects_flutter/screens/HomeScreen.dart';
import 'package:projects_flutter/screens/RegisterScreen.dart';
import 'package:projects_flutter/screens/pendingscreen.dart';
import 'package:projects_flutter/screens/profilesetupscreen.dart';
import 'package:projects_flutter/screens/rejectedscreen.dart';
import 'package:projects_flutter/widgets/custom_text_field.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.language, color: Colors.black87),
            onPressed: () {
              context.read<LanguageCubit>().toggle();
            },
          ),
        ],
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
          listener: (context, state) async {
            if (state is AuthSuccess) {
              final user = state.user;
              final cubit = context.read<AuthCubit>();
              final status = await cubit.checkProfileCompletionByEmail(user.email!);

              if (status == "incomplete") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              } else if (status == "complete") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()),
                );
              } else if (status == "pending") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PendingScreen()),
                );
              } else if (status == "deleted") {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RejectedScreen()),
                );
              }

            } else if (state is AuthFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                  duration: const Duration(seconds: 3),
                ),
              );
            }
          },

        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.business_center, size: 100, color: Colors.blue),
                        const SizedBox(height: 20),
                         Text(
                          loc.welcomeToWorkly,
                          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 40),

                        // Email field
                        CustomTextField(
                          controller: emailController,
                          label: loc.email,
                          icon: Icons.email,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: 20),

                        // Password field
                        CustomTextField(
                          controller: passwordController,
                          label: loc.password,
                          icon: Icons.lock,
                          obscureText: true,
                        ),
                        const SizedBox(height: 30),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isLoading
                                ? null
                                : () {
                              final email = emailController.text.trim();
                              final password = passwordController.text.trim();

                              if (email.isEmpty || password.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                   SnackBar(
                                    content: Text(loc.pleaseEnterEmailAndPassword),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                                return;
                              }

                              context.read<AuthCubit>().loginWithEmail(email, password);
                            },
                            child:  Text(loc.login, style: TextStyle(fontSize: 18)),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Sign up link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Text( loc.dontHaveAccount),
                            TextButton(
                              onPressed: isLoading
                                  ? null
                                  : () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                                );
                              },
                              child:  Text(loc.signUp),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),

                        // Divider with "OR" text
                        Row(
                          children: [
                            Expanded(child: Divider(color: Colors.grey.shade400)),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                loc.or,
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            Expanded(child: Divider(color: Colors.grey.shade400)),
                          ],
                        ),
                        const SizedBox(height: 20),

                        // Google Sign-In button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            icon: Image.asset(
                              'assets/images/google_logo.png', // Add Google logo to assets
                              height: 20,
                              width: 20,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.login, color: Colors.red);
                              },
                            ),
                            label:  Text(
                              loc.continueWithGoogle,
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () => context.read<AuthCubit>().loginWithGoogle(),
                          ),
                        ),
                        const SizedBox(height: 12),

                        // Apple Sign-In button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            icon: const Icon(
                              Icons.apple,
                              color: Colors.black,
                              size: 22,
                            ),
                            label:  Text(
                              loc.continueWithApple,
                              style: TextStyle(color: Colors.black87),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.grey.shade300),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            onPressed: isLoading
                                ? null
                                : () => context.read<AuthCubit>().loginWithApple(),
                          ),
                        ),
                        const SizedBox(height: 12),

                      ],
                    ),
                  ),
                ),
              ),

              // Full screen loading overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const CircularProgressIndicator(
                          color: Colors.blue,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          loc.signingIn,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}