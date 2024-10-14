import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class Utilities {

  static const platformChannel = MethodChannel('com.maths.mathsapp/iOS');
  static const platformChannelandroid = MethodChannel('com.maths.mathsapp/Android');


  static Future<String?> getAppVersionAndroid() async {
    try {
      final String? version = await platformChannelandroid.invokeMethod('getAppVersion');
      return version;
    } catch (e) {
      print('Error fetching app version: $e');
      return null;
    }
  }

  static Future<String?> isStoreversionData(String json) async {
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {
      platformChannel.invokeMethod('saveversion', {"previousAppStoreVersion": json});
    }
  }

  static Future<String?> isRetriveversionData() async {
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {
      String Stringlogin = await platformChannel.invokeMethod("retriveversion");
      if (Stringlogin.isNotEmpty && Stringlogin.toString().length > 0) {
        String jsonvalue = Stringlogin.toString();
        return jsonvalue;
      } else {
        return "";
      }
    }
  }


  static Future<String?> removeLogin() async {
    if (Platform.isAndroid) {
    } else if (Platform.isIOS) {
      await platformChannel.invokeMethod("removeversion");
    }
  }
  static Future<String> getAppVersion() async {
    try {
      final String version = await platformChannel.invokeMethod('getAppVersion');
      return version;
    } catch (e) {
      return "not available";
    }
  }
}