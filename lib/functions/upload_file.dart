import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:http/http.dart' as http;

// ignore: non_constant_identifier_names
Future file_upload(String dynamiclocation) async {
  try {
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = Colors.white
      ..textColor = Colors.black
      ..indicatorColor = primary
      ..maskColor = Colors.white
      ..dismissOnTap = false;
    EasyLoading.show(status: 'Please wait...');

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://103.207.1.94:8080/upload/$dynamiclocation'),
    );

    for (var file in files) {
      request.files.add(await http.MultipartFile.fromPath('files', file.path));
    }

    var response = await request.send();
    if (response.statusCode == 200) {
      if (kDebugMode) {
        print('Files uploaded successfully!');
      }
      EasyLoading.showSuccess('Great Success!');
    } else {
      if (kDebugMode) {
        print('Error uploading files: ${response.reasonPhrase}');
      }
    }
  } catch (e) {
    if (kDebugMode) {
      print("file Error:$e");
    }
  }
}
