import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);





  /// تسجيل الدخول بالبريد وكلمة المرور
  Future<User?> loginWithEmail(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    final user = credential.user;

    // نتأكد إنو الإيميل متحقق
    if (user != null && !user.emailVerified) {
      await _auth.signOut();
      throw FirebaseAuthException(
        code: 'email-not-verified',
        message: 'Please verify your email before logging in.',
      );
    }

    return user;
  }

  /// تسجيل الدخول عبر Google
  Future<User?> loginWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(accessToken: googleAuth.accessToken, idToken: googleAuth.idToken,);
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  /// تسجيل الخروج
  Future<void> signOut() async {
    await _auth.signOut();
    await _googleSignIn.signOut();
  }


  /// إنشاء حساب جديد
  Future<User?> registerWithEmail(String name, String email, String password) async {
    try {
      // إنشاء المستخدم
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        // تحديث اسم المستخدم
        await user.updateDisplayName(name);

        // إرسال رابط التحقق مباشرة بدون ActionCodeSettings
        if (!user.emailVerified) {
          await user.sendEmailVerification();
        }

        // تسجيل خروج بعد التسجيل
        await _auth.signOut();
      }

      return user;
    } catch (e) {
      print("حدث خطأ أثناء التسجيل: $e");
      return null;
    }
  }




  Future<User?> loginWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: credential.identityToken,
      accessToken: credential.authorizationCode,
    );

    final userCredential = await _auth.signInWithCredential(oauthCredential);
    return userCredential.user;
  }

}
