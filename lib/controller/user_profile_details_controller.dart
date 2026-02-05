import 'package:Out2Do/controller/swipe_controller.dart';
import 'package:get/get.dart';

import '../api/api_service.dart';
import '../api/storage_helper.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import '../views/home/tabs/connect/widgets/match_dialog.dart';


class UserProfileDetailController extends GetxController {

//  final name = "Ethan".obs;
  final name = "".obs;
 // final phone = "999999999".obs;
  final phone = "".obs;
//  final age = "32".obs;
  final age = "".obs;
 // final profession = "Fitness Instructor".obs;
  final profession = "".obs;
//  final ethnicity = "Asian".obs;
  final ethnicity = "".obs;
//  final drinking = "No, I don't drink".obs;
  final drinking = "".obs;
//  final smoking = "No, I don't smoke".obs;
  final smoking = "".obs;
 /* final hobbies = ["Gym",
    "Reading",
    "Cooking",
    "Gaming",
    "Music"].obs;*/
  final hobbies = [].obs;
//  final location = "Capitola, California".obs;
  final location = "".obs;
  final image = ""
      .obs;
/*  final about = "Spinning tracks by night, crushing fitness goals by day. "
      "Always on the lookout for someone to harmonize with.".obs;*/
  final about = "".obs;
  var userDetails = UserData().obs;
  var isLoading = true.obs;

  RxBool isConnected = false.obs;
  RxBool isBlocked = false.obs;
  RxBool isMyProfile = false.obs;
  int? profileUserId;
  RxBool fromChats = false.obs;
  RxList<String> additionalImages = <String>[].obs;
  RxList<String> additionalThumbImages = <String>[].obs;



  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      profileUserId = Get.arguments['id']; // Maan lo key 'id' hai
      fromChats.value = Get.arguments['fromChat']; // Maan lo key 'id' hai
      isMyProfile.value = Get.arguments['isMy'];
        if (profileUserId != null) {
        loadUserProfile(profileUserId!);
      } else {
        showCommonSnackbar(title: "Error", message: "User ID missing");
      }
    }
  }


  void loadUserProfile(int id) async {
    try {
      isLoading.value = true;
      UserData data = await ApiService().fetchUserProfileDetails(id);
      userDetails.value = data;
      name.value = "${userDetails.value.firstName}";
      age.value = calculateAge(userDetails.value.dob!).toString();
      phone.value ="${ userDetails.value.countryCode}${ userDetails.value.phone}";
      profession.value = userDetails.value.profession??"";
      ethnicity.value = userDetails.value.ethnicity??"";
      location.value = userDetails.value.address??'';
      drinking.value = userDetails.value.drinking??"";
      smoking.value = userDetails.value.smoking??"";
      image.value = userDetails.value.profile??"";
      isConnected.value = userDetails.value.isMatch??false;
      isBlocked.value = userDetails.value.isBlocked??false;

      print("isConnected  ${userDetails.value.isMatch}");


      about.value = userDetails.value.aboutMe??"";
      if(userDetails.value.hobbies!=null){
        hobbies.value =   userDetails.value.hobbies!.split(',').map((e) => e.trim()).toList();
      }
      additionalImages.clear();
    //  additionalImages.add(image.value);
      if (userDetails.value.additionalImages != null) {
        additionalImages.addAll(userDetails.value.additionalImages!);
      }
      if (userDetails.value.additionalImagesThumb != null) {
        print("additionalThumbImages  $additionalThumbImages");
        additionalThumbImages.addAll(userDetails.value.additionalImagesThumb!);
      }
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
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
            MatchDialog(profile: user,
                onKeepSwiping: () async {
                  Get.back();
                  await Future.delayed(const Duration(milliseconds: 100));
                  Get.back(result: true);
                }, onSendMessage: () async {
              Get.back();
              await Future.delayed(const Duration(milliseconds: 100));
                await Get.offNamed(
                  AppRoutes.chatMessages,
                    arguments: <String, dynamic>{
                      'sender': StorageProvider.getUserData()!.toJson(),
                      'receiver': user.toJson(),
                    }
                );
                if (Get.isRegistered<SwipeController>()) {
                  Get.find<SwipeController>().fetchProfiles();
                }
              },),
            barrierDismissible: false,
          );
        }
     //   Get.back(result: true);
      }else{
        print("MatchError $response}");
      }

    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      print("MatchResponse  $e");
    }
  }
  void connectUser() {

    markInterestedAndHandleMatch(userDetails.value);
    /*Get.dialog(
      MatchDialog(profile:  UserData(
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
      ),),
      barrierDismissible: false,
    );*/

    //  isConnected.value = true;
    //  showCommonSnackbar(title: "Connected", message: "You are now connected 🎉");
  }

  void sendMessage() async {
    if(fromChats.value){
      Get.back(result: {'action': isBlocked.value?"blocked":"unblock"});
  }else{
    //  await Future.delayed(const Duration(milliseconds: 100));
      await Get.offNamed(
          AppRoutes.chatMessages,
          arguments: <String, dynamic>{
            'sender': StorageProvider.getUserData()!.toJson(),
            'receiver': userDetails.value.toJson(),
          }
      );
      if (Get.isRegistered<SwipeController>()) {
        Get.find<SwipeController>().fetchProfiles();
      }
    }

    // showCommonSnackbar(title:"Message",message: "Opening chat...");
  }

  void blockUser() async {
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!); // Loading start
      bool success = await ApiService().blockUser(blockedUserId: profileUserId.toString());
      MyProgressBar.hideLoadingDialog(context: Get.context!); // Loading stop

      if (success) {
        isBlocked.value = true;
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      showCommonSnackbar(title: "Block Error", message: e.toString());
    }
  }

  void unblockUser() async {
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!); // Loading start
      bool success = await ApiService().unblockUser(blockedUserId: profileUserId.toString());
      MyProgressBar.hideLoadingDialog(context: Get.context!); // Loading stop

      if (success) {
        isBlocked.value = false;
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      showCommonSnackbar(title: "UnBlock Error", message: e.toString());
    }
  }

  void reportUser() {
    showCommonSnackbar(title:"Reported", message:"User has been reported");
  }

}





