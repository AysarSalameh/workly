import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/auth/cubit/auth_cubit.dart';
import 'package:projects_flutter/auth/cubit/auth_state.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/languge/cubit/language_cubit.dart';

class HrRegisterScreen extends StatefulWidget {
  const HrRegisterScreen({super.key});

  @override
  State<HrRegisterScreen> createState() => _HrRegisterScreenState();
}

class _HrRegisterScreenState extends State<HrRegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  void register(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthCubit>().registerWithEmail(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isWeb = screenWidth > 600;
    final loc = AppLocalizations.of(context)!;

    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(loc.success, style: TextStyle(color: Colors.green.shade700)), // عنوان من loc
              content: Text(loc.registrationSuccessful), // رسالة من loc
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // يغلق الـ AlertDialog
                    Navigator.pop(context); // يرجع للشاشة السابقة
                  },
                  child: Text(loc.ok), // زر من loc
                ),
              ],
            ),
          );


      } else if (state is AuthFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;

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
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.green.shade50, Colors.teal.shade100, Colors.blue.shade50],
                      ),
                    ),
                    child: Center(
                      child: Container(
                        width: isWeb ? 450 : screenWidth * 0.9,
                        padding: const EdgeInsets.all(32),
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 20,
                                offset: const Offset(0, 10)),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Back + Language Toggle
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.arrow_back, color: Colors.grey.shade600),
                                  onPressed: () => Navigator.pop(context),
                                ),
                                TextButton(
                                  onPressed: () => context.read<LanguageCubit>().toggleLanguage(),
                                  child: const Icon(Icons.language),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            // Logo
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [Colors.green.shade600, Colors.teal.shade600]),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.person_add, color: Colors.white, size: 40),
                            ),
                            const SizedBox(height: 24),
                            Text(loc.createAccount,
                                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.grey.shade800)),
                            const SizedBox(height: 8),
                            Text(loc.joinHrTeam, style: TextStyle(fontSize: 16, color: Colors.grey.shade600)),
                            const SizedBox(height: 32),
                            Form(
                              key: _formKey,
                              child: Column(
                                children: [
                                  // Name
                                  TextFormField(
                                    controller: nameController,
                                    validator: (v) => v == null || v.isEmpty ? loc.enterFullName : null,
                                    decoration: InputDecoration(
                                      labelText: loc.fullName,
                                      prefixIcon: Icon(Icons.person_outlined, color: Colors.green.shade600),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.green.shade600, width: 2)),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Email
                                  TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    validator: (v) => v == null || !v.contains('@') ? loc.enterValidEmail : null,
                                    decoration: InputDecoration(
                                      labelText: loc.email,
                                      prefixIcon: Icon(Icons.email_outlined, color: Colors.green.shade600),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.green.shade600, width: 2)),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Password
                                  TextFormField(
                                    controller: passwordController,
                                    obscureText: !_isPasswordVisible,
                                    validator: (v) => v == null || v.length < 8 ? loc.passwordRequirements : null,
                                    decoration: InputDecoration(
                                      labelText: loc.password,
                                      prefixIcon: Icon(Icons.lock_outlined, color: Colors.green.shade600),
                                      suffixIcon: IconButton(
                                        icon: Icon(_isPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey.shade600),
                                        onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.green.shade600, width: 2)),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  // Confirm Password
                                  TextFormField(
                                    controller: confirmPasswordController,
                                    obscureText: !_isConfirmPasswordVisible,
                                    validator: (v) => v != passwordController.text ? loc.passwordNotMatch : null,
                                    decoration: InputDecoration(
                                      labelText: loc.confirmPassword,
                                      prefixIcon: Icon(Icons.lock_outline, color: Colors.green.shade600),
                                      suffixIcon: IconButton(
                                        icon: Icon(_isConfirmPasswordVisible ? Icons.visibility_off : Icons.visibility,
                                            color: Colors.grey.shade600),
                                        onPressed: () => setState(() => _isConfirmPasswordVisible = !_isConfirmPasswordVisible),
                                      ),
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                          borderSide: BorderSide(color: Colors.green.shade600, width: 2)),
                                      filled: true,
                                      fillColor: Colors.grey.shade50,
                                    ),
                                  ),
                                  const SizedBox(height: 24),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 50,
                                    child: ElevatedButton(
                                      onPressed: isLoading ? null : () => register(context),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green.shade600,
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                      ),
                                      child: isLoading
                                          ? const CircularProgressIndicator(color: Colors.white)
                                          : Text(loc.createAccount,
                                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                  const SizedBox(height: 16),
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text(loc.alreadyHaveAccount,
                                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal)),
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
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
