import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/home/tabs/connect/widgets/match_dialog.dart';

class ConnectController extends GetxController {
  var profiles = <ConnectProfile>[].obs;
  var isLoading = false.obs; // Loading state add ki hai

  @override
  void onInit() {
    super.onInit();
    // onInit par data fetch karna shuru karein
    refreshProfiles();
  }

  // Isse hum UI se bhi call kar sakte hain (e.g. Pull to Refresh)
  Future<void> refreshProfiles() async {
    isLoading.value = true;

    // Profiles ko clear karein taaki purana data na dikhe
    profiles.clear();

    try {
      // Simulate network delay (Real API call ki tarah)
      await Future.delayed(const Duration(milliseconds: 500));

      profiles.addAll([
        ConnectProfile(
          name: "Aanya",
          age: 24,
          image: "https://picsum.photos/400/600?1",
        ),
        ConnectProfile(
          name: "Riya",
          age: 23,
          image: "https://picsum.photos/400/600?2",
        ),
        ConnectProfile(
          name: "Simran",
          age: 26,
          image: "https://picsum.photos/400/600?3",
        ),
      ]);
    } finally {
      isLoading.value = false;
    }
  }

  void onSwipeRight(ConnectProfile profile) {
    profiles.remove(profile);
 /*   Get.dialog(
      MatchDialog(profile: profile),
      barrierDismissible: false,
    );*/
  }

  void onSwipeLeft(ConnectProfile profile) {
    profiles.remove(profile);
  }
}

class ConnectProfile {
  final String name;
  final int age;
  final String image;

  ConnectProfile({
    required this.name,
    required this.age,
    required this.image,
  });
}