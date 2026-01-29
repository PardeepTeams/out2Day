import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/utils/colors.dart';
import 'package:Out2Do/utils/common_styles.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/login_controller.dart';
import '../widgets/common_text_field.dart';
import '../widgets/common_button.dart';
import 'package:flutter/gestures.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({super.key});

  final LoginController controller = Get.put(LoginController());

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
        decoration:  BoxDecoration(
          gradient: LinearGradient(
            colors: [
              MyColors.gradient1,
              MyColors.gradient2,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 1.0],
          ),
        ),

        child: SafeArea(
          child: SingleChildScrollView( // 👈 Scroll if keyboard opens
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 60),

                  /// 👋 Welcome Text
                  semiboldTextLarge(
                    AppStrings.loginWelcome,
                  ),
                  const SizedBox(height: 5),
                  regularText(
                    AppStrings.loginWelcomeDes
                  ),
                  const SizedBox(height: 60),

                  /// 📱 Phone Input Row
                  Row(
                    children: [
                      /// Country Code Picker Box
                      Obx(() => InkWell(
                        onTap: () async {
                          final code = await controller.countryPicker.showPicker(context: context,
                            backgroundColor: MyColors.white,
                            pickerMaxHeight: Get.height * 0.7, // Sheet ki height fix karein
                            scrollToDeviceLocale: true,);
                          if (code != null) {
                            controller.countryCode.value = code.dialCode;
                          }
                        },
                        child: Container(
                          height: 55,
                          width: 60,
                          padding:
                          const EdgeInsets.symmetric(horizontal: 8),
                          decoration: BoxDecoration(
                            color: MyColors.white,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                                color: MyColors.borderColor, width: 1),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            controller.countryCode.value,
                            style: const TextStyle(
                              fontSize: 14,
                              color: MyColors.black,
                              fontFamily: "regular",
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      )),

                      const SizedBox(width: 10),

                      /// Phone Number Field
                      Expanded(
                        child: CommonTextField(
                          controller: controller.phoneController,
                          hintText: AppStrings.hintPhoneNumber,
                          keyboardType: TextInputType.phone,
                          maxLength: 10,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 30),
                  /// Continue Button
                  Obx(
                        () => CommonButton(
                      title: AppStrings.btnContinue,
                      isLoading: controller.isLoading.value,
                      onTap:() {
                        dismissKeyboard(context);
                        controller.login(context);
                      },
                    ),
                  ),
                ],
              ),
            ),

        ),
      ),
    );
  }
}
