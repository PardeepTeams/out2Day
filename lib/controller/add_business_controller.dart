import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import 'package:geocoding/geocoding.dart';

import '../api/api_service.dart';
import '../api/storage_helper.dart';
import '../models/add_business_response_model.dart';
import '../models/business_model.dart';
import '../utils/app_strings.dart';
import '../utils/colors.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddBusinessController extends GetxController {
  /// Text Controllers
  final nameCtrl = TextEditingController();
  final categoryCtrl = TextEditingController();
  final descriptionCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final webUrlCtrl = TextEditingController();
  final startTimeCtrl = TextEditingController();
  final endTimeCtrl = TextEditingController();
  final priceCtrl = TextEditingController();

  double? latitude;
  double? longitude;
  String? cityName;
  String? country;

  var isLoading = true.obs;

  /// Images
  RxList<File> selectedImages = <File>[].obs;
  RxList<String> networkImages = <String>[].obs;
  RxList<Uint8List> webImages = <Uint8List>[].obs;

  RxList<String> removedImagesList = <String>[].obs;
  
  final int maxImages = 5;
  int get totalImages => selectedImages.length + networkImages.length + webImages.length;
  final picker = ImagePicker();
  /// Pick Image
  Future<void> pickImage(ImageSource source) async {
    const int maxSizeBytes = 2 * 1024 * 1024;
    if (totalImages >= 5) return;

    if (GetPlatform.isWeb) {
      final XFile? image = await picker.pickImage(source: source,imageQuality:40);
      if (image != null) {
        final bytes = await image.readAsBytes();
        webImages.add(bytes);
      }
      return;
    }
    if (source == ImageSource.gallery) {
      final images = await picker.pickMultiImage(imageQuality: 40);
      if (images.isNotEmpty) {
        final remaining = 5 - totalImages;
        selectedImages.addAll(
          images.take(remaining).map((e) => File(e.path)),
        );
      /*  for (var img in limitedImages) {
          final File file = File(img.path);
          final int fileSize = await file.length();
          print("fileSize $fileSize");
          if (fileSize <= maxSizeBytes) {
            selectedImages.add(file);
          } else {
            showCommonSnackbar(
                title: "File Too Large",
                message: "${img.name} is larger than 2 MB and was skipped."
            );
          }
        }*/
      }
    } else {
      final image = await picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 40,
      );
      if (image != null) {
        selectedImages.add(File(image.path));
      }
    }

  }

  void fillBusinessData(BusinessModel model) {
    nameCtrl.text = model.businessName ?? "";
    categoryCtrl.text = model.category ?? "";
    descriptionCtrl.text = model.description ?? "";
    locationCtrl.text = model.address ?? "";
    webUrlCtrl.text =  model.webLink ?? "";
    latitude = double.parse(model.latitude??"0.0");
    longitude = double.parse(model.longitude??"0.0");
    cityName = model.city??"";
    country = model.country??"";
    startTimeCtrl.text = formatToUITime(model.startTime);
    endTimeCtrl.text = formatToUITime(model.endTime);
    // Server se aayi images networkImages mein dalenge
    networkImages.assignAll(model.businessImages ?? []);
  }

  String formatToUITime(String? apiTime) {
    if (apiTime == null || apiTime.isEmpty) return "";
    try {
      // API format "18:00:00" ko parse karein
      DateFormat apiFormat = DateFormat("HH:mm:ss");
      DateTime parsedTime = apiFormat.parse(apiTime);

      // UI format "06:00 PM" mein convert karein
      return DateFormat("hh:mm a").format(parsedTime);
    } catch (e) {
      print("Time Parsing Error: $e");
      return "";
    }
  }

  void removeNetworkImage(int index) {
    removedImagesList.add(networkImages[index]);
    networkImages.removeAt(index);
  }
  /// Remove Image
  void removeImage(int index) {
    selectedImages.removeAt(index);
  }
  void removeWebImage(int index) {
    webImages.removeAt(index);
  }

  /// Submit Business
  void submitBusiness(BuildContext context) async {
  // Get.back(result: true);
    if (nameCtrl.text.isEmpty ||
        categoryCtrl.text.isEmpty ||
        descriptionCtrl.text.isEmpty ||
        locationCtrl.text.isEmpty||
        webUrlCtrl.text.isEmpty ||
        startTimeCtrl.text.isEmpty ||
        endTimeCtrl.text.isEmpty
    ) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }
    if(!isValidUrl(webUrlCtrl.text.trim())){
      Get.snackbar("Error", "Please fill the valid link");
    }
    if(selectedImages.isEmpty && webImages.isEmpty){
      Get.snackbar("Error", "Please add at least one image");
      return;
    }

    if (!isEndTimeValid(startTimeCtrl.text, endTimeCtrl.text)) {
      showCommonSnackbar(title: "Invalid Time", message: "End time must be after start time");
      return;
    }

    Map<String, String> body = {
      "user_id": StorageProvider.getUserData()?.id.toString() ?? "",
      "business_name": nameCtrl.text.trim(),
      "category": categoryCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
      "web_link": webUrlCtrl.text.trim(),
      "address": locationCtrl.text.trim(),
      "city": cityName ?? "Delhi",
      "country": country ?? "India",
      "latitude": latitude?.toString() ?? "28.6139",
      "longitude": longitude?.toString() ?? "77.2090",
      "start_time": formatToApiTime(startTimeCtrl.text),
      "end_time": formatToApiTime(endTimeCtrl.text),
    };

    try {
      MyProgressBar.showLoadingDialog(context: context);

      // images tuhadi RxList<File> selectedImages ton aaungian

      AddBusinessResponse response = await ApiService().createBusiness(
        body: body,
        images: kIsWeb ? webImages : selectedImages,
      );

      if (response.status ==1) {
        MyProgressBar.hideLoadingDialog(context: context);
        Get.back(result: true);
      } else {
        MyProgressBar.hideLoadingDialog(context: context);
        showCommonSnackbar(title: "Error", message: "Failed to create business");
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      showCommonSnackbar(title: "Error", message: e.toString());
    }
  }

  bool isEndTimeValid(String start, String end) {
    try {
      // Hamare format "10:30 PM" ko DateTime mein convert karenge compare karne ke liye
      DateFormat inputFormat = DateFormat("h:mm a");
      DateTime startTime = inputFormat.parse(start);
      DateTime endTime = inputFormat.parse(end);

      return endTime.isAfter(startTime);
    } catch (e) {
      return false;
    }
  }

