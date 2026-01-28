import 'package:get/get.dart';

import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import '../views/home/tabs/connect/widgets/match_dialog.dart';


class UserProfileDetailController extends GetxController {

  final name = "Ethan".obs;
  final age = 32.obs;
  final profession = "Fitness Instructor".obs;
  final ethnicity = "Asian".obs;
  final drinking = "No, I don't drink".obs;
  final smoking = "No, I don't smoke".obs;
  final hobbies = ["Gym",
    "Reading",
    "Cooking",
    "Gaming",
    "Music"].obs;
  final location = "Capitola, California".obs;
  final image = "https://images.unsplash.com/photo-1511671782779-c97d3d27a1d4"
      .obs;
  final about = "Spinning tracks by night, crushing fitness goals by day. "
      "Always on the lookout for someone to harmonize with.".obs;

  var userDetails = UserData().obs;
  var isLoading = false.obs;

  RxBool isConnected = false.obs;
  RxBool isBlocked = false.obs;
  RxBool isMyProfile = false.obs;
  int? profileUserId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      profileUserId = Get.arguments['id']; // Maan lo key 'id' hai
      isMyProfile.value = Get.arguments['isMy'];
      /*  if (profileUserId != null) {
        loadUserProfile(profileUserId!);
      } else {
        showCommonSnackbar(title: "Error", message: "User ID missing");
      }*/
    }
  }

/*  void loadUserProfile(int id) async {
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
      smoking.value = userDetails.value.drinking??"";
      image.value = userDetails.value.profile??"";
      aboutMe.value = userDetails.value.aboutMe??"";
      if(userDetails.value.hobbies!=null){
        hobbies.value =   userDetails.value.hobbies!.split(',').map((e) => e.trim()).toList();
      }
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading.value = false;
    }
  }*/

  void connectUser() {

    Get.dialog(
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
    );

    //  isConnected.value = true;
    //  showCommonSnackbar(title: "Connected", message: "You are now connected 🎉");
  }

  void sendMessage() {
    Get.toNamed(AppRoutes.chatMessages);
    // showCommonSnackbar(title:"Message",message: "Opening chat...");
  }

  void blockUser() {
    isBlocked.value = true;
    showCommonSnackbar(title: "Blocked",message: "User has been blocked");
  }

  void unblockUser() {
    isBlocked.value = false;
    showCommonSnackbar(title: "Unblocked",message:  "User has been unblocked");
  }

  void reportUser() {
    showCommonSnackbar(title:"Reported", message:"User has been reported");
  }

}





