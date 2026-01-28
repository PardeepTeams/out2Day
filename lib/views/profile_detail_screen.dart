/*
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import '../../controller/profile_detail_controller.dart';

class ProfileDetailScreen extends StatelessWidget {
  ProfileDetailScreen({super.key});

  final ProfileDetailController controller = Get.put(ProfileDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonAppBar(title: AppStrings.profile,
      ),
      body: Obx( (){
        if(controller.isLoading.value){
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.baseColor,
            ),
          );
        }
        return CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(
            child: Column(
              children: [
                const SizedBox(height: 40),

                /// Profile Image
                Obx(() => CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.grey.shade200,
                  backgroundImage: CachedNetworkImageProvider(controller.image.value),
                )),

                const SizedBox(height: 12),

                /// Name
                Obx(() => Text(
                  controller.name.value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    fontFamily: "semibold",
                    color: MyColors.baseColor,
                  ),
                )),

                const SizedBox(height: 4),

                /// Phone number with verified icon
                Obx(() => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      controller.phone.value,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: MyColors.baseColor,
                        fontFamily: "regular",
                      ),
                    ),
                    const SizedBox(width: 6),
                    const Icon(Icons.verified, color: Colors.green, size: 16),
                  ],
                )),

                const SizedBox(height: 16),

                /// CONNECT BUTTON
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: SizedBox(
                    width: double.infinity,
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.connectUser();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: MyColors.baseColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        elevation: 2,
                      ),
                      child: const Text(
                        AppStrings.btnConnect,
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: "semibold",
                          fontWeight: FontWeight.w600,
                          color: MyColors.white,
                        ),
                      ),
                    ),
                  ),
                ),


                const SizedBox(height: 24),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child:
                Align(
                  alignment: AlignmentGeometry.centerLeft,
                  child: _infoTile("Location", controller.location.value) ,
                ))
               ,
                const SizedBox(height: 24),
                /// Info Grid (Location, Profession, Height, Age)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _infoTile("Profession", controller.profession.value),
                      _infoTile("Age", "${controller.age.value}"),
                    ],
                  ),
                ),


                const SizedBox(height: 24),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment:AlignmentGeometry.centerLeft,
                        child:_infoTile(AppStrings.ethnicityLabel, controller.ethnicity.value) ,
                      ),
                      const SizedBox(height: 24),
                      _infoTile(AppStrings.drinking, controller.drinking.value),
                      const SizedBox(height: 24),
                      _infoTile(AppStrings.smoking, "${controller.smoking.value}"),
                    ],
                  ),
                ),


                const SizedBox(height: 24),

                /// About Me
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.centerLeft,
                        child:  const Text(
                          AppStrings.aboutLabel,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: "semibold",
                              color: MyColors.baseColor),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: AlignmentGeometry.centerLeft,
                        child:Text(
                          controller.aboutMe.value,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "regular",
                            color: MyColors.baseColor,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ) ,
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                /// Hobbies Chips
              /// Hobbies Chips Section
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // Left alignment confirm karda hai
                  children: [
                    const Text(
                      AppStrings.hobby,
                      style: TextStyle(
                          fontSize: 16, // InfoTile de label naal match karan layi
                          fontWeight: FontWeight.w600,
                          fontFamily: "semibold",
                          color: MyColors.baseColor),
                    ),
                    const SizedBox(height: 8), // Gap manage karan layi
                    Obx(() => Align(
                      alignment: Alignment.centerLeft, // Chips nu left side push karan layi
                      child: Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        alignment: WrapAlignment.start, // Multi-line alignment left rakhan layi
                        children: controller.hobbies.map((hobby) {
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: MyColors.baseColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: MyColors.baseColor.withOpacity(0.3)),
                            ),
                            child: Text(
                              hobby,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                fontFamily: "regular",
                                color: MyColors.baseColor,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    )),
                  ],
                ),
              ),

                const SizedBox(height: 24),

                /// Gallery
              */
