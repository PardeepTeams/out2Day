import 'package:Out2Do/api/storage_helper.dart';
import 'package:Out2Do/controller/user_profile_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/app_strings.dart';
import '../utils/colors.dart';
import 'package:cached_network_image/cached_network_image.dart';

class UserProfileDetailScreen extends StatefulWidget {
  const UserProfileDetailScreen({super.key});

  @override
  State<UserProfileDetailScreen> createState() => _UserProfileDetailScreenState();
}

class _UserProfileDetailScreenState extends State<UserProfileDetailScreen> {
  // Controller ko yahan initialize kiya gaya hai
  final controller = Get.put(UserProfileDetailController());

  // State variable dots manage karne ke liye
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: Obx((){
        if(controller.isLoading.value){
          return Center(
            child: CircularProgressIndicator(
              color: MyColors.baseColor,
            ),
          );
        }else{
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    /// 🖼 Image Slider (PageView)
                    Obx(() {
                      // Fallback agar additionalImages empty ho (optional safety)
                      if (controller.additionalImages.isEmpty && controller.image.value.isNotEmpty) {
                        return _buildSingleImage(controller.image.value);
                      }

                      return SizedBox(
                        height: 420,
                        width: double.infinity,
                        child: PageView.builder(
                          itemCount: controller.additionalImages.length,
                          onPageChanged: (i) {
                            setState(() {
                              currentIndex = i;
                            });
                          },
                          itemBuilder: (_, index) {
                            return CachedNetworkImage(
                              imageUrl: controller.additionalImages[index], // Original High-Res Image
                              width: double.infinity,
                              fit: BoxFit.cover,

                              // 🟢 Thumbnail placeholder: Jab tak original load ho rahi hai, ye dikhega
                              placeholder: (context, url) => Image.network(
                                controller.additionalThumbImages[index], // Backend se aaya hua Thumbnail URL
                                width: double.infinity,
                                fit: BoxFit.cover,
                              ),

                              // 🔴 Error handling: Agar original image na mile
                              errorWidget: (context, url, error) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 50, color: Colors.grey),
                              ),
                            );
                              /*Image.network(
                              controller.additionalImages[index],
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: Colors.grey[300],
                                child: const Icon(Icons.broken_image, size: 50),
                              ),
                            )*/;
                          },
                        ),
                      );
                    }),

                    /// ⚪ Indicator Dots
                    Obx(() {
                      if (controller.additionalImages.length <= 1) return const SizedBox.shrink();
                      return Positioned(
                        bottom: 52, // Transform translation ki wajah se thoda adjust kiya
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: MyColors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: List.generate(
                                controller.additionalImages.length,
                                    (i) => Container(
                                  margin: const EdgeInsets.symmetric(horizontal: 3),
                                  width: currentIndex == i ? 10 : 6,
                                  height: 6,
                                  decoration: BoxDecoration(
                                    color: currentIndex == i
                                        ? MyColors.white
                                        : Colors.white70,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }),

                    /// ⬅ Back Button
                    Positioned(
                      top: 40,
                      left: 16,
                      child: _circleIcon(Icons.arrow_back, () {
                        Get.back(result: true);
                      }),
                    ),

                    /// ⚙ More/Edit Button
                    Obx(() {
                      return Positioned(
                        top: 40,
                        right: 16,
                        child: controller.isMyProfile.value
                            ? _circleIcon(Icons.edit, () {
                          Get.toNamed(
                            AppRoutes.profileCreation,
                            arguments: true,
                          )?.then((result) {
                            if (result == true) {
                               controller.loadUserProfile(StorageProvider.getUserData()!.id!); //refresh logic
                            }
                          });
                        })
                            : _circleIcon(Icons.more_horiz, () {
                          _showUserOptions(context);
                        }),
                      );
                    })
                  ],
                ),

                /// 🧾 Details Card
                Container(
                  transform: Matrix4.translationValues(0, -40, 0),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  decoration: const BoxDecoration(
                    color: MyColors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                  ),
                  child: Obx(() => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Name & Age
                      Text(
                        "${controller.name.value}, ${controller.age.value}",
                        style: const TextStyle(
                          fontSize: 26,
                          fontFamily: "semibold",
                          color: MyColors.black,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                      const SizedBox(height: 12),

                      /// Info Rows
                      _locationInfoIconTile(
                          label: AppStrings.locationLabel,
                          icon: Icons.location_on,
                          value: controller.location.value),
                      _infoIconTile(
                          label: AppStrings.professionLabel,
                          icon: Icons.work_outline,
                          value: controller.profession.value),
                      _infoIconTile(
                          label: AppStrings.ethnicityLabel,
                          icon: Icons.public,
                          value: controller.ethnicity.value),
                      _infoIconTile(
                          label: AppStrings.drinking,
                          icon: Icons.local_bar_outlined,
                          value: controller.drinking.value),
                      _infoIconTile(
                          label: AppStrings.smoking,
                          icon: Icons.smoking_rooms_outlined,
                          value: controller.smoking.value),
                      _infoIconTile(
                          label: AppStrings.aboutLabel,
                          icon: Icons.person_pin_outlined,
                          value: controller.about.value),

                      const SizedBox(height: 12),

                      /// Hobbies Header
                      Row(
                        children: const [
                          Icon(Icons.interests_outlined, size: 22, color: MyColors.black),
                          SizedBox(width: 8),
                          Text(
                            AppStrings.hobby,
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: "semibold",
                              color: MyColors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 10),

                      /// Hobbies Wrap
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.hobbies
                            .map((hobby) => Chip(
                          label: Text(hobby),
                          backgroundColor: Colors.grey.shade200,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ))
                            .toList(),
                      ),

                      const SizedBox(height: 40), // Extra bottom padding
                    ],
                  )),
                ),
              ],
            ),
          );
        }

      })
      ,
    );
  }

  /// Safety widget agar additionalImages list null ya empty ho
  Widget _buildSingleImage(String imgUrl) {
    return SizedBox(
      height: 420,
      width: double.infinity,
      child: Image.network(imgUrl, fit: BoxFit.cover),
    );
  }

  Widget _infoIconTile({
    required String label,
    required IconData icon,
    required String value,
  }) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 1),
            child: Icon(icon, size: 20, color: MyColors.black),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontFamily: "regular",
                color: MyColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _locationInfoIconTile({
    required String label,
    required IconData icon,
    required String value,
  }) {
    if (value.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2),
            child: Icon(icon, size: 20, color: MyColors.black),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                height: 1.4,
                fontFamily: "regular",
                color: MyColors.black,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  void _showUserOptions(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(
          overlay.size.width - 50,
          80,
          16,
          0
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 8,
      items: [
        PopupMenuItem(
          value: 'connect',
          child: _buildMenuItem(Icons.person_add, "Connect", MyColors.black),
        ),
      /*  PopupMenuItem(
          value: 'block',
          child: _buildMenuItem(Icons.block, "Block User", MyColors.black),
        ),
        PopupMenuItem(
          value: 'report',
          child: _buildMenuItem(Icons.report_problem, "Report User", MyColors.black),
        ),*/
      ],
    ).then((value) {
      if (value == 'connect') {
        controller.connectUser();
      } else if (value == 'block') {
        controller.blockUser();
      } else if (value == 'report') {
        controller.reportUser();
      }
    });
  }

  Widget _buildMenuItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(
              color: color,
              fontFamily: "medium",
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}