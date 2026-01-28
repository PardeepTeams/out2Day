import 'dart:async';
import 'dart:convert';

import 'package:Out2Do/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/messages_service.dart';
import '../models/chat_messages.dart';
import '../models/messages_model.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import 'firebase_status_controller.dart';

class ChatMessagesController extends GetxController {
  final messages = <ChatMessage>[].obs;
  final scrollController = ScrollController();

  final userName = "Sophia";
  final userImage =
      "https://images.unsplash.com/photo-1529626455594-4ff0802cfb7e";

  var isBlocked = false.obs;

  void blockUser() {
    isBlocked.value = true;
    // Ithe tusi apni block wali API call vi kar sakde ho
  }

//  final MessagesService _service = MessagesService();

  TextEditingController textController = TextEditingController();
/*  final Rxn<UserData> sender = Rxn<UserData>();
  final Rxn<UserData> receiver = Rxn<UserData>();
  var requestId = "".obs;
  var receiverUnreadCount = 0.obs;

  var refChatList = FirebaseDatabase.instance.ref("ChatList");
  var refMessages = FirebaseDatabase.instance.ref("Messages");
  var refReceiverStatus = FirebaseDatabase.instance.ref("UserStatus");

  RxList<MessagesModel> messagesList = <MessagesModel>[].obs;

  late StreamSubscription<DatabaseEvent> _messagesListener;
  late StreamSubscription<DatabaseEvent> _myUnreadCountListener;
  late StreamSubscription<DatabaseEvent> _receiverUnreadCountListener;
  late StreamSubscription<DatabaseEvent> _receiverStatusListener;
  final RxString error = RxString("");
  final RxString hireId = RxString("");

  var isFirstLaunch = true.obs;


  var lastSeenMessage = ''.obs;

  var isTyping = false.obs;
  Timer? _typingTimer;*/

  @override
  void onInit() {
    super.onInit();

   /* var args = Get.arguments as Map;
    sender.value = UserData.fromJson(args["sender"] as Map<String, dynamic>);
    receiver.value =
        UserData.fromJson(args["receiver"] as Map<String, dynamic>);
    if ((sender.value?.id ?? 0) < (receiver.value?.id ?? 0)) {
      requestId.value = "${sender.value?.id}_${receiver.value?.id}";
    } else {
      requestId.value = "${receiver.value?.id}_${sender.value?.id}";
    }
    debugPrint("Sender : ${sender.value?.firstName!}");
    debugPrint("Receiver : ${receiver.value?.firstName}");
    initialState();
    textController.addListener(_onTextChanged);*/

    /// Dummy chat
    messages.addAll([
      ChatMessage(
        message: "Hey 👋",
        isMe: false,
        time: "10:30 AM",
      ),
      ChatMessage(
        message: "Hi! How are you?",
        isMe: true,
        time: "10:31 AM",
      ),
      ChatMessage(
        message: "Doing great 😊 What about you?",
        isMe: false,
        time: "10:32 AM",
      ),
      ChatMessage(
        message: "Hi! How are you?",
        isMe: true,
        time: "10:31 AM",
      ),
      ChatMessage(
        message: "Doing great 😊 What about you?",
        isMe: false,
        time: "10:32 AM",
      ),
      ChatMessage(
        message: "Hi! How are you?",
        isMe: true,
        time: "10:31 AM",
      ),
      ChatMessage(
        message: "Doing great 😊 What about you?",
        isMe: false,
        time: "10:32 AM",
      ),
      ChatMessage(
        message: "Hey 👋",
        isMe: false,
        time: "10:30 AM",
      ),
      ChatMessage(
        message: "Hi! How are you?",
        isMe: true,
        time: "10:31 AM",
      ),
      ChatMessage(
        message: "Doing great 😊 What about you?",
        isMe: false,
        time: "10:32 AM",
      ),
      ChatMessage(
        message: "Hi! How are you?",
        isMe: true,
        time: "10:31 AM",
      ),
      ChatMessage(
        message: "Doing great 😊 What about you?",
        isMe: false,
        time: "10:32 AM",
      ),
      ChatMessage(
        message: "Hi! How are you?",
        isMe: true,
        time: "10:31 AM",
      ),
      ChatMessage(
        message: "Doing great 😊 What about you?",
        isMe: false,
        time: "10:32 AM",
      ),
    ]);
  }




/*  void _onTextChanged() {
    if (textController.text.isNotEmpty) {
      if (!isTyping.value) {
        isTyping.value = true; // user started typing
        debugPrint("Typing Status : User started typing...");
        Get.find<FirebaseStatusController>()
            .setTypingStatus(receiverId: receiver.value?.id ?? 0);
      }

      // Reset the timer whenever user types
      _typingTimer?.cancel();
      _typingTimer = Timer(const Duration(seconds: 1), () {
        isTyping.value = false; // user stopped typing
        debugPrint("Typing Status : User stopped typing...");
        Get.find<FirebaseStatusController>().setTypingStatus(receiverId: 0);
      });
    } else {
      // If text cleared, mark as not typing
      isTyping.value = false;
      _typingTimer?.cancel();
      debugPrint("Typing Status : User stopped typing...");
      Get.find<FirebaseStatusController>().setTypingStatus(receiverId: 0);
    }
  }*/

/*  Future<void> initialState() async {
    await _service.initializeFirebaseUser();
    await getMessages();
    await updateMyUnreadCount();
    await getReceiverUnreadCount();
    await getReceiverStatus();
  }*/

