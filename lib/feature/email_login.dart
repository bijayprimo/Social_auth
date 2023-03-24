import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailLogin {

  /// Create a New user
  Future<User?> createUserViaEmail(
      {required String email,
      required String password,
      required Function(FirebaseAuthException e) onError}) async {
    User? user;
    debugPrint("create via email");
    try {
      final credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      user = credential.user;
      if (user != null) {
        debugPrint("User Email --- ${credential.user}");
      } else {
        debugPrint("User Email --- ${credential.user}");
      }
    } on FirebaseAuthException catch (e) {
      onError(e);
      if (e.code == 'user-not-found') {
        debugPrint('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        debugPrint('Wrong password provided for that user.');
      }
    } catch (e) {
      debugPrint('Exception Create User $e');
    }
    return user;
  }

  /// Login User If Already Present in the database
  Future<User?> loginViaEmail(
      {required String email,
      required String password,
      required Function(FirebaseAuthException e) onError}) async {
    User? user;
    debugPrint("login via email");
    try {
      final credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      user = credential.user;
      if (user != null) {
        debugPrint("User Email --- ${credential.user}");
      } else {
        debugPrint("User Email --- ${credential.user}");
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        user = await createUserViaEmail(
            email: email,
            password: password,
            onError: (FirebaseAuthException e) {
              onError(e);
            });
        debugPrint('No user found for that email.');
      } else {
        onError(e);
        debugPrint('Wrong password provided for that user.');
      }
    } catch (e) {
      debugPrint('Exception Login  $e');
    }
    return user;
  }
}
