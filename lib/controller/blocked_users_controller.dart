import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../models/blocked_user_model.dart';
import '../models/user_model.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';

class BlockedUsersController extends GetxController {

  var blockedUsers = <UserData>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadBlockedUsers();
  }

  void loadBlockedUsers() async {
    blockedUsers.value = [
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
    ];

   /* try {
      isLoading(true);
      BlockedUsersResponse response = await ApiService().getBlockedUsers();

      if (response.blockedUsers != null) {
        blockedUsers.assignAll(response.blockedUsers!);
      }
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading(false);
    }*/
  }

  void unblockUser(UserData user,BuildContext context) async {
      try {
        MyProgressBar.showLoadingDialog(context: Get.context!);
        bool success = await ApiService().unblockUser(
          blockedUserId: user.id.toString(),
        );
        MyProgressBar.hideLoadingDialog(context: Get.context!);

        if (success) {
          blockedUsers.remove(user);
        }
      } catch (e) {
        MyProgressBar.hideLoadingDialog(context: Get.context!);
        showCommonSnackbar(title: "Error", message: e.toString());
      }


  }
}
