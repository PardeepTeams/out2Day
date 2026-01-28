import 'dart:convert';

class FaqResponseModel {
  int? status;
  List<FaqModel>? faqs;

  FaqResponseModel({this.status, this.faqs});

  FaqResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['faqs'] != null) {
      faqs = <FaqModel>[];
      json['faqs'].forEach((v) {
        faqs!.add(FaqModel.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (faqs != null) {
      data['faqs'] = faqs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FaqModel {
  int? id;
  String? title;
  String? description;
  String? createdAt;
  String? updatedAt;

  FaqModel({
    this.id,
    this.title,
    this.description,
    this.createdAt,
    this.updatedAt,
  });

  FaqModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['description'] = description;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}