import 'dart:io';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/utils/my_progress_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/model/prediction.dart';
import 'package:image_picker/image_picker.dart';
import '../api/api_service.dart';
import '../api/storage_helper.dart';
import '../models/event_model.dart';
import '../models/my_events_model.dart';
import '../models/user_model.dart';
import '../utils/colors.dart';
import 'package:intl/intl.dart';
import 'package:geocoding/geocoding.dart';
import '../utils/common_styles.dart';
import 'dart:typed_data';

import 'package:flutter/foundation.dart' show kIsWeb;


class MyEventsController extends GetxController {
  var isLoading = true.obs;
  RxList<EventModel> myEvents = <EventModel>[].obs;
  RxList<EventModel> filteredEvents = <EventModel>[].obs;

  /// FORM
  final titleCtrl = TextEditingController();
  final locationCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final dateCtrl = TextEditingController();
  final timeCtrl = TextEditingController();

  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  /// IMAGES
  RxList<File> selectedImages = <File>[].obs;
  RxList<String> networkImages = <String>[].obs;
  RxList<Uint8List> webImages = <Uint8List>[].obs;

  RxList<String> removedImagesList = <String>[].obs;

  final ImagePicker picker = ImagePicker();

  int get totalImages => selectedImages.length + networkImages.length + webImages.length;
  final TextEditingController searchController = TextEditingController();

  double? latitude;
  double? longitude;
  String? cityName;
  String? country;

