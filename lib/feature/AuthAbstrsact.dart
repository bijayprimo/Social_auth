import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

abstract class AuthAbstract{

  Future<User?> googleLogin({required String androidClientId,required String iosClientId });
  Future<User?> appleLogin();
  Future<User?> facebookLogin();
  Future<User?> emailLogin({required String email,required String password,required Function(FirebaseAuthException e) onError});

  Future<void> phoneLogin({required BuildContext context,required String countryCode,
    required String mobile,
    String? verificationId,
    int? resendToken,
    String? routes});
  Future<void> verifyOtp({required BuildContext context,required String verificationId,required String otp});
}