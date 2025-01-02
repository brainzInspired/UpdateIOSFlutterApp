import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'dart:io';

class Utilities {

  static const platformChannel = MethodChannel('com.maths.mathsapp/iOS');
  static const platformChannelandroid = MethodChannel('com.maths.mathsapp/Android');



  //this is for android
  static Future<String?> getAppVersionAndroid() async {
    try {
      final String? version = await platformChannelandroid.invokeMethod(
          'getAppVersion');
      return version;
    } catch (e) {
      print('Error fetching app version: $e');
      return null;
    }
  }

  static Future<String?> getAndroidVersionFromGooglePlay(String package) async {
    final Dio dio = Dio();
    final response = await dio.get('https://play.google.com/store/apps/details?id=com.maths.mathsapp');
    // Look for all ,[[[ pattern and split all matches into an array
    List<String> splitted = response.data.split(',[[["');
    // In each element, remove everything after "]] pattern
    List<String> removedLast = splitted.map((String e) {
      return e.split('"]],').first;
    }).toList();
    // We are looking for a version in the array that satisfies the regular expression:
    // starts with one or more digits (\d), followed by a period (.), followed by one or more digits.
    List<String> filteredByVersion = removedLast
        .map((String e) {
      RegExp regex = RegExp(r'^\d+\.\d+');
      if (regex.hasMatch(e)) {
        return e;
      }
    }).whereType<String>()
        .toList();
    if (filteredByVersion.length == 1) {
      return filteredByVersion.first;
    }
    return null;
  }

  //this is for ios
  static Future<String> getAppVersion() async {
    try {
      final String version = await platformChannel.invokeMethod('getAppVersion');
      return version;
    } catch (e) {
      return "not available";
    }
  }
}