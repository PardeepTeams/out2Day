import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/place_type.dart';
import 'package:google_places_flutter/model/prediction.dart';
import '../models/business_model.dart';
import 'app_strings.dart';
import 'colors.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein

Widget myTitleText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      color: MyColors.white,
      fontFamily: 'semibold',
      fontWeight: FontWeight.w700,
    ),
  );
}

Widget semiboldText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      color: MyColors.black,
      fontFamily: 'semibold',
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget semiboldTextLarge(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 36,
      color: MyColors.black,
      fontFamily: 'semibold',
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget semiboldTextLarge2(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 40,
      color: MyColors.black,
      fontFamily: 'semibold',
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget semiboldTextWhite(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 20,
      color: MyColors.white,
      fontFamily: 'semibold',
      fontWeight: FontWeight.w600,
    ),
  );
}

Widget regularText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      color: MyColors.black,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget regularTextSingleLine(String text) {
  return Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontSize: 14,
      color: MyColors.black,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget regularText2(String text) {
  return Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontSize: 12,
      color: MyColors.greyText,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget regularTextCenter(String text) {
  return Text(
    text,
    textAlign: TextAlign.center,
    style: const TextStyle(
      fontSize: 14,
      color: MyColors.black,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget whiteRegularText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      color: MyColors.white,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget whiteRegularText2(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      color: MyColors.white,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget lightText(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 12,
      color: MyColors.greyText,
      fontFamily: 'light',
      fontWeight: FontWeight.w300,
    ),
  );
}

Widget regularTextWhite(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 14,
      color: MyColors.black,
      fontFamily: 'regular',
      fontWeight: FontWeight.w400,
    ),
  );
}

Widget mediumText(String text, Color? color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 16,
      color: color != null ? color : MyColors.black,
      fontFamily: 'medium',
      fontWeight: FontWeight.w500,
    ),
  );
}
Widget mediumTextSingleLine(String text, Color? color) {
  return Text(
    text,
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
      fontSize: 16,
      color: color != null ? color : MyColors.black,
      fontFamily: 'medium',
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget mediumTextLarge(String text, Color? color) {
  return Text(
    text,
    style: TextStyle(
      fontSize: 20,
      color: color != null ? color : MyColors.black,
      fontFamily: 'medium',
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget mediumTextWhite(String text) {
  return Text(
    text,
    style: const TextStyle(
      fontSize: 16,
      color: MyColors.black,
      fontFamily: 'medium',
      fontWeight: FontWeight.w500,
    ),
  );
}

Widget commonTextFieldLargeGap() {
  return const SizedBox(height: 14);
}

Widget commonTextFieldSmallGap() {
  return const SizedBox(height: 7);
}

Widget commonButtonGap() {
  return const SizedBox(height: 20);
}

/// Common function to show a Snackbar
void showCommonSnackbar({
  required String title,
  required String message,
  Color backgroundColor = MyColors.baseColor,
  Color textColor = MyColors.white,
  SnackPosition snackPosition = SnackPosition.BOTTOM,
  Duration duration = const Duration(seconds: 3),
}) {
  Get.snackbar(
    title,
    message,
    backgroundColor: backgroundColor,
    snackPosition: snackPosition,
    duration: duration,
    colorText: textColor,
    // default text color
    margin: const EdgeInsets.all(16),
    // some margin
    borderRadius: 10,
  );
}

void showImageSourceSheet({required Function(ImageSource) onImageSelected}) {
  Get.bottomSheet(
    Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag handle for better UX
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 20),
          ListTile(
            leading: const Icon(Icons.camera_alt, color: MyColors.baseColor),
            title: const Text(
              AppStrings.camera,
              style: TextStyle(
                fontFamily: "regular",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: MyColors.black,
              ),
            ),
            onTap: () {
              Get.back(); // Pehle sheet band hogi
              onImageSelected(ImageSource.camera); // Phir callback trigger hoga
            },
          ),
          ListTile(
            leading: const Icon(Icons.photo_library, color: MyColors.baseColor),
            title: const Text(
              AppStrings.gallery,
              style: TextStyle(
                fontFamily: "regular",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: MyColors.black,
              ),
            ),
            onTap: () {
              Get.back();
              onImageSelected(ImageSource.gallery);
            },
          ),
          const SizedBox(height: 10),
        ],
      ),
    ),
    isScrollControlled: true,
  );
}

Widget googlePlacesTextField({
  required TextEditingController controller,
  required String hint,
  required Function(Prediction) onLocationClick,
}) {
  final RxBool showClearIcon = (controller.text.isNotEmpty).obs;
  controller.addListener(() {
    if (showClearIcon.value != controller.text.isNotEmpty) {
      showClearIcon.value = controller.text.isNotEmpty;
    }
  });
  return Stack(
    alignment: Alignment.centerRight,
    children: [
      GooglePlaceAutoCompleteTextField(
        textEditingController: controller,
     //   googleAPIKey: "AIzaSyCFpI3IuqWxHr4rz87uT-7HO-ZIS-f1I7Y",
        googleAPIKey: kIsWeb?"AIzaSyAvGB9QmQqympYyGAeECdbXYbHMyOfrxA4":"AIzaSyDkCan3Xw2Wrd3oQyMwjYhC56M0VEeiUTU",
        textStyle: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: MyColors.black,
          fontFamily: "regular",
        ),
        inputDecoration: InputDecoration(
          counterText: "",
          hintText: hint,
          filled: true,
          fillColor: MyColors.white,
          contentPadding: const EdgeInsets.only(
              left: 16,
              right: 45, // 👈 Eh padding text nu icon ton pehle rok devegi
              top: 16,
              bottom: 16
          ),

          // ✅ Border Styling (CommonTextField ton copy kiti)
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
          ),
        ),
        boxDecoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        debounceTime: 400,
        isLatLngRequired: true,
        getPlaceDetailWithLatLng: (Prediction prediction) => onLocationClick.call(prediction),
        itemClick: (Prediction prediction) {
         /* controller.value = TextEditingValue(
            text: prediction.description ?? "",
            selection: TextSelection.fromPosition(TextPosition(offset: (prediction.description ?? "").length)),
          );*/
          showClearIcon.value = controller.text.isNotEmpty;
        },
        isCrossBtnShown: false, // Default button band kar deo
      ),

      // 🔥 TUHADA CUSTOM CROSS BUTTON
      Obx(() => Visibility(
        visible: showClearIcon.value,
        child: Padding(
          padding: const EdgeInsets.only(right: 12.0),
          child: InkWell(
            onTap: () {
              controller.clear();
              showClearIcon.value = false; // Icon hide karo
            },
            child: Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: MyColors.greyFilled2.withOpacity(0.8),
                border: Border.all(color: MyColors.borderColor, width: 1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.close, size: 14, color: MyColors.black),
            ),
          ),
        ),
      )),
    ],
  );
}




