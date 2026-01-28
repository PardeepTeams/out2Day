import 'package:Out2Do/utils/app_strings.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import 'package:fl_country_code_picker/fl_country_code_picker.dart';

import '../utils/my_progress_bar.dart';

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

  void login(BuildContext context) async {

  /*  if (phoneController.text.isEmpty) {
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
    );*/


    // 🔥 API / Firebase call here
    Get.toNamed(AppRoutes.otp,arguments: {
      'phone': phoneController.text.trim(), // Tuhada phone number
      'countryCode': countryCode.value,
      'verificationId': verificationId,
    });
  /*  Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;
      MyProgressBar.hideLoadingDialog(context: context);

    });*/
  }

  @override
  void onClose() {
    phoneController.dispose();
    super.onClose();
  }
}
