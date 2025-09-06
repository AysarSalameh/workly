import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_flutter/auth/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  Future<void> loginWithGoogleWeb() async {
    emit(AuthLoading());
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      final userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      emit(AuthSuccess(userCredential.user!));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }
  Future<void> loginWithAppleWeb() async {
    emit(AuthLoading());
    try {
      OAuthProvider appleProvider = OAuthProvider("apple.com");
      appleProvider.addScope('email');
      appleProvider.addScope('name');
      appleProvider.setCustomParameters({'locale': 'en'});

      final userCredential = await FirebaseAuth.instance.signInWithPopup(appleProvider);
      emit(AuthSuccess(userCredential.user!));
    } catch (e) {
      print(e.toString());
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.loginWithEmail(email, password);
      emit(AuthSuccess(user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Login failed"));
    } catch (e) {
      emit(AuthFailure("Unexpected error"));
    }
  }

  Future<void> loginWithGoogle() async {
    emit(AuthLoading());
    try {
      final user = await _authService.loginWithGoogle();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Google Sign-In canceled"));
      }
    } catch (e) {
      emit(AuthFailure("Google Sign-In failed"));
    }
  }

  void logout() async {
    await _authService.signOut();
    emit(AuthInitial());
  }


  Future<void> registerWithEmail(String name, String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.registerWithEmail(name, email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Registration failed"));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(e.message ?? "Registration failed"));
    } catch (e) {
      emit(AuthFailure("Unexpected error"));
    }
  }
  Future<void> loginWithApple() async {
    emit(AuthLoading());
    try {
      final user = await _authService.loginWithApple();
      if (user != null) emit(AuthSuccess(user));
      else emit(AuthFailure("Apple Sign-In canceled"));
    } catch (e) {
      emit(AuthFailure("Apple Sign-In failed: ${e.toString()}"));
    }
  }

  Future<String> checkProfileCompletionByEmail(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) {
      return "incomplete"; // ما في بيانات
    }

    final data = querySnapshot.docs.first.data();

    // تحقق من الحقول الأساسية
    final isComplete = data['name'] != null &&
        data['birthDate'] != null &&
        data['Id'] != null &&
        data['phoneNumber'] != null;

    if (!isComplete) {
      return "incomplete";
    }

    // رجع status إذا البيانات كاملة
    return data['hrStatus'] ?? "pending"; // الافتراضي pending
  }




}
