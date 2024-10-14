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
                 case "saveversion":
                   guard let args = call.arguments as? [String : Any] else {return}
                   let globallogin = args["previousAppStoreVersion"] as! String
                   UserDefaults.standard.set(globallogin, forKey: "previousAppStoreVersion")
                   break
                 case "retriveversion":
                   let data = UserDefaults.standard.string(forKey: "previousAppStoreVersion") as String?
                   if(data == nil){
                      result("")
                   }else{
                     result(data)
                   }
                   break
                 case "removeversion":
                   UserDefaults.standard.removeObject(forKey: "lastVersion")
                   //return
                   break
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
