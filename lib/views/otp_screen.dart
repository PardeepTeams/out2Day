import 'package:firebase_auth/firebase_auth.dart';

import '../routes/app_routes.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/utils/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../controller/otp_controller.dart';
import '../widgets/common_button.dart';
import '../utils/colors.dart';

class OtpScreen extends StatelessWidget {
  OtpScreen({super.key});
  final OtpController controller = Get.put(OtpController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0), // Height zero taaki dikhe nahi
        child: AppBar(
          elevation: 0,
          backgroundColor: MyColors.white, // Status bar ka color yahan set karein
        ),
      ),
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [MyColors.gradient1, MyColors.gradient2],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child:
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [

                  Align(
                    alignment: AlignmentGeometry.centerLeft,
                    child:Padding(
                      padding: const EdgeInsets.only(left: 7,top: 7),
                      child: Container(
                          height: 45, // Figma de 63x63 nu Flutter layout de hisaab naal adjust kita hai
                          width: 45,
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: MyColors.black.withOpacity(0.1),
                                blurRadius: 10,
                                spreadRadius: 1,
                                offset: const Offset(0, 4), // Shadow nu thalle dikhaun layi
                              ),
                            ],
                          ),
                          child: IconButton(
                            padding: EdgeInsets.zero,
                            icon: const Icon(
                              Icons.arrow_back_ios_new, // Figma wala back icon
                              color: MyColors.black,
                              size: 18,
                            ),
                            onPressed: (){
                              FirebaseAuth.instance.signOut();
                              Get.back();
                            },
                          ),
                        ),
                    ) ,
                  ),

                  const SizedBox(height: 60),
                  Obx(() =>semiboldTextLarge2("00:${controller.seconds.value.toString().padLeft(2, '0')}"))
                  ,
                  const SizedBox(height: 5),
                  regularTextCenter("${AppStrings.otpVerificationMsg}"),
                  const SizedBox(height: 40),

                  /// OTP Fields
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(6, (index) {
                      return SizedBox(
                        width: 50,   // 👈 perfect square width
                        height: 50,  // 👈 same height
                        child: TextField(
                          controller: controller.textControllers[index],
                          focusNode: controller.focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: InputDecoration(
                            counterText: "",
                            filled: true,
                            fillColor: Colors.white,
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 1),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(color: Colors.black, width: 2),
                            ),
                            contentPadding: EdgeInsets.zero, // 👈 padding remove for perfect square
                          ),
                          onChanged: (value) => controller.onChanged(value, index),
                        ),
                      );
                    }),
                  ),


                  const SizedBox(height: 30),

                  /// Verify Button
                  Obx(() => CommonButton(
                    title: AppStrings.verify,
                    isLoading: controller.isLoading.value,
                    onTap: (){
                      dismissKeyboard(context);
                      controller.verifyOtp(context);
                    },
                  )),

                  const SizedBox(height: 5),

                  /// Resend OTP
                  /// Resend OTP Section
         /*         Align(
                    alignment: Alignment.center,
                    child: Obx(() {
                      return controller.isResendAvailable.value
                          ? GestureDetector(
                        onTap: () {
                          dismissKeyboard(context);
                          controller.resendOtp(context);
                        },
                        child: const Text(
                          AppStrings.resendOTP,
                          style: TextStyle(
                            fontFamily: "medium",
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: MyColors.black,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ):SizedBox();
                          *//*: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: "regular",
                            fontSize: 16,
                            color: MyColors.black,
                          ),
                          children: [
                            const TextSpan(text: "Resend OTP in "),
                            TextSpan(
                              text: "00:${controller.seconds.value.toString().padLeft(2, '0')}",
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      );*//*
                    }),
                  )*/
                  Align(
                    alignment: Alignment.center,
                    child: Obx(() {
                      return controller.isResendAvailable.value
                          ?  RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(
                            fontFamily: "regular",
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: MyColors.black,
                          ),
                          children: [
                            const TextSpan(
                              text: AppStrings.resendOTPTime,
                            ),
                            WidgetSpan(
                              child: GestureDetector(
                                onTap: () {
                                  dismissKeyboard(context);
                                  if( controller.isResendAvailable.value)
                                    controller.resendOtp(context);
                                },
                                child: const Text(
                                  AppStrings.resendOTP,
                                  style: TextStyle(
                                    fontFamily: "medium",
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                    color: MyColors.black,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ):SizedBox();
                    }
                  ))
                ],
              ),
            )),

        ),
      ),
    );
  }
}
