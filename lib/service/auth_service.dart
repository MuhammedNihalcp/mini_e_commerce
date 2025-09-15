import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  User? _user;
  User? get user => _user;

  bool _isSignedin = false;
  bool get isSignedIn => _isSignedin;

  Stream<User?> get userChanges => _auth.authStateChanges();

  // Sign in an existing user with email and password.
  // Returns a Future that completes with a UserCredential if successful.
  Future<User?> signInWithEmail(String email, String password) async {
    final userCredential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );

    return userCredential.user;
  }

  // Register (create) a new user using email and password.
  // Returns a Future that completes with a UserCredential if successful.
  Future<UserCredential> registerWithEmail(String email, String password) =>
      _auth.createUserWithEmailAndPassword(email: email, password: password);

  // Sign out the currently logged-in user.
  // Returns a Future that completes when the sign-out is successful.
  Future<void> signOut() => _auth.signOut();

  Future<User?> signInWithGoogle() async {
    try {
      // Step 1: Trigger Google Sign-In
      final account = await _googleSignIn.authenticate(
        scopeHint: ['email', 'profile'],
      );

      // Step 2: Get authentication tokens
      final GoogleSignInAuthentication googleAuth = account.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
      );

      // Step 3: Sign in with Firebase
      final userCredential = await _auth.signInWithCredential(credential);

      return userCredential.user;
    } catch (e) {
      print("Error during Google Sign-In: $e");
      return null;
    }
  }
}
