import 'package:Out2Do/routes/app_routes.dart';
import 'package:Out2Do/utils/common_styles.dart';
import 'package:get/get.dart';

import '../api/api_service.dart';
import '../models/user_model.dart';
import '../views/home/tabs/connect/widgets/match_dialog.dart';

class ProfileDetailController extends GetxController {
  final name = "Sophia Williams".obs;
//  final name = "".obs;
  final age = 26.obs;
 // final age = "0".obs;
  final phone = "99999999999".obs;
//  final phone = "".obs;
  final height = "5'6\"".obs;
 // final height = "".obs;
  final profession = "Fashion Designer".obs;
 // final profession = "".obs;
  final gender = "Female".obs;
//  final gender = "".obs;
  final location = "Chicago, IL United States".obs;
 // final location = "".obs;
  final ethnicity = "North African".obs;
//  final ethnicity = "".obs;
  final drinking = "No, I don't drink".obs;
  final smoking = "No, I don't smoke".obs;

  var userDetails = UserData().obs;
  var isLoading = false.obs;

  final aboutMe = "Love traveling, coffee dates and meaningful conversations.".obs;


  final hobbies = <String>[
    "Gym",
    "Reading",
    "Cooking",
    "Gaming",
    "Music"
  ].obs;

  /// Interested In
  final interestedIn = <String>["Men", "Women", "Other"].obs;

  final image = "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e".obs;

  /// Connection state
  RxBool isConnected = false.obs;
  RxBool isBlocked = false.obs;
  RxBool isMyProfile = false.obs;

  RxList<String> gallery = <String>[
    "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e",
    "https://images.unsplash.com/photo-1544005313-94ddf0286df2",
    "https://images.unsplash.com/photo-1503023345310-bd7c1de61c7d",
    "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde",
    "https://images.unsplash.com/photo-1524504388940-b1c1722653e1",
    "https://images.unsplash.com/photo-1517841905240-472988babdf9",
  ].obs;
  int? profileUserId;

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      profileUserId = Get.arguments['id']; // Maan lo key 'id' hai
      isMyProfile.value =  Get.arguments['isMy'];
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

   /* Get.dialog(
      MatchDialog(profile:  UserData(
          id: 1,
          firstName: "Rohit",
          lastName: "Sharma",
          profile: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1974&auto=format&fit=crop",
          aboutMe: "Love traveling and music.",
          profession: "Software Engineer",
          distnace: "3.42", // Double value
          hobbies: "Music, Travel",
          city: "New Delhi",
          dob: "1997-12-12"
      ),),
      barrierDismissible: false,
    );*/

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
