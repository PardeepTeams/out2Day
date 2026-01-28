import 'package:Out2Do/controller/user_profile_details_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/app_strings.dart';
import '../utils/colors.dart';

class UserProfileDetailScreen extends StatelessWidget {
  UserProfileDetailScreen({super.key});

  final controller = Get.put(UserProfileDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 420,
                  width: double.infinity,
                  child: Image.network(
                    "https://images.unsplash.com/photo-1520975916090-3105956dac38",
                    fit: BoxFit.cover,
                  ),
                ),

                Positioned(
                  top: 40,
                  left: 16,
                  child: _circleIcon(Icons.arrow_back, () {
                    Get.back();
                  }),
                ),

                Obx((){
                  if(controller.isMyProfile.value){
                    return    Positioned(
                      top: 40,
                      right: 16,
                      child:
                      _circleIcon(Icons.edit, () {
                        Get.toNamed(
                          AppRoutes.profileCreation,
                          arguments: true,
                        )?.then((result) {
                          if (result == true) {
                            //  controller.loadUserFromStorage(); // 🔥 refresh
                          }
                        });
                      }),
                    );
                  }else{
                    return    Positioned(
                      top: 40,
                      right: 16,
                      child:
                      _circleIcon(Icons.more_horiz, () {
                        _showUserOptions(context);
                      }),
                    );
                  }
                })

              ],
            ),
            /// 🧾 Details Card
            Container(
              transform: Matrix4.translationValues(0, -40, 0),
              padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 14),
              decoration: const BoxDecoration(
                color: MyColors.white,
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
                  _infoIconTile(icon:Icons.location_on, value:controller.location.value),
                  _infoIconTile(icon:Icons.work_outline, value:controller.profession.value),
                  _infoIconTile(icon:Icons.public, value:controller.ethnicity.value),
                  _infoIconTile(icon:Icons.local_bar_outlined, value:controller.drinking.value),
                  _infoIconTile(icon:Icons.smoking_rooms_outlined, value:controller.smoking.value),

                  Text(
                    controller.about.value,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: "regular",
                      color: MyColors.black,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(
                    height: 12,
                  ),

                  /// Hobbies
                  Row(
                    children: const [
                      Icon(
                        Icons.interests_outlined,
                        size: 22,
                        color: MyColors.black,
                      ),
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

                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: controller.hobbies
                        .map((hobby) => Chip(
                      label: Text(hobby),
                      backgroundColor: Colors.grey.shade200,
                    ))
                        .toList(),
                  ),
                ],
              )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _infoIconTile({
    required IconData icon,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 2), // thoda fine-tune
            child: Icon(
              icon,
              size: 20,
              color: MyColors.black,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
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


  /// 🔹 ICON BUTTON
  Widget _circleIcon(IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
    // Screen ki width aur height nikalne ke liye
    final RenderBox overlay = Overlay.of(context).context.findRenderObject() as RenderBox;

    showMenu(
      context: context,
      // Menu ko right side icon ke niche dikhane ke liye position
      position: RelativeRect.fromLTRB(
          overlay.size.width - 50, // Right se distance
          80,                      // Top se distance
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
        PopupMenuItem(
          value: 'block',
          child: _buildMenuItem(Icons.block, "Block User", MyColors.black),
        ),
        PopupMenuItem(
          value: 'report',
          child: _buildMenuItem(Icons.report_problem, "Report User", MyColors.black),
        ),
      ],
    ).then((value) {
      // Click handling logic
      if (value == 'connect') {
        controller.connectUser();
      } else if (value == 'block') {
        print("Block clicked");
      } else if (value == 'report') {
        print("Report clicked");
      }
    });
  }

// Menu item ka design (Icon + Text)
  Widget _buildMenuItem(IconData icon, String text, Color color) {
    return Row(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(width: 12),
        Text(
          text,
          style: TextStyle(color: color,
              fontFamily: "medium",
              fontSize: 16,
              fontWeight: FontWeight.w500),
        ),
      ],
    );
  }
}