// Time ko "10:30 PM" se "22:30:00" mein badalne ke liye
  String formatToApiTime(String timeStr) {
    if (timeStr.isEmpty) return "00:00:00";
    DateFormat inputFormat = DateFormat("h:mm a");
    DateFormat outputFormat = DateFormat("HH:mm:ss");
    DateTime time = inputFormat.parse(timeStr);
    return outputFormat.format(time);
  }

  void updateBusiness(BuildContext context,int id) async {

    if (nameCtrl.text.isEmpty ||
        categoryCtrl.text.isEmpty ||
        descriptionCtrl.text.isEmpty ||
        locationCtrl.text.isEmpty||
        webUrlCtrl.text.isEmpty ||
        startTimeCtrl.text.isEmpty ||
        endTimeCtrl.text.isEmpty
    ) {
      Get.snackbar("Error", "Please fill all fields");
      return;
    }

    if(!isValidUrl(webUrlCtrl.text.trim())){
      Get.snackbar("Error", "Please fill the valid link");
    }
    if(selectedImages.isEmpty && webImages.isEmpty && networkImages.isEmpty){
      Get.snackbar("Error", "Please add at least one image");
      return;
    }

    if (!isEndTimeValid(startTimeCtrl.text, endTimeCtrl.text)) {
      showCommonSnackbar(title: "Invalid Time", message: "End time must be after start time");
      return;
    }


    Map<String, String> body = {
      "user_id": StorageProvider.getUserData()?.id.toString() ?? "",
      "business_name": nameCtrl.text.trim(),
      "category": categoryCtrl.text.trim(),
      "description": descriptionCtrl.text.trim(),
      "web_link": webUrlCtrl.text.trim(),
      "address": locationCtrl.text.trim(),
      "city": cityName ?? "Delhi",
      "country": country ?? "India",
      "latitude": latitude?.toString() ?? "0.0",
      "longitude": longitude?.toString() ?? "0.0",
      "business_id": id.toString(),
      "start_time": formatToApiTime(startTimeCtrl.text),
      "end_time": formatToApiTime(endTimeCtrl.text),
    };

    try {
      MyProgressBar.showLoadingDialog(context: context);

      bool success = await ApiService().updateBusiness(
          body: body,
          newImages: kIsWeb?webImages:selectedImages, removedImages: removedImagesList
      );

      if (success) {
        print('BackScreen');
        MyProgressBar.hideLoadingDialog(context: context);
        Get.back(result: true);
      } else {
        MyProgressBar.hideLoadingDialog(context: context);
        showCommonSnackbar(title: "Error", message: "Failed to create business");
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      showCommonSnackbar(title: "Error", message: e.toString());
    }
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
      locationCtrl.text = fullAddress;

    } catch (e) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.somethingWrong);
    }
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
    locationCtrl.text = address;
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

  @override
  void onClose() {
    nameCtrl.dispose();
    categoryCtrl.dispose();
    descriptionCtrl.dispose();
    locationCtrl.dispose();
    super.onClose();
  }

  bool isValidUrl(String url) {
    final urlRegExp = RegExp(
        r"^(https?|ftp)://[^\s/$.?#].[^\s]*$",
        caseSensitive: false);
    return urlRegExp.hasMatch(url);
  }

  void showIosTimePicker(BuildContext context,bool isEnd) {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: const Color.fromARGB(255, 255, 255, 255),
        child: Column(
          children: [
            // Done Button (Top bar)
            Container(
              alignment: Alignment.centerRight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: CupertinoButton(
                padding: EdgeInsets.zero,
                child: const Text("Done", style: TextStyle(fontFamily: "semibold", color: MyColors.baseColor)),
                onPressed: () => Get.back(),
              ),
            ),
            // Picker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.time,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (DateTime newTime) {
                  // Format time: 10:30 AM/PM
                  String formattedTime = "${newTime.hour > 12 ? newTime.hour - 12 : newTime.hour}:${newTime.minute.toString().padLeft(2, '0')} ${newTime.hour >= 12 ? 'PM' : 'AM'}";
                 if(isEnd){
                   endTimeCtrl.text = formattedTime;
                 }else{
                   startTimeCtrl.text = formattedTime;
                 }

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
