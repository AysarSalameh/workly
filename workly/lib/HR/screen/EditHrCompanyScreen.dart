import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:projects_flutter/HR/screen/hrdashboardscreen.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class EditHrCompanyScreen extends StatefulWidget {
  final String hrName;
  final String hrImageUrl; // رابط الصورة من Firebase

  const EditHrCompanyScreen({
    super.key,
    required this.hrName,
    required this.hrImageUrl,
  });

  @override
  State<EditHrCompanyScreen> createState() => _EditHrCompanyScreenState();
}

class _EditHrCompanyScreenState extends State<EditHrCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _hrNameController;
  Uint8List? _newLogoBytes; // الصورة الجديدة إذا اختارها المستخدم
  String? _currentImageUrl;  // الصورة الحالية من Firebase
  final String _uid = FirebaseAuth.instance.currentUser?.email ?? '';

  @override
  void initState() {
    super.initState();
    _hrNameController = TextEditingController(text: widget.hrName);
    _currentImageUrl = widget.hrImageUrl;
  }

  @override
  void dispose() {
    _hrNameController.dispose();
    super.dispose();
  }

  void _onSave(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<HrCompanyCubit>();
    cubit.updateHrData(
      uid: _uid,
      hrName: _hrNameController.text.trim(),
      newLogoBytes: _newLogoBytes,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return BlocProvider(
      create: (_) => HrCompanyCubit(),
      child: BlocConsumer<HrCompanyCubit, HrCompanyState>(
        listener: (context, state) {
          if (state is HrCompanySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.companySaved)),
            );
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (_) => const HrDashboardScreen()),
                  (route) => false,
            );

          } else if (state is HrCompanyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<HrCompanyCubit>();
          final isLoading = state is HrCompanyLoading;

          return Scaffold(
            body: Column(
              children: [
                // AppBar مخصص مثل SettingsPage
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Colors.indigo.shade600,
                        Colors.blue.shade600,
                        Colors.indigo.shade700,
                      ],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Row(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                loc.editCompany,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                loc.manageSettings,
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.8),
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // زر حفظ صغير في AppBar
                        IconButton(
                          icon: const Icon(Icons.save, color: Colors.white),
                          onPressed: isLoading ? null : () => _onSave(context),
                        ),
                      ],
                    ),
                  ),
                ),

                // محتوى الشاشة
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () async {
                              await cubit.pickLogoImage();
                              setState(() {
                                _newLogoBytes = cubit.logoBytes;
                              });
                            },
                            child: Stack(
                              alignment: Alignment.bottomRight,
                              children: [
                                CircleAvatar(
                                  radius: 50,
                                  backgroundColor: Colors.grey.shade300,
                                  backgroundImage: _newLogoBytes != null
                                      ? MemoryImage(_newLogoBytes!)
                                      : (_currentImageUrl != null && _currentImageUrl != ''
                                      ? NetworkImage(_currentImageUrl!)
                                      : null) as ImageProvider?,
                                  child: (_newLogoBytes == null && (_currentImageUrl == null || _currentImageUrl == ''))
                                      ? Icon(Icons.business, size: 50, color: Colors.grey.shade700)
                                      : null,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    color: Colors.blue.shade600,
                                    shape: BoxShape.circle,
                                    border: Border.all(color: Colors.white, width: 2),
                                  ),
                                  padding: const EdgeInsets.all(4),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            controller: _hrNameController,
                            decoration: InputDecoration(
                              labelText: loc.hrName,
                              prefixIcon: Icon(Icons.person, color: Colors.blue.shade600),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
                            ),
                            validator: (v) => v == null || v.isEmpty ? loc.enterHrName : null,
                          ),
                          const SizedBox(height: 30),
                          SizedBox(
                            height: 55,
                            width: double.infinity,
                            child: ElevatedButton.icon(
                              icon: isLoading
                                  ? const CircularProgressIndicator(strokeWidth: 2, color: Colors.white)
                                  : const Icon(Icons.save, color: Colors.white),
                              label: Text(
                                isLoading ? loc.saving : loc.save,
                                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                              ),
                              onPressed: isLoading ? null : () => _onSave(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue.shade600,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
