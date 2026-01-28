import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../../../controller/home_tab_controller.dart';
import '../../../../../routes/app_routes.dart';
import '../../../../../utils/colors.dart';

class ProfileGridCard extends StatelessWidget {
  final ProfileModel profile;
  final HomeTabController controller;

  const ProfileGridCard({
    super.key,
    required this.profile,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(AppRoutes.userProfileDetail)?.then((value) {
          controller.refreshHome();
        });
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(14),
        child: Stack(
          children: [
            Positioned.fill(
              child: CachedNetworkImage(
                fit: BoxFit.cover, imageUrl: profile.images.first,
                placeholder: (context, url) => Container(
                  color: MyColors.greyLight,
                  child: const Center(
                    child: CircularProgressIndicator(strokeWidth: 2, color: MyColors.baseColor),
                  ),
                ),
                // Agar image load na ho paye (Error handle):
                errorWidget: (context, url, error) => Container(
                  color: MyColors.greyLight,
                  child: const Icon(Icons.person, color: Colors.grey, size: 40),
                ),
                // Optional: MemCache use karke RAM bachane ke liye
                memCacheHeight: 400,
                memCacheWidth: 400,
              ),
            ),

            /// ❤️ TOP RIGHT Connect Icon
            Positioned(
              top: 10,
              right: 10,
              child: GestureDetector(
                onTap: () => controller.connectProfile(profile),
                child: Container(
                  height: 34,
                  width: 34,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: profile.isConnected
                        ? MyColors.baseColor
                        : Colors.white,
                    border: Border.all(
                      color: MyColors.baseColor,
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: MyColors.black.withOpacity(0.15),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Icon(
                    profile.isConnected
                        ? Icons.favorite
                        : Icons.favorite_border,
                    color: profile.isConnected
                        ? MyColors.white
                        : MyColors.baseColor,
                    size: 18,
                  ),
                ),
              ),
            ),

            /// ⬇ Bottom Name, Age & Distance
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.65),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "${profile.name}, ${profile.age}",
                      style: const TextStyle(
                        color: MyColors.white,
                        fontSize: 14,
                        fontFamily: "regular",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${5} km away", // distance property
                      style: const TextStyle(
                        color: MyColors.white,
                        fontSize: 12,
                        fontFamily: "regular",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
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



