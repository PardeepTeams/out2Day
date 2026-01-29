import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

import '../api/api_service.dart';
import '../models/user_model.dart';
import '../utils/common_styles.dart';
import '../views/home/tabs/connect/widgets/match_dialog.dart';

class SwipeController extends GetxController {
  final CardSwiperController swiperController = CardSwiperController();

  // Profile list (Asal app vich eh API ton aayegi)
  var profiles = <UserData>[].obs;
  var gridProfiles = <UserData>[].obs;
  var isLoading = true.obs;
  var isGridView = false.obs;
  var commonIndex = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfiles();
  }



  void fetchProfiles() async {
    try {
      commonIndex.value = 0;
  /*    var staticUsers = [
        UserData(
          id: 1,
          firstName: "Rohit",
          lastName: "Sharma",
          profile: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1974&auto=format&fit=crop",
          aboutMe: "Love traveling and music.",
          profession: "Software Engineer",
          distnace: 3.42, // Double value
          hobbies: "Music, Travel",
          city: "New Delhi",
          dob: "1997-12-12"
        ),
        UserData(
          id: 2,
          firstName: "Pardeep",
          lastName: "Kumar",
          profile: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop",
          aboutMe: "Fitness enthusiast and foodie.",
          profession: "Designer",
          distnace: 4.57,
          hobbies: "Gym, Cooking",
          city: "Chandigarh",
            dob: "1995-12-12"
        ),
        UserData(
          id: 3,
          firstName: "Aushotosh",
          lastName: "Rana",
          profile: "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1974&auto=format&fit=crop",
          aboutMe: "Love My Family and Peace.",
          profession: "Writer",
          distnace: 5.1,
          hobbies: "Meditation, Reading",
          city: "Mumbai",
            dob: "1999-12-12"
        ),
      ];*/
      isLoading.value = true;
      // Profiles vich static data assign kitta
    //  profiles.assignAll(staticUsers);
      profiles.clear();
      gridProfiles.clear();
  //    isLoading.value = true;
  //    profiles.assignAll(staticUsers);
      var users = await ApiService().fetchHomeUsers();
      profiles.assignAll(users);
      gridProfiles.assignAll(users);
    } catch (e) {
      // Backend wala original message hi show hoyega
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void handleUserAction(int index, bool isLiked) {
    if (index < 0 || index >= profiles.length) return;

    final targetUser = profiles[index];

    if (isLiked) {
      Get.dialog(
        MatchDialog(profile: targetUser),
        barrierDismissible: false,
      );
    }

    profiles.removeWhere((user) => user.id == targetUser.id);
    gridProfiles.removeWhere((user) => user.id == targetUser.id);

  }

  // Jadon card swipe hunda hai
  bool onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right || direction == CardSwiperDirection.left) {
      commonIndex.value = currentIndex ?? profiles.length;
      final swipedProfile = profiles[previousIndex];

      gridProfiles.removeWhere((user) => user.id == swipedProfile.id);
      if (direction == CardSwiperDirection.right) {
         Get.dialog(
        MatchDialog(profile: swipedProfile),
        barrierDismissible: false,
      );

        // API Call ithe karo: controller.likeUser(swipedUser['id']);
      } else if (direction == CardSwiperDirection.left) {
        // print("Disliked: ${swipedProfile['name']}");
        gridProfiles.remove(profiles[previousIndex]);
      }

      return true;
    }else{
      return false;
    }

  }



  void connectFromGrid(int index) {
    handleUserAction(index, true);
  }

  void cancelFromGrid(int index) {
    handleUserAction(index, false);
  }
}