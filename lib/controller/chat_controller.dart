import 'package:Out2Do/api/api_service.dart';
import 'package:Out2Do/api/storage_helper.dart';
import 'package:Out2Do/models/user_model.dart';
import 'package:get/get.dart';

import '../models/chat_user.dart';
import '../routes/app_routes.dart';

class ChatController extends GetxController {
  final RxList<ChatUser> chats = <ChatUser>[].obs;

  var isLoading = true.obs;
 // var matchesList = <UserData>[].obs;
  final recentMatches = [
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
  ];

  /// Called when controller is created
  @override
  void onInit() {
    super.onInit();
    getAllData();
  }

  void getAllData(){
   // getMyMatches();
    loadChats();
  }

/*  void getMyMatches() async {
    try {
      isLoading(true);
      var response = await ApiService().fetchMyMatches();
      matchesList.assignAll(response.data!); // Data save karo
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading(false);
    }
  }*/

  /// Called when UI is fully rendered
  @override
  void onReady() {
    super.onReady();
    // Future socket / firebase listener can be attached here
  }

  /// Load mock / API chats
  void loadChats() {
    chats.assignAll([
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
    ]);
  }

  /// Clear unread count when chat opened
  void openChat(int index) {
    final chat = chats[index];
    chats[index] = ChatUser(
      name: chat.name,
      image: chat.image,
      lastMessage: chat.lastMessage,
      time: chat.time,
      unreadCount: 0,
      isOnline: chat.isOnline,
    );

    Get.toNamed(AppRoutes.chatMessages)?.then((value) {
       loadChats();
      if (value == true) {
        print("Data updated, refreshing UI...");
      }
    });
  }

  void openRecentChat(UserData data) {

    Get.toNamed(AppRoutes.chatMessages,
      arguments: <String, dynamic>{
        'sender': StorageProvider.getUserData()!.toJson(),
        'receiver': data.toJson(),
      },)?.then((value) {
      loadChats();
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
