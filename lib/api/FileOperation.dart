// ignore_for_file: use_build_context_synchronously, prefer_const_constructors, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import '../functions/api_methods.dart';
import '../functions/variabels.dart';

class FileOperationdart {
  // ignore: non_constant_identifier_names

  //filedelete operati
  // ignore: non_constant_identifier_names
  static Future<dynamic> Fileopener(
      BuildContext context, String filename) async {
    final output = await getExternalStorageDirectory();
    RegExp pathToDownloads = RegExp(r'.+0\/');
    final outputPath =
        '${pathToDownloads.stringMatch(output!.path).toString()}Download';
    final filePath = '$outputPath/$filename';

    if (kDebugMode) {
      print(filePath);
    }

    final file = File(filePath);
    if (await file.exists()) {
      OpenFile.open(filePath);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          content: Text('File Not Exists!'),
        ),
      );
    }
  }
  //fileDownload operation

  static Future<dynamic> downloadFile(
      BuildContext context, String downloaduri, String Id) async {
    var fileUri = "http://$ip:$port/image/$Id/$downloaduri";
    if (kDebugMode) {
      print(fileUri);
    }
    try {
      final response = await Dio()
          .get(fileUri, options: Options(responseType: ResponseType.bytes));
      final output = await getExternalStorageDirectory();
      RegExp pathToDownloads = RegExp(r'.+0\/');
      final outputPath =
          '${pathToDownloads.stringMatch(output!.path).toString()}Download';
      final filePath = '$outputPath/${fileUri.split('/').last}';

      if (kDebugMode) {
        print(filePath);
      }

      final file = File(filePath);
      if (await file.exists()) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
            ),
            content: Text('File Already Exists!'),
          ),
        );
      } else {
        await file.writeAsBytes(response.data);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
            ),
            content: Text('File Download Successfully'),
          ),
        );
      }
    } catch (error) {
      if (kDebugMode) {
        print(error.toString());
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          content: Text('Download Failed'),
        ),
      );
    }
  }

  static Future<dynamic> getnotificationid(
      String employee, tasktittle, taskcontent, pushnotificationtittle) async {
    List<dynamic> employeeid = [];
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/alert/getnotificationid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'empid': employee.toString(),
          },
        ),
      );
      if (response.statusCode == 200) {
        employeeid = json.decode(response.body);
        List<dynamic> noti = [];
        noti.add(employeeid[0][0]["Notification_id"]);
        sendnotification(
          noti,
          tasktittle,
          taskcontent,
          pushnotificationtittle,
        );
        if (kDebugMode) {
          print(employeeid[0][0]["Notification_id"]);
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<dynamic> sendnotification(
      List notificationid,
      String tasktittle,
      String taskcontent,
      String pushnotificationtittle) async {
    try {
      if (notificationid.isNotEmpty) {
        final http.Response response = await http.post(
          Uri.parse('http://$ip:$port/alert/SendNotificationToDevice'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonEncode(
            {
              'devices': notificationid,
              'tasktittle': tasktittle,
              'taskcontent': taskcontent,
              'pushnotificationtittle': pushnotificationtittle,
            },
          ),
        );
        if (response.statusCode == 200) {}
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static fileUploadfunc(String dynamiclocation, String Id) async {
    FilePickerResult? result =
        await FilePicker.platform.pickFiles(allowMultiple: true);

    if (result != null) {
      List<File> files = result.paths.map((path) => File(path!)).toList();
      if (kDebugMode) {
        // print(files.length);
      }
      if (kDebugMode) {
        print(files);
      }
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
        Uri.parse('http://$ip:$port/upload/$dynamiclocation'),
      );

      for (var file in files) {
        request.files
            .add(await http.MultipartFile.fromPath('files', file.path));
        send_attachment(
          Id,
          file.path.split('/').last,
          box.read("employee").toString(),
        );
        if (kDebugMode) {
          print('Added file: ${file.path.split('/').last}');
        }
      }

      var response = await request.send();
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print('Files uploaded successfully!');
        }
        EasyLoading.showSuccess('File Uploaded!');
        files.clear();
      } else {
        if (kDebugMode) {
          print('Error uploading files: ${response.reasonPhrase}');
        }
      }
    } else {
      if (kDebugMode) {
        print("User canceled the picker");
      }
    }
  }

  static Editprofiledata(
      File imageFile, String dynamiclocation, String Id) async {
    // ignore: unrelated_type_equality_checks
    if (imageFile.length() != 0) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://$ip:$port/upload/$dynamiclocation'),
      );
      EasyLoading.instance
        ..loadingStyle = EasyLoadingStyle.custom
        ..backgroundColor = Colors.white
        ..textColor = Colors.black
        ..indicatorColor = primary
        ..maskColor = Colors.white
        ..dismissOnTap = false;
      EasyLoading.show(status: 'Please wait...');
      request.files
          .add(await http.MultipartFile.fromPath('file', imageFile.path));
      // add other fields and headers to the request if needed
      var response = await request.send();
      if (response.statusCode == 200) {
        // send_attachment(
        //   Id,
        //   imageFile.path.split('/').last,
        //   box.read("employee").toString(),
        // );
        EasyLoading.showSuccess('File Uploaded!');

        if (kDebugMode) {
          print('Added file: ${imageFile.path.split('/').last}');
        }
      } else {
        // handle error response
      }
    }
  }

  static Future<dynamic> Filedeleting(String Id, String filename) async {
    try {
      final http.Response response = await http.delete(
        Uri.parse('http://$ip:$port/filedel/$Id/$filename'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode == 200) {
        if (kDebugMode) {
          print("File Deleted");
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  static Future<dynamic> versionchecking(String version) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/login/versionchecking'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          {
            'version': version,
          },
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> ver = [];
        ver = jsonDecode(response.body);
        if (kDebugMode) {
          print(response.body);
        }
        if (ver.isNotEmpty) {
          versioncheck = true;
        } else {
          versioncheck = false;
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  //end class
}
