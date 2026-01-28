// location_delegate_web.dart
import 'dart:js' as js;
import 'dart:html' as html;
import 'location_delegate.dart';

class LocationDelegateWeb implements LocationDelegate {
  @override
  void getDetails(String placeId, dynamic controller) {
    final html.Element div = html.document.createElement('div');
    final jsDiv = js.JsObject.fromBrowserObject(div);

    final service = js.JsObject(
      js.context['google']['maps']['places']['PlacesService'], [jsDiv],
    );

    final request = js.JsObject.jsify({
      'placeId': placeId,
      'fields': ['geometry', 'address_components', 'formatted_address']
    });

    service.callMethod('getDetails', [request, (place, status) {
      if (status == 'OK' && place != null) {
        // 1. Lat/Lng nikalna
        final location = place['geometry']['location'];
        final String lat = location.callMethod('lat').toString();
        final String lng = location.callMethod('lng').toString();
        final String fullAddress = place['formatted_address'] ?? "";

        // 2. Address Components se City, State, Country, Postal Code nikalna
        String city = "";
        String state = "";
        String country = "";
        String postalCode = "";

        final components = place['address_components'];
        final int len = components['length'];

        for (var i = 0; i < len; i++) {
          final comp = components[i];
          final List types = List.from(comp['types']);

          if (types.contains('locality')) {
            city = comp['long_name'];
          } else if (types.contains('administrative_area_level_1')) {
            state = comp['long_name'];
          } else if (types.contains('country')) {
            country = comp['long_name'];
          } else if (types.contains('postal_code')) {
            postalCode = comp['long_name'];
          }
        }

        // 3. Controller ke updated function ko call karein
        controller.onWebLocationFetched(
          address: fullAddress,
          lat: lat,
          lng: lng,
          city: city,
          state: state,
          country1: country,
          zipCode: postalCode,
        );
      }
    }]);
  }
}

LocationDelegate getPlatformDelegate() => LocationDelegateWeb();