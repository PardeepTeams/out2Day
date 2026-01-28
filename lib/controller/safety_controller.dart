import 'package:get/get.dart';

import '../api/api_service.dart';
import '../models/safety_advice_response.dart';
import '../utils/common_styles.dart';

class SafetyController extends GetxController {

  /// 🔹 Banner Data
  final bannerTitle = "Safety Advice".obs;
  final bannerSubtitle =
      "Our guide for how to stay safe without losing the momentum.".obs;
  final bannerImage = "assets/logo_outdo.svg".obs;
  var adviceCategories = <SafetyCategory>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchSafetyAdvice();
    super.onInit();
  }

  void fetchSafetyAdvice() async {
    try {
      isLoading(true);
      SafetyAdviceResponse response = await ApiService().getSafetyAdvice();
      if (response.data != null) {
        adviceCategories.assignAll(response.data!);
      }
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading(false);
    }
  }

}

