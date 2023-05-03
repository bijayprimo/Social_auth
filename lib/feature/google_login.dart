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

if(googleUser!= null){
      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth =
      await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      try {
        final userCredent = await FirebaseAuth.instance.currentUser
            ?.linkWithCredential(credential);
      } on FirebaseAuthException catch (e) {
        switch (e.code) {
          case "provider-already-linked":
            print("The provider has already been linked to the user.");
            break;
          case "invalid-credential":
            print("The provider's credential is not valid.");
            break;
          case "credential-already-in-use":
            print("The account corresponding to the credential already exists, "
                "or is already linked to a Firebase User.");
            break;
        // See the API reference for the full list of error codes.
          default:
            print("Unknown error.");
        }
      }


      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithCredential(credential);
      user = userCredential.user;

      debugPrint("User Email --- ${user!.email}");
      return user;
    }
    } catch (e) {
      debugPrint("Error $e");
    }
    return user;
  }
}
