import 'package:Out2Do/api/api_service.dart';
import 'package:Out2Do/api/storage_helper.dart';
import 'package:Out2Do/models/user_model.dart';
import 'package:Out2Do/utils/common_styles.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../models/chat_responseModel.dart';
import '../models/chat_user.dart';
import '../routes/app_routes.dart';
import 'home_controller.dart';

class ChatController extends GetxController {
//  final RxList<ChatUser> chats = <ChatUser>[].obs;

  var isLoading = true.obs;
  var matchesList = <UserData>[].obs;
  var chats = <Chat>[].obs;
  Rxn<UserData> userDetails = Rxn<UserData>();
/*  final recentMatches = [
    {
      "image": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1974&auto=format&fit=crop",
      "online": true,
    },
    {
      "image": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop",
      "online": true,
    },
    {
      "image": "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1974&auto=format&fit=crop",
      "online": true,
    },
    {
      "image": "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop",
      "online": true,
    },
    {
      "image": "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1974&auto=format&fit=crop",
      "online": false,
    },
    {
      "image": "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1974&auto=format&fit=crop",
      "online": true,
    },
  ];*/

  /// Called when controller is created
  @override
  void onInit() {
    super.onInit();
    userDetails.value = StorageProvider.getUserData();
    getAllData();
  }

  void getAllData(){
    loadChats();
  }

 /* void getMyMatches() async {
    try {
      isLoading(true);
      var response = await ApiService().fetchMyMatches();
      matchesList.assignAll(response.data!); // Data save karo
    } catch (e) {
      showCommonSnackbar(title: "Error", message: e.toString());
    } finally {
      isLoading(false);
    }
  }*/


  /// Load mock / API chats
  void loadChats() async{
  /*  chats.assignAll([
      ChatUser(
        name: "Aanya",
        image: "https://images.unsplash.com/photo-1524504388940-b1c1722653e1?q=80&w=1974&auto=format&fit=crop",
        lastMessage: "Hey! How are you? 😊",
        time: "2:15 PM",
        unreadCount: 3,
        isOnline: true,
      ),
      ChatUser(
        name: "Riya",
        image: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=1974&auto=format&fit=crop",
        lastMessage: "Let's meet tomorrow!",
        time: "1:40 PM",
        unreadCount: 4,
      ),
      ChatUser(
        name: "Simran",
        image: "https://images.unsplash.com/photo-1517841905240-472988babdf9?q=80&w=1974&auto=format&fit=crop",
        lastMessage: "😂😂",
        time: "12:05 PM",
        unreadCount: 0,
      ),
    ]);*/

    try {
      isLoading.value = true;

      // API hit
      ChatResponseModel response = await ApiService().fetchFirebaseChats();
      isLoading.value = false;
      List<Chat> fetchedChats = response.chats ?? [];

      // 3. Sorting Logic: Latest timestamp sabse upar (Descending Order)
      fetchedChats.sort((a, b) {
        // Agar timestamp null ho to use 0 treat karein
        int timeA = a.timestamp ?? 0;
        int timeB = b.timestamp ?? 0;
        return timeB.compareTo(timeA); // B bada hai to wo pehle aayega
      });
      chats.assignAll(fetchedChats);


      matchesList.assignAll(response.matches ?? []);

    } catch (e) {
      isLoading.value = false;
      // Error handle aur display
      print("Chat API Error: $e");

      showCommonSnackbar(
          title: "Error",
          message: e.toString() ?? "Failed to remove event"
      );

    }
  }

  /// Clear unread count when chat opened
  void openChat(int index) {
    final chat = chats[index];
    /*chats[index] = ChatUser(
      name: chat.name,
      image: chat.image,
      lastMessage: chat.lastMessage,
      time: chat.time,
      unreadCount: 0,
      isOnline: chat.isOnline,
    );*/
    UserData? receiver =
    chat.receiver != userDetails.value?.id
        ? (chat.receiverDetail ?? UserData())
        : (chat.senderDetail ?? UserData());
    Get.toNamed(AppRoutes.chatMessages, arguments: <String, dynamic>{
      'sender': StorageProvider.getUserData()!.toJson(),
      'receiver':receiver.toJson(),
    })?.then((value) {
       loadChats();
       refreshHomeBadge();

      if (value == true) {
        print("Data updated, refreshing UI...");
      }
    });
  }


  void refreshHomeBadge() {
    try {
      // Iska naam wahi rakhein jo aapke HomeController class ka hai
      if (Get.isRegistered<HomeController>()) {
        final homeController = Get.find<HomeController>();
        // Yahan wo function call karein jo unread API hit karta hai
        homeController.updateUnreadBadge();
        print("Home badge refreshed successfully");
      }
    } catch (e) {
      print("HomeController not found in memory: $e");
    }
  }

  void openRecentChat(UserData data) {
    Get.toNamed(AppRoutes.chatMessages,
      arguments: <String, dynamic>{
        'sender': StorageProvider.getUserData()!.toJson(),
        'receiver': data.toJson(),
        "setDefault":true
      },)?.then((value) {
      loadChats();
      refreshHomeBadge();
      if (value == true) {
        print("Data updated, refreshing UI...");
      }
    });
  }

  /// Called when controller is removed from memory
  @override
  void onClose() {
    chats.clear(); // 💾 free memory
    super.onClose();
  }
}
