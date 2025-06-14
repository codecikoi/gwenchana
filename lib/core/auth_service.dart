import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

// get current user

  User? get currentUser => _auth.currentUser;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // email sing in

  Future<UserCredential?> signInWithEmailPassword(
      String email, password) async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No account found with this email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        case 'user-disabled':
          errorMessage = 'This account has been disabled.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      throw errorMessage;
    }
  }

  // email sign up

  Future<UserCredential?> signUpWithEmailPassword(
      String email, password) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      return userCredential;
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'weak-password':
          errorMessage = 'The password provided is too weak.';
          break;
        case 'email-already-in-use':
          errorMessage = 'The account already exists for that email.';
          break;
        case 'invalid-email':
          errorMessage = 'The email address is not valid.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      throw errorMessage;
    }
  }

  // google sign in

  signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      // ignore: avoid_print
      print('error signing in with google: $e');
    }
  }
}
// facebook sign in

  // Future<UserCredential?> signInWithFacebook() async {
  //   final LoginResult loginResult = await FacebookAuth.instance.login();

  //   // Create a credential from the access token
  //   if (loginResult.status == LoginStatus.success &&
  //       loginResult.accessToken != null) {
  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.tokenString);
  //     return await FirebaseAuth.instance
  //         .signInWithCredential(facebookAuthCredential);
  //   } else {
  //     return null;
  //   }
  // }

  // sign out

//   Future<void> signOut() async {
//     await Future.wait([
//       _auth.signOut(),
//       _googleSignIn.signOut(),
//       FacebookAuth.instance.logOut(),
//     ]);
//   }
// }
