import 'package:Out2Do/utils/common_styles.dart';
import 'package:get/get.dart';

class HomeTabController extends GetxController {
  /// Toggle View
  var isGridView = true.obs;

  /// Search Range
  var searchRange = 100.0.obs;

  /// Selected Preference
  var preference = "All".obs;

  var imageIndexMap = <int, int>{}.obs;

  // Naya variable loading dikhane ke liye
  var isLoading = false.obs;

  // Profiles ko khali obs list banayein
  var profiles = <ProfileModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    // Screen load hote hi data fetch karega
    refreshHome();
  }

  void updateImageIndex(int cardIndex, int imageIndex) {
    imageIndexMap[cardIndex] = imageIndex;
  }

  int getImageIndex(int cardIndex) {
    return imageIndexMap[cardIndex] ?? 0;
  }

  void connectProfile(ProfileModel profile) {
    if (profile.isConnected){
      profile.isConnected = false;
    }
    else{
      profile.isConnected = true;
    }
    profiles.refresh(); // GetX list refresh

  }


  /// 🔄 Refresh Logic jo HomeController call karega
  Future<void> refreshHome() async {
    isLoading.value = true;

    // Purana data saaf karein refresh feel dene ke liye
    profiles.clear();
    imageIndexMap.clear();

    // Fake network delay (Real API feel ke liye)
    await Future.delayed(const Duration(milliseconds: 600));

    /// Dummy Profiles update
    profiles.addAll([
      ProfileModel(
        name: "Aanya",
        age: 24,
        images: [
          "https://picsum.photos/400/600?1",
          "https://picsum.photos/400/600?2",
        ],
      ),
      ProfileModel(
        name: "Riya",
        age: 22,
        images: [
          "https://picsum.photos/400/600?3",
        ],
      ),
      ProfileModel(
        name: "Simran",
        age: 26,
        images: [
          "https://picsum.photos/400/600?4",
          "https://picsum.photos/400/600?5",
        ],
      ),
    ]);

    isLoading.value = false;
  }
}

/// Model Same Rahega
class ProfileModel {
  final String name;
  final int age;
  final List<String> images;
  bool isConnected;

  ProfileModel({
    required this.name,
    required this.age,
    required this.images,
    this.isConnected = false,
  });
}