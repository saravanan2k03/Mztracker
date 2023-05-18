// ignore_for_file: unnecessary_new, prefer_const_constructors, duplicate_ignore

import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../api/FileOperation.dart';

class FileUpload extends StatefulWidget {
  const FileUpload({super.key});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  @override
  void initState() {
    requestPermission();
    super.initState();
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
              child:
                  ElevatedButton(onPressed: () {}, child: Text("Select File"))),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    // FileOperationdart.downloadFile(context, "tt.pdf");
                  },
                  child: Text("Download"))),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    requestPermission();
                  },
                  child: Text("Request Storage Permission"))),
          Center(
              child:
                  ElevatedButton(onPressed: () {}, child: Text("Delete File"))),
          Center(
              child: ElevatedButton(
                  onPressed: () {
                    FileOperationdart.Fileopener(context, "tt.pdf");
                  },
                  child: Text("Open")))
        ],
      ),
    );
  }
}
