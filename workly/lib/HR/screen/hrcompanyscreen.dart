
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projects_flutter/HR/company/hrcompanycubit.dart';
import 'package:projects_flutter/HR/company/hrcompanystate.dart';
import 'package:projects_flutter/HR/screen/hr_home_screen.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

class HrCompanyScreen extends StatefulWidget {
  const HrCompanyScreen({super.key});

  @override
  State<HrCompanyScreen> createState() => _HrCompanyScreenState();
}

class _HrCompanyScreenState extends State<HrCompanyScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _companyNameController = TextEditingController();
  final TextEditingController _companyCodeController = TextEditingController();
  final TextEditingController _hrNameController = TextEditingController();

  final String _companyEmail = FirebaseAuth.instance.currentUser?.email ?? '';
  final String _uid = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _companyNameController.addListener(_onCompanyNameChanged);
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _companyCodeController.dispose();
    _hrNameController.dispose();
    super.dispose();
  }

  void _onCompanyNameChanged() {
    _companyCodeController.text = _generateCompanyCode(
      _companyNameController.text,
    );
  }

  String _generateCompanyCode(String name) {
    if (name.trim().isEmpty) return '';
    final cleaned = name.replaceAll(RegExp(r'[^A-Za-z0-9\s]'), '').trim();
    final code = cleaned.replaceAll(' ', '_').toUpperCase();
    return code;
  }

  void _onSave(BuildContext context, Uint8List? logoImage) {
    if (!_formKey.currentState!.validate()) return;
    final cubit = context.read<HrCompanyCubit>();
    cubit.saveCompanyData(
      companyName: _companyNameController.text.trim(),
      code: _companyCodeController.text.trim(),
      status: "pending",
      hrName: _hrNameController.text.trim(),
      companyEmail: _companyEmail,
      uid: _uid,
      logoImage: logoImage,
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isWeb = MediaQuery.of(context).size.width > 600;

    return BlocProvider(
      create: (_) => HrCompanyCubit(),
      child: BlocConsumer<HrCompanyCubit, HrCompanyState>(
        listener: (context, state) {
          if (state is HrCompanySuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(loc.companySaved)),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const HrHomeScreen()),
            );
          }
 else if (state is HrCompanyFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          final cubit = context.read<HrCompanyCubit>();
          final isLoading = state is HrCompanyLoading;
          final logo = (state is LogoPicked) ? state.logoImage : null;

          return Scaffold(
            appBar: AppBar(
              title: Text(loc.companyData),
              centerTitle: true,
              backgroundColor: Colors.blue.shade600,
              foregroundColor: Colors.white,
            ),
            body: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isWeb ? 700 : double.infinity,
                ),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        GestureDetector(
                          onTap: () => cubit.pickLogoImage(),
                          child: CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.grey.shade300,
                            backgroundImage:
                            logo != null ? MemoryImage(logo) : null,
                            child: logo == null
                                ? Icon(Icons.business,
                                size: 50, color: Colors.grey.shade700)
                                : null,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _hrNameController,
                          decoration: InputDecoration(
                            labelText: loc.hrName,
                            prefixIcon: Icon(Icons.person,
                                color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (v) =>
                          v == null || v.isEmpty ? loc.enterHrName : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          initialValue: _companyEmail,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: loc.companyEmail,
                            prefixIcon: Icon(Icons.email,
                                color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _companyNameController,
                          decoration: InputDecoration(
                            labelText: loc.companyName,
                            prefixIcon: Icon(Icons.business,
                                color: Colors.blue.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? loc.enterCompanyName
                              : null,
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _companyCodeController,
                          readOnly: true,
                          decoration: InputDecoration(
                            labelText: loc.companyCode,
                            prefixIcon:
                            Icon(Icons.vpn_key, color: Colors.green.shade600),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        SizedBox(
                          height: 55,
                          child: ElevatedButton.icon(
                            icon: isLoading
                                ? const CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white)
                                : const Icon(Icons.save, color: Colors.white),
                            label: Text(
                              isLoading ? loc.saving : loc.save,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            onPressed:
                            isLoading ? null : () => _onSave(context, logo),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
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
  }
}

