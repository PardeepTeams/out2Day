import 'package:Out2Do/models/user_model.dart';

class BlockedUsersResponse {
  int? status;
  String? message;
  List<UserData>? blockedUsers;

  BlockedUsersResponse({this.status, this.message, this.blockedUsers});

  factory BlockedUsersResponse.fromJson(Map<String, dynamic> json) {
    return BlockedUsersResponse(
      status: json['status'],
      message: json['message'],
      blockedUsers: json['blocked_users'] != null
          ? List<UserData>.from(json['blocked_users'].map((x) => UserData.fromJson(x)))
          : [],
    );
  }
}
