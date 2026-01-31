import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<UserCredential> login({required String email, required String password}) async {
    return await _auth.signInWithEmailAndPassword(email: email, password: password);
  }

  Future<UserCredential> signup({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(fullName.trim());
    return cred;
  }

  Future<void> sendEmailVerification() async {
    final user = _auth.currentUser;
    await user?.sendEmailVerification();
  }

  Future<void> sendResetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email.trim());
    } on FirebaseAuthException catch (e) {
      throw e;
    }
  }

  String mapAuthCodeToKey(String code) {
    switch (code) {
      case 'user-not-found':
        return 'errUserNotFound';
      case 'wrong-password':
        return 'errWrongPassword';
      case 'invalid-email':
        return 'errInvalidEmail';
      case 'user-disabled':
        return 'errUserDisabled';
      case 'invalid-credential':
        return 'errWrongPassword';
      default:
        return 'errGeneric';
    }
  }
}