  /// ---------------- PICK IMAGES ----------------
  Future<void> pickImage(ImageSource source) async {
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

  @override
  void onInit() {
    super.onInit();
   // loadMyEvents();
    searchController.addListener(() {
      filterEvents(searchController.text);
    });
  }

  void filterEvents(String query) {
    if (query.isEmpty) {
      filteredEvents.assignAll(myEvents);
    } else {
      filteredEvents.assignAll(
        myEvents.where(
              (e) =>
          e.eventTitle!.toLowerCase().contains(query.toLowerCase()) ||
          e.city!.toLowerCase().contains(query.toLowerCase()) ||
          e.country!.toLowerCase().contains(query.toLowerCase()) ||
          e.description!.toLowerCase().contains(query.toLowerCase()) ||
              e.address!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  Future<void> loadMyEvents(bool isShow) async {
  /*  myEvents.value = [
      EventModel(
          id: 1,
          eventTitle: "Dating Night Party",
          eventImages: [
            "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
            "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
            "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
          ],
          address: "California, USA",
          eventDate: "2026-04-14",
          description: "Meet singles near you",
          status: 1,
          eventTime: "18:00:00",
          city: "Delhi",
          country: "India"
      ),
      EventModel(
          id: 2,
          eventTitle: "Singles Meetup",
          eventImages: [
            "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
            "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
          ],
          address: "California, USA",
          eventDate: "2026-04-14",
          description: "Meet singles near you",
          status: 0,
          eventTime: "19:30:00",
          city: "Delhi",
          country: "India"
      ),
      EventModel(
          id: 3,
          eventTitle: "Love & Music Festival",
          eventImages: [
            "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
            "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7",
            "https://images.unsplash.com/photo-1515169067865-5387ec356754",
          ],
          address: "California, USA",
          eventDate: "2026-04-14",
          description: "Meet singles near you",
          status: 2,
          eventTime: "16:30:00",
          city: "Delhi",
          country: "India"
      ),
    ];
    filteredEvents.assignAll(myEvents);*/

    try {
      if(isShow){
        isLoading.value = true;
      }
      MyEventResponseModel response = await ApiService().fetcMyEvents();

      if (response.status == 1 && response.allEvents != null) {
        isLoading.value = false;
        myEvents.assignAll(response.allEvents!);
        filteredEvents.assignAll(myEvents);
      }else{
        isLoading.value = false;
        showCommonSnackbar(title: "Error", message: response.message!);
      }
    } catch (e) {
      myEvents.clear();
      filteredEvents.assignAll(myEvents);
      isLoading.value = false;
      print("MyEventsError $e");
      showCommonSnackbar(title: "Error", message: e.toString());
    }

  }

  void removeLocalImage(int index) => selectedImages.removeAt(index);

  void removeNetworkImage(int index) {
    removedImagesList.add(networkImages[index]);
    networkImages.removeAt(index);
  }

  void removeWebImage(int index) => webImages.removeAt(index);

  void pickDate(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    selectedDate.value =  selectedDate.value ?? DateTime.now();
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 300,
        decoration: const BoxDecoration(
          color: MyColors.white,
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
                        _updateDobField(selectedDate.value!);
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
                minimumDate: today,
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
  void _updateDobField(DateTime date) {
    dateCtrl.text = DateFormat(AppStrings.dateFormet).format(date);
  }


  /// ---------------- ADD EVENT ----------------
  void addEvent(BuildContext context) async {
    String apiDate  = convertDateFormatApi(dateCtrl.text.trim());
    MyProgressBar.showLoadingDialog(context: context);
    Map<String, String> body = {
      "user_id": StorageProvider.getUserData()?.id.toString() ?? "",
      "event_title": titleCtrl.text.trim(),
      "description": descCtrl.text.trim(),
      "event_date": apiDate, // Format YYYY-MM-DD
      "event_time": formatTimeTo24Hour(timeCtrl.text.trim()),
      "address": locationCtrl.text.trim(),
      "city": cityName.toString(),
      "country": country.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
    };

    List<File> imageFiles = selectedImages;

    try {
      bool success = await ApiService().createEvent(body: body, images: kIsWeb?webImages:imageFiles);
      if (success) {
        MyProgressBar.hideLoadingDialog(context: context);
        Get.back(result: true); // Ya Home te navigate karo
      }else{
        MyProgressBar.hideLoadingDialog(context: context);
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      showCommonSnackbar(title: "Error", message: e.toString());
    }

   // Get.back(result: true);
  //  clearForm();
  }

  /// ---------------- UPDATE EVENT ----------------
  void updateEvent(EventModel event,BuildContext context) async{
    String apiDate  = convertDateFormatApi(dateCtrl.text.trim());
    MyProgressBar.showLoadingDialog(context: context);
    Map<String, String> body = {
      "user_id": StorageProvider.getUserData()?.id.toString() ?? "",
      "event_title": titleCtrl.text.trim(),
      "description": descCtrl.text.trim(),
      "event_date": apiDate, // Format YYYY-MM-DD
      "event_time": formatTimeTo24Hour(timeCtrl.text.trim()),
      "address": locationCtrl.text.trim(),
      "city": cityName.toString(),
      "country": country.toString(),
      "latitude": latitude.toString(),
      "longitude": longitude.toString(),
      "event_id":event.id!.toString()
    };

    List<File> imageFiles = selectedImages;

    try {
      bool success = await ApiService().updateEvent(body: body, newImages: kIsWeb?webImages:imageFiles, removedImages: removedImagesList);
      if (success) {
        MyProgressBar.hideLoadingDialog(context: context);
        myEvents.refresh();
        clearForm();
        Get.back(result: true); // Ya Home te navigate karo
      }else{
        MyProgressBar.hideLoadingDialog(context: context);
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: context);
      showCommonSnackbar(title: "Error", message: e.toString());
    }
  //  Get.back(result: true);
  }

  bool validate() {
    if (titleCtrl.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.titleReq);
      return false;
    }
    if (locationCtrl.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.locationReq);
      return false;
    }
    if (dateCtrl.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.dateReq);
      return false;
    }
    if (timeCtrl.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.timeReq);
      return false;
    }
    if (descCtrl.text.trim().isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.descReq);
      return false;
    }
    // Check if at least one image exists (Local or Network)
    if (selectedImages.isEmpty && networkImages.isEmpty) {
      showCommonSnackbar(title: AppStrings.errorText, message: AppStrings.imageReq);
      return false;
    }
    return true;
  }

  /// ---------------- FILL EDIT FORM ----------------
  void fillForm(EventModel event) {
    titleCtrl.text = event.eventTitle!;
    locationCtrl.text = event.address!;
    descCtrl.text = event.description!;
    latitude = double.parse(event.latitude??"0.0");
    longitude = double.parse(event.longitude??"0.0");
    cityName = event.city??"";
    country = event.country??"";
    if (event.eventDate != null && event.eventDate!.isNotEmpty) {
      try {
        // 2. String (e.g. "2026-02-16") nu DateTime object vich badlo
        DateTime parsedDate = DateTime.parse(event.eventDate!);

        // 3. Controller de selectedDate variable nu update karo
        selectedDate.value = parsedDate;

        // 4. TextField vich formatted date set karo (dd-MM-yyyy)
        dateCtrl.text = DateFormat(AppStrings.dateFormet).format(parsedDate);
      } catch (e) {
        print("Date parsing error: $e");
        dateCtrl.text = event.eventDate!; // Error aave taan raw string dikhao
      }
    }
    timeCtrl.text =formatTimeTo12Hour(event.eventTime) ?? "";;
    networkImages.assignAll(event.eventImages!);
    selectedImages.clear();
  }

  /// ---------------- CLEAR ----------------
  void clearForm() {
    titleCtrl.clear();
    locationCtrl.clear();
    descCtrl.clear();
    dateCtrl.clear();
    titleCtrl.clear();
    selectedDate.value = null;
    selectedImages.clear();
    networkImages.clear();
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


  void showIosTimePicker(BuildContext context) {
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
                  timeCtrl.text = formattedTime;
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



  void deleteEvent(EventModel event) async {
 //   myEvents.remove(event);
  //  filterEvents(searchController.text);
    try {
      // 1. Loading dikhao
      MyProgressBar.showLoadingDialog(context: Get.context!);

      UserModel response = await ApiService().removeEventApi(event.id!);

      // 2. Loading band karo
      MyProgressBar.hideLoadingDialog(context: Get.context!);

      if (response.status == 1) {
        // ✅ Success Message
        showCommonSnackbar(
            title: "Success",
            message: response.message ?? "Event removed successfully"
        );
        myEvents.remove(event);
        filterEvents(searchController.text);
      } else {
        // ❌ Backend Error Message
        showCommonSnackbar(
            title: "Error",
            message: response.message ?? "Failed to remove event"
        );
      }
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      showCommonSnackbar(title: "Error", message: e.toString());
    }

  }

  @override
  void onClose() {
    titleCtrl.dispose();
    locationCtrl.dispose();
    descCtrl.dispose();
    dateCtrl.dispose();
    timeCtrl.dispose();
    super.onClose();
  }
}
