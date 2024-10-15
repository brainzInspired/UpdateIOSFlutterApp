package com.maths.mathsapp

import android.content.pm.PackageInfo
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import android.os.Bundle


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
                    } else {
                        result.error("UNAVAILABLE", "App version not available.", null)
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

}