Widget googlePlacesTextFieldWeb({
  required TextEditingController controller,
  required String hint,
  required Function(Prediction) onLocationClick,
}) {
  final RxBool showClearIcon = (controller.text.isNotEmpty).obs;
  controller.addListener(() {
    if (showClearIcon.value != controller.text.isNotEmpty) {
      showClearIcon.value = controller.text.isNotEmpty;
    }
  });

  if (kIsWeb) {
    // Web fallback using JS SDK
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        SizedBox(
          height: 60,
          child: HtmlElementView(
            viewType: 'autocomplete-input',
          ),
        ),
        Obx(() => Visibility(
          visible: showClearIcon.value,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {
                controller.clear();
                showClearIcon.value = false;
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14),
              ),
            ),
          ),
        )),
      ],
    );
  } else {
    // Mobile fallback using existing google_places_flutter
    return Stack(
      alignment: Alignment.centerRight,
      children: [
        GooglePlaceAutoCompleteTextField(
          textEditingController: controller,
          googleAPIKey: "YOUR_MOBILE_KEY",
          textStyle: const TextStyle(fontSize: 14),
          inputDecoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.only(left: 16, right: 45, top: 16, bottom: 16),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
          ),
          getPlaceDetailWithLatLng: onLocationClick,
          itemClick: (Prediction p) {
            controller.text = p.description ?? '';
            showClearIcon.value = controller.text.isNotEmpty;
          },
          isCrossBtnShown: false,
        ),
        Obx(() => Visibility(
          visible: showClearIcon.value,
          child: Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: InkWell(
              onTap: () {
                controller.clear();
                showClearIcon.value = false;
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(0.8),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close, size: 14),
              ),
            ),
          ),
        )),
      ],
    );
  }
}

