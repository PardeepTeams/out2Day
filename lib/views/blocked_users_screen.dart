import 'package:Out2Do/models/user_model.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart'; // 👈 Import add karein

import '../../controller/blocked_users_controller.dart';
import '../../models/blocked_user_model.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';
import '../routes/app_routes.dart';

class BlockedUsersScreen extends StatelessWidget {
  BlockedUsersScreen({super.key});

  final BlockedUsersController controller =
  Get.put(BlockedUsersController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar:CommonAppBar(title: AppStrings.blockUsers),
      body: Obx(
            () {
              if(controller.isLoading.value){
                return Center(
                  child: CircularProgressIndicator(
                    color: MyColors.baseColor,
                  ),
                );
              }
              return controller.blockedUsers.isEmpty
                  ? const Center(
                child: Text(
                  "No blocked users",
                  style: TextStyle(fontFamily: "medium"),
                ),
              )
                  : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.blockedUsers.length,
                itemBuilder: (_, index) {
                  return _userTile(controller.blockedUsers[index],context);
                },
              );
            }
      ),
    );
  }

  Widget _userTile(UserData user,BuildContext context) {
    return InkWell(
      onTap: (){
        Get.toNamed(AppRoutes.userProfileDetail,arguments: {'id': user.id})?.then((value) {
          // controller.refreshHome();
        });
      },
      child:Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: MyColors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: MyColors.black.withOpacity(0.08),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        children: [
          /// 👤 PROFILE IMAGE
          CircleAvatar(
            radius: 26,
            backgroundColor: Colors.grey.shade200,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: user.profile??"",
                fit: BoxFit.cover,
                width: 64,
                height: 64,

                // 🔹 Animation settings: Slow karan layi (1.5 seconds)
                fadeInDuration: const Duration(milliseconds: 1500),
                fadeOutDuration: const Duration(milliseconds: 1500),
                fadeInCurve: Curves.easeIn, // Smooth shuruat layi

                // 🔹 Loading Spinner
                placeholder: (context, url) => const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),

                // 🔹 Error icon je image load na hove
                errorWidget: (context, url, error) => const Icon(
                    Icons.person,
                    size: 30,
                    color: Colors.grey
                ),
              ),
            ),
          ),

          const SizedBox(width: 14),

          /// NAME + AGE
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                mediumText("${user.firstName??""}", null),
                const SizedBox(height: 4),
                regularText("${calculateAge(user.dob!) }years"),
              ],
            ),
          ),

          /// 🔓 UNBLOCK BUTTON
          InkWell(
            onTap: (){
              controller.unblockUser(user,context);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: MyColors.baseColor),
              ),
              child: const Text(
                AppStrings.unblock,
                style: TextStyle(
                  fontFamily: "semibold",
                  fontWeight: FontWeight.w600,
                  color: MyColors.baseColor,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
