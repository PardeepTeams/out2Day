import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:Out2Do/api/api_service.dart';
import 'package:Out2Do/models/user_model.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../api/messages_service.dart';
import '../models/chat_messages.dart';
import '../models/messages_model.dart';
import '../utils/common_styles.dart';
import '../utils/my_progress_bar.dart';
import 'firebase_status_controller.dart';

class ChatMessagesController extends GetxController {
 // final messages = <ChatMessage>[].obs;
  final scrollController = ScrollController();

  final userName = "";
  final userImage = "";

  var isBlocked = false.obs;
  final FocusNode messageFocusNode = FocusNode();

  void blockUser() async {
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!); // Loading start
      bool success = await ApiService().blockUser(blockedUserId: receiver.value!.id!.toString());
   // Loading stop

      if (success) {
        int sId = sender.value!.id!;
        int rId = receiver.value!.id!;

        // 2. Realtime Database mein DONO paths update karein
        // Taaki Sender aur Receiver dono ko real-time block dikhe
        Map<String, dynamic> blockData = {'isBlocked': true};
        if(messagesList.isNotEmpty){
          await /*_dbRef*/_currentDbRoot.child('ChatList').child('id_$sId').child('id_$rId').update(blockData);
          await /*_dbRef*/_currentDbRoot.child('ChatList').child('id_$rId').child('id_$sId').update(blockData);
        }
        isBlocked.value = true;
        Get.back(); // Agar profile details mein hain
      }
      MyProgressBar.hideLoadingDialog(context: Get.context!);
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      showCommonSnackbar(title: "Block Error", message: e.toString());
    }
  }

  final MessagesService _service = MessagesService();

  TextEditingController textController = TextEditingController();
  final Rxn<UserData> sender = Rxn<UserData>();
  final Rxn<UserData> receiver = Rxn<UserData>();
  var requestId = "".obs;
  var receiverUnreadCount = 0.obs;

 /* var refChatList = FirebaseDatabase.instance.ref("ChatList");
  var refMessages = FirebaseDatabase.instance.ref("Messages");
  var refReceiverStatus = FirebaseDatabase.instance.ref("UserStatus");*/

  late DatabaseReference _dbRef;
  late DatabaseReference refChatList;
  late DatabaseReference refMessages;
  late DatabaseReference refReceiverStatus;
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
  Timer? _typingTimer;
  RxBool isBlockedByOther = false.obs;

  //final DatabaseReference _dbRef = FirebaseDatabase.instance.ref();

  late DatabaseReference _dbRefWeb;
  late DatabaseReference refChatListWeb;
  late DatabaseReference refMessagesWeb;
  late DatabaseReference refReceiverStatusWeb;

  void listenToBlockStatus() {
    int sId = sender.value!.id!;
    int rId = receiver.value!.id!;

    // Aapke structure ke hisaab se path: ChatList/id_SENDER/id_RECEIVER
    /*_dbRef*/_currentDbRoot.child('ChatList').child('id_$sId').child('id_$rId').child('isBlocked')
        .onValue.listen((event) {
      if (event.snapshot.exists) {
        isBlocked.value = event.snapshot.value as bool;
      }
    });
  }


  String getChatId(int u1, int u2) {
    return u1 < u2 ? "${u1}_$u2" : "${u2}_$u1";
  }



  void _initDatabaseByPlatform() {
    if (kIsWeb) {
      // WEB: URL ke saath initialize
      _dbRefWeb = FirebaseDatabase.instance.ref();
      refChatListWeb = _dbRefWeb.child("ChatList");
      refMessagesWeb = _dbRefWeb.child("Messages");
      refReceiverStatusWeb = _dbRefWeb.child("UserStatus");
    } else {
      // MOBILE: Default instance
      _dbRef = FirebaseDatabase.instance.ref();
      refChatList = _dbRef.child("ChatList");
      refMessages= _dbRef.child("Messages");
      refReceiverStatus = _dbRef.child("UserStatus");
    }
  }

  @override
  void onInit() {
    super.onInit();
    _initDatabaseByPlatform();

    var args = Get.arguments as Map;
    sender.value = UserData.fromJson(args["sender"] as Map<String, dynamic>);
    receiver.value =
        UserData.fromJson(args["receiver"] as Map<String, dynamic>);
    if ((sender.value?.id ?? 0) < (receiver.value?.id ?? 0)) {
      requestId.value = "${sender.value?.id}_${receiver.value?.id}";
    } else {
      requestId.value = "${receiver.value?.id}_${sender.value?.id}";
    }
    isBlocked.value = receiver.value!.isBlocked??false;


   print("receiver ${receiver.value!.isBlocked}");
    initialState();
    textController.addListener(_onTextChanged);

    /// Dummy chat
  /*  messages.addAll([
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
    ]);*/
  }




  void _onTextChanged() {
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
  }

  Future<void> initialState() async {
    await _service.initializeFirebaseUser();
    await getMessages();
    await updateMyUnreadCount();
    await getReceiverUnreadCount();
    await getReceiverStatus();
    listenToBlockStatus();
  }

