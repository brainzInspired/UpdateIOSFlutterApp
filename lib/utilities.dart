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
  static Future<String> getAppVersion() async {
    try {
      final String version = await platformChannel.invokeMethod('getAppVersion');
      return version;
    } catch (e) {
      return "not available";
    }
  }
}