  void sendMessage() {
    if (textController.text.trim().isEmpty) return;

    messages.add(
      ChatMessage(
        message: textController.text.trim(),
        isMe: true,
        time: "Now",
      ),
    );

    textController.clear();

    Future.delayed(const Duration(milliseconds: 100), () {
      scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }


 /* Future<void> sendMessage() async {
    if (textController.text.trim().isEmpty) return;


    var timeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();

    // Send message
    var body = <String, dynamic>{
      "sender": sender.value?.id,
      "receiver": receiver.value?.id,
      "message": textController.text.trim(),
      "timestamp": timeStamp,
      "requestId": requestId.value,
    };
    refMessages.child(requestId.value).push().set(body);

    // Update History list
    var body2 = <String, dynamic>{
      "message": textController.text.trim(),
      "timestamp": timeStamp,
      "sender": sender.value?.id,
      "receiver": receiver.value?.id,
    };

    // Update History list for me
    refChatList
        .child("id_${sender.value?.id}")
        .child("id_${receiver.value?.id}")
        .update(body2);

    // Update History list for receiver by updating unread count
    body2["unreadCount"] = receiverUnreadCount.value + 1;
    refChatList
        .child("id_${receiver.value?.id}")
        .child("id_${sender.value?.id}")
        .update(body2);

   *//* if ((receiver.value?.deviceToken ?? "").isNotEmpty) {
      sendNotification(message: textController.text.trim());
    }*//*
    textController.text = "";

  }*/

/*  Future<void> sendNotification({required String message}) async {
    var body = jsonEncode(<String, dynamic>{
      'message': {
        'token': receiver.value?.deviceToken ?? "",
        'notification': {
          'title': sender.value?.name ?? "",
          'body': message,
        },
        'data': {
          'notification_type': "message",
          'sender': jsonEncode(sender.value?.toJson()),
          'receiver': jsonEncode(receiver.value?.toJson()),
        },
      }
    });
    log("Notification Body : $body");
    _service.sendNotification(body);
  }*/

/*  Future<void> getMessages() async {
    var context = Get.context!;
    try {
      if (isFirstLaunch.value) {
        MyProgressBar.showLoadingDialog(context: context);
      }
      _messagesListener = refMessages
          .child(requestId.value)
          .onValue
          .listen((DatabaseEvent event) {
        final data = event.snapshot.value as Map<dynamic, dynamic>?;
        if (data != null) {
          final messages = data.entries.map((entry) {
            final json = Map<String, dynamic>.from(entry.value);
            return MessagesModel.fromJson(json);
          }).toList()
            ..sort((a, b) => (b.timestamp ?? 0).compareTo(a.timestamp ?? 0));

          messagesList.value = messages;
        }
        if (isFirstLaunch.value) {
          if (context.mounted) {
            MyProgressBar.hideLoadingDialog(context: context);
          }
          if ((Get.arguments as Map)["setDefault"] == true &&
              messagesList.isEmpty) {
            textController.text =
            "Hi ${receiver.value?.firstName ?? ""}, I want to hire you as my trainer.";
          }
          isFirstLaunch.value = false;
        }
      });
    } catch (e) {
      debugPrint("Error getting message : $e");
      if (isFirstLaunch.value) {
        MyProgressBar.hideLoadingDialog(context: context);
        isFirstLaunch.value = false;
      }
    }
  }

  Future<void> updateMyUnreadCount() async {
    try {
      _myUnreadCountListener = refChatList
          .child("id_${sender.value?.id}")
          .child("id_${receiver.value?.id}")
          .onValue
          .listen((DatabaseEvent event) {
        var data = event.snapshot.value;
        if (data != null && data is Map) {
          refChatList
              .child("id_${sender.value?.id}")
              .child("id_${receiver.value?.id}")
              .child("unreadCount")
              .set(0);
        }
      });
    } catch (e) {
      debugPrint("Error getting my chat list : $e");
    }
  }

  Future<void> getReceiverUnreadCount() async {
    try {
      _receiverUnreadCountListener = refChatList
          .child("id_${receiver.value?.id}")
          .child("id_${sender.value?.id}")
          .onValue
          .listen((DatabaseEvent event) {
        var data = event.snapshot.value;
        if (data != null && data is Map) {
          var lastMsgBy = data["sender"];
          if (lastMsgBy == sender.value?.id) {
            receiverUnreadCount.value = data["unreadCount"] as int;
          }
        }
      });
    } catch (e) {
      debugPrint("Error getting receiver chat list : $e");
    }
  }

  Future<void> getReceiverStatus() async {
    try {
      _receiverStatusListener = refReceiverStatus
          .child("${receiver.value?.id}")
          .onValue
          .listen((DatabaseEvent event) {
        var data = event.snapshot.value;
        lastSeenMessage.value = "";
        if (data != null && data is Map) {
          var lastSeen = data['lastSeen'] as int?;
          var typingTo = data['typingTo'] as int?;
          if (typingTo != null && typingTo == sender.value?.id) {
            lastSeenMessage.value = "Typing....";
          } else {
            if (lastSeen == null) {
              lastSeenMessage.value = "Offline";
            } else if (lastSeen == 0) {
              lastSeenMessage.value = "Online";
            } else {
              lastSeenMessage.value = getFormattedMessageTimeLastSeen(timestamp: lastSeen);
            }
          }
        }
      });
    } catch (e) {
      debugPrint("Error getting receiver status : $e");
    }
  }*/

  @override
  void onClose() {
    scrollController.dispose();
    messages.clear();
  /*  _messagesListener.cancel();
    _myUnreadCountListener.cancel();
    _receiverUnreadCountListener.cancel();
    _receiverStatusListener.cancel();*/
    textController.dispose();
  //  _typingTimer?.cancel();
    super.onClose();
  }
}
