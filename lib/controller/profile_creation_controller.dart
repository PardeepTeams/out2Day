import 'dart:convert';
import 'dart:io';
import 'package:Out2Do/models/HobbyModel.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import '../api/api_service.dart';
import '../api/storage_helper.dart';
import '../models/ethnicity_model.dart';
import '../models/profession_model.dart';
import '../models/user_model.dart';
import '../routes/app_routes.dart';
import '../utils/common_styles.dart';
import 'package:intl/intl.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:typed_data';
import '../utils/my_progress_bar.dart';

class ProfileCreationController extends GetxController {
  var nameController = TextEditingController();
  var lastNameController = TextEditingController();
  final TextEditingController webLocationController = TextEditingController();
  var emailController = TextEditingController();
  var aboutController = TextEditingController();
  var locationController = TextEditingController();

 // var heightController = TextEditingController();
  var ethnicityController = TextEditingController();

  Rx<File?> profileImage = Rx<File?>(null);

  RxInt genderIndex = 0.obs;
  var selectedPreferences = <String>[].obs;
  var isLoading = false.obs;
  var isBusinessProfile = false.obs;
  var isLoadingLocation = false.obs;
  var dobController = TextEditingController();
  double? latitude;
  double? longitude;
  String? cityName;
  String? country;
  var selectedDate = DateTime(DateTime.now().year - 18).obs;

  bool isEdit = false;
  RxInt currentStep = 0.obs;

  final availablePreferences = [AppStrings.male, AppStrings.female, AppStrings.other];
  RxString selectedProfession = "".obs;
  RxString selectedDrinking = "".obs;
  RxString selectedSmoking = "".obs;
  RxString selectedEthnicity = "".obs;

  RxList<Ethnicity> ethnicityList = <Ethnicity>[].obs;
  var isEthnicityLoading = false.obs;

  // Variables
  RxList<Profession> professionList = <Profession>[].obs;
  var isProfessionLoading = false.obs;
  String phone = "";
  String countryCode = "";

  RxBool isOtherProfessionSelected = false.obs;
  RxBool isOtherEthnicitySelected = false.obs;

  TextEditingController otherProfessionController = TextEditingController();
  TextEditingController otherEthnicityController = TextEditingController();

  final ScrollController pageScrollController = ScrollController();
  Rx<Uint8List?> webImage = Rx<Uint8List?>(null);

  RxList<Hobby> hobbyList = <Hobby>[].obs; // Hobbies layi vi same Profession model use kar sakde ho
  var isHobbyLoading = false.obs;
  var selectedHobbies = <String>[].obs; // Multi-select layi list
  RxBool isOtherHobbySelected = false.obs;
  TextEditingController otherHobbyController = TextEditingController();

  RxString profileImageUrl = "".obs;

