import 'package:Out2Do/models/notifications_model.dart';
import 'package:Out2Do/utils/app_strings.dart';
import 'package:Out2Do/widgets/common_app_bar.dart';
import 'package:Out2Do/widgets/common_home_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/notification_controller.dart';
import '../../utils/colors.dart';
import '../../utils/common_styles.dart';

class NotificationsScreen extends StatelessWidget {
  NotificationsScreen({super.key});

  final NotificationController controller =
  Get.put(NotificationController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.white,
      appBar: CommonAppBar(title: AppStrings.notifications),
      body: Obx(
            () => controller.notifications.isEmpty
            ? const Center(
          child: Text(
            "No notifications",
            style: TextStyle(fontFamily: "medium"),
          ),
        )
            : ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: controller.notifications.length,
          itemBuilder: (_, index) {
            return _notificationTile(
              controller.notifications[index],index
            );
          },
        ),
      ),
    );
  }

  Widget _notificationTile(NotificationsModel notification,int index) {
    return InkWell(
      onTap: () => controller.markAsRead(notification,index),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification.isRead
              ? MyColors.white
              : MyColors.baseColor.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: MyColors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            Text(
              notification.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style:  TextStyle(
                fontFamily: !notification.isRead?"semibold":"regular",
                fontSize: 16,
                fontWeight:!notification.isRead?FontWeight.w600:FontWeight.w400,
                color: MyColors.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 2),
            /// MESSAGE
            Text(
              notification.message,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontFamily: "regular",
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: MyColors.black,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 2),
            /// TIME
            Align(
              alignment: Alignment.centerRight,
              child: lightText(
                notification.time,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
