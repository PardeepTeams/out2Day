import 'package:Out2Do/controller/business_controller.dart';
import 'package:Out2Do/controller/chat_controller.dart';
import 'package:Out2Do/controller/events_controller.dart';
import 'package:Out2Do/controller/swipe_controller.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';

import 'connect_controller.dart';
import 'home_tab_controller.dart';

class HomeController extends GetxController {
  var selectedIndex = 0.obs;

  /// Unread chat counts
  var unreadChats = 4.obs; // Example initial unread count

  var unreadActivity= 0.obs;

  @override
  void onInit() {
    super.onInit();
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


}
