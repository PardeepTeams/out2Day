import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/api_service.dart'; // Aapka API service
import '../../utils/my_progress_bar.dart';

class ReportController extends GetxController {
  var selectedReason = "".obs;
  final TextEditingController detailsController = TextEditingController();
  var isLoading = false.obs;

  final List<String> reportReasons = [
    "Spam or Fraud",
    "Inappropriate Content",
    "Harassment or Bullying",
    "Fake Profile",
    "Underage User",
    "Other"
  ];

  void selectReason(String reason) {
    selectedReason.value = reason;
  }

  Future<void> submitReport(String targetUserId) async {
    if (selectedReason.isEmpty) {
      Get.snackbar("Error", "Please select a reason first",
          snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.red, colorText: Colors.white);
      return;
    }

    Get.back();
/*    try {
      MyProgressBar.showLoadingDialog(context: Get.context!);

      // Assume aapke ApiService mein reportUser method hai
      final response = await ApiService().reportUser(
        targetId: targetUserId,
        reason: selectedReason.value,
        description: detailsController.text,
      );

      MyProgressBar.hideLoadingDialog(context: Get.context!);

      if (response['status'] == 1) {
        Get.back(); // Screen close
        Get.snackbar("Success", "User has been reported successfully.",
            snackPosition: SnackPosition.BOTTOM, backgroundColor: Colors.green, colorText: Colors.white);
      } else {
        Get.snackbar("Error", response['message'] ?? "Something went wrong");
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      Get.snackbar("Error", "Failed to submit report: $e");
    }*/
  }

  @override
  void onClose() {
    detailsController.dispose();
    super.onClose();
  }
}