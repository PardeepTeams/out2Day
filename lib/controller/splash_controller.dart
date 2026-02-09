import 'package:Out2Do/routes/app_routes.dart';
import 'package:get/get.dart';

import '../api/api_service.dart';
import '../api/storage_helper.dart';
import '../main.dart';

/*class SplashController extends GetxController {
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
}*/

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    initialSetup();
  }

  void initialSetup() async {
    String oldVersion = StorageProvider.getApiVersion();
    String? serverVersion = await ApiService().fetchApiVersion();

    if (serverVersion != null && serverVersion != oldVersion) {
      // 🚩 Sirf flag set karein, version abhi save NA karein
      StorageProvider.write("temp_server_version", serverVersion);
      StorageProvider.write("temp_static_server_version", serverVersion);
      StorageProvider.write("needs_data_refresh", true);
      StorageProvider.write("needs_static_data_refresh", true);
    } else {
      StorageProvider.write("needs_data_refresh", false);
      StorageProvider.write("needs_static_data_refresh", false);
    }

    // 3. 2-3 seconds ka delay (Total time manage karne ke liye)
    await Future.delayed(const Duration(seconds: 2));

    _checkLogin();
  }

  void _checkLogin() async {
    bool isLoggedIn = StorageProvider.isUserLoggedIn();
    if (isLoggedIn) {
    //  Get.offAllNamed(AppRoutes.home);
      if (pendingNotificationPayload != null) {
        // Step 1: Pehle Home pe jayein (Back stack ke liye)
        Get.offAllNamed(AppRoutes.home);
        await Future.delayed(const Duration(milliseconds: 200));
        // Step 2: Phir notification redirect karein
        String payload = pendingNotificationPayload!;
        pendingNotificationPayload = null; // Clear it
        manageNotificationClick(payload);
      } else {
        Get.offAllNamed(AppRoutes.home);
      }
    } else {
      Get.offAllNamed(AppRoutes.login);
    }
  }
}
