import 'package:Out2Do/api/storage_helper.dart';
import 'package:get/get.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter/material.dart';
import '../api/api_service.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import '../views/home/tabs/connect/widgets/match_dialog.dart';

class SwipeController extends GetxController {
  final CardSwiperController swiperController = CardSwiperController();

  // Profile list (Asal app vich eh API ton aayegi)
  var profiles = <UserData>[].obs;
  var gridProfiles = <UserData>[].obs;
  var isLoading = true.obs;
  var isGridView = false.obs;
  var commonIndex = 0.obs;
  var isSwitching = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchProfiles();
  }
  void toggleView() async {
    isSwitching.value = true; // Loader Start
    isGridView.toggle();
    commonIndex.value = 0;

    // Jab hum Swipe view (Stack) mein jaate hain, toh heavy rendering hoti hai
    await WidgetsBinding.instance.endOfFrame;
    await Future.delayed(const Duration(milliseconds: 600));
    isSwitching.value = false; // Loader Stop
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
      await WidgetsBinding.instance.endOfFrame;
      await Future.delayed(const Duration(milliseconds: 500));
      isLoading.value = false;
    } catch (e) {
      isLoading.value = false;
      // Backend wala original message hi show hoyega
      showCommonSnackbar(title: "Error", message: e.toString());

    }
  }






  void removeFromGridLists(int userId) {
    gridProfiles.removeWhere((user) => user.id == userId);
    profiles.removeWhere((user) => user.id == userId);
    gridProfiles.refresh();
    profiles.refresh();
  }

  void removeFromProfiles(int userId) {
    profiles.removeWhere((user) => user.id == userId);
    profiles.refresh();
  }

  void handleUserAction(UserData targetUser, bool isLiked) {
    if (isLiked) {
      markInterestedAndHandleMatch(targetUser);
    }else{
      markNotInterestedAndHandleMatch(targetUser);
    }
  }


  Future<void> markInterestedAndHandleMatch(UserData user) async {
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!);

      final response = await ApiService().markUserInterested(
        interestedId: user.id.toString(),
      );
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      if (response['status'] == 1) {
        if (response['match'] == true) {
          Get.dialog(
            MatchDialog(profile: user, onKeepSwiping: () {
              Get.back();
            },
              onSendMessage: ()async  {
              Get.back();
              await Future.delayed(const Duration(milliseconds: 100));
                await Get.toNamed(
                    AppRoutes.chatMessages,
                   arguments: <String, dynamic>{
                  'sender': StorageProvider.getUserData()!.toJson(),
                  'receiver': user.toJson(),
                   "setDefault":true
                }
                );
                fetchProfiles();
              },),
            barrierDismissible: false,
          );
        }

      }else{
        print("MatchError $response}");
      }

    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      print("MatchResponse  $e");
    }
  }



  Future<void> markNotInterestedAndHandleMatch(UserData user) async {
    print("notItrested");
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!);

      final response = await ApiService().markUserNotInterested(
        interestedId: user.id.toString(),
      );
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      if (response['status'] == 1) {
      //  removeFromGridLists(user.id!);
      }else{
        print("MatchError $response}");
      }

    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      print("MatchResponse  $e");
    }
  }

  bool onSwipe(int previousIndex, int? currentIndex, CardSwiperDirection direction) {
    if (direction == CardSwiperDirection.right || direction == CardSwiperDirection.left) {
      commonIndex.value = currentIndex ?? profiles.length;

      final swipedUser = profiles[previousIndex];
      if (direction == CardSwiperDirection.right) {
        markInterestedAndHandleMatch(swipedUser);
      }else{
        removeFromGridLists(swipedUser.id!);
      }
      return true;
    }else{
      return false;
    }

  }


  void connectFromGrid(UserData user) {
    print("MatchUserPardeep  ${user.id}");
    int swipeIndex = profiles.indexWhere((element) => element.id == user.id);
    if (swipeIndex != -1) {
      swiperController.swipe(CardSwiperDirection.right);
    }
    removeFromGridLists(user.id!);
    handleUserAction(user, true);
  }

  void cancelFromGrid(UserData user) {
    int swipeIndex = profiles.indexWhere((element) => element.id == user.id);
    if (swipeIndex != -1) {
      swiperController.swipe(CardSwiperDirection.left);
    }
    removeFromGridLists(user.id!);

    handleUserAction(user, false);
  }

  void swipeRight(UserData user) {
    print("MatchUserPardeep  ${user.id}");
    int swipeIndex = profiles.indexWhere((element) => element.id == user.id);
    if (swipeIndex != -1) {
      swiperController.swipe(CardSwiperDirection.right);
    }
    removeFromProfiles(user.id!);
    if(profiles.isEmpty){
      profiles.assignAll(gridProfiles);
    }
  }

  void swipeLeft(UserData user) {
    int swipeIndex = profiles.indexWhere((element) => element.id == user.id);
    if (swipeIndex != -1) {
      swiperController.swipe(CardSwiperDirection.left);
    }
    removeFromProfiles(user.id!);
    if(profiles.isEmpty){
      profiles.assignAll(gridProfiles);
    }
  }
}