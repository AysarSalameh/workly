import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/Employee/auth/cubit/auth_cubit.dart';
import 'package:projects_flutter/Employee/auth/cubit/auth_state.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isValidEmail(String email) => RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);
  bool isValidPassword(String password) => password.length >= 6;

  void register() {
    final loc = AppLocalizations.of(context)!;
    String name = nameController.text.trim();
    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.pleaseFillAllFields)),
      );
      return;
    }
    if (!isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.pleaseEnterValidEmail)),
      );
      return;
    }
    if (!isValidPassword(password)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(loc.passwordMustBe6Characters)),
      );
      return;
    }

    context.read<AuthCubit>().registerWithEmail(name, email, password);
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: Text(loc.register, style: theme.textTheme.titleLarge),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: theme.iconTheme,
      ),
      body: BlocConsumer<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.accountCreated), backgroundColor: Colors.green),
            );
            Navigator.pop(context);
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        builder: (context, state) {
          bool isLoading = state is AuthLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.person_add, size: 100, color: theme.colorScheme.primary),
                const SizedBox(height: 20),
                Text(
                  loc.registerNewAccount,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 40),

                // Name
                TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    labelText: loc.fullName,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.person, color: theme.iconTheme.color),
                  ),
                ),
                const SizedBox(height: 20),

                // Email
                TextField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: loc.email,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.email, color: theme.iconTheme.color),
                  ),
                ),
                const SizedBox(height: 20),

                // Password
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: loc.password,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    prefixIcon: Icon(Icons.lock, color: theme.iconTheme.color),
                  ),
                ),
                const SizedBox(height: 30),

                // Register button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: isLoading ? null : register,
                    child: isLoading
                        ? CircularProgressIndicator(color: theme.colorScheme.onPrimary)
                        : Text(loc.register,
                        style: theme.textTheme.labelLarge
                            ?.copyWith(color: theme.colorScheme.onPrimary)),
                  ),
                ),
                const SizedBox(height: 10),

                // Back to login
                TextButton(
                  onPressed: isLoading ? null : () => Navigator.pop(context),
                  child: Text(loc.alreadyHaveAccount, style: theme.textTheme.bodyLarge),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
