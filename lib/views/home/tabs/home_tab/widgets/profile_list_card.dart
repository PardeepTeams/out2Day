import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../controller/home_tab_controller.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import zaroori hai

class ProfileListCard extends StatelessWidget {
  final ProfileModel profile;
  final int cardIndex;
  final HomeTabController controller;

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
        Get.toNamed(AppRoutes.userProfileDetail)?.then((value) {
          controller.refreshHome();
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
                    child: PageView.builder(
                      controller: pageController,
                      itemCount: profile.images.length,
                      onPageChanged: (index) {
                        controller.updateImageIndex(cardIndex, index);
                      },
                      itemBuilder: (_, index) {
                        return CachedNetworkImage(
                          imageUrl: profile.images[index],
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
                        );
                      },
                    ),
                  ),

                  /// 🔘 DOT INDICATOR
                  Positioned(
                    bottom: 6,
                    child: Obx(() {
                      final activeIndex =
                      controller.getImageIndex(cardIndex);

                      return Row(
                        children: List.generate(
                          profile.images.length,
                              (index) => AnimatedContainer(
                            duration:
                            const Duration(milliseconds: 250),
                            margin:
                            const EdgeInsets.symmetric(horizontal: 2),
                            height: 6,
                            width: activeIndex == index ? 14 : 6,
                            decoration: BoxDecoration(
                              color: activeIndex == index
                                  ? MyColors.baseColor
                                  : Colors.white.withOpacity(0.7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                        ),
                      );
                    }),
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
                    Text(
                      "${profile.name}, ${profile.age}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: "regular",
                        color: MyColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "5 km away",
                      style: const TextStyle(
                        fontSize: 13,
                        fontFamily: "regular",
                        color: Colors.grey,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// ❤️ CONNECT / CONNECTED BUTTON
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: GestureDetector(
                onTap: () => controller.connectProfile(profile),
                child: Container(
                  height: 34,
                  padding:
                  const EdgeInsets.symmetric(horizontal: 14),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: profile.isConnected
                        ? MyColors.baseColor
                        : MyColors.white,
                    borderRadius: BorderRadius.circular(10),
                    border: profile.isConnected
                        ? null
                        : Border.all(
                      color: MyColors.baseColor,
                      width: 1,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Text(
                    profile.isConnected
                        ? "CONNECTED"
                        : "CONNECT",
                    style: TextStyle(
                      fontFamily: "regular",
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: profile.isConnected
                          ? MyColors.white
                          : MyColors.baseColor,
                      letterSpacing: 0.4,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


