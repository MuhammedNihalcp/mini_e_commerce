import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../service/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  User? user;

  AuthProvider() {
    _authService.userChanges.listen((u) {
      user = u;
      notifyListeners();
    });
  }

  Future<void> signInEmail(String email, String password) async {
    await _authService.signInWithEmail(email, password).then((data) {
      if (data == null) {
        // print("Google Sign-In failed");
        user = null;
      } else {
        user = data;
      }
    });
    notifyListeners();
  }

  Future<void> registerEmail(String email, String password) async =>
      await _authService.registerWithEmail(email, password);

  Future<void> signInWithGoogle() async {
    await _authService.signInWithGoogle().then((data) {
      if (data == null) {
        // print("Google Sign-In failed");
        user = null;
      } else {
        user = data;
      }
    });
    notifyListeners();
  }

  Future<void> signOut() async => await _authService.signOut();
}
