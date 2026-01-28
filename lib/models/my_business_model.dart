import 'package:Out2Do/models/business_model.dart';

import 'event_model.dart';

class MyBusinessResponseModel{
  int? status;
  String? message;
  List<BusinessModel>? allBusinesses;

  MyBusinessResponseModel({this.status, this.message, this.allBusinesses});

  MyBusinessResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['my_businesses'] != null) {
      allBusinesses = <BusinessModel>[];
      json['my_businesses'].forEach((v) {
        allBusinesses!.add(BusinessModel.fromJson(v));
      });
    }
  }
}