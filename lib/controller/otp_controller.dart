/*
import 'dart:async';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/api_service.dart';
import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';

class OtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxList<String> otp = List.generate(6, (index) => "").obs;

  late List<TextEditingController> textControllers;
  late List<FocusNode> focusNodes;
  var isLoading = false.obs;
  var seconds = 30.obs;
  var isResendAvailable = false.obs;

  String phone = "";
  String countryCode = "";
  String verificationId = "";
  // Timer reference
  Timer? _timer;


  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      phone = Get.arguments['phone'];
      countryCode = Get.arguments['countryCode'];
      verificationId = Get.arguments['verificationId'];
    }
    textControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
    startTimer();
  }

  /// Called whenever user types in an OTP field
  void onChanged(String value, int index) {
    if (value.length > 1) {
      value = value.substring(value.length - 1);
      textControllers[index].text = value;
    }
    otp[index] = value;

    // Move focus forward
    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }

    // Move focus backward
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get otpCode => otp.join();

  /// Verify OTP
  void verifyOtp(BuildContext context) async {
    if (otpCode.length < 6) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.enterOTP);
      return;
    }
    isLoading.value = false;
    try {
      MyProgressBar.showLoadingDialog(context: context);
      final credential = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otpCode,
      );

      await _auth.signInWithCredential(credential);
      int status = await ApiService().loginApi(
          countryCode: countryCode,
          phone: phone
      );
      if (status == 1) {
        isLoading.value = false;
        MyProgressBar.hideLoadingDialog(context: context);
        Get.offAllNamed(AppRoutes.home);
      } else if (status == 0) {
        isLoading.value = false;
        MyProgressBar.hideLoadingDialog(context: context);
        Get.offNamed(AppRoutes.profileCreation,arguments: {
          'phone': phone, // Tuhada phone number
          'countryCode': countryCode,
        });
      }
    } catch (e) {
      isLoading.value = false;
      MyProgressBar.hideLoadingDialog(context: context);
      Get.snackbar("Error", "Invalid OTP");
    }
    */
/*Get.offAllNamed(AppRoutes.profileCreation,arguments: {
      'phone': phone, // Tuhada phone number
      'countryCode': countryCode,
    });*//*

   */
/* Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      MyProgressBar.hideLoadingDialog(context: context);
      Get.offAllNamed(AppRoutes.profileCreation,arguments: {
        'phone': phone, // Tuhada phone number
        'countryCode': countryCode,
      });
    });*//*

  }

  /// Start the resend timer
  void startTimer() {
    isResendAvailable.value = false;
    seconds.value = 30;

    // Cancel existing timer if any
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        isResendAvailable.value = true;
        timer.cancel();
      }
    });
  }

  /// Resend OTP
  void resendOtp(BuildContext context) async {
    otp.fillRange(0, 6, "");
    textControllers.forEach((t) => t.clear());
    startTimer();
*/
/*    MyProgressBar.showLoadingDialog(context: context);
    await _auth.verifyPhoneNumber(
      phoneNumber: countryCode + phone,
      timeout: const Duration(seconds: 60),
      verificationCompleted: (credential) {},
      verificationFailed: (e) {
        isLoading.value = false;
        MyProgressBar.hideLoadingDialog(context: context);
        showCommonSnackbar(title: "Error", message: e.message ?? "Something went wrong");
      },
      codeSent: (verId, token) {
        MyProgressBar.hideLoadingDialog(context: context);
        verificationId = verId;
        isLoading.value = false;
        showCommonSnackbar(title: AppStrings.otpText, message: AppStrings.otpResent,);
      },
      codeAutoRetrievalTimeout: (verId) {
        MyProgressBar.hideLoadingDialog(context: context);
        verificationId = verId;
        isLoading.value = false;
        showCommonSnackbar(title: AppStrings.otpText, message: AppStrings.otpResent,);
      },
    );*//*


  }

  @override
  void onClose() {
    // Dispose all controllers and focus nodes
    textControllers.forEach((t) => t.dispose());
    focusNodes.forEach((f) => f.dispose());
    _timer?.cancel(); // cancel timer
    super.onClose();
  }
}
*/
import 'dart:async';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter/foundation.dart' show kIsWeb; // ✅ Web support ke liye

import '../api/api_service.dart';
import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';


