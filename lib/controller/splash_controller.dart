import 'package:Out2Do/routes/app_routes.dart';
import 'package:get/get.dart';

import '../api/storage_helper.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    goToNext();
  }

  void goToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    _checkLogin();
  }

  void _checkLogin() {
    bool isLoggedIn = StorageProvider.isUserLoggedIn();
    print("isLoggedIn   $isLoggedIn");
    if (isLoggedIn) {
      Get.offAllNamed(AppRoutes.home);
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
