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
  /*  if (otpCode.length < 6) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.enterOTP);
      return;
    }*/

    isLoading.value = false;
  //  MyProgressBar.showLoadingDialog(context: context);
   /* try {
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
    }*/
    Get.offAllNamed(AppRoutes.profileCreation,arguments: {
      'phone': phone, // Tuhada phone number
      'countryCode': countryCode,
    });
   /* Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      MyProgressBar.hideLoadingDialog(context: context);
      Get.offAllNamed(AppRoutes.profileCreation,arguments: {
        'phone': phone, // Tuhada phone number
        'countryCode': countryCode,
      });
    });*/
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
    );*/

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
