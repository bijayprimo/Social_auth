library authentication;

import 'package:authentication/feature/AuthAbstrsact.dart';
import 'package:authentication/feature/apple_login.dart';
import 'package:authentication/feature/email_login.dart';
import 'package:authentication/feature/facebook_login.dart';
import 'package:authentication/feature/google_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'feature/sign_phone_number.dart';

class AuthManager extends AuthAbstract{


  @override
  Future<User?> googleLogin({required String androidClientId,required String iosClientId }) async{
  return await LoginManager().signInWithGoogle(androidClientId: androidClientId, iosClientId: iosClientId);
  }

  @override
  Future<User?> facebookLogin() async{
    return await FacebookManager().signInWithFacebook();
  }

  @override
  Future<User?> appleLogin() async{
    return await AppleLoginService().signInWithApple();
  }

  @override
  Future<void> phoneLogin({required BuildContext context,required String countryCode,
    required String mobile,
    String? verificationId,
    int? resendToken,
    String? routes}) async{

    PhoneAuthenticationService(context: context).registerUser(context: context, countryCode: countryCode, mobile: mobile,routes: routes);
  }

  @override
  Future<void> verifyOtp({required BuildContext context,required String verificationId,required String otp}) async {
     PhoneAuthenticationService(context: context).verifyOtp(context:context,verificationId: verificationId, otp: otp);
  }

  @override
  Future<User?> emailLogin({required String email, required String password,required Function(FirebaseAuthException e) onError}) async  {
    return await EmailLogin().loginViaEmail(email: email, password: password, onError:  onError);
  }
}
