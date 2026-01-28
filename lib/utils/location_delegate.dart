import 'location_delegate_stub.dart'
if (dart.library.html) 'location_delegate_web.dart'
if (dart.library.io) 'location_delegate_mobile.dart';

abstract class LocationDelegate {
  void getDetails(String placeId, dynamic controller);

  // Factory constructor sahi platform ki file uthayega
  factory LocationDelegate() => getPlatformDelegate();
}