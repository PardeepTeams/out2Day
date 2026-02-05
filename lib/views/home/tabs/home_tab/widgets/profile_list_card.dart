import 'package:Out2Do/controller/swipe_controller.dart';
import 'package:Out2Do/models/user_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/home_tab_controller.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../../utils/common_styles.dart'; // 👈 Import zaroori hai

class ProfileListCard extends StatelessWidget {
  final UserData profile;
  final int cardIndex;
  final SwipeController controller;

  const ProfileListCard({
    super.key,
    required this.profile,
    required this.cardIndex,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    final PageController pageController = PageController();

    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.ewProfileDetail, arguments: {'id': profile.id, "isMy": false,"fromChat":false})?.then((value) {
          controller.fetchProfiles();
        });
      },
      child: Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            /// 📸 IMAGE SLIDER
            ClipRRect(
              borderRadius: const BorderRadius.horizontal(
                left: Radius.circular(16),
              ),
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  SizedBox(
                    width: 110,
                    height: double.infinity,
                    child:CachedNetworkImage(
                      imageUrl: profile.additionalImagesThumb!.first,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: MyColors.greyLight,
                        child: const Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: MyColors.baseColor,
                          ),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: MyColors.greyLight,
                        child: const Icon(Icons.broken_image, color: Colors.grey),
                      ),
                      // Memory optimization ke liye
                      memCacheHeight: 300,
                    )
                  ),

                ],
              ),
            ),

            /// 👤 PROFILE INFO
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    semiboldTextWhite("${profile.firstName!}, ${calculateAge(profile.dob!).toString()}"),
                    whiteRegularText(profile.profession ?? ""),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}


