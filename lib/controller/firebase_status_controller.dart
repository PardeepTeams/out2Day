import 'package:Out2Do/api/storage_helper.dart';
import 'package:Out2Do/models/user_model.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../api/messages_service.dart';

class FirebaseStatusController extends GetxController {
  final GetStorage _storage = GetStorage();
  Rxn<UserData> loginUser = Rxn<UserData>();
  var refUserStatus = FirebaseDatabase.instance.ref("UserStatus");

  @override
  void onInit() {
    super.onInit();
    loginUser.value = StorageProvider.getUserData()!;
    debugPrint("Login User : ${loginUser.value?.id}");
    setUserLastSeen();
  }

  @override
  void onClose() {
    var timeStamp = (DateTime.now().millisecondsSinceEpoch / 1000).round();
    setUserLastSeen(timestamp: timeStamp);
    debugPrint("Closing Status Controller");
    super.onClose();
  }

  Future<void> setUserLastSeen({int timestamp = 0}) async {
    try {
      await MessagesService().initializeFirebaseUser();
      refUserStatus.child((loginUser.value?.id ?? 0).toString()).update(
        <String, dynamic>{
          'lastSeen': timestamp,
          if (timestamp > 0) 'typingTo': 0
        },
      );
    } catch (e) {
      debugPrint("Error Changing Last Seen : $e");
    }
  }

  Future<void> setTypingStatus({required int receiverId}) async {
    try {
      await MessagesService().initializeFirebaseUser();
      refUserStatus.child((loginUser.value?.id ?? 0).toString()).update(
        <String, dynamic>{
          'typingTo': receiverId,
        },
      );
    } catch (e) {
      debugPrint("Error Changing Last Seen : $e");
    }
  }
}
