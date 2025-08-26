import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_flutter/Employee/data_profile/profile_cubit.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';
import 'package:projects_flutter/Employee/screens/HomeScreen.dart';
import 'package:projects_flutter/Employee/widgets/buildTextField.dart';
import 'package:projects_flutter/Employee/widgets/buildDateField.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final ProfileCubit cubit;
  late final String userEmail;

  // Controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController ibanController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController idNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    cubit = context.read<ProfileCubit>();
    userEmail = FirebaseAuth.instance.currentUser?.email ?? '';
    cubit.loadUser(userEmail);
  }

  @override
  void dispose() {
    nameController.dispose();
    birthController.dispose();
    addressController.dispose();
    ibanController.dispose();
    phoneController.dispose();
    idNumberController.dispose();
    super.dispose();
  }

  void _setControllersData(Map<String, dynamic> data) {
    if (nameController.text.isEmpty) {
      nameController.text = data['name'] ?? '';
      birthController.text = data['birthDate'] ?? '';
      addressController.text = data['address'] ?? '';
      ibanController.text = data['iban'] ?? '';
      phoneController.text = data['phoneNumber'] ?? '';
      idNumberController.text = data['Id'] ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state is ProfileEdited) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(loc.profileSaved),
              backgroundColor: Colors.green,
            ),
          );
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const HomeScreen()),
          );
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
        if (state is ProfileLoading || state is ProfileInitial) {
          return Scaffold(
            backgroundColor: isDark ? Color(0xFF121212) : Colors.white,
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        if (state is ProfileLoaded) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _setControllersData(state.userData);
          });
        }

        final data = state is ProfileLoaded ? state.userData : {};

        final profileImageProvider = cubit.profileImage != null
            ? FileImage(cubit.profileImage!)
            : (data['profileImage'] != null
            ? MemoryImage(base64Decode(data['profileImage']))
            : null) as ImageProvider?;

        final idImageProvider = cubit.idImage != null
            ? FileImage(cubit.idImage!)
            : (data['idImage'] != null
            ? MemoryImage(base64Decode(data['idImage']))
            : null) as ImageProvider?;

        return Scaffold(
          backgroundColor: isDark ? const Color(0xFF121212) : Colors.white,
          appBar: AppBar(
            title: Text(
              loc.editProfile,
              style: TextStyle(color: isDark ? Colors.white : Colors.black),
            ),
            backgroundColor: isDark ? const Color(0xFF1F1F1F) : Colors.white,
            iconTheme: IconThemeData(color: isDark ? Colors.white : Colors.black),
            elevation: 1,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                const SizedBox(height: 20),

                // صورة الملف الشخصي
                GestureDetector(
                  onTap: () async {
                    await cubit.pickProfileImage(context, loc);
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: profileImageProvider,
                        child: profileImageProvider == null
                            ? const Icon(Icons.person, size: 60)
                            : null,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // صورة الهوية
                GestureDetector(
                  onTap: () async {
                    await cubit.pickIdImage(context, loc);
                    setState(() {});
                  },
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.grey),
                          image: idImageProvider != null
                              ? DecorationImage(
                              image: idImageProvider, fit: BoxFit.cover)
                              : null,
                        ),
                        child: idImageProvider == null
                            ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.badge, size: 50),
                            const SizedBox(height: 8),
                            Text(
                              loc.uploadId,
                              style: TextStyle(
                                  color: isDark ? Colors.white : Colors.black),
                            ),
                          ],
                        )
                            : null,
                      ),
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.camera_alt, color: Colors.white),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // الحقول
                buildTextField(
                    controller: nameController,
                    label: loc.name,
                    icon: Icons.person,
                    isDark: isDark),
                const SizedBox(height: 20),
                buildTextField(
                    controller: phoneController,
                    label: loc.phoneNumber,
                    icon: Icons.phone,
                    isDark: isDark),
                const SizedBox(height: 20),
                buildTextField(
                    controller: idNumberController,
                    label: loc.idNumber,
                    icon: Icons.perm_identity,
                    isDark: isDark),
                const SizedBox(height: 20),
                buildTextField(
                    controller: addressController,
                    label: loc.address,
                    icon: Icons.location_on,
                    maxLines: 2,
                    isDark: isDark),
                const SizedBox(height: 20),
                buildTextField(
                    controller: ibanController,
                    label: loc.iban,
                    icon: Icons.account_balance,
                    isDark: isDark),
                const SizedBox(height: 20),
                buildDateField(context: context, controller: birthController, isDark: isDark),
                const SizedBox(height: 20),

                // زر الحفظ
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isDark ? Colors.deepPurple : Colors.blue,
                    ),
                    onPressed: () {
                      cubit.editSaveProfile(
                        phoneNumber: phoneController.text.trim(),
                        name: nameController.text.trim(),
                        birthDate: birthController.text.trim(),
                        Id: idNumberController.text.trim(),
                        address: addressController.text.trim(),
                        iban: ibanController.text.trim(),
                        email: userEmail,
                        loc: loc,
                      );
                    },
                    child: Text(
                      loc.saveProfile,
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
