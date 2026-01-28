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
      Get.to(() => EventDetailsScreen(event:  EventModel(
          id: 1,
          eventTitle: "Dating Night Party",
          eventImages: [
            "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
            "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
            "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
          ],
          address: "California, USA",
          eventDate: "2026-04-14",
          description: "Meet singles near you",
          status: 1,
          eventTime: "18:00:00",
          city: "Delhi",
          country: "India"
      ),myEvents: false,));
    }else if(index == 2){
      Get.to(() => BusinessDetailsScreen(business:  BusinessModel(
        id: 1,
        businessName: "Adult Dance Classes",
        category: "Cafe",
        description: "Best coffee in town",
        address: "California",
        businessImages:  [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        status: 1,
        webLink: 'https://cafemocha.com',
      ),myBusiness: false,));
    }else{
      Get.toNamed(AppRoutes.chatMessages)?.then((value) {
      });
    }

  }
}
