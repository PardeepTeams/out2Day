import 'package:Out2Do/models/user_model.dart';

class MyMatchesResponse {
  int? status;
  String? message;
  int? count;
  List<UserData>? data;

  MyMatchesResponse({this.status, this.message, this.count, this.data});

  factory MyMatchesResponse.fromJson(Map<String, dynamic> json) {
    return MyMatchesResponse(
      status: json['status'],
      message: json['message'],
      count: json['count'],
      data: json['data'] != null
          ? List<UserData>.from(json['data'].map((x) => UserData.fromJson(x)))
          : [],
    );
  }
}
