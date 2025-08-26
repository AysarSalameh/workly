import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_flutter/data_profile/profile_cubit.dart';
import 'package:projects_flutter/screens/pendingscreen.dart';
import 'package:flutter_datetime_picker_plus/flutter_datetime_picker_plus.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/widgets/buildDateField.dart';
import 'package:projects_flutter/widgets/buildTextField.dart';

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
                  buildTextField(controller: nameController, label: loc.name, icon: Icons.person),
                  const SizedBox(height: 16),
                  buildTextField(controller: emailController, label: loc.email, icon: Icons.email, enabled: false),
                  const SizedBox(height: 16),
                  buildDateField(context: context, controller: birthController,),
                  const SizedBox(height: 16),
                  buildTextField(controller: phoneController, label: loc.phoneNumber, icon: Icons.phone),
                  const SizedBox(height: 16),
                  buildTextField(controller: idNumberController, label: loc.idNumber, icon: Icons.perm_identity),
                  const SizedBox(height: 16),
                  buildTextField(controller: companyCodeController, label: loc.companyCode, icon: Icons.business),
                  const SizedBox(height: 16),
                  buildTextField(controller: addressController, label: loc.address, icon: Icons.location_on, maxLines: 2),
                  const SizedBox(height: 16),
                  buildTextField(controller: ibanController, label: loc.iban, icon: Icons.account_balance),
                  const SizedBox(height: 16),

                  // زر لتحديد موقع الشركة من GPS
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        cubit.pickCompanyLocation();
                      },
                      icon: const Icon(Icons.gps_fixed),
                      label: const Text("Use GPS for company location"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

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
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
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
}
