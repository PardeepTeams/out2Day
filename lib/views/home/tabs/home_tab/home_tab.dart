import 'package:Out2Do/controller/home_tab_controller.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/views/home/tabs/home_tab/widgets/profile_grid_card.dart';
import 'package:Out2Do/views/home/tabs/home_tab/widgets/profile_list_card.dart';
import 'package:Out2Do/widgets/common_app_bar_static.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../utils/colors.dart';
import '../../../../widgets/common_home_app_bar.dart';


class HomeTab extends StatelessWidget {
  HomeTab({super.key});

  final HomeTabController controller = Get.put(HomeTabController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonHomeAppBarStatic(
        title: "",
          showGridToggle: true,
        isGridView: controller.isGridView,
        onGridToggle: () => controller.isGridView.toggle(),
        notificationCount: 0,

      ),
      body: Column(
        children: [
          /// 📸 Profiles
          Expanded(
            child: Obx(() {
              if(controller.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(
                    color: MyColors.baseColor,
                  ),
                );
              }
              if (controller.isGridView.value) {
                /// GRID VIEW
                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.profiles.length,
                  gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 12,
                    crossAxisSpacing: 12,
                    childAspectRatio: 0.7,
                  ),
                  itemBuilder: (_, index) {
                    return ProfileGridCard(
                      profile: controller.profiles[index], controller: controller,
                    );
                  },
                );
              } else {
                /// SINGLE VIEW
                return  ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: controller.profiles.length,
                  itemBuilder: (_, index) {
                    return ProfileListCard(
                      profile: controller.profiles[index],
                      cardIndex: index,
                      controller: controller,
                    );
                  },
                );;
              }
            }),
          ),
        ],
      ),
    );
  }
}
