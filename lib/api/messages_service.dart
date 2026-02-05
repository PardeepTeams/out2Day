import 'dart:convert';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

class MessagesService {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  Future<void> initializeFirebaseUser() async {
    try {
      var auth = FirebaseAuth.instance;
      if (auth.currentUser != null) {
        return;
      }
      await auth.signInAnonymously();
    } catch (e) {
      debugPrint("Error User Authentication : $e");
    }
  }

/*  Future<ChatHistoryResponse?> getChatHistory(
      String token, String userId) async {
    try {
      final response = await http.get(
        Uri.parse('${AppPages.baseURL}/get-firebase-chats?user_id=$userId'),
        headers: {
          HttpHeaders.contentTypeHeader: ContentType.json.toString(),
          HttpHeaders.authorizationHeader: "Bearer $token",
        },
      );
      final json = jsonDecode(response.body);
      return ChatHistoryResponse.fromJson(json);
    } catch (e) {
      debugPrint("Error Getting Chat History from api : $e");
      return null;
    }
  }*/

  Future<void> sendNotification(String body) async {
    try {
      var authToken = await getAccessToken() ?? "";
      final response = await http.post(
        Uri.parse(
            "https://fcm.googleapis.com/v1/projects/out2day-d9410/messages:send"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        debugPrint('Notification sent successfully.');
      } else {
        debugPrint('Failed to send notification: ${response.body}');
      }
    } catch (e) {
      debugPrint('Error sending notification: $e');
    }
  }

/*  Future<String?> getAccessToken() async {
    String? token = await messaging.getToken(
        vapidKey: "BERopO2oEVrT8bDna0UeU3UaGNgAlSUH6Gfc2TVUZQZ5J8iNPwuXFY2nzXbXxixc-vmhhYQeZga44Pgciv7jN14"
    );
    return token;
  }*/


  Future<String?> getAccessToken() async {
    try {
      // Load service account credentials from JSON file
      final serviceAccountJson =
      await rootBundle.loadString('assets/service_account_key.json');
      final serviceAccount = json.decode(serviceAccountJson);

      // Define required OAuth scopes
      final scopes = ['https://www.googleapis.com/auth/cloud-platform'];

      // Create credentials
      final accountCredentials = ServiceAccountCredentials.fromJson(serviceAccount);

      // Obtain OAuth token
      final client = await clientViaServiceAccount(accountCredentials, scopes);
      final authHeaders = client.credentials.accessToken.data;
      client.close();
      return authHeaders;
    } catch (e) {
      debugPrint('Error obtaining OAuth token: $e');
      return null;
    }
  }
}
