import UIKit
import Flutter
import Firebase
import FirebaseAuth // <--- Ye line confirm karein

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    FirebaseApp.configure()
    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

  // ISME CHANGE KAREIN:
  override func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {

    // 1. Pehle Firebase ko check karne dein ki ye uska URL hai ya nahi
    if Auth.auth().canHandle(url) {
      return true
    }

    // 2. Agar Firebase ka nahi hai, toh baaki plugins ko handle karne dein
    return super.application(app, open: url, options: options)
  }
}