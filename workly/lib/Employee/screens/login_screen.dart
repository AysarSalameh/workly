import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/Employee/auth/cubit/auth_cubit.dart';
import 'package:projects_flutter/Employee/auth/cubit/auth_state.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/Employee/languge/cubit/language_cubit.dart';
import 'package:projects_flutter/Employee/screens/HomeScreen.dart';
import 'package:projects_flutter/Employee/screens/RegisterScreen.dart';
import 'package:projects_flutter/Employee/screens/pendingscreen.dart';
import 'package:projects_flutter/Employee/screens/profilesetupscreen.dart';
import 'package:projects_flutter/Employee/screens/rejectedscreen.dart';
import 'package:projects_flutter/Employee/widgets/custom_text_field.dart';

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
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.iconTheme,
        actions: [
          IconButton(
            icon: Icon(Icons.language, color: theme.iconTheme.color),
            onPressed: () => context.read<LanguageCubit>().toggle(),
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
                  MaterialPageRoute(builder: (_) => const ProfileScreen()));
            } else if (status == "approved") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const HomeScreen()));
            } else if (status == "pending") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PendingScreen()));
            } else if (status == "deleted") {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const RejectedScreen()));
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
              SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(Icons.business_center,
                        size: 100, color: theme.colorScheme.primary),
                    const SizedBox(height: 20),
                    Text(
                      loc.welcomeToWorkly,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.bold),
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
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.primary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
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

                          context
                              .read<AuthCubit>()
                              .loginWithEmail(email, password);
                        },
                        child: Text(loc.login,
                            style: theme.textTheme.labelLarge?.copyWith(
                                color: theme.colorScheme.onPrimary)),
                      ),
                    ),
                    const SizedBox(height: 15),

                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loc.dontHaveAccount,
                            style: theme.textTheme.bodyLarge),
                        TextButton(
                          onPressed: isLoading
                              ? null
                              : () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const RegisterScreen()),
                            );
                          },
                          child: Text(loc.signUp,
                              style: theme.textTheme.bodyMedium
                                  ?.copyWith(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Divider with "OR"
                    Row(
                      children: [
                        Expanded(child: Divider(color: theme.dividerColor)),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(loc.or, style: theme.textTheme.bodySmall),
                        ),
                        Expanded(child: Divider(color: theme.dividerColor)),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Google Sign-In
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: Image.asset('assets/images/google_logo.png',
                            height: 22, width: 22, errorBuilder:
                                (context, error, stackTrace) {
                              return Icon(Icons.login, color: theme.iconTheme.color);
                            }),
                        label: Text(loc.continueWithGoogle,
                            style: theme.textTheme.bodyMedium),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.dividerColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed:
                        isLoading ? null : () => context.read<AuthCubit>().loginWithGoogle(),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Apple Sign-In
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: OutlinedButton.icon(
                        icon: Icon(Icons.apple,
                            color: theme.iconTheme.color, size: 22),
                        label: Text(loc.continueWithApple,
                            style: theme.textTheme.bodyMedium),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.dividerColor),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed:
                        isLoading ? null : () => context.read<AuthCubit>().loginWithApple(),
                      ),
                    ),
                  ],
                ),
              ),

              // Loading overlay
              if (isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                          strokeWidth: 3,
                        ),
                        const SizedBox(height: 20),
                        Text(loc.signingIn,
                            style: theme.textTheme.bodyLarge
                                ?.copyWith(color: Colors.white)),
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
