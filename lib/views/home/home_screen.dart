
import 'dart:io';

import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/views/business/business_tab_screen.dart';
import 'package:Out2Do/views/home/tabs/chat/chat_tab.dart';
import 'package:Out2Do/views/home/tabs/connect/connect_tab.dart';
import 'package:Out2Do/views/home/tabs/home_tab/home_tab.dart';
import 'package:Out2Do/views/home/tabs/profile/profile_tab.dart';
import 'package:Out2Do/views/home/tabs/swipe_card_screen.dart';
import 'package:Out2Do/views/notifications_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import '../../controller/connect_controller.dart';
import '../../controller/home_controller.dart';
import '../../controller/home_tab_controller.dart';
import '../../utils/colors.dart';
import '../events/events_tab_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key);

  final HomeController controller = Get.put(HomeController());

  // Humne List ko hata kar ye function banaya hai jo har baar naya widget return karega
  Widget _getRefreshableTab(int index) {
    switch (index) {
      case 0:
        return SwipeCardScreen();
      case 1:
        return EventsTabScreen();
      case 2:
        return BusinessesTabScreen();
      case 3:
        return ChatTab();
      case 4:
        return ProfileTab();
      default:
        return HomeTab();
    }
  }

  @override
  Widget build(BuildContext context) {

    return PopScope(
      canPop: false,
        onPopInvokedWithResult: (didPop,result){
           if(controller.selectedIndex.value !=0){
             controller.changeTab(0);
           }else{
              exit(0);
           }
        },
        child: Scaffold(
      // Har baar naya instance milega toh screen refresh hogi
      body: Obx(() => _getRefreshableTab(controller.selectedIndex.value)),

      bottomNavigationBar: Obx(
            () => SafeArea(child:
        Container(
          decoration: BoxDecoration(
            color: MyColors.white,
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(25), // Adjust radius as needed
              topRight: Radius.circular(25),
            ),
            boxShadow: [
              BoxShadow(
                color: MyColors.black.withOpacity(0.1),
                blurRadius: 25,
                offset: const Offset(0, -3),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTabItem(icon: "assets/home.svg", label: AppStrings.home, index: 0),
              _buildTabItem(icon: "assets/events.svg", label: AppStrings.events, index: 1),
              _buildTabItem(icon: "assets/activity.svg", label: AppStrings.connect, index: 2,
                  badgeCount: controller.unreadActivity.value),
              _buildTabItem(
                  icon: "assets/chat.svg",
                  label: AppStrings.chat,
                  index: 3,
                  badgeCount: controller.unreadChats.value),
              _buildTabItem(icon: "assets/profile.svg", label: AppStrings.profile, index: 4),
            ],
          ),
        )),
      ),
    ))
      ;
  }

  Widget _buildTabItem(
      {required String icon,
        required String label,
        required int index,
        int badgeCount = 0}) {
    return Obx(() {
      final isSelected = controller.selectedIndex.value == index;

      return GestureDetector(
        onTap: () => controller.changeTab(index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? MyColors.white : MyColors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgPicture.asset(
                    icon,
                    color: isSelected ? MyColors.baseColor : MyColors.black3,
                    width: 28,
                    height: 28,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(
                      color: isSelected ? MyColors.baseColor : MyColors.black3,
                      fontSize: 12,
                      fontFamily: "medium",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              if (badgeCount > 0)
                Positioned(
                  top: -5,
                  right: -5,
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 1.5),
                    ),
                    constraints: const BoxConstraints(minWidth: 18, minHeight: 18),
                    child: Center(
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    });
  }
}