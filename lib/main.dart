import 'package:Out2Do/api/storage_helper.dart';
import 'package:Out2Do/routes/app_pages.dart';
import 'package:Out2Do/routes/app_routes.dart';
import 'package:Out2Do/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';
import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';


final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();
String? pendingNotificationPayload;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Android 15 isse transparent hi rakhta hai
    systemNavigationBarColor: Colors.transparent,
  ));
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );



 /* if (!kIsWeb) {
    await askNotificationPermission();
    await _initializeNotifications();


    final launchDetails = await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      pendingNotificationPayload = launchDetails?.notificationResponse?.payload;
    }

    // 2. Check if app opened from terminated state (FCM)
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      pendingNotificationPayload = jsonEncode(initialMessage.data);
    }
   *//* await _checkForNotificationLaunch((payload) {
      pendingNotificationPayload = payload;
    });
    final initialMessage = await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      pendingNotificationPayload = jsonEncode(initialMessage.data);
    }*//*
  } else {
    await askNotificationPermissionWeb();
  }

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    debugPrint('Message received: ${message.data}');
    if (Platform.isAndroid) {
      showNotification(
        id: 0,
        title: message.notification?.title ?? "",
        message: message.notification?.body ?? "",
        payload: jsonEncode(message.data),
      );
    }
  });
  FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    debugPrint("Background/Terminated Notification Click: ${message.data}");
    manageNotificationClick(jsonEncode(message.data));
  });*/

/*  if (pendingPayload != null && (pendingPayload ?? "").isNotEmpty) {
    // Delay so that navigation system is ready
    Future.delayed(const Duration(milliseconds: 2500), () {
      if (Get.currentRoute != AppRoutes.splash) {
        manageNotificationClick(pendingPayload!);
      } else {
        // Agar abhi bhi splash par hai, toh thoda aur wait karein ya splash controller se handle karwayein
        _retryNavigation(pendingPayload!);
      }
    });
  }*/

  runApp(const MyApp());
}
// Ek chota helper function
void _retryNavigation(String payload) async {
  await Future.delayed(const Duration(seconds: 2));
  manageNotificationClick(payload);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Latest devices ke liye zaroori hai
        scaffoldBackgroundColor: MyColors.white,
        appBarTheme: const AppBarTheme(
          systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: MyColors.white,
            statusBarIconBrightness: Brightness.dark, // Android ke liye
            statusBarBrightness: Brightness.light,    // iOS ke liye
          ),
        ),
      ),
      title: 'Out2DO',
      initialRoute: AppRoutes.splash,
      getPages: AppPages.pages,
    );
  }
}





// Method to initialize the notifications
Future<void> _initializeNotifications() async {
  // Android initialization settings
  const AndroidInitializationSettings initializationSettingsAndroid =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  // iOS initialization settings
  const DarwinInitializationSettings initializationSettingsIOS =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  // Combine Android and iOS settings
  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
  );

  // Initialize the plugin with settings and handle notification taps
  await flutterLocalNotificationsPlugin.initialize(
    onDidReceiveNotificationResponse: _onNotificationResponse,
    onDidReceiveBackgroundNotificationResponse:
    _onBackgroundNotificationResponse, settings: initializationSettings,
  );
}

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint("Handling a background message: ${message.notification?.title}");
}

// Callback for when a notification is clicked in the foreground or background
void _onNotificationResponse(NotificationResponse notificationResponse) {
  String? payload = notificationResponse.payload;
  if (payload != null && payload.isNotEmpty) {
    manageNotificationClick(payload);
  }
}

// Callback for when a notification is clicked in the background
@pragma('vm:entry-point')
void _onBackgroundNotificationResponse(
    NotificationResponse notificationResponse) {
  String? payload = notificationResponse.payload;
  if (payload != null && payload.isNotEmpty) {
    manageNotificationClick(payload);
  }
}

// Check if the app was launched by a notification click
Future<void> _checkForNotificationLaunch(
    Function(String) onPayloadFound) async {
  final launchDetails =
  await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (launchDetails?.didNotificationLaunchApp ?? false) {
    final payload = launchDetails?.notificationResponse?.payload;
    if (payload != null && payload.isNotEmpty) {
      onPayloadFound.call(payload);
    }
  }
}

Future<void> manageNotificationClick(String notificationPayload) async {
  try {
    final isLogin = StorageProvider.isUserLoggedIn();

    if(isLogin){
      final user = StorageProvider.getUserData();
      if(user!=null){
        Map<String, dynamic> outerJson = jsonDecode(notificationPayload);
        var notificationType = outerJson["notification_type"];
        if (notificationType == "message") {
          var notificationSender =
          jsonDecode(outerJson["sender"]) as Map<String, dynamic>;
          var notificationReceiver =
          jsonDecode(outerJson["receiver"]) as Map<String, dynamic>;
          if (notificationSender.entries.isNotEmpty &&
              notificationReceiver.entries.isNotEmpty) {
            Map<String, dynamic> receiver =
            (user.id) != notificationReceiver["id"]
                ? notificationReceiver
                : notificationSender;
            Get.toNamed(
              AppRoutes.chatMessages,
              arguments: <String, dynamic>{
                'sender': user.toJson(),
                'receiver': receiver,
              },
            );
          }
        } else if (notificationType == "activity") {

        } else if (notificationType == "event") {
          /* Get.toNamed(AppPages.trainerDetail,
              arguments: {
                "trainer":outerJson["sender_id"].toString()
              });*/



        } else if (notificationType == "connect") {

        } else {
          Get.toNamed(AppRoutes.notifications);
        }
      }
    }

  } catch (e) {
    debugPrint("Error in notification click : $e");
  }
}

Future<void> askNotificationPermissionWeb() async {
  NotificationSettings settings =
  await FirebaseMessaging.instance.requestPermission();

  switch (settings.authorizationStatus) {
    case AuthorizationStatus.authorized:
      break;
    case AuthorizationStatus.provisional:
      break;
    case AuthorizationStatus.denied:
      break;
    default:
  }
}

Future<void> askNotificationPermission() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
    provisional: false, // iOS par turant permission popup dikhane ke liye false rakhein
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    debugPrint('User granted permission');
  } else if (settings.authorizationStatus == AuthorizationStatus.denied) {
    debugPrint('User declined permission');
  }
}

Future<void> showNotification({
  required int id,
  required String title,
  required String message,
  required String payload,
}) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
  AndroidNotificationDetails(
    'GYM',
    'GYM',
    channelDescription: 'GYM',
    icon: "@mipmap/ic_launcher",
    importance: Importance.max,
    priority: Priority.high,
    showWhen: true,
    enableVibration: true,
  );

  const DarwinNotificationDetails iosPlatform = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  const NotificationDetails platformChannelSpecifics = NotificationDetails(
    android: androidPlatformChannelSpecifics,
    iOS: iosPlatform,
  );

  await flutterLocalNotificationsPlugin.show(
    title: title,
    body:message,
    notificationDetails:platformChannelSpecifics,
    payload: payload, id: id,
  );
}