/*Widget googlePlacesTextField({
  required TextEditingController controller,
  required String hint,
  required Function(Prediction) onLocationClick,
}) {
  return GooglePlaceAutoCompleteTextField(
    textEditingController: controller,
    googleAPIKey: "AIzaSyCFpI3IuqWxHr4rz87uT-7HO-ZIS-f1I7Y",
    textStyle: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: MyColors.black,
      fontFamily: "regular",
    ),
    // 🔹 Is decoration nu CommonTextField de bilkul same rakho
    inputDecoration: InputDecoration(
      counterText: "",
      hintText: hint,
      filled: true,
      fillColor: MyColors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),

      // ✅ Border Styling (CommonTextField ton copy kiti)
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: MyColors.borderColor, width: 1),
      ),
    ),

    // Suggestion box di styling
    boxDecoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(8),
    ),

    debounceTime: 400,
    countries: const ["in", "US"],
    isLatLngRequired: true,
    getPlaceDetailWithLatLng: (Prediction prediction) {
      onLocationClick.call(prediction);
    },
    itemClick: (Prediction prediction) {
      String desc = prediction.description ?? "";
      controller.value = TextEditingValue(
        text: desc,
        selection: TextSelection.fromPosition(TextPosition(offset: desc.length)),
      );
      // Keyboard nu daso ki kamm khatam ho gaya
      FocusManager.instance.primaryFocus?.unfocus();
    },
    // Suggestion list item design
    itemBuilder: (context, index, Prediction prediction) {
      return Container(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            const Icon(Icons.location_on, color: Colors.grey, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                prediction.description ?? "",
                style: const TextStyle(fontSize: 14, fontFamily: "regular"),
              ),
            ),
          ],
        ),
      );
    },
    seperatedBuilder: const Divider(height: 1),
    isCrossBtnShown: true,
    placeType: PlaceType.geocode,
  );
}*/

void dismissKeyboard(BuildContext context) {
  FocusScope.of(context).unfocus();
}

bool isValidEmail(String email) {
  // Email pattern ka regex
  final RegExp emailRegExp = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );
  return emailRegExp.hasMatch(email);
}

String convertDateFormatApi(String inputDate) {
  final inputFormat = DateFormat(AppStrings.dateFormet);
  final outputFormat = DateFormat(AppStrings.apiFormet);

  DateTime date = inputFormat.parse(inputDate);
  return outputFormat.format(date);
}

String changeServerDateFormatToCurrentTimeZone(String date) {
  try {
    final input = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
    final utcDate = input.parseUtc(date).toLocal();
    return DateFormat(AppStrings.dateFormet).format(utcDate);
  } catch (_) {
    return "";
  }
}

Widget image(BusinessModel business) => ClipRRect(
  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
  child: CachedNetworkImage(
    // 👈 Image.network ki jagah
    imageUrl: business.businessImages![0],
    height: 180,
    width: double.infinity,
    fit: BoxFit.cover,
    placeholder: (context, url) => Container(
      height: 180,
      color: MyColors.greyLight,
      child: const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: MyColors.baseColor,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Container(
      height: 190,
      color: MyColors.greyLight,
      child: const Icon(Icons.image_not_supported, color: Colors.grey),
    ),
  ),
);

BoxDecoration cardDecoration() => BoxDecoration(
  color: MyColors.white,
  borderRadius: BorderRadius.circular(18),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 10,
      offset: const Offset(0, 6),
    ),
  ],
);

Widget websiteView(String url) {
  if (url.isEmpty) return const SizedBox();

  return InkWell(
    onTap: () async {
      /*  final uri = Uri.parse(url);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }*/
    },
    child: Row(
      children: [
        const Icon(Icons.language, size: 16, color: MyColors.baseColor),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            url,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontFamily: "regular",
              fontSize: 14,
              color: MyColors.baseColor,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
      ],
    ),
  );
}

String formatAge(String date) {
  DateTime parsedDate = DateTime.parse(date); // 2008-01-01
  return DateFormat(AppStrings.dateFormet).format(parsedDate);
}

int calculateAge(String dob) {
  DateTime birthDate = DateTime.parse(dob);
  DateTime today = DateTime.now();

  int age = today.year - birthDate.year;
  if (today.month < birthDate.month ||
      (today.month == birthDate.month && today.day < birthDate.day)) {
    age--;
  }
  return age;
}

