import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:math_expressions/math_expressions.dart';
import 'buttons.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';
import 'utilities.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var userInput = '';
  var answer = '';
  final List<String> buttons = [
    'C',
    '+/-',
    '%',
    'DEL',
    '7',
    '8',
    '9',
    '/',
    '4',
    '5',
    '6',
    'x',
    '1',
    '2',
    '3',
    '-',
    '0',
    '.',
    '=',
    '+',
  ];

  String appshow_version = "";
  String previousAppStoreVersion = "";

  @override
  void initState() {
    super.initState();
    if(Platform.isAndroid){
      WidgetsBinding.instance.addPostFrameCallback((_) {
        checkForUpdateAndroid();
      });
    }else{
      checkForUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Calculator app ver"+appshow_version+"local"+previousAppStoreVersion),
      ),
      backgroundColor: Colors.white38,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: Text(
                userInput,
                style: TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.centerRight,
              child: Text(
                answer,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.9,
              child: GridView.builder(
                itemCount: buttons.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 4,
                ),
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput = '';
                          answer = '0';
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  } else if (index == 1) {
                    return MyButton(
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  } else if (index == 2) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  } else if (index == 3) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput =
                              userInput.substring(0, userInput.length - 1);
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.blue[50],
                      textColor: Colors.black,
                    );
                  } else if (index == 18) {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          equalPressed();
                        });
                      },
                      buttonText: buttons[index],
                      color: Colors.orange[700],
                      textColor: Colors.white,
                    );
                  } else {
                    return MyButton(
                      buttontapped: () {
                        setState(() {
                          userInput += buttons[index];
                        });
                      },
                      buttonText: buttons[index],
                      color: isOperator(buttons[index])
                          ? Colors.blueAccent
                          : Colors.white,
                      textColor: isOperator(buttons[index])
                          ? Colors.white
                          : Colors.black,
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool isOperator(String x) {
    return x == '/' || x == 'x' || x == '-' || x == '+' || x == '=';
  }

  void equalPressed() {
    String finaluserinput = userInput;
    finaluserinput = userInput.replaceAll('x', '*');
    Parser p = Parser();
    Expression exp = p.parse(finaluserinput);
    ContextModel cm = ContextModel();
    double eval = exp.evaluate(EvaluationType.REAL, cm);
    answer = eval.toString();
  }

  Future<void> checkForUpdate() async {
    final afterupdate = await Utilities.getAppVersion();
    previousAppStoreVersion = afterupdate.toString();
    final int timestamp = DateTime.now().millisecondsSinceEpoch;
    //com.example.update change this package name with your packagename
    final String url = 'https://itunes.apple.com/lookup?bundleId=com.example.update&time=$timestamp';
    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['resultCount'] > 0) {
          final appStoreVersion = data['results'][0]['version'];
          appshow_version = appStoreVersion.toString();
          if(previousAppStoreVersion.isNotEmpty){
            List<String> oldversion = previousAppStoreVersion.split('.');
            int olderversion = int.parse(oldversion[1]);
            await Future.delayed(Duration(seconds: 2));
            List<String> newversion = appshow_version.split('.');
            int newerversion = int.parse(newversion[1]);
            if(newerversion > olderversion){
              _showUpdateDialog(appshow_version);
            }
          }
        }
      }
    } catch (e) {
      print('Error checking for update: $e');
    }
    setState(() {
      appshow_version;
      previousAppStoreVersion;
    });
  }

  void _launchAppStore() async {
    const appStoreUrl =
        'https://apps.apple.com/app/12345689'; // Replace with actual App Store URL
     // ("Go to your app store-> Distribution-> App information -> General Information get "Apple_id" replace this "12345689" with your actual appleid)
    if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
      await launchUrl(Uri.parse(appStoreUrl));
    }
  }

  // Function to show the "Update Available" dialog
  void _showUpdateDialog(String newVersion) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog without updating
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Update Available"),
          content: Text(
            "A new version ($newVersion) is available. Please update to the latest version.\n"
                "If you don't want to update the application by clicking the update button, then next time you will have to manually update the application on the app store.",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop(); // Disable this line if you want to force the update
              },
              child: Text("Later"),
            ),
            TextButton(
              onPressed: () async {
                _launchAppStore(); // Redirect to App Store
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  void checkForUpdateAndroid() async {
    final previous = await Utilities.getAppVersionAndroid();
    previousAppStoreVersion = previous.toString();
    print("object"+previousAppStoreVersion);
    final playstore = await Utilities.getAndroidVersionFromGooglePlay('com.maths.mathsapp'); //"com.example.tips" replace with your package name this version means
    appshow_version = playstore.toString();
    List<String> previousVersionParts = previousAppStoreVersion.split('.');
    List<String> currentVersionParts = appshow_version.split('.');
    // Parse the third number from each version
    int oldVersion = int.parse(previousVersionParts[2]);
    int newVersion = int.parse(currentVersionParts[2]);
    if (newVersion > oldVersion) {
      _showUpdateAndroidDialog(appshow_version); // Show the update dialog if needed
    }else{
      //getApplogo(); if update not avcailable then call your service here

    }
  }

  BuildContext? dialogcontext;
  void _showUpdateAndroidDialog(String newVersion) {
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog without updating
      builder: (BuildContext context) {
        dialogcontext = context;
        return AlertDialog(
          title: Text("Update Available"),
          content: Text(
            "A new version ($newVersion) is available and required to continue using the application. "
                "Please update to the latest version now to access all features and ensure the app functions properly\n"
                "Updating is mandatory thank you for your cooperation!",
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SystemNavigator.pop();
              },
              child: Text("Later"),
            ),
            TextButton(
              onPressed: () async {
                _launchPlayStoreAndroid(); // Redirect to App Store
              },
              child: Text("Update"),
            ),
          ],
        );
      },
    );
  }

  //i have created another method also "launchAppStore" this one
  // because if "canLaunchUrl" this library is depricated then come to the cache so this option is also available for you if you dont want to use "canLaunchUrl"
  void _launchPlayStoreAndroid() async {
    try{
      const appStoreUrl = 'https://play.google.com/store/apps/details?id=com.maths.mathsapp'; // Replace with actual Play Store URL
      if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
        await launchUrl(Uri.parse(appStoreUrl));
      }
    }catch(e){
      await Utilities.platformChannelandroid.invokeMethod('launchAppStore');
    }
  }
}
