import 'package:Out2Do/utils/app_strings.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PrivacyPolicyController extends GetxController {

  late WebViewController webViewController;

  RxBool isLoading = true.obs;

  var appBarTitle = "".obs;
  var url = "".obs;
   // 🔥 replace with real url

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      url.value = Get.arguments['url'] ?? "";
    }

    webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (url) {
            isLoading.value = true;
          },
          onPageFinished: (url) {
            isLoading.value = false;
          },
        ),
      )
      ..loadRequest(Uri.parse(url.value));
  }
}
