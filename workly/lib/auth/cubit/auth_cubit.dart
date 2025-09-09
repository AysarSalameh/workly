import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:projects_flutter/auth/auth_service.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthService _authService;

  AuthCubit(this._authService) : super(AuthInitial());

  // 🔹 helper لدوال معالجة الأخطاء
  String _getFirebaseErrorMessage(FirebaseAuthException e, {String? defaultMessage}) {
    switch (e.code) {
      case 'invalid-email':
        return "The email address is badly formatted.";
      case 'user-disabled':
        return "This user has been disabled.";
      case 'user-not-found':
        return "No user found with this email.";
      case 'wrong-password':
        return "Incorrect password. Please try again.";
      default:
        return defaultMessage ?? "Unknown error happened, please try again.";
    }
  }

  Future<void> loginWithEmail(String email, String password) async {
    emit(AuthLoading());
    try {
      final user = await _authService.loginWithEmail(email, password);
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Login failed. Please try again."));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e)));
    } catch (_) {
      emit(AuthFailure("Unexpected error occurred. Please try again."));
    }
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
      emit(AuthFailure(_getFirebaseErrorMessage(e, defaultMessage: "Registration failed")));
    } catch (_) {
      emit(AuthFailure("Unexpected error occurred. Please try again."));
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
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e, defaultMessage: "Google Sign-In failed")));
    } catch (_) {
      emit(AuthFailure("Google Sign-In failed"));
    }
  }

  Future<void> loginWithApple() async {
    emit(AuthLoading());
    try {
      final user = await _authService.loginWithApple();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthFailure("Apple Sign-In canceled"));
      }
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e, defaultMessage: "Apple Sign-In failed")));
    } catch (_) {
      emit(AuthFailure("Apple Sign-In failed"));
    }
  }

  Future<void> loginWithGoogleWeb() async {
    emit(AuthLoading());
    try {
      GoogleAuthProvider googleProvider = GoogleAuthProvider();
      googleProvider.addScope('email');
      googleProvider.addScope('profile');

      final userCredential = await FirebaseAuth.instance.signInWithPopup(googleProvider);
      emit(AuthSuccess(userCredential.user!));
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e, defaultMessage: "Google Web Sign-In failed")));
    } catch (e) {
      emit(AuthFailure("Google Web Sign-In failed: ${e.toString()}"));
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
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(_getFirebaseErrorMessage(e, defaultMessage: "Apple Web Sign-In failed")));
    } catch (e) {
      emit(AuthFailure("Apple Web Sign-In failed: ${e.toString()}"));
    }
  }

  void logout() async {
    await _authService.signOut();
    emit(AuthInitial());
  }

  Future<String> checkProfileCompletionByEmail(String email) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Employee')
        .where('email', isEqualTo: email)
        .limit(1)
        .get();

    if (querySnapshot.docs.isEmpty) return "incomplete";

    final data = querySnapshot.docs.first.data();
    final isComplete = data['name'] != null &&
        data['birthDate'] != null &&
        data['Id'] != null &&
        data['phoneNumber'] != null;

    if (!isComplete) return "incomplete";
    return data['hrStatus'] ?? "pending";
  }
}
