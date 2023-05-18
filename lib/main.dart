// ignore_for_file: prefer_const_constructors, duplicate_ignore, no_leading_underscores_for_local_identifiers
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/utils/Bottomnavbar.dart';
import 'package:mztrackertodo/views/LoginPage.dart';
import 'package:mztrackertodo/views/Version.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'views/splashscreen.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  await GetStorage.init();
  runApp(MyApp());
  FileOperationdart.versionchecking(version);
  signinchecking();
}

// ignore: non_constant_identifier_names
UploadNotificationId(String Id) async {
  try {
    final http.Response response = await http.post(
      Uri.parse('http://$ip:$port/alert/uploadnotificationid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'empid': box.read("employee").toString(),
          'notificationid': Id,
        },
      ),
    );
    if (response.statusCode == 200) {}
  } catch (e) {
    if (kDebugMode) {
      print(e);
    }
  }
}

Future<void> requestPermission() async {
  if (await Permission.storage.request().isGranted) {
    if (kDebugMode) {
      print("permission");
    }
  } else {
    if (kDebugMode) {
      print("permissionfalse");
    }
  }
}

Future<String> getExternalStorageDirectoryPath() async {
  final directory = await getExternalStorageDirectory();
  return directory!.path;
}

signinchecking() async {
  GoogleSignIn _googleSignIn = GoogleSignIn();
  await _googleSignIn.isSignedIn().then((value) {
    if (value) {
      Loginsucess = true;
      initPlatform();
      getExternalStorageDirectoryPath();
      requestPermission();
      if (kDebugMode) {
        print("Google Has been Signed $Loginsucess");
      }
    } else {
      Loginsucess = false;
    }
  });
}

Future<void> initPlatform() async {
  OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
  await OneSignal.shared.setAppId("3cfaaad6-e32a-461f-9eba-587e52f2eda1");
  OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
    if (kDebugMode) {
      print("Accepted permission: $accepted");
    }
  });

  await OneSignal.shared.getDeviceState().then((value) {
    if (kDebugMode) {
      print("onesignalvalue:${value!.userId}");
    }
    UploadNotificationId(value!.userId!);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(Duration(seconds: 10)),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold();
        }
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: 'Mztracker',
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            home: Loginsucess
                ? versioncheck
                    ? BottomnavbarPage()
                    : VersionScreen()
                : versioncheck
                    ? LoginPage()
                    : VersionScreen(),
          );
        }
        return MaterialApp(
          title: 'Mztracker',
          debugShowCheckedModeBanner: false,
          home: Splash_Screen(),
        );
      },
    );
  }
}