/*  void sendMessage() {
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
  }*/

  DatabaseReference get _currentMessagesRef => kIsWeb ? refMessagesWeb : refMessages;
  DatabaseReference get _currentChatListRef => kIsWeb ? refChatListWeb : refChatList;
  DatabaseReference get _currentStatusRef => kIsWeb ? refReceiverStatusWeb : refReceiverStatus;
  DatabaseReference get _currentDbRoot => kIsWeb ? _dbRefWeb : _dbRef;
  Future<void> sendMessage() async {

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
   // refMessages.child(requestId.value).push().set(body);
    _currentMessagesRef.child(requestId.value).push().set(body);

    // Update History list
    var body2 = <String, dynamic>{
      "message": textController.text.trim(),
      "timestamp": timeStamp,
      "sender": sender.value?.id,
      "receiver": receiver.value?.id,
      "isBlocked":false
    };

    // Update History list for me
   /* refChatList
        .child("id_${sender.value?.id}")
        .child("id_${receiver.value?.id}")
        .update(body2);*/

    _currentChatListRef.child("id_${sender.value?.id}")
        .child("id_${receiver.value?.id}")
        .update(body2);

    // Update History list for receiver by updating unread count
    body2["unreadCount"] = receiverUnreadCount.value + 1;
 /*   refChatList
        .child("id_${receiver.value?.id}")
        .child("id_${sender.value?.id}")
        .update(body2);*/

    _currentChatListRef
        .child("id_${receiver.value?.id}")
        .child("id_${sender.value?.id}")
        .update(body2);

    if ((receiver.value?.deviceToken ?? "").isNotEmpty && receiver.value!.isNotification ==1) {
      sendNotification(message: textController.text.trim());
    }
    textController.text = "";

  }

  Future<void> sendNotification({required String message}) async {
    var body = jsonEncode(<String, dynamic>{
      'message': {
        'token': receiver.value?.deviceToken ?? "",
        'notification': {
          'title': sender.value?.firstName ?? "",
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
  }

  Future<void> getMessages() async {
    var context = Get.context!;
    try {
      if (isFirstLaunch.value) {
        MyProgressBar.showLoadingDialog(context: context);
      }
      _messagesListener = /*refMessages*/_currentMessagesRef
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
          if ((Get.arguments as Map)["setDefault"] == true){
            Future.delayed(const Duration(milliseconds: 300), () {
              messageFocusNode.requestFocus();
            });
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
      _myUnreadCountListener = /*refChatList*/_currentChatListRef
          .child("id_${sender.value?.id}")
          .child("id_${receiver.value?.id}")
          .onValue
          .listen((DatabaseEvent event) {
        var data = event.snapshot.value;
        if (data != null && data is Map) {
          /*refChatList*/_currentChatListRef
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
      _receiverUnreadCountListener = /*refChatList*/_currentChatListRef
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
      _receiverStatusListener = /*refReceiverStatus*/_currentStatusRef
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
  }


  void unBlockUser() async {
    try {
      MyProgressBar.showLoadingDialog(context: Get.context!); // Loading start
      bool success = await ApiService().unblockUser(blockedUserId: receiver.value!.id!.toString());
      // Loading stop

      if (success) {
        int sId = sender.value!.id!;
        int rId = receiver.value!.id!;

        // 2. Realtime Database mein DONO paths update karein
        // Taaki Sender aur Receiver dono ko real-time block dikhe
        Map<String, dynamic> blockData = {'isBlocked': false};
        if(messagesList.isNotEmpty){
          await /*_dbRef*/_currentDbRoot.child('ChatList').child('id_$sId').child('id_$rId').update(blockData);
          await /*_dbRef*/_currentDbRoot.child('ChatList').child('id_$rId').child('id_$sId').update(blockData);
        }

        isBlocked.value = false;

      }
      MyProgressBar.hideLoadingDialog(context: Get.context!);
    } catch (e) {
      MyProgressBar.hideLoadingDialog(context: Get.context!);
      showCommonSnackbar(title: "Block Error", message: e.toString());
    }
  }

  @override
  void onClose() {
    scrollController.dispose();
    messageFocusNode.dispose();
  //  messages.clear();
    _messagesListener.cancel();
    _myUnreadCountListener.cancel();
    _receiverUnreadCountListener.cancel();
    _receiverStatusListener.cancel();
    textController.dispose();
    _typingTimer?.cancel();
    super.onClose();
  }
}
