package com.maths.mathsapp

import android.content.pm.PackageInfo
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.content.Intent;
import android.net.Uri;

class MainActivity: FlutterActivity() {
    private val CHANNEL = "com.maths.mathsapp/Android"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        flutterEngine?.dartExecutor?.binaryMessenger?.let {
            MethodChannel(it, CHANNEL).setMethodCallHandler { call, result ->
                if (call.method == "getAppVersion") {
                    val appVersion = getAppVersion()
                    if (appVersion != null) {
                        result.success(appVersion)
                    } else if (call.method.equals("launchAppStore")) {
                        launchAppStore();
                        result.success(null);
                    } else {
                        result.notImplemented();
                    }
                } else {
                    result.notImplemented()
                }
            }
        }
    }

    private fun getAppVersion(): String? {
        return try {
            val packageInfo: PackageInfo = packageManager.getPackageInfo(packageName, 0)
            packageInfo.versionName
        } catch (e: Exception) {
            e.printStackTrace()
            null
        }
    }

    private fun launchAppStore() {
        val appStoreUrl = "https://play.google.com/store/apps/details?id=com.TOTALytics.App"
        val intent = Intent(Intent.ACTION_VIEW, Uri.parse(appStoreUrl))
        startActivity(intent)
    }

}