  void scrollToTop() {
    if (pageScrollController.hasClients) {
      pageScrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }
  void nextStep() {
/*    if(currentStep == 0){
      if(profileImage.value == null && profileImageUrl.isEmpty){
        showCommonSnackbar(title: AppStrings.photoReqTitle, message: AppStrings.photoReqMsg);
        return;
      }
      if (nameController.text.trim().isEmpty) {
        showCommonSnackbar(title: AppStrings.nameReqTitle, message: AppStrings.nameReqMsg);
        return;
      }

      if (emailController.text.trim().isEmpty) {
        showCommonSnackbar(title: AppStrings.emailReqTitle, message: AppStrings.emailReqMsg);
        return;
      }
      if(!isValidEmail(emailController.text.trim())){
        showCommonSnackbar(title: AppStrings.emailReqTitle, message: AppStrings.emailReqMsg);
        return;
      }
      if (dobController.text.isEmpty) {
        showCommonSnackbar(title: AppStrings.dobReqTitle, message: AppStrings.dobReqMsg);
        return;
      }


    }
    if(currentStep ==1){
      if (locationController.text.trim().isEmpty) {
        showCommonSnackbar(title: AppStrings.locationReqTitle, message: AppStrings.locationReqMsg);
        return;
      }

      if(selectedHobbies.isEmpty){
        showCommonSnackbar(title: AppStrings.hobbiesReqTitle, message: AppStrings.hobbiesReqMsg);
        return;
      }

      if (selectedHobbies.value == "Other" &&
          otherHobbyController.text.trim().isEmpty) {
        showCommonSnackbar(
          title: AppStrings.hobbiesReqMsg,
          message: AppStrings.hobbiesReqMsg,
        );
        return;
      }

      if (selectedPreferences.isEmpty) {
        showCommonSnackbar(title: AppStrings.interestReqTitle, message: AppStrings.interestReqMsg);
        return;
      }

      // Ethnicity Validation
      if (selectedEthnicity.isEmpty) {
        showCommonSnackbar(title: AppStrings.ethnicityLabel, message: AppStrings.ethnicityReqMsg);
        return;
      }
      if (selectedEthnicity.value == "Other" &&
          otherEthnicityController.text.trim().isEmpty) {
        showCommonSnackbar(
          title: AppStrings.ethnicityLabel,
          message: AppStrings.ethnicityEnterReqMsg,
        );
        return;
      }

    }*/
    if (currentStep.value < 2) {
      currentStep.value++;
      scrollToTop(); // 🔥 AUTO SCROLL TO TOP
    }
  }

  void previousStep() {
    if (currentStep.value > 0) currentStep.value--;
  }

  final drinkingChips = ["Yes, I drink", "I drink sometimes", "I rarely drink","No, I don't drink" , "I'm sober"];
  final smokingChips = ["I smoke sometimes", "No, I don't smoke", "Yes, I smoke" , "I'm trying to quit"];



  void pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source, imageQuality: 40);
    if (image != null) {
      if (kIsWeb) {
        webImage.value = await image.readAsBytes();
      } else {
        profileImage.value = File(image.path);
      }
    }
  }

  @override
  void onInit() {
    super.onInit();
    getAllData();
    if (Get.arguments != null) {
      if (Get.arguments is bool) {
        isEdit = Get.arguments as bool;
      } else{
        getCurrentLocation();
      }
      /*else if (Get.arguments is Map) {
        phone = Get.arguments['phone'] ?? "";
        countryCode = Get.arguments['countryCode'] ?? "";
        getCurrentLocation();
      }*/

      if (isEdit) {
      /*  everAll(
          [ethnicityList, professionList, hobbyList],
              (_) {
            final user = StorageProvider.getUserData();
            if (user != null) {
              _fillDataFromStorage(user);
            }
          },
        );*/
      }
    }
  }



  void _fillDataFromStorage(UserData user) {
    /// 🧑 Basic Info
    nameController.text = user.firstName ?? "";
    lastNameController.text = user.lastName ?? "";
    emailController.text = user.email ?? "";
    aboutController.text = user.aboutMe ?? "";

    /// 📅 DOB
    if (user.dob != null && user.dob!.isNotEmpty) {
      dobController.text = formatAge(user.dob!);
    }
    if (user.profile != null && user.profile!.isNotEmpty) {
      profileImageUrl.value = ApiService.imageBaseUrl + user.profile!;
    }

    /// 📍 Location
    locationController.text = user.address ?? "";
    cityName = user.city;
    country = user.country;
    latitude = double.tryParse(user.latitude ?? "0");
    longitude = double.tryParse(user.longitude ?? "0");

    /// 🚻 Gender
    int index = availablePreferences.indexWhere(
          (e) => e.toLowerCase() == user.gender?.toLowerCase(),
    );
    if (index != -1) {
      genderIndex.value = index;
    }

    /// ❤️ Interests (comma separated → list)
    if (user.interests != null && user.interests!.isNotEmpty) {
      selectedPreferences.assignAll(
        user.interests!.split(',').map((e) => e.trim()).toList(),
      );
    }

    /// 🎯 Hobbies
    if (user.hobbies != null && user.hobbies!.isNotEmpty) {
      selectedHobbies.assignAll(
        user.hobbies!.split(',').map((e) => e.trim()).toList(),
      );
    }

    /// 🌍 Ethnicity
    if (user.ethnicity != null && user.ethnicity!.isNotEmpty) {
      final ethnicity = user.ethnicity!.trim();

      if (_existsInList(ethnicityList, ethnicity)) {
        selectedEthnicity.value = ethnicity;
        isOtherEthnicitySelected.value = false;
        otherEthnicityController.clear();
      } else {
        selectedEthnicity.value = "Other";
        isOtherEthnicitySelected.value = true;
        otherEthnicityController.text = ethnicity;
      }
    }




    if (user.profession != null && user.profession!.isNotEmpty) {
      final profession = user.profession!.trim();

      if (_existsInList(professionList, profession)) {
        selectedProfession.value = profession;
        isOtherProfessionSelected.value = false;
        otherProfessionController.clear();
      } else {
        selectedProfession.value = "Other";
        isOtherProfessionSelected.value = true;
        otherProfessionController.text = profession;
      }
    }

    /// 🍷 Drinking
    selectedDrinking.value = user.drinking ?? "";

    /// 🚬 Smoking
    selectedSmoking.value = user.smoking ?? "";

    /// 🏢 Business profile
    isBusinessProfile.value = user.isBusiness == "1";
  }


  bool _existsInList(List<dynamic> list, String value) {
    return list.any(
          (e) => e.name?.trim().toLowerCase() == value.trim().toLowerCase(),
    );
  }

  Future<void> getAllData() async {
    // Parallel execution taaki time bache
    await Future.wait([
      getEthnicities(),
      getProfessions(),
      getHobbies(),
    ]);
  }


  Future<void> getHobbies() async {
    isHobbyLoading.value = true;
    try {
      // Note: ApiService vich fetchHobbies() function hona chahida hai
      HobbyModel data = await ApiService().fetchHobbies();
      if (data.status == 1 && data.hobbies != null) {
        hobbyList.assignAll(data.hobbies!);
        hobbyList.add(Hobby(name: "Other"));
      }
    } catch (e) {
      print("Hobby Error: $e");
    } finally {
      isHobbyLoading.value = false;
    }
  }

  Future<void> getProfessions() async {
    isProfessionLoading.value = true;
    try {
      ProfessionModel data = await ApiService().fetchProfessions();
      if (data.status == 1 && data.professions != null) {
        professionList.assignAll(data.professions!);
        professionList.add(Profession(name: "Other"));
      }
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isProfessionLoading.value = false;
    }
  }

  // API Call Function
  Future<void> getEthnicities() async {
    isEthnicityLoading.value = true;
    try {
      EthnicityModel data = await ApiService().fetchEthnicities();
      if (data.status == 1 && data.ethnicities != null) {
        ethnicityList.assignAll(data.ethnicities!);
        ethnicityList.add(Ethnicity(name: "Other"));
      } else {
        showCommonSnackbar(title: "Error", message: data.message!);
      }
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isEthnicityLoading.value = false;
    }
  }


  // --- Toggle Logic for Multi-Select ---
  void toggleHobby(String hobbyName) {
    if (hobbyName == "Other") {
      isOtherHobbySelected.toggle(); // Toggle 'Other' field visibility
      if (!isOtherHobbySelected.value) otherHobbyController.clear();
    } else {
      // 🔹 Agar pehle se list mein hai to remove karo, nahi to add karo
      if (selectedHobbies.contains(hobbyName)) {
        selectedHobbies.remove(hobbyName);
      } else {
        selectedHobbies.add(hobbyName);
      }
    }
  }


  // Current Location Logic
  Future<void> getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.disableLocations);
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.locationPermissionsDenied);
        return;
      }
    }

    isLoadingLocation.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);

      // Store Lat/Lng
      latitude = position.latitude;
      longitude = position.longitude;

      List<Placemark> placemarks = await placemarkFromCoordinates(latitude!, longitude!);

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        cityName = place.locality ?? place.subAdministrativeArea ?? "";
        country = place.country ?? "";
        cityName = place.locality; // City name store kiya

        // Poora address construct karna
        String fullAddress = [
          if (place.street != null && place.street!.isNotEmpty) place.street,
          if (place.subLocality != null && place.subLocality!.isNotEmpty) place.subLocality,
          if (place.locality != null && place.locality!.isNotEmpty) place.locality,
          if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) place.administrativeArea,
          if (place.postalCode != null && place.postalCode!.isNotEmpty) place.postalCode,
        ].join(", ");

        locationController.text = fullAddress;
      }
    } catch (e) {
      showCommonSnackbar(title: AppStrings.errorText, message: e.toString());
    } finally {
      isLoadingLocation.value = false;
    }
  }

  void togglePreference(String preference) {
    if (selectedPreferences.contains(preference)) {
      selectedPreferences.remove(preference);
    } else {
      selectedPreferences.add(preference);
    }
  }

  void submitProfile(BuildContext context) async {
/*    if (profileImage.value ==null && profileImageUrl.isEmpty) {
      showCommonSnackbar(title: AppStrings.photoReqTitle, message: AppStrings.photoReqMsg);
      return;
    }
    if (nameController.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.nameReqTitle, message: AppStrings.nameReqMsg);
      return;
    }

    if (emailController.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.emailReqTitle, message: AppStrings.emailReqMsg);
      return;
    }
    if(!isValidEmail(emailController.text.trim())){
      showCommonSnackbar(title: AppStrings.emailReqTitle, message: AppStrings.emailReqMsg);
      return;
    }
    if (dobController.text.isEmpty) {
      showCommonSnackbar(title: AppStrings.dobReqTitle, message: AppStrings.dobReqMsg);
      return;
    }
    // 3. Location Validation
    if (locationController.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.locationReqTitle, message: AppStrings.locationReqMsg);
      return;
    }

    // 4. Interested In (Preferences) Validation
    if (selectedPreferences.isEmpty) {
      showCommonSnackbar(title: AppStrings.interestReqTitle, message: AppStrings.interestReqMsg);
      return;
    }


    // Ethnicity Validation
    if (selectedEthnicity.isEmpty) {
      showCommonSnackbar(title: AppStrings.ethnicityLabel, message: AppStrings.ethnicityReqMsg);
      return;
    }
    if (selectedEthnicity.value == "Other" &&
        otherEthnicityController.text.trim().isEmpty) {
      showCommonSnackbar(
        title: AppStrings.ethnicityLabel,
        message: AppStrings.ethnicityEnterReqMsg,
      );
      return;
    }
    if(selectedProfession.isEmpty){
      showCommonSnackbar(title: AppStrings.professionLabel, message: AppStrings.professionReqMsg);
      return;
    }

    if(selectedProfession =="Other" &&  otherProfessionController.text.trim().isEmpty){
      showCommonSnackbar(title: AppStrings.professionLabel, message: AppStrings.professionEnterReqMsg);
      return;
    }

    if(selectedDrinking.isEmpty){
      showCommonSnackbar(title: AppStrings.drinking, message: AppStrings.drinkingReqMsg);
      return;
    }

    if(selectedSmoking.isEmpty){
      showCommonSnackbar(title: AppStrings.smoking, message: AppStrings.smokingReqMsg);
      return;
    }

    if (aboutController.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.aboutReqTitle, message: AppStrings.aboutReqMsg);
      return;
    };

    try {
      isLoading.value = true;
      MyProgressBar.showLoadingDialog(context: context);
      String hobbies = selectedHobbies
          .map((hobby) {
        if (hobby == "Other") {
          return otherHobbyController.text.trim();
        }
        return hobby;
      })
          .where((hobby) => hobby.isNotEmpty)
          .join(", ");
      final user = StorageProvider.getUserData();

      // 1. Saara data ik Map vich taiyar karo
      Map<String, String> body = {
        if (isEdit && user?.id != null) "user_id": user!.id.toString(),
        "first_name": nameController.text.trim(),
        "last_name": lastNameController.text.trim(),
        "email": emailController.text.trim(),
        "country_code": countryCode,
        "phone": phone,
        "gender": availablePreferences[genderIndex.value].toLowerCase(), // Male/Female/Other
        "latitude": latitude?.toString() ?? "0.0",
        "longitude": longitude?.toString() ?? "0.0",
        "interests": selectedPreferences.map((e) => e.toLowerCase()).join(','), // Comma separated string
        "dob": convertDateFormatApi(dobController.text.trim()),
        "address": locationController.text.trim(),
        "city": cityName ?? "",
        "country": country??"", // Ya Placemark ton country nikaal lo
        "hobbies": hobbies,
        "ethnicity": selectedEthnicity.value == "Other"
      ? otherEthnicityController.text.trim()
          : selectedEthnicity.value, // Ethnicity field tusi add kita si
        "profession": selectedProfession.value == "Other"
            ? otherProfessionController.text.trim()
            : selectedProfession.value,
        "about_me": aboutController.text.trim(),
        "is_business": isBusinessProfile.value ? "1" : "0",
        "drinking": selectedDrinking.value,
        "smoking": selectedSmoking.value,
      };

      print("UpdateprofileBody $body");

      File? imageToUpload;
      if (profileImage.value != null) {
        imageToUpload = profileImage.value; // ✅ only when new image selected
      }

      bool success = isEdit
          ? await ApiService().updateProfileApi(
        body: body,
        profileImage: imageToUpload, // null bhi ja sakta hai
      ) : await ApiService().createProfileApi(
        body: body,
        profileImage: imageToUpload,
      );
      if (success) {
        MyProgressBar.hideLoadingDialog(context: context);
        isLoading.value = false;
        if(isEdit){
          Get.back(result: true);
        }else{
          Get.offNamed(AppRoutes.home,arguments: {});
        }
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      isLoading.value = false;
      showCommonSnackbar(title: "Error", message: e.toString());
    }*/

    if(isEdit){
      Get.back(result: true);
    }else{
      Get.offNamed(AppRoutes.home,arguments: {});
    }
  }

  Future<Map<String, double>?> getLatLngFromPlaceId(String placeId, String apiKey) async {
    final url = Uri.parse(
        'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$apiKey');

    final response = await http.get(url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final location = data['result']?['geometry']?['location'];
      if (location != null) {
        return {
          'lat': location['lat'],
          'lng': location['lng'],
        };
      }
    }
    return null; // in case of error
  }


