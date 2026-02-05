import 'package:Out2Do/models/notifications_model.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/business_model.dart';
import '../models/event_model.dart';
import '../routes/app_routes.dart';
import '../views/business/business_details_screen.dart';
import '../views/events/events_details_screen.dart';

class NotificationController extends GetxController {
  RxList<NotificationsModel> notifications = <NotificationsModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  void loadNotifications() {
    notifications.value = [
      NotificationsModel(
        id: "1",
        title: "Event Approved",
        message: "Your event has been approved successfully.",
        time: "2 min ago",
        isRead: false,
      ),
      NotificationsModel(
        id: "2",
        title: "New Message",
        message: "You have received a new message from Rahul.",
        time: "1 hr ago",
        isRead: false,
      ),
      NotificationsModel(
        id: "3",
        title: "Business Approved",
        message: "Your business listing is now live.",
        time: "Yesterday",
        isRead: false,
      ),
    ];
  }

  void markAsRead(NotificationsModel notification,int index) {
    final index = notifications.indexOf(notification);
    notifications[index] =
        NotificationsModel(
          id: notification.id,
          title: notification.title,
          message: notification.message,
          time: notification.time,
          isRead: true,
        );
    if(index == 0){

    }else if(index == 2){

    }else{

    }

  }
}
