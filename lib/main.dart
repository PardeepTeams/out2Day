import 'package:Out2Do/routes/app_pages.dart';
import 'package:Out2Do/routes/app_routes.dart';
import 'package:Out2Do/utils/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';
import 'firebase_options.dart';



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
  runApp(const MyApp());
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


