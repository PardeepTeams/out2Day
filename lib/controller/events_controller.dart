import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../api/api_service.dart';
import '../models/event_model.dart';
import '../utils/common_styles.dart';

class EventsController extends GetxController {
  RxList<EventModel> events = <EventModel>[].obs;
  RxList<EventModel> filteredEvents = <EventModel>[].obs;
  var isLoading = false.obs;
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
   // loadEvents();

    /// 🔍 Listen to search
    searchController.addListener(() {
      filterEvents(searchController.text);
    });
  }

  void loadEvents() async {
 /*   events.value = [
      EventModel(
        id: 1,
        eventTitle: "Dating Night Party",
        eventImages: [
          "https://images.unsplash.com/photo-1528605248644-14dd04022da1",
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        address: "California, USA",
        eventDate: "2026-04-14",
        description: "Meet singles near you",
        status: 1,
        eventTime: "18:00:00",
          city: "Delhi",
          country: "India"
      ),
      EventModel(
        id: 2,
        eventTitle: "Singles Meetup",
        eventImages: [
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1492684223066-81342ee5ff30",
        ],
        address: "California, USA",
        eventDate: "2026-04-14",
        description: "Meet singles near you",
        status: 1,
        eventTime: "19:30:00",
        city: "Delhi",
        country: "India"
      ),
      EventModel(
        id: 3,
        eventTitle: "Love & Music Festival",
        eventImages: [
          "https://images.unsplash.com/photo-1500530855697-b586d89ba3ee",
          "https://images.unsplash.com/photo-1516450360452-9312f5e86fc7",
          "https://images.unsplash.com/photo-1515169067865-5387ec356754",
        ],
          address: "California, USA",
        eventDate: "2026-04-14",
        description: "Meet singles near you",
        status: 1,
        eventTime: "16:30:00",
          city: "Delhi",
          country: "India"
      ),
    ];

    filteredEvents.assignAll(events);*/


    try {
      isLoading.value = true;
      EventResponseModel response = await ApiService().fetchUpcomingEvents();

      if (response.status == 1 && response.allEvents != null) {
        isLoading.value = false;
        events.assignAll(response.allEvents!);
        filteredEvents.assignAll(events);
      }else{
        isLoading.value = false;
        showCommonSnackbar(title: "Error", message: response.message!);
      }
    } catch (e) {
      isLoading.value = false;
      showCommonSnackbar(title: "Error", message: e.toString());
    }


  }

  void filterEvents(String query) {
    print("textuser $query");
    if (query.isEmpty) {
      filteredEvents.assignAll(events);
    } else {
      filteredEvents.assignAll(
        events.where(
              (e) =>
          e.eventTitle!.toLowerCase().contains(query.toLowerCase()) ||
              e.city!.toLowerCase().contains(query.toLowerCase()) ||
              e.country!.toLowerCase().contains(query.toLowerCase()) ||
              e.description!.toLowerCase().contains(query.toLowerCase()) ||
              e.address!.toLowerCase().contains(query.toLowerCase()),
        ),
      );
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
