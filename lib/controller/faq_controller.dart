import 'package:get/get.dart';

import '../api/api_service.dart';
import '../models/faq_model.dart';

class FaqController extends GetxController {

  /// Currently expanded question index
  RxInt expandedIndex = (-1).obs;
  var isLoading = true.obs;
  var faqList = <FaqModel>[].obs;

  /// FAQ DATA
/*  final faqs = <Map<String, String>>[
    {
      "question": "How do I create my profile?",
      "answer":
      "You can create your profile by completing the onboarding steps. Upload at least one photo and fill in your basic details."
    },
    {
      "question": "Why should I upload more photos?",
      "answer":
      "Profiles with more photos receive more matches and better engagement."
    },
    {
      "question": "Can I edit my profile later?",
      "answer":
      "Yes, you can edit your profile anytime from the Edit Profile section."
    },
    {
      "question": "Is my personal data safe?",
      "answer":
      "Your data is securely stored and encrypted. We never share it without your consent."
    },
    {
      "question": "How can I delete my account?",
      "answer":
      "You can delete your account from Settings > Account > Delete Account."
    },
  ].obs;*/

  /// TOGGLE EXPAND
  void toggleFaq(int index) {
    expandedIndex.value = expandedIndex.value == index ? -1 : index;
  }

  @override
  void onInit() {
    getFaqs();
    super.onInit();
  }

  void getFaqs() async {
    try {
      isLoading.value = true;
      FaqResponseModel response = await ApiService().fetchFaqs();
      if (response.status == 1 && response.faqs != null) {
        faqList.assignAll(response.faqs!);
      }
    } catch (e) {
      print("FAQ Error: $e");
    } finally {
      isLoading.value = false; // Screen black hone se rokne ke liye
    }
  }
}
