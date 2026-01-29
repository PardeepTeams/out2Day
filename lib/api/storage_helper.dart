import 'package:get_storage/get_storage.dart';

import '../models/dynamic_page_model.dart';
import '../models/user_model.dart';


class StorageProvider {
  static final box = GetStorage();

  // Keys
  static const String keyToken = "token";
  static const String keyUserData = "user_data";
  static const String keyIsLogin = "is_login";
  static const String keyHobbies = "hobbies";
  static const String keyEthnicities = "ethnicities";
  static const String keyProfessions = "professions";
  static const String _versionKey = "app_api_version";
  static const String _staticVersionKey = "app_static_api_version";
  static const String _pagesKey = "dynamic_pages_cache";

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

  static void saveString(String key, String value) {
    GetStorage().write(key, value);
  }

  static String? getString(String key) {
    return GetStorage().read(key);
  }

  static void saveApiVersion(String version) {
    GetStorage().write(_versionKey, version);
  }

  static String getApiVersion() {
    return GetStorage().read(_versionKey) ?? "1";
  }

  static void saveStaticApiVersion(String version) {
    GetStorage().write(_staticVersionKey, version);
  }

  static String getStaticApiVersion() {
    return GetStorage().read(_staticVersionKey) ?? "1";
  }
// Generic Write
  static void write(String key, dynamic value) {
    GetStorage().write(key, value);
  }

  // Generic Read
  static dynamic read(String key) {
    return GetStorage().read(key);
  }
  static void remove(String key) {
    GetStorage().remove(key);
  }

  static void saveDynamicPages(List<DynamicPageModel> pages) {
    // List ko JSON string ya Map list mein convert karein
    List<Map<String, dynamic>> data = pages.map((v) => v.toJson()).toList();
    GetStorage().write(_pagesKey, data);
  }

  /// 📤 Pages load karein
  static List<DynamicPageModel>? getDynamicPages() {
    var rawData = GetStorage().read(_pagesKey);
    if (rawData != null) {
      // JSON data ko wapis model list mein convert karein
      return (rawData as List).map((v) => DynamicPageModel.fromJson(v)).toList();
    }
    return null;
  }
}