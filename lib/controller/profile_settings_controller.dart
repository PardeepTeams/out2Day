import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:url_launcher/url_launcher.dart';

import '../api/api_service.dart';
import '../api/storage_helper.dart';
import '../models/dynamic_page_model.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/app_strings.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import '../widgets/dialog_helper.dart';

class ProfileSettingsController extends GetxController {
  var profileImageUrl = "".obs;
  RxString userName = "".obs;
  RxString userAge = "".obs;
  RxInt userId = 0.obs;

  var notificationsEnabled = true.obs;

  var isSettingsLoading = false.obs;
  var dynamicPages = <DynamicPageModel>[].obs;

  @override
  void onInit() {
    super.onInit();
  //  getDynamicPages();
    loadDynamicPagesFromLocal();
    loadUserFromStorage();
  }

 /* Future<void> getDynamicPages() async {
    isSettingsLoading.value = true;
    try {
      var pages = await ApiService().fetchAllPages();
      dynamicPages.assignAll(pages);
    } catch (e) {
      print("Error in Controller: $e");
    } finally {
      isSettingsLoading.value = false;
    }
  }*/


  void loadUserFromStorage() {
    print("isEdit");
    UserData? user = StorageProvider.getUserData();

    if (user == null) return;

    userId.value = user.id!;

    /// 🧑 Name
    userName.value =
        "${user.firstName ?? ""}".trim();

    /// 🎂 Age (DOB se)
    if (user.dob != null && user.dob!.isNotEmpty) {
      userAge.value = calculateAge(user.dob!).toString();
    }

    if(user.isNotification!=null){
      notificationsEnabled.value = user.isNotification ==0?false:true;
    }

    /// 🖼 Profile Image (API URL)
    if (user.additionalImagesThumb != null && user.additionalImagesThumb!.isNotEmpty) {
      profileImageUrl.value = user.additionalImagesThumb!.first;
    }
  }



  void changeNotificationSetting(bool value) async {
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!);

      // API call (1 for true/on, 0 for false/off)
      var result = await ApiService().updateNotificationStatus(status: value ? 1 : 0);

      MyProgressBar.hideLoadingDialog(context: Get.context!);
      notificationsEnabled.value = value;

      UserData? user = StorageProvider.getUserData();
      user!.isNotification = value?1:0;
      StorageProvider.saveAuthData(token: StorageProvider.getToken()!, userData: user);
      // Success message
      showCommonSnackbar(title: "Success", message: result['message'] ?? "Status updated");

    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      showCommonSnackbar(title: "Error", message: e.toString());
      notificationsEnabled.value = !value;
    }
  }
  void loadDynamicPagesFromLocal() {
    bool needsRefresh = StorageProvider.read("needs_static_data_refresh") ?? false;
    var cachedPages = StorageProvider.getDynamicPages(); // Ye method niche add karenge
   /* if (cachedPages != null && cachedPages.isNotEmpty) {
      dynamicPages.assignAll(cachedPages);
    }else{
      getDynamicPages();
    }*/
    if (needsRefresh || cachedPages == null || cachedPages.isEmpty) {
      getDynamicPages();
    } else {
      dynamicPages.assignAll(cachedPages);
    }
  }

  void _finalizeVersionUpdate() {
    String? tempVersion = StorageProvider.read("temp_static_server_version");

    if (tempVersion != null) {
      StorageProvider.saveStaticApiVersion(tempVersion);
      StorageProvider.write("needs_static_data_refresh", false);
      StorageProvider.remove("temp_static_server_version");
    }
  }

  Future<void> getDynamicPages() async {
    // Loader sirf tab dikhayein jab screen khali ho
    if (dynamicPages.isEmpty) isSettingsLoading.value = true;

    try {
      var pages = await ApiService().fetchAllPages();

      if (pages != null && pages.isNotEmpty) {
        dynamicPages.assignAll(pages);
        StorageProvider.saveDynamicPages(pages); // Local mein save karein
        _finalizeVersionUpdate();
      } else {
        // Agar API response khali aaye toh local fallback
        _useLocalFallback();
      }
    } catch (e) {
      print("DEBUG: API Error, falling back to local: $e");
      _useLocalFallback();
    } finally {
      isSettingsLoading.value = false;
    }
  }

