import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class FacebookManager {

  /// Facebook Login
  Future<User?> signInWithFacebook() async {
    try {
      // Trigger the sign-in flow
      final LoginResult loginResult = await FacebookAuth.instance.login(permissions: ['email']);

      print("login result ----- ${loginResult.message}");

      // Create a credential from the access token
      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithCredential(facebookAuthCredential);
      User? user = userCredential.user;
      print("User Email --- ${user!.email}");
      // Once signed in, return the UserCredential
      return user;
    } catch (e) {
      debugPrint("facebook Exception    $e");
    }
  }
}