String formatToDdMmmYy(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return "N/A";
  }

  try {
    // 1. Raw string (2026-02-16) nu DateTime vich convert karo
    DateTime dateTime = DateTime.parse(dateString);

    // 2. Format karo: dd (date), MMM (Month name short), yy (year short)
    // Example: 16 Feb 26
    return DateFormat('dd MMM yy').format(dateTime);
  } catch (e) {
    // Agar format galat hove taan original string hi return karo
    return dateString;
  }
}

String formatToDdDayMmmYy(String? dateString) {
  if (dateString == null || dateString.isEmpty) {
    return "N/A";
  }

  try {
    // 1. Raw string (2026-02-16) nu DateTime vich convert karo
    DateTime dateTime = DateTime.parse(dateString);

    // 2. Format karo: dd (date), MMM (Month name short), yy (year short)
    // Example: 16 Feb 26
    return DateFormat('EEEE, dd MMM yyyy').format(dateTime);
  } catch (e) {
    // Agar format galat hove taan original string hi return karo
    return dateString;
  }
}

String formatTimeTo12Hour(String? timeString) {
  if (timeString == null || timeString.isEmpty) return "N/A";

  try {
    // 1. Time string (18:00:00) nu parse karan layi dummy date jodo
    // DateFormat.jms() "18:00:00" format nu parse karda hai
    DateTime tempDate = DateFormat("HH:mm:ss").parse(timeString);

    // 2. Hun 12-hour format (06:00 PM) vich convert karo
    return DateFormat("hh:mm a").format(tempDate);
  } catch (e) {
    return timeString; // Error aaun te original time dikhao
  }
}

String formatTimeTo24Hour(String? timeString) {
  if (timeString == null || timeString.isEmpty) return "N/A";

  try {
    // 1. Time string (18:00:00) nu parse karan layi dummy date jodo
    // DateFormat.jms() "18:00:00" format nu parse karda hai

    DateTime tempDate = DateFormat("hh:mm a").parse(timeString);

    // 2. Hun 12-hour format (06:00 PM) vich convert karo
    return DateFormat("HH:mm:ss").format(tempDate);
  } catch (e) {
    return timeString; // Error aaun te original time dikhao
  }
}

String getFormattedMessageTimeLastSeen({required int timestamp}) {
  try {
    if (timestamp <= 0) {
      return "Offline";
    }
    var now = DateTime.now();
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    if (now.difference(dateTime).inMinutes <= 1) {
      return "Last seen just now";
    } else if (now.difference(dateTime).inMinutes < 60) {
      return "Last seen ${now.difference(dateTime).inMinutes} min ago";
    } else if (now.difference(dateTime).inHours < 24 &&
        dateTime.day == now.day) {
      return "Last seen today at ${DateFormat("hh:mm a").format(dateTime)}";
    } else if (now.difference(dateTime).inDays < 7) {
      return "Last seen ${DateFormat("EEE 'at' hh:mm a").format(dateTime)}";
    } else if (now.difference(dateTime).inDays < 360 &&
        now.year == dateTime.year) {
      return "Last seen ${DateFormat("dd MMM 'at' hh:mm a").format(dateTime)}";
    } else {
      return "Last seen ${DateFormat("dd-MM-yyyy 'at' hh:mm a").format(dateTime)}";
    }
  } catch (e) {
    debugPrint("Error formatting message time : $e");
    return "";
  }
}

String getFormattedMessageTime({required int timestamp}) {
  try {
    if (timestamp <= 0) {
      return "";
    }
    var now = DateTime.now();
    var dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    if (now.difference(dateTime).inMinutes <= 1) {
      return "Just now";
    } else if (now.difference(dateTime).inMinutes < 60) {
      return "${now.difference(dateTime).inMinutes} min ago";
    } else if (now.difference(dateTime).inHours < 24 &&
        dateTime.day == now.day) {
      return "${now.difference(dateTime).inHours} hours ago";
    } else if (now.difference(dateTime).inDays < 7) {
      return DateFormat("EEE hh:mm a").format(dateTime);
    } else if (now.difference(dateTime).inDays < 360 &&
        now.year == dateTime.year) {
      return DateFormat("dd MMM 'at' hh:mm a").format(dateTime);
    } else {
      String formattedDate =
      DateFormat("dd-MM-yyyy 'at' hh:mm a").format(dateTime);
      return formattedDate;
    }
  } catch (e) {
    debugPrint("Error formatting message time : $e");
    return "";
  }
}
