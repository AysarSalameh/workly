import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String message;
  AuthFailure(this.message);
}
class ProfileStatusLoading extends AuthState {}
class ProfileStatusIncomplete extends AuthState {}
class ProfileStatusPending extends AuthState {}
class ProfileStatusRejected extends AuthState {}
class ProfileStatusApproved extends AuthState {}
class ProfileStatusError extends AuthState {
  final String message;
  ProfileStatusError(this.message);
}
