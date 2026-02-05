import 'package:Out2Do/views/blocked_users_screen.dart';
import 'package:Out2Do/views/business/my_business_screen.dart';
import 'package:Out2Do/views/events/events_listings.dart';
import 'package:Out2Do/views/events/events_tab_screen.dart';
import 'package:Out2Do/views/events/my_events_listing_screen.dart';
import 'package:Out2Do/views/home/home_screen.dart';
import 'package:Out2Do/views/home/tabs/chat/chat_messages_screen.dart';
import 'package:Out2Do/views/privacy_policy_screen.dart';
import 'package:Out2Do/views/profile_creation_screen.dart';
import 'package:Out2Do/views/profile_detail_screen.dart';
import 'package:Out2Do/views/report_user_screen.dart';
import 'package:get/get.dart';
import '../views/business/business_tab_screen.dart';
import '../views/faq_screen.dart';
import '../views/login_screen.dart';
import '../views/new_profile_details_screen.dart';
import '../views/notifications_screen.dart';
import '../views/otp_screen.dart';
import '../views/safety_screen.dart';
import '../views/splash_screen.dart';
import '../views/user_profile_details_screen.dart';
import 'app_routes.dart';

class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
    ),
    GetPage(
      name: AppRoutes.login,
      page: () =>  LoginScreen(),
    ),
    GetPage(
      name: AppRoutes.otp,
      page: () =>  OtpScreen(),
    ),

    GetPage(
      name: AppRoutes.profileCreation,
      page: () =>  ProfileCreationScreen(),
    ),

    GetPage(
      name: AppRoutes.home,
      page: () =>  HomeScreen(),
    ),
    GetPage(
      name: AppRoutes.userProfileDetail,
      page: () =>  UserProfileDetailScreen(),
    ),
    GetPage(
      name: AppRoutes.chatMessages,
      page: () =>  ChatMessagesScreen(),
    ),
    GetPage(
      name: AppRoutes.events,
      page: () =>  EventsTabScreen(),
    ),
   /* GetPage(
      name: AppRoutes.myEvents,
      page: () =>  MyEventsScreen(),
    ),*/
    GetPage(
      name: AppRoutes.business,
      page: () =>  BusinessesTabScreen(),
    ),
    GetPage(
      name: AppRoutes.blockedUser,
      page: () =>  BlockedUsersScreen(),
    ),
    GetPage(
      name: AppRoutes.notifications,
      page: () =>  NotificationsScreen(),
    ),
    GetPage(
      name: AppRoutes.faqs,
      page: () =>  FaqScreen(),
    ),
    GetPage(
      name: AppRoutes.privacyPolicy,
      page: () =>  PrivacyPolicyScreen(),
    ),
    GetPage(
      name: AppRoutes.safetyScreen,
      page: () =>  SafeDatingScreen(),
    ),

    GetPage(
      name: AppRoutes.ewProfileDetail,
      page: () =>  UserProfileDetailScreen(),
    ),

  ];
}
