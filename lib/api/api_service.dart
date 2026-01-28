import 'dart:convert';
import 'dart:io';
import 'package:Out2Do/api/storage_helper.dart';
import 'package:Out2Do/models/HobbyModel.dart';
import 'package:Out2Do/models/event_model.dart';
import 'package:Out2Do/models/my_business_model.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/add_business_response_model.dart';
import '../models/blocked_user_model.dart';
import '../models/business_model.dart';
import '../models/dynamic_page_model.dart';
import '../models/ethnicity_model.dart';
import '../models/faq_model.dart';
import '../models/my_events_model.dart';
import '../models/my_matched_response.dart';
import '../models/profession_model.dart';
import '../models/safety_advice_response.dart';
import '../models/user_model.dart';
import 'package:get/get.dart';

import '../routes/app_routes.dart';
import '../utils/common_styles.dart';

class ApiService {
  static const String baseUrl = "https://out2day.brickandwallsinc.com/api";
  static const String imageBaseUrl = "https://out2day.brickandwallsinc.com/";

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return false;
    }
    return true;
  }
  Future<EthnicityModel> fetchEthnicities() async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }
    try {
      final response = await http.get(Uri.parse("$baseUrl/all-ethnicities"))
          .timeout(const Duration(seconds: 10));;

      if (response.statusCode == 200) {
        print("EthnicitiesData  ${response.body}" );
        return EthnicityModel.fromJson(json.decode(response.body));
      } else {
        // Backend error message handle karna
        var errorData = json.decode(response.body);
        throw errorData['message'] ?? "Failed to load ethnicities";
      }
    } catch (e) {
      throw e.toString();
    }
  }
  Future<HobbyModel> fetchHobbies() async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }
    try {
      final response = await http
          .get(Uri.parse("$baseUrl/all-hobbies"))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        print("hobbiesData  ${response.body}" );
        return HobbyModel.fromJson(json.decode(response.body));
      } else {
        // Backend error message handle karna
        var errorData = json.decode(response.body);
        throw errorData['message'] ?? "Failed to load hobbies";
      }
    } catch (e) {
      throw e.toString();
    }
  }


  Future<ProfessionModel> fetchProfessions() async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      final response = await http.get(Uri.parse("$baseUrl/all-professions"))
          .timeout(const Duration(seconds: 10));;

      if (response.statusCode == 200) {
        print("ProfessionsData  ${response.body}" );
        return ProfessionModel.fromJson(json.decode(response.body));
      } else {
        var errorData = json.decode(response.body);
        throw errorData['message'] ?? "Failed to load professions";
      }
    } catch (e) {
      throw e.toString();
    }
  }


  Future<bool> createProfileApi({
    required Map<String, String> body,
    File? profileImage,
    Uint8List? webImageBytes,
  }) async {
    // 1. Check Internet Connection
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      var request = http.MultipartRequest('POST', Uri.parse("$baseUrl/register"));

      // 2. Add Headers
      request.headers.addAll({
        'Accept': 'application/json',
      });

      // 3. Add Text Parameters
      request.fields.addAll(body);

      // 4. Add Main Profile Image
      if (kIsWeb && webImageBytes != null) {
        // ✅ Web ke liye bytes use karein
        request.files.add(http.MultipartFile.fromBytes(
          'profile',
          webImageBytes,
          filename: 'profile_image.jpg', // Web par filename dena zaroori hai
        ));
      } else if (profileImage != null) {
        // 📱 Mobile ke liye path use karein
        request.files.add(await http.MultipartFile.fromPath('profile', profileImage.path));
      }

      // 6. Send and Get Response
      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // JSON decode karo taaki message aur data read kar sako
      var responseData = json.decode(response.body);

      print("createProfile ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        // Check status from backend response
        if (responseData['status'] == 1) {
          UserModel userModel = UserModel.fromJson(responseData);
          if (userModel.token != null && userModel.data != null) {
            StorageProvider.saveAuthData(
              token: userModel.token!,

              userData: userModel.data!,
            );
          }
          return true;
        } else {
          // Agar status false hai (e.g. Validation error)
          throw responseData['message'] ?? "Something went wrong";
        }
      } else {
        // 400, 401, 500 errors handle karo
        throw responseData['message'] ?? "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      rethrow;
    }
  }



  Future<bool> updateProfileApi({
    required Map<String, String> body,
    File? profileImage,
    Uint8List? webImageBytes,
  }) async {
    if (!await isConnected()) {
      throw Exception("Please check your internet connection.");
    }

    try {
      final token = StorageProvider.getToken();

      if (token == null || token.isEmpty) {
        throw Exception("Unauthorized. Please login again.");
      }

      var request = http.MultipartRequest(
        'POST',
        Uri.parse("$baseUrl/update-profile"),
      );

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll(body);

      if (kIsWeb && webImageBytes != null) {
        // ✅ Web ke liye bytes use karein
        request.files.add(http.MultipartFile.fromBytes(
          'profile',
          webImageBytes,
          filename: 'profile_image.jpg', // Web par filename dena zaroori hai
        ));
      } else if (profileImage != null) {
        // 📱 Mobile ke liye path use karein
        request.files.add(await http.MultipartFile.fromPath('profile', profileImage.path));
      }

    /*  if (profileImage != null) {
        request.files.add(
          await http.MultipartFile.fromPath('profile', profileImage.path),
        );
      }*/

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      var responseData = json.decode(response.body);

      print("updateProfile ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == 1) {
          UserModel userModel = UserModel.fromJson(responseData);

          if (userModel.data != null) {
            StorageProvider.saveAuthData(
              token: token,
              userData: userModel.data!,
            );
          }
          return true;
        } else {
          throw Exception(responseData['message'] ?? "Something went wrong");
        }
      }

      // 🔥 UNAUTHORIZED FROM BACKEND
      if (response.statusCode == 401) {
        throw Exception(responseData['message'] ?? "Unauthorized");
      }

      // 🔥 OTHER SERVER ERRORS
      throw Exception(
        responseData['message'] ??
            "Server error (${response.statusCode})",
      );
    } catch (e) {
      // 🔴 DO NOT SWALLOW MESSAGE
      rethrow;
    }
  }






  Future<int> loginApi({required String countryCode, required String phone}) async {
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/login"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json', // Backend nu dasso ki JSON hi chahida hai
        },
        body: json.encode({
          'country_code': countryCode,
          'phone': phone,
        }),
      );
      print("url $countryCode");
      print("url $phone");

      var responseData = json.decode(response.body);
      print("responseData $responseData");
      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {

          UserModel userModel = UserModel.fromJson(responseData);
          StorageProvider.saveAuthData(
            token: userModel.token!,
            userData: userModel.data!,
          );
          return 1;
        } else {
          // CASE: Status 0 (Not Registered)
          return 0;
        }
      } else {
        print("response Error ");
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      print("response Error ${e}");
      rethrow;
    }
  }



  Future<List<UserData>> fetchHomeUsers() async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      final token = StorageProvider.getToken();
      final userData = StorageProvider.getUserData();

      if (token == null || userData == null) {
        throw "Session expired. Please login again.";
      }

      final response = await http.post(
        Uri.parse("$baseUrl/home"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'user_id': userData.id.toString(), // Token de naal user_id bhejna
        }),
      );

      var responseData = json.decode(response.body);
      print("Home Response: ${response.body}");

      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {
          // 'users' list nu map karke UserData objects vich convert karo
          List<dynamic> usersJson = responseData['users'];
          return usersJson.map((json) => UserData.fromJson(json)).toList();
        } else {
          if(responseData["message"] == "Unauthorized"){
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          // Backend da message throw karo (e.g. status 0)
          throw responseData['message'] ?? "No users found.";
        }
      } else {
        // Validation errors (400, 422) ya Server errors
        throw responseData['message'] ?? "Server Error: ${response.statusCode}";

      }
    } catch (e) {
      // Backend message hi hamesha throw hoyega
      rethrow;
    }
  }


  Future<UserData> fetchUserProfileDetails(int profileUserId) async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      final token = StorageProvider.getToken();
      if (token == null) {
        throw "Session expired. Please login again.";
      }

      final response = await http.post(
        Uri.parse("$baseUrl/user-profile-details"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
          // Note: Agar body JSON hai taan 'Content-Type' zaroori hai
        },
        body: {
          'profile_user_id': profileUserId.toString(),
        },
      );

      var responseData = json.decode(response.body);
      print("Profile Details Response: ${response.body}");

      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {
          // Response vich key 'profile_details' hai, usnu UserData vich map karo
          return UserData.fromJson(responseData['profile_details']);
        } else {
          if(responseData["message"] == "Unauthorized"){
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          throw responseData['message'] ?? "Profile not found.";
        }
      } else {
        throw responseData['message'] ?? "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      // Backend da asali message hi agge jayega
      rethrow;
    }
  }


  Future<bool> createEvent({
    required Map<String, String> body,
    required List<dynamic> images,
  }) async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }
    try {
      final token = StorageProvider.getToken();
      var uri = Uri.parse("$baseUrl/events/create");
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll(body);

      for (var image in images) {
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'event_images[]',
            image as Uint8List,
            filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ));
        } else {
          File file = image as File;
          request.files.add(await http.MultipartFile.fromPath(
            'event_images[]',
            file.path,
          ));
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      var responseData = json.decode(response.body);
      print("Create event Response: $responseData");


    ;

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == 1) {
          return true; // ✅ Poora model return karo
        } else {
          if(responseData["message"] == "Unauthorized"){
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          throw responseData['message'] ?? "Failed to create event";
        }
      } else {
        throw responseData['message'] ?? "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      rethrow;
    }
  }



  Future<bool> updateEvent({
    required Map<String, String> body,
    required List<dynamic> newImages,
    required List<String> removedImages,
  }) async {
    try {
      final token = StorageProvider.getToken();
      var uri = Uri.parse("$baseUrl/update-event");
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll(body);

      if (removedImages.isNotEmpty) {
        for (int i = 0; i < removedImages.length; i++) {
          request.fields['removed_images[$i]'] = removedImages[i];
        }
      }

      // 2. Check karo agar newImages empty nahi hai, taan hi add karo
      if (newImages.isNotEmpty) {
        for (var image in newImages) {
          if (kIsWeb) {
            request.files.add(http.MultipartFile.fromBytes(
              'event_images[]',
              image as Uint8List,
              filename: 'update_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ));
          } else {
            File file = image as File;
            request.files.add(await http.MultipartFile.fromPath(
              'event_images[]',
              file.path,
            ));
          }
        }
      }

      print("request  $request");

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // 🔥 Backend response parse karo
      var responseData = json.decode(response.body);
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == 1) {
          print("Update Response: $responseData");
          return true;
        } else {
          if (responseData["message"] == "Unauthorized") {
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          throw responseData['message'] ?? "Failed to create event";
        }
      } else {
        throw responseData['message'] ?? "Failed to create event";
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<EventResponseModel> fetchUpcomingEvents() async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      final token = StorageProvider.getToken();
      final response = await http.get(
        Uri.parse("$baseUrl/upcoming-events"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return EventResponseModel.fromJson(responseData);
      } else {
        if(responseData["message"] == "Unauthorized"){
          StorageProvider.clearStorage();
          Get.offAllNamed(AppRoutes.login);
        }
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<MyEventResponseModel> fetcMyEvents() async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      final userData = StorageProvider.getUserData();
      final token = StorageProvider.getToken();
      final response = await http.post(
        Uri.parse("$baseUrl/my-events"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'user_id': userData!.id!.toString(),
        },
      );

      var responseData = json.decode(response.body);

      print("MyEvents  $responseData");

      if (response.statusCode == 200) {
        return MyEventResponseModel.fromJson(responseData);
      } else {
        if(responseData["message"] == "Unauthorized"){
          StorageProvider.clearStorage();
          Get.offAllNamed(AppRoutes.login);
        }
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<BusinessResponseModel> fetchAllBusinesses() async {
    final token = StorageProvider.getToken();
    try {
      final response = await http.get(
        Uri.parse("https://out2day.brickandwallsinc.com/api/all-businesses"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        return BusinessResponseModel.fromJson(json.decode(response.body));
      } else {
        if(responseData["message"] == "Unauthorized"){
          StorageProvider.clearStorage();
          Get.offAllNamed(AppRoutes.login);
        }
        throw "Failed to load businesses";
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<MyBusinessResponseModel> fetcMyBusinesses() async {
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      final userData = StorageProvider.getUserData();
      final token = StorageProvider.getToken();
      final response = await http.post(
        Uri.parse("$baseUrl/my-businesses"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'user_id': userData!.id!.toString(),
        },
      );

      var responseData = json.decode(response.body);

      print("MyEvents  $responseData");

      if (response.statusCode == 200) {
        return MyBusinessResponseModel.fromJson(responseData);
      } else {
        if(responseData["message"] == "Unauthorized"){
          StorageProvider.clearStorage();
          Get.offAllNamed(AppRoutes.login);
        }
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<AddBusinessResponse> createBusiness({
    required Map<String, String> body,
    required List<dynamic> images,
  }) async {
    try {
      final token = StorageProvider.getToken();
      var uri = Uri.parse("$baseUrl/business/create");
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll(body);

      for (var image in images) {
        if (kIsWeb) {
          request.files.add(http.MultipartFile.fromBytes(
            'business_images[]',
            image as Uint8List,
            filename: 'upload_${DateTime.now().millisecondsSinceEpoch}.jpg',
          ));
        } else {
          File file = image as File;
          request.files.add(await http.MultipartFile.fromPath(
            'business_images[]',
            file.path,
          ));
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      var responseData = json.decode(response.body);
      print("Create Business Response: $responseData");

      // 🔥 Model vich convert karo
      AddBusinessResponse businessRes = AddBusinessResponse.fromJson(responseData);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (businessRes.status == 1) {
          return businessRes; // ✅ Poora model return karo
        } else {
          _handleUnauthorized(businessRes.message);
          showCommonSnackbar(title: "Error", message: businessRes.message ?? "Failed");
          return businessRes;
        }
      } else {
        _handleUnauthorized(businessRes.message);
        showCommonSnackbar(title: "Server Error", message: businessRes.message ?? "Error");
        return businessRes;
      }
    } catch (e) {
      print("CreateBusiness Error: $e");
      showCommonSnackbar(title: "Connection Error", message: e.toString());
      return AddBusinessResponse(status: 0, message: e.toString());
    }
  }

// 🔐 Unauthorized handle karan layi chota helper
  void _handleUnauthorized(String? message) {
    if (message == "Unauthorized") {
      StorageProvider.clearStorage();
      Get.offAllNamed(AppRoutes.login);
    }
  }




  Future<bool> updateBusiness({
    required Map<String, String> body,
    required List<dynamic> newImages,
    required List<String> removedImages,
  }) async {
    try {
      final token = StorageProvider.getToken();
      var uri = Uri.parse("$baseUrl/update-business");
      var request = http.MultipartRequest('POST', uri);

      request.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      request.fields.addAll(body);

      if (removedImages.isNotEmpty) {
        for (int i = 0; i < removedImages.length; i++) {
          request.fields['removed_images[$i]'] = removedImages[i];
        }
      }

      // 2. Check karo agar newImages empty nahi hai, taan hi add karo
      if (newImages.isNotEmpty) {
        for (var image in newImages) {
          if (kIsWeb) {
            request.files.add(http.MultipartFile.fromBytes(
              'business_images[]',
              image as Uint8List,
              filename: 'update_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ));
          } else {
            File file = image as File;
            request.files.add(await http.MultipartFile.fromPath(
              'business_images[]',
              file.path,
            ));
          }
        }
      }

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      // 🔥 Backend response parse karo
      var responseData = json.decode(response.body);


      if (response.statusCode == 200 || response.statusCode == 201) {

        if (responseData['status'] == 1) {
          print("Update Response: $responseData");
       //   showCommonSnackbar(title: "Success", message: responseData['message'] ?? "Updated!");
          return true;
        } else {
          if (responseData["message"] == "Unauthorized") {
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          // Status 0 case: Backend da error message dikhao
          showCommonSnackbar(title: "Error", message: responseData['message'] ?? "Something went wrong");
          return false;
        }
      } else {
        showCommonSnackbar(title: "Server Error", message: responseData['message'] ?? "Failed to update");
        return false;
      }
    } catch (e) {
      print("UpdateBusiness Error: $e");
      showCommonSnackbar(title: "Error", message: "Connection failed: $e");
      return false;
    }
  }



  Future<FaqResponseModel> fetchFaqs() async {
    try {
      final response = await http.get(
        Uri.parse("$baseUrl/faqs"),
        headers: {
          'Accept': 'application/json',
        },

      );
      print("faqsResponse ${response.body}");
      if (response.statusCode == 200) {
        var responseData = json.decode(response.body);
        return FaqResponseModel.fromJson(responseData);
      } else {
        throw "Failed to load FAQs";
      }
    } catch (e) {
      rethrow;
    }
  }


  Future<int> logoutApi() async {
    try {
      String token  = StorageProvider.getToken()!.toString();
      var response = await http.post(
        Uri.parse("$baseUrl/logout"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json', // Backend nu dasso ki JSON hi chahida hai
        },
        body: json.encode({
          'user_id': StorageProvider.getUserData()!.id!.toString(),
        }),
      );

      var responseData = json.decode(response.body);
      print("responseData $responseData");
      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {

          UserModel userModel = UserModel.fromJson(responseData);
          StorageProvider.clearStorage();
          return 1;
        } else {
          // CASE: Status 0 (Not Registered)
          return 0;
        }
      } else {
        print("response Error ");
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      print("response Error ${e}");
      rethrow;
    }
  }


  Future<int> removeAccountApi() async {
    try {
      String token  = StorageProvider.getToken()!.toString();
      var response = await http.post(
        Uri.parse("$baseUrl/remove-account"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
          'Accept': 'application/json', // Backend nu dasso ki JSON hi chahida hai
        },
        body: json.encode({
          'user_id': StorageProvider.getUserData()!.id!.toString(),
        }),
      );

      var responseData = json.decode(response.body);
      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {
          StorageProvider.clearStorage();
          return 1;
        } else {
          // CASE: Status 0 (Not Registered)
          return 0;
        }
      } else {
        print("response Error ");
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      print("response Error ${e}");
      rethrow;
    }
  }






  Future<UserModel> removeBusinessApi(int id) async {
    final token = StorageProvider.getToken(); // Token hasil karo
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/remove-business"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // 👈 Token bhejna zaroori hai
        },
        body: json.encode({
          'business_id': id, // Direct ID bhejo ya .toString() agar backend string mangda hai
        }),
      );

      var responseData = json.decode(response.body);
      print("Remove Event Response: $responseData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(responseData);
      } else {
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      print("Remove Event API Error: $e");
      rethrow;
    }
  }

  Future<UserModel> removeEventApi(int id) async {
    final token = StorageProvider.getToken(); // Token hasil karo
    try {
      var response = await http.post(
        Uri.parse("$baseUrl/remove-event"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token', // 👈 Token bhejna zaroori hai
        },
        body: json.encode({
          'event_id': id, // Direct ID bhejo ya .toString() agar backend string mangda hai
        }),
      );

      var responseData = json.decode(response.body);
      print("Remove Event Response: $responseData");

      if (response.statusCode == 200 || response.statusCode == 201) {
        return UserModel.fromJson(responseData);
      } else {
        throw responseData['message'] ?? "Server Error";
      }
    } catch (e) {
      print("Remove Event API Error: $e");
      rethrow;
    }
  }

  Future<BlockedUsersResponse> getBlockedUsers() async {
    try {
      final token = StorageProvider.getToken();
      final userId = StorageProvider.getUserData()?.id;

      print("userId  $userId");
      print("userId  $token");

      var response = await http.post(
        Uri.parse("$baseUrl/blocked-users"),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode({
          'user_id': userId.toString(),
        }),
      );

      var responseData = json.decode(response.body);

      print("BlockedUsers  $responseData");

      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {
          return BlockedUsersResponse.fromJson(responseData);
        } else {
          if (responseData["message"] == "Unauthorized") {
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          throw responseData['message'] ?? "Failed to load blocked users";
        }
      } else if (response.statusCode == 401) {
        StorageProvider.clearStorage();
        Get.offAllNamed('/login');
        throw "Session expired. Please login again.";
      } else {
        // Server error (500, 404 etc)
        throw "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      // Connection ya Parsing error
      print("Blocked Users API Error: $e");
      rethrow; // Controller isnu catch karega
    }
  }


  Future<bool> unblockUser({required String blockedUserId}) async {
    try {
      final token = StorageProvider.getToken();
      final userId = StorageProvider.getUserData()?.id;

      var response = await http.post(
        Uri.parse("$baseUrl/unblock-user"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'user_id': userId.toString(),
          'blocked_user_id': blockedUserId,
        },
      );

      var responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == 1) {
          showCommonSnackbar(title: "Success", message: responseData['message'] ?? "User unblocked");
          return true;
        } else {
          if (responseData["message"] == "Unauthorized") {
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          throw responseData['message'] ?? "Failed to unblock user";
        }
      } else if (response.statusCode == 401) {
        StorageProvider.clearStorage();
        Get.offAllNamed('/login');
        throw "Session expired. Please login again.";
      } else {
        // 400, 404, 500 errors
        throw responseData['message'] ?? "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Unblock API Error: $e");
      // Throwing error so controller can catch it
      rethrow;
    }
  }



  Future<bool> blockUser({required String blockedUserId}) async {
    try {
      final token = StorageProvider.getToken();
      final userId = StorageProvider.getUserData()?.id;

      var response = await http.post(
        Uri.parse("$baseUrl/block-user"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'user_id': userId.toString(),
          'blocked_user_id': blockedUserId,
        },
      );

      var responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == 1) {
          showCommonSnackbar(title: "Success", message: responseData['message'] ?? "User unblocked");
          return true;
        } else {
          if (responseData["message"] == "Unauthorized") {
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          throw responseData['message'] ?? "Failed to unblock user";
        }
      } else if (response.statusCode == 401) {
        StorageProvider.clearStorage();
        Get.offAllNamed('/login');
        throw "Session expired. Please login again.";
      } else {
        // 400, 404, 500 errors
        throw responseData['message'] ?? "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Unblock API Error: $e");
      // Throwing error so controller can catch it
      rethrow;
    }
  }



  Future<SafetyAdviceResponse> getSafetyAdvice() async {
    try {
      var response = await http.get(
        Uri.parse("$baseUrl/safety-advice"),
        headers: {
          'Accept': 'application/json',
        },
      );

      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {
          return SafetyAdviceResponse.fromJson(responseData);
        } else {
          // Backend logical error (Status 0)
          throw responseData['message'] ?? "Something went wrong";
        }
      } else {
        // Server errors (404, 500, etc.)
        throw "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Safety Advice API Error: $e");
      // Throwing human-friendly message
      if (e.toString().contains("SocketException")) {
        throw "No Internet connection";
      }
      rethrow;
    }
  }


  Future<MyMatchesResponse> fetchMyMatches() async {
    try {
      final token = StorageProvider.getToken();
      final userId = StorageProvider.getUserData()?.id;

      var response = await http.post(
        Uri.parse("$baseUrl/my-matches"),
        headers: {
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: {
          'user_id': userId.toString(),
        },
      );

      var responseData = json.decode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseData['status'] == 1) {
          return MyMatchesResponse.fromJson(responseData);
        } else {
          if (responseData["message"] == "Unauthorized") {
            StorageProvider.clearStorage();
            Get.offAllNamed(AppRoutes.login);
          }
          throw responseData['message'] ?? "Failed to load matches";
        }
      } else if (response.statusCode == 401) {
        StorageProvider.clearStorage();
        Get.offAllNamed('/login');
        throw "Unauthorized: Please login again";
      } else {
        throw "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      print("Fetch Matches Error: $e");
      rethrow;
    }
  }


  Future<List<DynamicPageModel>> fetchAllPages() async {
    // 1. Check Connection
    if (!await isConnected()) {
      throw "Please check your internet connection.";
    }

    try {
      final response = await http.get(
        Uri.parse("$baseUrl/all-pages"),
        headers: {
          'Accept': 'application/json',
        },
      );

      print("AllPages Response: ${response.body}");
      var responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        if (responseData['status'] == 1) {
          List<dynamic> pagesJson = responseData['all_pages'];
          return pagesJson.map((json) => DynamicPageModel.fromJson(json)).toList();
        } else {
          throw responseData['message'] ?? "Failed to load pages";
        }
      } else {
        throw "Server Error: ${response.statusCode}";
      }
    } catch (e) {
      print("fetchAllPages API Error: $e");
      rethrow;
    }
  }

  Future<String?> fetchApiVersion() async {
    try {
      final response = await http.get(Uri.parse("$baseUrl/api-version"));
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        if (data['status'] == 1) {
          return data['version'].toString();
        }
      }
    } catch (e) {
      print("API Version Error: $e");
    }
    return null;
  }

}