/*  Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        "Gallery",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            fontFamily: "semibold",
                            color: MyColors.baseColor),
                      ),
                      Text(
                        "See all",
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            fontFamily: "medium",
                            color: MyColors.baseColor),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                /// Gallery Grid
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Obx(() => GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.gallery.length,
                    gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      return CachedNetworkImage(
                        imageUrl: controller.gallery[index],
                        fit: BoxFit.cover,
                      );
                    },
                  )),
                ),*//*

              //  const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ); }),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
                fontSize: 16, color: MyColors.baseColor, fontFamily: "semibold")),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "regular",
                color: MyColors.baseColor)),
      ],
    );
  }
}
*/


import 'package:Out2Do/routes/app_routes.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import '../../controller/profile_detail_controller.dart';

class ProfileDetailScreen extends StatelessWidget {
  ProfileDetailScreen({super.key});

  final ProfileDetailController controller = Get.put(ProfileDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      /// 🔹 Title change based on isMyProfile
      appBar: CommonAppBar(
        title: controller.isMyProfile.value ? "My Profile" : AppStrings.profile,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: MyColors.baseColor,
            ),
          );
        }
        return CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const SizedBox(height: 40),

                  /// Profile Image
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade200,
                    backgroundImage: CachedNetworkImageProvider(controller.image.value),
                  ),

                  const SizedBox(height: 12),

                  /// Name
                  Text(
                    controller.name.value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                      fontFamily: "semibold",
                      color: MyColors.baseColor,
                    ),
                  ),

                  const SizedBox(height: 4),

                  /// Phone number with verified icon
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        controller.phone.value,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: MyColors.baseColor,
                          fontFamily: "regular",
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.verified, color: Colors.green, size: 16),
                    ],
                  ),

                  const SizedBox(height: 16),

                  /// 🔹 CONNECT OR EDIT BUTTON
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 60),
                    child: SizedBox(
                      width: double.infinity,
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          if (controller.isMyProfile.value) {
                            Get.toNamed(
                              AppRoutes.profileCreation,
                              arguments: true,
                            )?.then((result) {
                              if (result == true) {
                                //  controller.loadUserFromStorage(); // 🔥 refresh
                              }
                            });
                          } else {
                            controller.connectUser();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.baseColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (controller.isMyProfile.value) ...[
                              const Icon(Icons.edit, color: MyColors.white, size: 18),
                              const SizedBox(width: 8),
                            ],
                            Text(
                              controller.isMyProfile.value ? "Edit" : AppStrings.btnConnect,
                              style: const TextStyle(
                                fontSize: 16,
                                fontFamily: "semibold",
                                fontWeight: FontWeight.w600,
                                color: MyColors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: _infoTile("Location", controller.location.value),
                    ),
                  ),
                  const SizedBox(height: 24),

                  /// Info Grid (Profession, Age)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _infoTile("Profession", controller.profession.value),
                        _infoTile("Age", "${controller.age.value}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Align(
                          alignment:AlignmentGeometry.centerLeft,
                          child:_infoTile(AppStrings.ethnicityLabel, controller.ethnicity.value) ,
                        ),
                        const SizedBox(height: 24),
                        _infoTile(AppStrings.drinking, controller.drinking.value),
                        const SizedBox(height: 24),
                        _infoTile(AppStrings.smoking, "${controller.smoking.value}"),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// About Me
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.aboutLabel,
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontFamily: "semibold",
                              color: MyColors.baseColor),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.aboutMe.value,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            fontFamily: "regular",
                            color: MyColors.baseColor,
                          ),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  /// Hobbies Chips Section
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          AppStrings.hobby,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              fontFamily: "semibold",
                              color: MyColors.baseColor),
                        ),
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            alignment: WrapAlignment.start,
                            children: controller.hobbies.map((hobby) {
                              return Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: MyColors.baseColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: MyColors.baseColor.withOpacity(0.3)),
                                ),
                                child: Text(
                                  hobby,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    fontFamily: "regular",
                                    color: MyColors.baseColor,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _infoTile(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 16,
                color: MyColors.baseColor,
                fontFamily: "semibold")),
        const SizedBox(height: 4),
        Text(value,
            style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w400,
                fontFamily: "regular",
                color: MyColors.baseColor)),
      ],
    );
  }
}
