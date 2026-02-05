/*
import 'package:Out2Do/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

import '../utils/my_progress_bar.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();

  RxString countryCode = "+1".obs;
  final countryPicker = const FlCountryCodePicker(); // Instance
  var countryFlag = "🇮🇳".obs; // Optional: Flag dikhane ke liy
  RxBool isLoading = false.obs;
  String verificationId = "";

  void setCountryCode(String code) {
    countryCode.value = code;
  }

*/
/*  void login(BuildContext context) async {

    if (phoneController.text.isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.enterPhone);
      return;
    }

    final phoneNumber ="${countryCode.value}${phoneController.text}";

    isLoading.value = false;


    MyProgressBar.showLoadingDialog(context: context);
    await _auth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) {},
      verificationFailed: (e) {
        isLoading.value = false;
        MyProgressBar.hideLoadingDialog(context: context);
        print("SMSError ${e.message}");
        showCommonSnackbar(title: "Error",message:  e.message ?? "Something went wrong");
      },
      codeSent: (verId, token) {
        MyProgressBar.hideLoadingDialog(context: context);
        verificationId = verId;
        isLoading.value = false;
        Get.offNamed(AppRoutes.otp,arguments: {
          'phone': phoneController.text.trim(), // Tuhada phone number
          'countryCode': countryCode.value,
          "verificationId" : verificationId
        });
      },
      codeAutoRetrievalTimeout: (verId) {
        MyProgressBar.hideLoadingDialog(context: context);
        verificationId = verId;
        isLoading.value = false;
        Get.offNamed(AppRoutes.otp,arguments: {
          'phone': phoneController.text.trim(), // Tuhada phone number
          'countryCode': countryCode.value,
          'verificationId': verificationId,
        });
      },
    );


    // 🔥 API / Firebase call here
   *//*
*/
/* Get.toNamed(AppRoutes.otp,arguments: {
      'phone': phoneController.text.trim(), // Tuhada phone number
      'countryCode': countryCode.value,
      'verificationId': verificationId,
    });*//*
*/
/*

  }*//*






// ... class ke andar ...

  void login(BuildContext context) async {
    if (phoneController.text.isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.enterPhone);
      return;
    }

    final phoneNumber = "${countryCode.value}${phoneController.text}";
    MyProgressBar.showLoadingDialog(context: context);

    try {
      if (kIsWeb) {
        // ✅ WEB LOGIC
        // Invisible reCAPTCHA ya Normal ke liye verifier create karein
        ConfirmationResult confirmationResult = await _auth.signInWithPhoneNumber(
          phoneNumber,
          RecaptchaVerifier(
            // ✅ delegates ko use karein FirebaseAuthPlatform ki requirement poori karne ke liye
            auth: _auth as dynamic,
            container: 'recaptcha-container',
            size: RecaptchaVerifierSize.normal,
            theme: RecaptchaVerifierTheme.light,
          ),
        );

        MyProgressBar.hideLoadingDialog(context: context);

        // Web mein verificationId ki jagah confirmationResult pass karna hota hai
        Get.offNamed(AppRoutes.otp, arguments: {
          'phone': phoneController.text.trim(),
          'countryCode': countryCode.value,
          'confirmationResult': confirmationResult, // Isse OTP confirm hoga
          'isWeb': true
        });

      } else {
        // ✅ MOBILE LOGIC (Aapka purana code)
        await _auth.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (credential) {},
          verificationFailed: (e) {
            MyProgressBar.hideLoadingDialog(context: context);
            print("SMSError ${e.message}");
            showCommonSnackbar(title: "Error", message: e.message ?? "Something went wrong");
          },
          codeSent: (verId, token) {
            MyProgressBar.hideLoadingDialog(context: context);
            verificationId = verId;
            Get.offNamed(AppRoutes.otp, arguments: {
              'phone': phoneController.text.trim(),
              'countryCode': countryCode.value,
              "verificationId": verificationId,
              'isWeb': false
            });
          },
          codeAutoRetrievalTimeout: (verId) {
            verificationId = verId;
          },
        );
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      showCommonSnackbar(title: "Error", message: e.toString());
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
*/
import 'package:Out2Do/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';

