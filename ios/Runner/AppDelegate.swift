import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
      let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
      let deviceChannel = FlutterMethodChannel(name: "com.maths.mathsapp/iOS",binaryMessenger: controller.binaryMessenger)
      prepareMethodHandler(deviceChannel: deviceChannel)
      GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
    
    private func prepareMethodHandler(deviceChannel: FlutterMethodChannel) {
           deviceChannel.setMethodCallHandler({
               (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
               switch call.method {
                 case "getAppVersion":
                  if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                      print("App Version: \(version)")  // This will print the version to the console
                      result(version)
                  } else {
                      print("Failed to retrieve app version")  // Print failure message
                      result("")
                  }
                   
               default:
                   result(FlutterMethodNotImplemented)
                   return
               }
           })
       }
}
