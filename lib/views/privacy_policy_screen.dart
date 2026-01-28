import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';
import '../utils/colors.dart';
import '../controller/privacy_policy_controller.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  PrivacyPolicyScreen({super.key});

  final PrivacyPolicyController controller = Get.put(PrivacyPolicyController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: AppBar(
        backgroundColor: MyColors.white,
        centerTitle: true,
        title: SvgPicture.asset(
            "assets/logo_outdo.svg",
            width: 120,
          ),
        leading: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.arrow_back_ios, color: MyColors.baseColor),
        ),
      ),
      body: Stack(
        children: [
          /// WEB VIEW
          WebViewWidget(controller: controller.webViewController),

          /// LOADER
          Obx(
            () => controller.isLoading.value
                ? Container(
                    color: Colors.white.withOpacity(0.7),
                    child: const Center(
                      child: CircularProgressIndicator(
                        color: MyColors.baseColor,
                      ),
                    ),
                  )
                : const SizedBox(),
          ),
        ],
      ),
    );
  }
}
