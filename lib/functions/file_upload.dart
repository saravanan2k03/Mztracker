import 'dart:io';
import 'package:dio/dio.dart';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

Future<dynamic> deleteFile(String urifile) async {
  var url = 'http://103.207.1.94:8080/filedel/$urifile';
  final response = await http.delete(Uri.parse(url));

  if (response.statusCode == 200) {
    if (kDebugMode) {
      print("File deleted successfully");
    }
  } else {
    if (kDebugMode) {
      print("Failed to delete file");
    }
  }
}
//fileDownload operation

Future<dynamic> downloadFile(BuildContext context, String downloaduri) async {
  var fileUri = "http://103.207.1.94:8080/uploads/$downloaduri";
  try {
    final response = await Dio()
        .get(fileUri, options: Options(responseType: ResponseType.bytes));
    final output = await getExternalStorageDirectory();
    RegExp pathToDownloads = new RegExp(r'.+0\/');
    final outputPath =
        '${pathToDownloads.stringMatch(output!.path).toString()}Download';
    final filePath = '$outputPath/${fileUri.split('/').last}';

    if (kDebugMode) {
      print(filePath);
    }
    final file = File(filePath);
    await file.writeAsBytes(response.data);
    // ignore: use_build_context_synchronously, duplicate_ignore
    ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(content: Text('File downloaded successfully')));
  } catch (error) {
    if (kDebugMode) {
      print(error.toString());
    }
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Download failed')));
  }
}
