import 'package:Out2Do/models/user_model.dart';

class ChatResponseModel {
  int? status;
  String? message;
  List<Chat>? chats;
  List<UserData>? matches;

  ChatResponseModel({this.status, this.message, this.chats, this.matches});

  ChatResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['chats'] != null) {
      chats = <Chat>[];
      json['chats'].forEach((v) {
        chats!.add(Chat.fromJson(v));
      });
    }
    if (json['matches'] != null) {
      matches = <UserData>[];
      json['matches'].forEach((v) {
        matches!.add(UserData.fromJson(v));
      });
    }
  }
}

class Chat {
  String? message;
  int? receiver;
  int? sender;
  int? timestamp;
  int? unreadCount;
  UserData? senderDetail;
  UserData? receiverDetail;

  Chat({
    this.message,
    this.receiver,
    this.sender,
    this.timestamp,
    this.unreadCount,
    this.senderDetail,
    this.receiverDetail,
  });

  Chat.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    receiver = json['receiver'];
    sender = json['sender'];
    timestamp = json['timestamp'];
    unreadCount = json['unreadCount'];
    senderDetail = json['sender_detail'] != null
        ? UserData.fromJson(json['sender_detail'])
        : null;
    receiverDetail = json['receiver_detail'] != null
        ? UserData.fromJson(json['receiver_detail'])
        : null;
  }
}