class OtpController extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  RxList<String> otp = List.generate(6, (index) => "").obs;

  late List<TextEditingController> textControllers;
  late List<FocusNode> focusNodes;
  var isLoading = false.obs;
  var seconds = 30.obs;
  var isResendAvailable = false.obs;

  String phone = "";
  String countryCode = "";
  String verificationId = "";

  // ✅ Web support ke liye extra variables
  bool isWeb = false;
  ConfirmationResult? confirmationResult;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      phone = Get.arguments['phone'] ?? "";
      countryCode = Get.arguments['countryCode'] ?? "";
      isWeb = Get.arguments['isWeb'] ?? false;

      if (isWeb) {
        // Web ke liye confirmationResult use hota hai
        confirmationResult = Get.arguments['confirmationResult'];
      } else {
        // Mobile ke liye verificationId
        verificationId = Get.arguments['verificationId'] ?? "";
      }
    }
    textControllers = List.generate(6, (index) => TextEditingController());
    focusNodes = List.generate(6, (index) => FocusNode());
    startTimer();
  }

  void onChanged(String value, int index) {
    if (value.length > 1) {
      value = value.substring(value.length - 1);
      textControllers[index].text = value;
    }
    otp[index] = value;

    if (value.isNotEmpty && index < 5) {
      focusNodes[index + 1].requestFocus();
    }
    if (value.isEmpty && index > 0) {
      focusNodes[index - 1].requestFocus();
    }
  }

  String get otpCode => otp.join();

  /// 🔥 VERIFY OTP (Updated for Web & Mobile)
  void verifyOtp(BuildContext context) async {
    if (otpCode.length < 6) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.enterOTP);
      return;
    }

    try {
      MyProgressBar.showLoadingDialog(context: context);

      UserCredential? userCredential;

      if (isWeb && confirmationResult != null) {
        // ✅ WEB FLOW: confirmationResult.confirm use karein
        userCredential = await confirmationResult!.confirm(otpCode);
      } else {
        // ✅ MOBILE FLOW: PhoneAuthProvider use karein
        final credential = PhoneAuthProvider.credential(
          verificationId: verificationId,
          smsCode: otpCode,
        );
        userCredential = await _auth.signInWithCredential(credential);
      }

      // Agar Sign in success ho gaya, toh API call karein
      if (userCredential.user != null) {
        int status = await ApiService().loginApi(
            countryCode: countryCode,
            phone: phone
        );

        MyProgressBar.hideLoadingDialog(context: context);

        if (status == 1) {
          Get.offAllNamed(AppRoutes.home);
        } else {
          // status 0 ya kisi aur case mein Profile Creation par bhejein
          Get.offNamed(AppRoutes.profileCreation, arguments: {
            'phone': phone,
            'countryCode': countryCode,
          });
        }
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      print("OTP Verification Error: $e");
      Get.snackbar("Error", "Invalid OTP or Session Expired");
    }
  }

  void startTimer() {
    isResendAvailable.value = false;
    seconds.value = 30;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (seconds.value > 0) {
        seconds.value--;
      } else {
        isResendAvailable.value = true;
        timer.cancel();
      }
    });
  }

  void resendOtp(BuildContext context) async {
/*    otp.fillRange(0, 6, "");
    textControllers.forEach((t) => t.clear());
    startTimer();*/

    MyProgressBar.showLoadingDialog(context: context);
    if(kIsWeb){
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
          final result = await _auth.signInWithPhoneNumber(countryCode + phone, verifier);

          // ✅ STEP: SMS send hone ke baad verifier ko clear karein taaki box hat jaye
          verifier.clear();

          confirmationResult = result;
          MyProgressBar.hideLoadingDialog(context: context);

        } catch (e) {
          verifier.clear(); // Error aane par bhi clear karein
          MyProgressBar.hideLoadingDialog(context: context);
          print("Web Auth Error Trace: $e");
          showCommonSnackbar(title: "Auth Error", message: "Error: ${e.toString()}");
        }

      }
    }else{
      await _auth.verifyPhoneNumber(
        phoneNumber: countryCode + phone,
        timeout: const Duration(seconds: 60),
        verificationCompleted: (credential) {},
        verificationFailed: (e) {
          isLoading.value = false;
          MyProgressBar.hideLoadingDialog(context: context);
          showCommonSnackbar(title: "Error", message: e.message ?? "Something went wrong");
        },
        codeSent: (verId, token) {
          MyProgressBar.hideLoadingDialog(context: context);
          verificationId = verId;
          isLoading.value = false;
          showCommonSnackbar(title: AppStrings.otpText, message: AppStrings.otpResent,);
        },
        codeAutoRetrievalTimeout: (verId) {
          MyProgressBar.hideLoadingDialog(context: context);
          verificationId = verId;
          isLoading.value = false;
          showCommonSnackbar(title: AppStrings.otpText, message: AppStrings.otpResent,);
        },
      );
    }



  }



  @override
  void onClose() {
    textControllers.forEach((t) => t.dispose());
    focusNodes.forEach((f) => f.dispose());
    _timer?.cancel();
    super.onClose();
  }
}