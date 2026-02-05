import 'dart:async';

import 'package:Out2Do/controller/business_controller.dart';
import 'package:Out2Do/controller/chat_controller.dart';
import 'package:Out2Do/controller/events_controller.dart';
import 'package:Out2Do/controller/swipe_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import '../api/api_service.dart';
import '../api/storage_helper.dart';
import 'connect_controller.dart';
import 'home_tab_controller.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  /// Unread chat counts
  var unreadChats = 0.obs; // Example initial unread count

  var unreadActivity= 0.obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    updateUnreadBadge();
    _timer = Timer.periodic(Duration(seconds: 30), (timer) {
      updateUnreadBadge();
    });
  }

  void updateUnreadBadge() async {
    try {
      final myId = StorageProvider.getUserData()?.id;
      if (myId != null) {
        var response = await ApiService().fetchUnreadChatCount(userId: myId.toString());
        if (response['status'] == 1) {
          int count = response['unread_users'];
          unreadChats.value = count;
          // Aap is count ko apne RxInt variable mein save kar sakte hain
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void changeTab(int index) {
    selectedIndex.value = index;

    // Har baar tab change hone par refresh trigger karein
    if (index == 0) {
      if (Get.isRegistered<SwipeController>()) {
        Get.find<SwipeController>().fetchProfiles();
      }
    }
    else if (index == 1) {
      // Agar ConnectController registered hai, toh uska data refresh karo
      if (Get.isRegistered<EventsController>()) {
        Get.find<EventsController>().loadEvents();
      }
    }else if(index ==2){
      if (Get.isRegistered<BusinessController>()) {
        Get.find<BusinessController>().loadBusinesses();
      }
    }else if(index ==3){
      if (Get.isRegistered<ChatController>()) {
        Get.find<ChatController>().getAllData();
      }
    }
  }

  @override
  void onClose() {
    // Controller destroy hone par timer stop karna zaroori hai
    _timer?.cancel();
    super.onClose();
  }
}
