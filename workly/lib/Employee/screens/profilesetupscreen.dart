import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_flutter/Employee/data_profile/profile_cubit.dart';
import 'package:projects_flutter/Employee/screens/pendingscreen.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/Employee/widgets/buildDateField.dart';
import 'package:projects_flutter/Employee/widgets/buildTextField.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameController = TextEditingController();
  final birthController = TextEditingController();
  final companyCodeController = TextEditingController();
  final addressController = TextEditingController();
  final ibanController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final idNumberController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    companyCodeController.dispose();
    addressController.dispose();
    ibanController.dispose();
    emailController.dispose();
    phoneController.dispose();
    idNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final loc = AppLocalizations.of(context)!;
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? "";
    final userPhoto = FirebaseAuth.instance.currentUser?.photoURL ?? "";

    if (emailController.text.isEmpty) emailController.text = userEmail;
    if (nameController.text.isEmpty) nameController.text = userName;

    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              loc.profile,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
                color: Theme.of(context).appBarTheme.foregroundColor,
              ),
            ),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.profileSaved),
                  backgroundColor: theme.colorScheme.primary,
                  duration: const Duration(seconds: 1),
                ),
              );
              Future.delayed(const Duration(seconds: 1), () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const PendingScreen()),
                );
              });
            } else if (state is ProfileError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: theme.colorScheme.error,
                ),
              );
            }
          },
          builder: (context, state) {
            final cubit = context.read<ProfileCubit>();

            return SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 20),

                  // Profile Image Picker
                  GestureDetector(
                    onTap: () => cubit.pickProfileImage(context, loc),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: theme.colorScheme.onBackground
                              .withOpacity(0.1),
                          backgroundImage: cubit.profileImage != null
                              ? FileImage(cubit.profileImage!)
                              : (userPhoto.isNotEmpty
                                        ? NetworkImage(userPhoto)
                                        : null)
                                    as ImageProvider?,
                          child:
                              (cubit.profileImage == null && userPhoto.isEmpty)
                              ? Icon(
                                  Icons.person,
                                  size: 60,
                                  color: theme.iconTheme.color,
                                )
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.primary,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ID Image Picker
                  Text(loc.uploadId, style: theme.textTheme.titleMedium),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => cubit.pickIdImage(context, loc),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.onBackground.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: theme.dividerColor),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          if (cubit.idImage != null)
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                cubit.idImage!,
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: 150,
                              ),
                            )
                          else
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.credit_card,
                                  size: 50,
                                  color: theme.colorScheme.onBackground
                                      .withOpacity(0.5),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  loc.tapToUploadId,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: theme.hintColor,
                                  ),
                                ),
                              ],
                            ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.7),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // Form Fields
                  buildTextField(
                    controller: nameController,
                    label: loc.name,
                    icon: Icons.person,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: emailController,
                    label: loc.email,
                    icon: Icons.email,
                    enabled: false,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),
                  buildDateField(
                    context: context,
                    controller: birthController,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: phoneController,
                    label: loc.phoneNumber,
                    icon: Icons.phone,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: idNumberController,
                    label: loc.idNumber,
                    icon: Icons.perm_identity,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: companyCodeController,
                    label: loc.companyCode,
                    icon: Icons.business,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: addressController,
                    label: loc.address,
                    icon: Icons.location_on,
                    maxLines: 2,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),
                  buildTextField(
                    controller: ibanController,
                    label: loc.iban,
                    icon: Icons.account_balance,
                    isDark: Theme.of(context).brightness == Brightness.dark,
                  ),
                  const SizedBox(height: 16),

                  // Company GPS Location Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: BlocBuilder<ProfileCubit, ProfileState>(
                      builder: (context, state) {
                        if (state is CompanyLocationLoading) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return ElevatedButton.icon(
                          onPressed: () => cubit.pickCompanyLocation(loc),
                          icon: Icon(
                            Icons.gps_fixed,
                            color: theme.colorScheme.onPrimary,
                          ),
                          label: Text(
                            loc.useGps,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: theme.colorScheme.onPrimary,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: theme.colorScheme.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Save Profile Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: state is ProfileLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: theme.colorScheme.primary,
                            ),
                          )
                        : ElevatedButton(
                            onPressed: () {
                              if (cubit.idImage == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(loc.uploadId),
                                    backgroundColor: theme.colorScheme.error,
                                  ),
                                );
                                return;
                              }

                              cubit.saveProfile(
                                name: nameController.text.trim(),
                                email: userEmail,
                                birthDate: birthController.text.trim(),
                                phoneNumer: phoneController.text.trim(),
                                Id: idNumberController.text.trim(),
                                companyCode: companyCodeController.text.trim(),
                                address: addressController.text.trim(),
                                iban: ibanController.text.trim(),
                                loc: loc,
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green, // لون الخلفية
                              foregroundColor: Colors.white, // لون النص
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: Text(
                              loc.saveProfile,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
