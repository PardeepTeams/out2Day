import 'dart:convert';

import 'business_model.dart';

class AddBusinessResponse {
  int? status;
  String? message;
  BusinessModel? data;

  AddBusinessResponse({this.status, this.message, this.data});

  factory AddBusinessResponse.fromJson(Map<String, dynamic> json) => AddBusinessResponse(
    status: json['status'],
    message: json['message'],
    data: json['data'] != null ? BusinessModel.fromJson(json['data']) : null,
  );
}

