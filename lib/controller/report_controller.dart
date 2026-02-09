import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_service.dart'; // Aapka API service
import '../../utils/my_progress_bar.dart';
import '../models/report_reaso.dart';
import '../utils/common_styles.dart';

class ReportController extends GetxController {
  var selectedReason = "".obs;
  final TextEditingController detailsController = TextEditingController();
  var isLoading = true.obs;

  var reasonsList = <ReportReason>[].obs;

  void selectReason(String reason) {
    selectedReason.value = reason;
  }

  @override
  void onInit() {
    super.onInit();
    getReasons();
  }

  void getReasons() async {
    try {
      isLoading.value = true;
      var data = await ApiService().fetchReportReasons();
      reasonsList.assignAll(data);
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }
  Future<void> submitReport(String targetUserId) async {
    if (selectedReason.isEmpty) {
      showCommonSnackbar(title: "Error", message: "Please select a reason first");
      return;
    }else if(detailsController.text.isEmpty){
      showCommonSnackbar(title: "Error", message: "Please enter a report reason");
    }

    Get.back();
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!);

      // Assume aapke ApiService mein reportUser method hai
      bool success = await ApiService().reportUserApi(
        reportedUserId: targetUserId,
        reason: selectedReason.value,
        description: detailsController.text,
      );

      MyProgressBar.hideLoadingDialog(context: Get.context!);

      if (success) {
        Get.back(); // Screen close karein
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      Get.snackbar("Error", "Failed to submit report: $e");
    }
  }

  @override
  void onClose() {
    detailsController.dispose();
    super.onClose();
  }
}