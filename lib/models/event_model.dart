import 'package:Out2Do/models/user_model.dart';

class EventResponseModel{
  int? status;
  String? message;
  List<EventModel>? allEvents;

  EventResponseModel({this.status, this.message, this.allEvents});

  EventResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['all_events'] != null) {
      allEvents = <EventModel>[];
      json['all_events'].forEach((v) {
        allEvents!.add(EventModel.fromJson(v));
      });
    }
  }
}

class EventModel {
  int? id;
  int? userId;
  String? eventTitle;
  String? description;
  String? eventDate;
  String? eventTime;
  List<String>? eventImages;
  List<String>? eventImagesThumb;
  String? address;
  String? city;
  String? country;
  String? latitude;
  String? longitude;
  int? status;
  UserData? userDetail;

  EventModel({
    this.id,
    this.userId,
    this.eventTitle,
    this.description,
    this.eventDate,
    this.eventTime,
    this.eventImages,
    this.address,
    this.city,
    this.country,
    this.latitude,
    this.longitude,
    this.status,
    this.userDetail,
    this.eventImagesThumb,
  });

  EventModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    eventTitle = json['event_title'];
    description = json['description'];
    eventDate = json['event_date'];
    eventTime = json['event_time'];
    // event_images array nu handle karna
 //   eventImages = json['event_images']??[];
//    eventImagesThumb = json['business_images_thumb']??[];

    if (json['event_images'] != null) {
      eventImages = List<String>.from(json['event_images']);
    } else {
      eventImages = [];
    }

    if (json['event_images_thumb'] != null) {
      eventImagesThumb = List<String>.from(json['event_images_thumb']);
    } else {
      eventImagesThumb = [];
    }
    address = json['address'];
    city = json['city'];
    country = json['country'];
    latitude = json['latitude'];
    longitude = json['longitude'];
    status = json['status'];
    userDetail = json['user_detail'] != null ? UserData.fromJson(json['user_detail']) : null;
  }
}