class LoginController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController phoneController = TextEditingController();

  RxString countryCode = "+1".obs;
  final countryPicker = const FlCountryCodePicker();
  RxBool isLoading = false.obs;
  String verificationId = "";
  ConfirmationResult? confirmationResult;
  String? deviceToken;

  void setCountryCode(String code) {
    countryCode.value = code;
  }

  @override
  void onInit() {
    super.onInit();
    getToken();

    if (Get.arguments != null) {
      phoneController.text = Get.arguments['phone'] ?? "";
      countryCode.value = Get.arguments['countryCode'] ?? "";
    }
  }

  /// 🔥 MAIN LOGIN FUNCTION
  void login(BuildContext context) async {
    // 1. Validation
    if (phoneController.text.isEmpty) {
      showCommonSnackbar(
          title: AppStrings.errorText,
          message: AppStrings.enterPhone
      );
      return;
    }

    final phoneNumber = "${countryCode.value}${phoneController.text.trim()}";
    MyProgressBar.showLoadingDialog(context: context);

    try {
      if (kIsWeb) {
        final verifier = RecaptchaVerifier(
          auth: FirebaseAuthPlatform.instance,
          container: 'recaptcha-container',
          size: RecaptchaVerifierSize.compact,
          theme: RecaptchaVerifierTheme.light,
        );

        try {
          await verifier.render();

          // SMS bhejein
          final result = await _auth.signInWithPhoneNumber(phoneNumber, verifier);

          // ✅ STEP: SMS send hone ke baad verifier ko clear karein taaki box hat jaye
          verifier.clear();

          confirmationResult = result;
          MyProgressBar.hideLoadingDialog(context: context);
          Get.toNamed(AppRoutes.otp, arguments: {
            'phone': phoneController.text.trim(),
            'countryCode': countryCode.value,
            'isWeb': true,
            "deviceToken":deviceToken,
            'confirmationResult': result,
          });
        } catch (e) {
          verifier.clear(); // Error aane par bhi clear karein
          MyProgressBar.hideLoadingDialog(context: context);
          print("Web Auth Error Trace: $e");
          showCommonSnackbar(title: "Auth Error", message: "Error: ${e.toString()}");
        }

      } else {
        if(verificationId.isNotEmpty){
          verificationId = "";
        }
        final FirebaseAuth _auth1 = FirebaseAuth.instance;
        await _auth1.verifyPhoneNumber(
          phoneNumber: phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: (PhoneAuthCredential credential) async {
            // Android par kabhi kabhi auto-verify ho jata hai
            // await _auth.signInWithCredential(credential);
          },
          verificationFailed: (FirebaseAuthException e) {
            MyProgressBar.hideLoadingDialog(context: context);
            print("SMSError: ${e.message}");
            showCommonSnackbar(
                title: "Verification Failed",
                message: e.message ?? "Something went wrong"
            );
          },
          codeSent: (String verId, int? resendToken) {
            MyProgressBar.hideLoadingDialog(context: context);
            verificationId = verId;

            Get.toNamed(AppRoutes.otp, arguments: {
              'phone': phoneController.text.trim(),
              'countryCode': countryCode.value,
              'verificationId': verificationId,
              'isWeb': false,
              "deviceToken":deviceToken,
              'confirmationResult': null, // Web placeholder
            });
          },
          codeAutoRetrievalTimeout: (String verId) {
            verificationId = verId;
            MyProgressBar.hideLoadingDialog(context: context);
            verificationId = verId;

            Get.toNamed(AppRoutes.otp, arguments: {
              'phone': phoneController.text.trim(),
              'countryCode': countryCode.value,
              'verificationId': verificationId,
              'isWeb': false,
              "deviceToken":deviceToken,
              'confirmationResult': null, // Web placeholder
            });
          },
        );
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      print("Login Error: $e");
      showCommonSnackbar(title: "Error", message: e.toString());
    }
  }

  void getToken()async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    String? token = await messaging.getToken(
        vapidKey: "BERopO2oEVrT8bDna0UeU3UaGNgAlSUH6Gfc2TVUZQZ5J8iNPwuXFY2nzXbXxixc-vmhhYQeZga44Pgciv7jN14"
    );
    deviceToken = token;
    print("token  $token");
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}