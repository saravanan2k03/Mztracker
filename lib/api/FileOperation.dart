// ignore_for_file: non_constant_identifier_names
import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/variabels.dart';

class FileOperationdart {
  static Future<void> Fileopener(BuildContext context, String filename) async {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Opening $filename (mock)')),
    );
  }

  static Future<void> downloadFile(
      BuildContext context, String downloaduri, String Id) async {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('File downloaded (mock)')),
    );
  }

  static Future<void> fileUploadfunc(String dynamiclocation, String Id) async {
    final result = await FilePicker.platform.pickFiles(allowMultiple: true);
    if (result == null) return;

    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = primary
      ..textColor = blackclr
      ..indicatorColor = primary
      ..maskColor = primary.withOpacity(0.1)
      ..dismissOnTap = false;
    EasyLoading.show(status: 'Uploading...');
    await Future.delayed(const Duration(milliseconds: 500));

    for (final path in result.paths) {
      if (path != null) {
        final filename = path.split('/').last.split('\\').last;
        MockRepository.addAttachment(Id, filename, box.read('employee').toString());
      }
    }
    EasyLoading.showSuccess('File Uploaded!');
  }

  static Future<void> Editprofiledata(
      dynamic imageFile, String dynamiclocation, String Id) async {
    EasyLoading.showSuccess('Profile Updated (mock)!');
  }

  static Future<void> Filedeleting(String Id, String filename) async {
    MockRepository.deleteAttachment(Id, filename);
  }

  static Future<void> sendnotification(
      String employee, String tasktittle, String taskcontent, String title) async {
    // mock — no-op
  }

  static Future<void> versionchecking(String version) async {
    versioncheck = true;
  }
}
