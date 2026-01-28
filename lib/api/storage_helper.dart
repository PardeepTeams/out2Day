import 'package:get_storage/get_storage.dart';

import '../models/user_model.dart';


class StorageProvider {
  static final box = GetStorage();

  // Keys
  static const String keyToken = "token";
  static const String keyUserData = "user_data";
  static const String keyIsLogin = "is_login";

  /// --- SAVE DATA ---
  static void saveAuthData({required String token, required UserData userData}) {
    box.write(keyToken, token);
    box.write(keyIsLogin, true);
    box.write(keyUserData, userData.toJson());
  }

  /// --- GET DATA ---

  // 1. Get Token
  static String? getToken() => box.read(keyToken);

  // 2. Get IsLogin status
  static bool isUserLoggedIn() => box.read(keyIsLogin) ?? false;

  // 3. Get UserData as Model
  static UserData? getUserData() {
    var data = box.read(keyUserData);
    if (data != null) {
      return UserData.fromJson(data);
    }
    return null;
  }

  /// --- LOGOUT ---
  static void clearStorage() {
    box.erase();
  }
}