// Helper method fallback ke liye
  void _useLocalFallback() {
    var cachedPages = StorageProvider.getDynamicPages();
    if (cachedPages != null && cachedPages.isNotEmpty) {
      dynamicPages.assignAll(cachedPages);
    }
  }


  /// Toggle notifications
  void toggleNotifications(bool value) {
    changeNotificationSetting(value);
 //   notificationsEnabled.value = value;
  }
  /// Perform actions
  void blockUsers() => Get.toNamed(AppRoutes.blockedUser,
      arguments: true)?.then((value) {
    // controller.refreshHome();
  });
  void deleteAccount(BuildContext context) => DialogHelper.showIosDialog(
    title: AppStrings.deleteAccount,
    message: AppStrings.deleteAccMsg,
    confirmText: AppStrings.delete,
    isDeleteAction: true,
    onConfirm: () async {
      Get.offAllNamed(AppRoutes.login);
   /*   try{
        MyProgressBar.showLoadingDialog(context: context);
        int status = await ApiService().removeAccountApi();
        if (status == 1) {
          MyProgressBar.hideLoadingDialog(context: context);
          Get.offAllNamed(AppRoutes.login);
        } else if (status == 0) {
          MyProgressBar.hideLoadingDialog(context: context);
        }
      }catch(e){
        MyProgressBar.hideLoadingDialog(context: context);
        Get.snackbar("Error", e.toString());
      }*/
    },
  );
  void businessListing() => Get.toNamed(AppRoutes.business,
      arguments: true)?.then((value) {
    // controller.refreshHome();
  });
  void events() =>  Get.toNamed(AppRoutes.events,
      arguments: true)?.then((value) {
    // controller.refreshHome();
  });
  void faqs() =>   Get.toNamed(AppRoutes.faqs,
      arguments: true)?.then((value) {
    // controller.refreshHome();
  });

  Future<void> launchInBrowser(String url) async {
    final Uri _url = Uri.parse(url);
    try {
      if (!await launchUrl(
        _url,
        mode: LaunchMode.externalApplication, // Nave tab vich kholn layi
      )) {
        throw Exception('Could not launch $_url');
      }
    } catch (e) {
      Get.snackbar("Error", "URL open nahi ho saki");
    }
  }
  void logout(BuildContext context) => DialogHelper.showIosDialog(
    title: AppStrings.logout,
    message: AppStrings.logoutMsg,
    confirmText: AppStrings.logout,
    onConfirm: () async {
     // Get.offAllNamed(AppRoutes.login);
      try{
        MyProgressBar.showLoadingDialog(context: context);
        int status = await ApiService().logoutApi();
        if (status == 1) {
          MyProgressBar.hideLoadingDialog(context: context);
          Get.offAllNamed(AppRoutes.login);
        } else if (status == 0) {
          MyProgressBar.hideLoadingDialog(context: context);
        }
      }catch(e){
        MyProgressBar.hideLoadingDialog(context: context);
        Get.snackbar("Error", e.toString());
      }
    },
  );
  void privacyPolicy() {
    if(kIsWeb){
      launchInBrowser("https://out2day.brickandwallsinc.com/privacy-policies");
    }else{
      Get.toNamed(AppRoutes.privacyPolicy,
          arguments: true)?.then((value) {
        // controller.refreshHome();
      });
    }

  }
  void termsAndConditions(){
    if(kIsWeb){
      launchInBrowser("https://out2day.brickandwallsinc.com/terms-and-condition");
    }else{
      Get.toNamed(AppRoutes.privacyPolicy,
          arguments: false)?.then((value) {
        // controller.refreshHome();
      });
    }

  }

  void safety() => Get.toNamed(AppRoutes.safetyScreen,
      arguments: true)?.then((value) {
    // controller.refreshHome();
  });

  @override
  void onClose() {
    super.onClose();
  }
}
