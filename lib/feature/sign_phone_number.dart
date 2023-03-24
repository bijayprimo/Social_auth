import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:get/get.dart';

class PhoneAuthenticationService {
  final BuildContext context;

  FirebaseAuth auth = FirebaseAuth.instance;
  String? verificationId ="";

  PhoneAuthenticationService( {required this.context});

  /// Send OTP
  Future<void> registerUser(
      {required BuildContext context,required String countryCode,
        required String mobile,
        String? verificationId,
        int? resendToken,
        String? routes}
      ) async {

    Loader.show(context);
  debugPrint("mobile $mobile");
  debugPrint("county code $countryCode");
    await auth.verifyPhoneNumber(
      phoneNumber: "$countryCode $mobile",
      verificationCompleted: (PhoneAuthCredential credential) {
        Loader.hide();
        debugPrint("completed ----  ${credential.smsCode}");
        Get.snackbar("Verification Code", "${credential.smsCode}",
            backgroundColor: Colors.black, colorText: Colors.white60);
      },
      verificationFailed: (FirebaseAuthException e) {
        Loader.hide();
        if (e.code == 'invalid-phone-number') {
          debugPrint('The provided phone number is not valid.');
          Get.snackbar(
            "Verification",
            "The provided phone number is not valid.",
          );
        }
      },
      codeSent: (String verificationId, int? resendToken) {
        Loader.hide();
        this.verificationId= verificationId;
        resendToken = resendToken;
        debugPrint("otp code ---- $resendToken");

        if(routes!=null) {
          Navigator.of(context).pushNamed(
              routes, arguments: verificationId);
        }
        else{

        }
      },
      timeout: const Duration(seconds: 25),
      forceResendingToken: resendToken,
      codeAutoRetrievalTimeout: (String verificationId) {
        Loader.hide();
        verificationId = verificationId;
      },
    );
  }



  /// Otp Verification
  Future verifyOtp({required BuildContext context,required String verificationId,required String otp}) async {
    PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId:verificationId, smsCode: otp
    );
    debugPrint("Credential ----- ${credential.smsCode}");
    await auth.signInWithCredential(credential);
  }

}