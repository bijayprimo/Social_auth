import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class AppleLoginService {
  /// Generates a cryptographically secure random nonce, to be included in a
  /// credential request.
  String generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)])
        .join();
  }

  /// Returns the sha256 hash of [input] in hex notation.
  String sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  final _firebaseAuth = FirebaseAuth.instance;

  Future<User?> signInWithApple() async {
    User? user;
    try {
      // To prevent replay attacks with the credential returned from Apple, we
      // include a nonce in the credential request. When signing in with
      // Firebase, the nonce in the id token returned by Apple, is expected to
      // match the sha256 hash of `rawNonce`.
      final rawNonce = generateNonce();
      final nonce = sha256ofString(rawNonce);
      // Request credential for the currently signed in Apple account.
      AuthorizationCredentialAppleID? appleCredential;
      await SignInWithApple.getAppleIDCredential(
        webAuthenticationOptions: WebAuthenticationOptions(
          clientId: "com.dogexp.dogNews",
          //'de.lunaone.flutter.signinwithappleexample.service',

          redirectUri: kIsWeb
              ? Uri.parse(
                  'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple')
              : Uri.parse(
                  'https://dogexpress-30ff0.firebaseapp.com/__/auth/handler',
                ),
        ),
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      ).then((value) {
         appleCredential = value;
      }).onError((error, stackTrace) {
         appleCredential = null;
      }).whenComplete(() => print("done"));
   if(appleCredential!=null){
     // Create an `OAuthCredential` from the credential returned by Apple.
     final oauthCredential = OAuthProvider("apple.com").credential(
       idToken: appleCredential!.identityToken,
       rawNonce: rawNonce,
     );
     // Sign in the user with Firebase. If the nonce we generated earlier does
     // not match the nonce in `appleCredential.identityToken`, sign in will fail.
     UserCredential userCredential =
     await FirebaseAuth.instance.signInWithCredential(oauthCredential);

     user = userCredential.user;
     return user;
   }
    } catch (e, st) {
      debugPrint("Apple Login exception  $st ");
      debugPrint("Apple Login error  $e ");
      return user;
    }
  }
}
