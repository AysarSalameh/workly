import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:projects_flutter/l10n/app_localizations.dart';

/// ---------------------------
/// Cubit + States
/// ---------------------------

class HrCompanyState {}

class HrCompanyInitial extends HrCompanyState {}

class HrCompanyLoading extends HrCompanyState {}

class HrCompanySuccess extends HrCompanyState {
  final String message;
  HrCompanySuccess(this.message);
}
class LogoPicked extends HrCompanyState {
  final Uint8List logoImage; // بيانات اللوجو
  LogoPicked(this.logoImage);
}

class HrCompanyFailure extends HrCompanyState {
  final String error;
  HrCompanyFailure(this.error);
}