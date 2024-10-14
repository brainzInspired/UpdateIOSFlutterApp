# UpdateIOSFlutterApp

To update your Flutter application for iOS and Android without using external dependencies, follow these steps. Specifically for iOS, ensure you update the following key in your Info.plist file:

<key>CFBundleShortVersionString</key>
<string>1.0</string>
This version number corresponds to the app's version that you first uploaded. If you are releasing an update, change the version number as shown below. Make sure that the version on the App Store matches the one you set in the code. For example, if your current version is 1.0, update it to 1.1 when releasing the new version:

<key>CFBundleShortVersionString</key>
<string>1.1</string>
Remember to also update the version on the App Store to match this new version (1.1) when you submit the updated app.

And all other code is already mentioned in this MathsApp if any query then asked me.
