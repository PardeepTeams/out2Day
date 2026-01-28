// google_web_autocomplete.dart
export 'google_web_autocomplete_stub.dart'
if (dart.library.html) 'google_web_autocomplete_web.dart'
if (dart.library.js) 'google_web_autocomplete_web.dart';