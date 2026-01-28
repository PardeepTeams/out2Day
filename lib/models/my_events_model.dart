import 'event_model.dart';

class MyEventResponseModel{
  int? status;
  String? message;
  List<EventModel>? allEvents;

  MyEventResponseModel({this.status, this.message, this.allEvents});

  MyEventResponseModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    if (json['my_events'] != null) {
      allEvents = <EventModel>[];
      json['my_events'].forEach((v) {
        allEvents!.add(EventModel.fromJson(v));
      });
    }
  }
}