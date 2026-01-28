import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../controller/connect_controller.dart';
import '../../../../utils/app_strings.dart';
import '../../../../utils/colors.dart';
import '../../../../widgets/common_home_app_bar.dart';
import 'widgets/swipe_card.dart';

class ConnectTab extends StatelessWidget {
  ConnectTab({super.key});

  final ConnectController controller = Get.put(ConnectController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: const CommonHomeAppBar(
      ),
      body: Center(
        child: Obx(() {
          if(controller.isLoading.value){
            return CircularProgressIndicator(
              color: MyColors.baseColor,
            );
          }
          if (controller.profiles.isEmpty) {
            return const Text(
              AppStrings.noCoonectUsers,
              style: TextStyle(fontSize: 18),
            );
          }

          return Stack(
            alignment: Alignment.center,
            children: controller.profiles
                .map((profile) => SwipeCard(
              profile: profile,
              controller: controller,
            ))
                .toList(),
          );
        }),
      ),
    );
  }
}
