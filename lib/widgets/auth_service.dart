import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth;

  AuthService({FirebaseAuth? auth}) : _auth = auth ?? FirebaseAuth.instance;

  Future<UserCredential> login({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(email: email.trim(), password: password);
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

  Future<void> sendResetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  String mapAuthCodeToKey(String code) {
    switch (code) {
      case 'wrong-password':
        return 'errWrongPassword';
      case 'user-not-found':
        return 'errUserNotFound';
      case 'email-already-in-use':
        return 'errEmailInUse';
      case 'weak-password':
        return 'errWeakPassword';
      case 'too-many-requests':
        return 'errTooManyRequests';
      default:
        return 'errGeneric';
    }
  }
}
