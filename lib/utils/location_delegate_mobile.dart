// location_delegate_mobile.dart
import 'location_delegate.dart';

class LocationDelegateMobile implements LocationDelegate {
  @override
  void getDetails(String placeId, dynamic controller) {

  }
}

LocationDelegate getPlatformDelegate() => LocationDelegateMobile();