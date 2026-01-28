import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../utils/app_strings.dart';
import '../utils/colors.dart';


class DialogHelper {
  static void showIosDialog({
    required String title,
    required String message,
    required String confirmText,
    required VoidCallback onConfirm,
    bool isDeleteAction = false, // Agar delete hai to text Red dikhega
  }) {
    Get.dialog(
      CupertinoAlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: "semibold",
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: MyColors.black,
          ),
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            message,
            style: const TextStyle(
              fontFamily: "regular",
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.black87,
            ),
          ),
        ),
        actions: [
          CupertinoDialogAction(
            child: const Text(
              AppStrings.cancel,
              style: TextStyle(fontFamily: "regular", color: MyColors.black,
              fontWeight: FontWeight.w400,
              fontSize: 18,),
            ),
            onPressed: () => Get.back(),
          ),

          /// ✅ Confirm / Delete Button
          CupertinoDialogAction(
            isDestructiveAction: isDeleteAction, // iOS style red text
            onPressed: () {
              Get.back();
              onConfirm();
            },
            child: Text(
              confirmText,
              style: TextStyle(
                fontFamily: "semibold",
                fontWeight: FontWeight.w600,
                fontSize: 18,
                color: isDeleteAction ? MyColors.red : MyColors.baseColor,
              ),
            ),
          ),
        ],
      ),
      barrierDismissible: true,
    );
  }
}