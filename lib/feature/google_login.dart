import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class LoginManager {
  /// Google Login
  late final GoogleSignInAccount? googleUser;


  Future<User?> signInWithGoogle({required String androidClientId,required String iosClientId }) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;


    // Check if the user is already signed in with Facebook.
    final User? user = _auth.currentUser;
    if (user != null) {
      // The user is not signed in. Show an error message and return.


      final List<String> providerIds = await user!.providerData.map((e) =>
      e.providerId).toList();
      if (providerIds.contains('facebook.com')) {
        // The user is not signed in with Facebook. Show an error message and return.


        // Get the Facebook access token for the user.
        final LoginResult result = await FacebookAuth.instance.login();
        if (result.status == LoginStatus.success) {
          // The Facebook login failed. Show an error message and return.

          final AccessToken accessToken = result.accessToken!;
          final String facebookAccessToken = accessToken.token;


          User? userGooglge;
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

            if (googleUser != null) {
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
              userGooglge = userCredential.user;

              debugPrint("User Email --- ${userGooglge!.email}");
              return user;
            }
          } catch (e) {
            debugPrint("Error $e");
          }
          return user;
        }
      }
    }
  }
}
