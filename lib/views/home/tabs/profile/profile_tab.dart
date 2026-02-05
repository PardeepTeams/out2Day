import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_home_app_bar.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import '../../../../controller/profile_settings_controller.dart';
import '../../../../routes/app_routes.dart';
import '../../../../utils/colors.dart';
import '../../../../utils/common_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';


class ProfileTab extends StatelessWidget {
  ProfileTab({super.key});

  final ProfileSettingsController controller = Get.put(ProfileSettingsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonHomeAppBar(),
      body: Obx((){
         if(controller.isSettingsLoading.value){
           return Center(
             child: CircularProgressIndicator(
               color: MyColors.baseColor,
             ),
           );
         }
        return    SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Obx(() {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    children: [
                      /// Profile Image
                     /* CircleAvatar(
                        radius: 40,
                        backgroundColor: MyColors.greyLight,
                        backgroundImage:  controller.profileImageUrl.value.isNotEmpty
                            ? NetworkImage(controller.profileImageUrl.value)
                            : null,
                        child: (controller.profileImageUrl.value.isEmpty)
                            ? const Icon(
                          Icons.person,
                          color: MyColors.baseColor,
                          size: 40,
                        )
                            : null,
                      ),*/

                      CircleAvatar(
                        radius: 35,
                        backgroundColor: MyColors.greyLight,
                        child: ClipOval(
                            child: CachedNetworkImage(
                              imageUrl: controller.profileImageUrl.value, // Aapka variable
                              fit: BoxFit.cover,
                              width: 70,
                              height: 70,

                              // ✅ Cache settings: Agar image cache mein hai toh bina loader ke turant dikhegi
                              placeholderFadeInDuration: Duration.zero,
                              fadeInDuration: const Duration(milliseconds: 500), // Puranay 1500ms se kam kiya taaki lag na lage

                              // ✅ Image cache management
                              memCacheWidth: 200, // Memory optimization
                              memCacheHeight: 200,

                              errorWidget: (context, url, error) => const Icon(
                                Icons.person,
                                size: 30,
                                color: Colors.grey,
                              ),
                            )
                        ),
                      ),

                      const SizedBox(width: 16),

                      /// Name & Age
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            semiboldText(
                              controller.userName.value,
                            ),
                            regularText(
                              "${controller.userAge.value} yrs",
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap:(){
                          Get.toNamed(
                            AppRoutes.profileCreation,
                            arguments: true,
                          )?.then((result) {
                            if (result == true) {
                                controller.loadUserFromStorage(); // 🔥 refresh
                            }
                          });
                        },
                        child: Container(
                          decoration: BoxDecoration(
                            color: MyColors.baseColor,
                            shape: BoxShape.circle,
                            border: Border.all(color: MyColors.white, width: 2),
                          ),
                          padding: const EdgeInsets.all(6),
                          child: const Icon(
                            Icons.edit,
                            color: MyColors.white,
                            size: 18,
                          ),
                        ),
                      ),

                    ],
                  ),
                );
              }),

              const SizedBox(height: 30),

              /// Notifications Toggle
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Obx(() {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      mediumText(AppStrings.notifications,null),
                      Switch(
                        value: controller.notificationsEnabled.value,
                        activeThumbColor: MyColors.baseColor,
                        onChanged: controller.toggleNotifications,
                      ),
                    ],
                  );
                }),
              ),

              _settingsOption(
                title: AppStrings.myProfile,
                icon: Icons.person,
                onTap:(){


                  Get.toNamed(AppRoutes.userProfileDetail,arguments: {'id':controller.userId.value ,"isMy":true,"fromChat":false})?.then((value) {
                     controller.loadUserFromStorage();
                  });
                },
              ),
              /// Options List
              _settingsOption(
                title: AppStrings.blockUsers,
                icon: Icons.block,
                onTap:(){
                  controller.blockUsers();
                },
              ),
              _settingsOption(
                title: AppStrings.faqs,
                icon: Icons.help,
                onTap: controller.faqs,
              ),
              _settingsOption2(
                title: AppStrings.safty,
                onTap: controller.safety,
              ),

             /* _settingsOption(
                title: AppStrings.privacyPolicy,
                icon: Icons.privacy_tip,
                onTap: controller.privacyPolicy,
              ),
              _settingsOption(
                title: AppStrings.termsConditions,
                icon: Icons.description,
                onTap: controller.termsAndConditions,
              ),*/

              ...controller.dynamicPages.map((page) {
                return _settingsOption(
                  title: page.title ?? "",
                  imageUrl: page.image, // Backend image URL
                  onTap: () {
                    if(kIsWeb){
                     controller.launchInBrowser(page.pageUrl!);
                    }else{
                      Get.toNamed(AppRoutes.privacyPolicy,
                          arguments: {
                        "url":page.pageUrl
                          })?.then((value) {
                        // controller.refreshHome();
                      });
                    }
                  },
                );
              }).toList(),



              _settingsOption(
                title: AppStrings.logout,
                icon: Icons.logout,
                onTap: (){
                  controller.logout(context);
                },
              ),
              _settingsOption(
                  title: AppStrings.deleteAccount,
                  icon: Icons.delete_forever,
                  onTap: (){
                    controller.deleteAccount(context);
                  },
                  isDestructive: true
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      })
   ,
    );
  }

  /// Single Option Row
  Widget _settingsOption({
    required String title,
    IconData? icon,        // Optional IconData
    String? imageUrl,      // Optional Image URL from Backend
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? MyColors.red : MyColors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: MyColors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔥 Icon ya Network Image check
            if (imageUrl != null)
              Image.network(imageUrl, width: 24, height: 24, errorBuilder: (c, e, s) => Icon(Icons.settings, color: color))
            else
              Icon(icon ?? Icons.privacy_tip, color: color),

            const SizedBox(width: 16),
            mediumText(title, color),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _settingsOption2({
    required String title,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? MyColors.red : MyColors.black;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: MyColors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: MyColors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            // 🔥 Icon ya Network Image check
            SvgPicture.asset("assets/safety_icon.svg",width: 24, height: 24,),
            const SizedBox(width: 16),
            mediumText(title, color),
            const Spacer(),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }


}

