import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/screen/hrdashboardscreen.dart';
import 'package:projects_flutter/HR/screen/hrProfilescreen.dart';
import 'package:projects_flutter/HR/screen/hrregisterscreen.dart';
import 'package:projects_flutter/auth/auth_service.dart';
import 'package:projects_flutter/auth/cubit/auth_cubit.dart';
import 'package:projects_flutter/auth/cubit/auth_state.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/languge/cubit/language_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HrLoginScreen extends StatefulWidget {
  const HrLoginScreen({super.key});

  @override
  State<HrLoginScreen> createState() => _HrLoginScreenState();
}

class _HrLoginScreenState extends State<HrLoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  final String _uid = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;

    return BlocProvider(
      create: (_) => AuthCubit(AuthService()),
      child: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) async {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(loc.loginSuccess),
                backgroundColor: Colors.green,
              ),
            );

            final uid = FirebaseAuth.instance.currentUser!.email;
            final doc = await FirebaseFirestore.instance
                .collection('companies')
                .doc(uid)
                .get();
            if (!mounted) return;
            if (doc.exists) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => HrDashboardScreen()),
              );
            } else {
              // بيانات الشركة غير موجودة -> اذهب لشاشة تعبئة بيانات الشركة
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const HrCompanyScreen()),
              );
            }
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;
          final cubit = context.read<AuthCubit>();

          return Scaffold(
            body: LayoutBuilder(
              builder: (context, constraints) {
                final screenHeight = constraints.maxHeight;
                return SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: screenHeight),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.shade50,
                            Colors.indigo.shade100,
                            Colors.purple.shade50,
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Center(
                        child: Container(
                          width: isWeb ? 450 : screenWidth * 0.9,
                          padding: const EdgeInsets.all(32),
                          margin: const EdgeInsets.symmetric(
                            vertical: 32,
                            horizontal: 16,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // زر تحويل اللغة
                              Align(
                                alignment: Alignment.topRight,
                                child: IconButton(
                                  icon: const Icon(Icons.language),
                                  onPressed: () => context
                                      .read<LanguageCubit>()
                                      .toggleLanguage(),
                                ),
                              ),

                              // Logo
                              Container(
                                width: 80,
                                height: 80,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.blue.shade600,
                                      Colors.indigo.shade600,
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: const Icon(
                                  Icons.business_center,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                              const SizedBox(height: 24),
                              Text(
                                loc.hrPortal,
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey.shade800,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                loc.hrLogin,
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                              const SizedBox(height: 32),

                              Form(
                                key: _formKey,
                                child: Column(
                                  children: [
                                    // Email
                                    TextFormField(
                                      controller: emailController,
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return loc.enterEmail;
                                        }
                                        if (!value.contains('@')) {
                                          return loc.enterValidEmail;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: loc.email,
                                        prefixIcon: Icon(
                                          Icons.email_outlined,
                                          color: Colors.blue.shade600,
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.blue.shade600,
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Password
                                    TextFormField(
                                      controller: passwordController,
                                      obscureText: !_isPasswordVisible,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return loc.enterPassword;
                                        }
                                        return null;
                                      },
                                      decoration: InputDecoration(
                                        labelText: loc.password,
                                        prefixIcon: Icon(
                                          Icons.lock_outlined,
                                          color: Colors.blue.shade600,
                                        ),
                                        suffixIcon: IconButton(
                                          icon: Icon(
                                            _isPasswordVisible
                                                ? Icons.visibility_off
                                                : Icons.visibility,
                                            color: Colors.grey.shade600,
                                          ),
                                          onPressed: () => setState(
                                            () => _isPasswordVisible =
                                                !_isPasswordVisible,
                                          ),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                        ),
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            12,
                                          ),
                                          borderSide: BorderSide(
                                            color: Colors.blue.shade600,
                                            width: 2,
                                          ),
                                        ),
                                        filled: true,
                                        fillColor: Colors.grey.shade50,
                                      ),
                                    ),
                                    const SizedBox(height: 20),

                                    // Login Button
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: ElevatedButton(
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                if (_formKey.currentState!
                                                    .validate()) {
                                                  cubit.loginWithEmail(
                                                    emailController.text.trim(),
                                                    passwordController.text
                                                        .trim(),
                                                  );
                                                }
                                              },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.blue.shade600,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        child: isLoading
                                            ? const CircularProgressIndicator(
                                                color: Colors.white,
                                              )
                                            : Text(
                                                loc.login,
                                                style: const TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                      ),
                                    ),
                                    const SizedBox(height: 16),

                                    // Google Sign-In
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: OutlinedButton.icon(
                                        icon: Image.asset(
                                          'assets/images/google_logo.png',
                                          height: 22,
                                          width: 22,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                                return Icon(
                                                  Icons.login,
                                                  color: Theme.of(
                                                    context,
                                                  ).iconTheme.color,
                                                );
                                              },
                                        ),
                                        label: Text(
                                          loc.continueWithGoogle,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Theme.of(
                                              context,
                                            ).dividerColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () => cubit.loginWithGoogleWeb(),
                                      ),
                                    ),
                                    const SizedBox(height: 12),

                                    // Apple Sign-In
                                    SizedBox(
                                      width: double.infinity,
                                      height: 50,
                                      child: OutlinedButton.icon(
                                        icon: Icon(
                                          Icons.apple,
                                          color: Theme.of(
                                            context,
                                          ).iconTheme.color,
                                          size: 22,
                                        ),
                                        label: Text(
                                          loc.continueWithApple,
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodyMedium,
                                        ),
                                        style: OutlinedButton.styleFrom(
                                          side: BorderSide(
                                            color: Theme.of(
                                              context,
                                            ).dividerColor,
                                          ),
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                        ),
                                        onPressed: isLoading
                                            ? null
                                            : () => cubit.loginWithAppleWeb(),
                                      ),
                                    ),
                                    const SizedBox(height: 24),

                                    // Register Button
                                    TextButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (_) =>
                                                const HrRegisterScreen(),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        loc.createNewAccount,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
