import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/data_profile/profile_cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/screens/pendingscreen.dart';

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
    final userEmail = FirebaseAuth.instance.currentUser?.email ?? "";
    final userName = FirebaseAuth.instance.currentUser?.displayName ?? "";
    final userPhoto = FirebaseAuth.instance.currentUser?.photoURL ?? "";
    final loc = AppLocalizations.of(context)!;

    if (emailController.text.isEmpty) emailController.text = userEmail;
    if (nameController.text.isEmpty) nameController.text = userName;

    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(loc.profile),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: BlocConsumer<ProfileCubit, ProfileState>(
          listener: (context, state) {
            if (state is ProfileSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(loc.profileSaved),
                  backgroundColor: Colors.green,
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
                  backgroundColor: Colors.red,
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

                  // Profile Image
                  GestureDetector(
                    onTap: () => cubit.pickProfileImage(),
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 60,
                          backgroundColor: Colors.grey[300],
                          backgroundImage: cubit.profileImage != null
                              ? FileImage(cubit.profileImage!)
                              : (userPhoto.isNotEmpty
                              ? NetworkImage(userPhoto) as ImageProvider
                              : null),
                          child: (cubit.profileImage == null && userPhoto.isEmpty)
                              ? const Icon(Icons.person, size: 60, color: Colors.grey)
                              : null,
                        ),
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: const BoxDecoration(
                            color: Colors.blue,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  // ID Image Upload
                  Text(
                    loc.uploadId,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => cubit.pickIdImage(),
                    child: Container(
                      height: 150,
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[400]!),
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
                                Icon(Icons.credit_card, size: 50, color: Colors.grey[600]),
                                const SizedBox(height: 8),
                                Text(
                                  loc.tapToUploadId,
                                  style: TextStyle(color: Colors.grey[600]),
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
                  _buildTextField(controller: nameController, label: loc.name, icon: Icons.person),
                  const SizedBox(height: 16),
                  _buildTextField(controller: emailController, label: loc.email, icon: Icons.email, enabled: false),
                  const SizedBox(height: 16),
                  _buildDateField(context),
                  const SizedBox(height: 16),
                  _buildTextField(controller: phoneController, label: loc.phoneNumber, icon: Icons.phone),
                  const SizedBox(height: 16),
                  _buildTextField(controller: idNumberController, label: loc.idNumber, icon: Icons.perm_identity),
                  const SizedBox(height: 16),
                  _buildTextField(controller: companyCodeController, label: loc.companyCode, icon: Icons.business),
                  const SizedBox(height: 16),
                  _buildTextField(controller: addressController, label: loc.address, icon: Icons.location_on, maxLines: 2),
                  const SizedBox(height: 16),
                  _buildTextField(controller: ibanController, label: loc.iban, icon: Icons.account_balance),
                  const SizedBox(height: 40),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: state is ProfileLoading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                      onPressed: () {
                        if (cubit.idImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please upload your ID before continuing."),
                              backgroundColor: Colors.red,
                            ),
                          );
                          return;
                        }

                        if (_validateForm()) {
                          cubit.saveProfile(
                            name: nameController.text.trim(),
                            email: userEmail,
                            birthDate: birthController.text.trim(),
                            phoneNumer: phoneController.text.trim(),
                            Id: idNumberController.text.trim(),
                            companyCode: companyCodeController.text.trim(),
                            address: addressController.text.trim(),
                            iban: ibanController.text.trim(),
                          );
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        loc.saveProfile,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      enabled: enabled,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!),
        ),
      ),
    );
  }

  Widget _buildDateField(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    return TextField(
      controller: birthController,
      readOnly: true,
      decoration: InputDecoration(
        labelText: loc.birthDate,
        prefixIcon: const Icon(Icons.cake, color: Colors.pinkAccent),
        suffixIcon: const Icon(Icons.calendar_today),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[400]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.blue, width: 2),
        ),
      ),
      onTap: () {
        DatePicker.showDatePicker(
          context,
          showTitleActions: true,
          minTime: DateTime(1900, 1, 1),
          maxTime: DateTime.now(),
          onChanged: (date) {},
          onConfirm: (date) {
            birthController.text =
            "${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}";
          },
          currentTime: DateTime.now().subtract(const Duration(days: 365 * 25)),
          locale: LocaleType.en,
        );
      },
    );
  }

  bool _validateForm() {
    final loc = AppLocalizations.of(context)!;
    if (nameController.text.trim().isEmpty) {
      _showErrorSnackBar(loc.errorEnterName);
      return false;
    }
    if (birthController.text.trim().isEmpty) {
      _showErrorSnackBar(loc.errorSelectBirth);
      return false;
    }
    if (phoneController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter your phone number.");
      return false;
    }
    if (idNumberController.text.trim().isEmpty) {
      _showErrorSnackBar("Please enter your ID number.");
      return false;
    }
    if (companyCodeController.text.trim().isEmpty) {
      _showErrorSnackBar(loc.errorEnterCode);
      return false;
    }
    return true;
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }
}