// Inside your ProfileCreationController
  void onWebLocationFetched({
    required String address,
    required String lat,
    required String lng,
    required String city,
    required String state,
    required String country1,
    required String zipCode,
  }) {
    locationController.text = address;
    latitude = double.tryParse(lat);
    longitude = double.tryParse(lng);

    // Agar aapne city/state ke liye alag controllers banaye hain:
    // cityController.text = city;
    // stateController.text = state;
    // zipController.text = zipCode;
    cityName = city;
    country = country1;

    print("Fetched: $city, $state, $country, $zipCode");
    update(); // Agar GetX use kar rahe hain toh
  }
  Future<void> getLocationDetails(Prediction prediction) async {
    try {
      latitude = double.tryParse(prediction.lat ?? "0.0");
      longitude = double.tryParse(prediction.lng ?? "0.0");


        if (latitude == null || longitude == null || latitude == 0.0 || longitude == 0.0) {
          showCommonSnackbar(title: "Error", message: "Unable to get location");
          return;
        }

        final List<Placemark> placeMarks =
        await GeocodingPlatform.instance
        !.placemarkFromCoordinates(latitude!, longitude!);

        if (placeMarks.isEmpty) {
          showCommonSnackbar(title:AppStrings.errorText , message: AppStrings.addessError);
          return;
        }

        final Placemark place = placeMarks.first;

        cityName = place.locality ?? place.subAdministrativeArea ?? "";
        country = place.country ?? "";
        /// 🏠 Build full address
        final String fullAddress = [
          place.name,
          place.subLocality,
          place.locality,        // City
          place.administrativeArea, // State
          place.postalCode,
          place.country,
        ].where((element) => element != null && element!.isNotEmpty)
            .join(", ");

        /// ✅ Set address to text field
        locationController.text = fullAddress;
     // }


    } catch (e) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.somethingWrong);
    }
  }



  void showIosDatePicker(BuildContext context) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(
          children: [
            // Header: Done Button
            Container(
              height: 50,
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Colors.grey.shade200)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CupertinoButton(child: const Text('Cancel'), onPressed: () => Get.back()),
                  CupertinoButton(
                      child: const Text('Done'),
                      onPressed: () {
                        _updateDobField(selectedDate.value);
                        Get.back();
                      }
                  ),
                ],
              ),
            ),
            // Picker
            Expanded(
              child: CupertinoDatePicker(
                initialDateTime: selectedDate.value,
                mode: CupertinoDatePickerMode.date,
                maximumYear: DateTime.now().year - 18,
                minimumYear: 1950,
                onDateTimeChanged: (DateTime newDate) {
                  selectedDate.value = newDate;
                  _updateDobField(newDate);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Helper function to format date
  void _updateDobField(DateTime date) {
    dobController.text = DateFormat(AppStrings.dateFormet).format(date);
  }

}