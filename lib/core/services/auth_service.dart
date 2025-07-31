import 'package:firebase_auth/firebase_auth.dart';

abstract class IAuthService {
  User? get currentUser;
  Stream<User?> get authStateChanges;

  Future<UserCredential?> signInWithEmailPassword(
      String email, String password);
  Future<UserCredential?> signUpWithEmailPassword(
      String email, String password);

  Future<UserCredential?> signInWithGoogle();
  Future<UserCredential?> signInWithFacebook();
  Future<void> signOut();
  Future<void> resetPassword(String email);
  Future<void> reauthenticateAndDelete(String password);
}
