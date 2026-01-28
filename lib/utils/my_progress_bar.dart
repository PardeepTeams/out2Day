import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'colors.dart';

class MyProgressBar {
  static Widget myProgressBar() {
    return const Center(
      child: CircularProgressIndicator(
        color: MyColors.baseColor,
      ),
    );
  }

  static void showLoadingDialog({required BuildContext context}) {
    showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return PopScope(
          canPop: false,
          child: myProgressBar(),
        );
      },
    );
  }

  static void hideLoadingDialog({required BuildContext context}) {
    Navigator.of(context, rootNavigator: true).pop();
  }
}
