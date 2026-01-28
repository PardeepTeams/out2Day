import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/profile_detail_controller.dart';
import '../../utils/app_strings.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';

class NewProfileDetailScreen extends StatelessWidget {
  NewProfileDetailScreen({super.key});

  final ProfileDetailController controller =
  Get.put(ProfileDetailController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          /// IMAGE HEADER
          SliverAppBar(
            expandedHeight: 420,
            pinned: true,
            backgroundColor: MyColors.baseColor,
            leading: IconButton(
              icon: const CircleAvatar(
                backgroundColor: Colors.black26,
                child: Icon(
                  Icons.arrow_back_ios_new,
                  size: 18,
                  color: Colors.white,
                ),
              ),
              onPressed: () => Get.back(),
            ),
            flexibleSpace: FlexibleSpaceBar(
              background: Obx(
                    () => CachedNetworkImage(
                  imageUrl: controller.image.value,
                  fit: BoxFit.cover,
                  placeholder: (_, __) =>
                      Container(color: MyColors.greyLight),
                ),
              ),
            ),
          ),

          /// CONTENT
          SliverToBoxAdapter(
            child: Transform.translate(
              offset: const Offset(0, -28),
              child: Container(
                padding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                decoration: const BoxDecoration(
                  color: MyColors.white,
                  borderRadius:
                  BorderRadius.vertical(top: Radius.circular(28)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 28),
                    /// NAME + AGE
                    Obx(
                          () => Text(
                        "${controller.name.value}, ${controller.age.value}",
                        style: const TextStyle(
                          fontFamily: "semibold",
                          fontSize: 24,
                          color: MyColors.black,
                        ),
                      ),
                    ),

                    const SizedBox(height: 6),

                    /// PROFESSION
                    Obx(
                          () => regularText(controller.profession.value),
                    ),

                    const SizedBox(height: 22),

                    /// INFO ROW
                    Row(
                      children: [
                        _infoTile("Gender", controller.gender.value),
                        const SizedBox(width: 12),
                        _infoTile("Height", controller.height.value),
                      ],
                    ),

                    const SizedBox(height: 28),

                    /// CONNECT BUTTON
                    Obx(
                          () => SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: MyColors.baseColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                          ),
                          onPressed: controller.isConnected.value
                              ? controller.sendMessage
                              : controller.connectUser,
                          child: Text(
                            controller.isConnected.value
                                ? "Send Message"
                                : "Connect Now",
                            style: const TextStyle(
                              fontFamily: "semibold",
                              fontSize: 15,
                              color: MyColors.white,
                              fontWeight: FontWeight.w600
                            ),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// ABOUT
                    _sectionTitle("About Me"),
                    const SizedBox(height: 10),
                    Obx(
                          () => Text(
                        controller.aboutMe.value,
                        style: const TextStyle(
                          fontFamily: "regular",
                          fontSize: 14,
                          height: 1.6,
                          color: MyColors.grey,
                        ),
                      ),
                    ),

                    const SizedBox(height: 30),

                    /// INTERESTS
                    _sectionTitle("Interested In"),
                    const SizedBox(height: 12),
                    Obx(
                          () => Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: controller.interestedIn
                            .map(
                              (e) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color:
                              MyColors.baseColor.withOpacity(0.08),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              e,
                              style: const TextStyle(
                                fontFamily: "medium",
                                fontSize: 13,
                                color: MyColors.baseColor,
                              ),
                            ),
                          ),
                        )
                            .toList(),
                      ),
                    ),

                    const SizedBox(height: 32),

                    /// SAFETY
                    _sectionTitle("Safety & Privacy"),
                    const SizedBox(height: 14),

                    Obx(
                          () => Container(
                        decoration: BoxDecoration(
                          color: MyColors.white,
                          borderRadius: BorderRadius.circular(18),
                          border:
                          Border.all(color: MyColors.greyLight),
                        ),
                        child: Column(
                          children: [
                            _actionTile(
                              icon: controller.isBlocked.value
                                  ? Icons.lock_open
                                  : Icons.block,
                              iconColor: controller.isBlocked.value
                                  ? MyColors.baseColor
                                  : MyColors.red,
                              title: controller.isBlocked.value
                                  ? "Unblock User"
                                  : AppStrings.blockUser,
                              subtitle: controller.isBlocked.value
                                  ? "Allow this user to contact you again"
                                  : AppStrings.blockUserMsg,
                              onTap: controller.isBlocked.value
                                  ? controller.unblockUser
                                  : controller.blockUser,
                            ),
                            Divider(
                              height: 1,
                              color: MyColors.greyLight,
                              indent: 60,
                            ),
                            _actionTile(
                              icon: Icons.report,
                              iconColor: MyColors.orange,
                              title: AppStrings.reportUser,
                              subtitle: AppStrings.reportUserMsg,
                              onTap: controller.reportUser,
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// -------- HELPERS --------

  Widget _sectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: "semibold",
        fontSize: 17,
        color: MyColors.black,
      ),
    );
  }

  Widget _infoTile(String title, String value) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: MyColors.greyLight,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: const TextStyle(
                    fontFamily: "regular",
                    fontSize: 12,
                    color: MyColors.grey)),
            const SizedBox(height: 4),
            Text(
              value,
              style: const TextStyle(
                fontFamily: "medium",
                fontSize: 14,
                color: MyColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _actionTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return ListTile(
      onTap: onTap,
      contentPadding:
      const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      leading: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: iconColor.withOpacity(0.12),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: iconColor, size: 22),
      ),
      title: Text(
        title,
        style: const TextStyle(
          fontFamily: "semibold",
          fontSize: 14,
          color: MyColors.black,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: const TextStyle(
          fontFamily: "regular",
          fontSize: 12,
          color: MyColors.grey,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios,
        size: 14,
        color: MyColors.grey,
      ),
    );
  }
}
