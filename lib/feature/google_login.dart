import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginManager {
  /// Google Login
  late final GoogleSignInAccount? googleUser;

  Future<User?> signInWithGoogle({required String androidClientId,required String iosClientId }) async {
    User? user;
    try {
      if (Platform.isAndroid) {
        googleUser = await GoogleSignIn(
                clientId:
                    androidClientId)
            .signIn();
      } else if (Platform.isIOS) {
        googleUser = await GoogleSignIn(
                clientId: iosClientId)
            .signIn();
      }


      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      user = userCredential.user;

      debugPrint("User Email --- ${user!.email}");
      return user;
    } catch (e) {
      debugPrint("$e");
    }
    return user;
  }
}
