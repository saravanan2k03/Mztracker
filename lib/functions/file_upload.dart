import 'package:flutter/material.dart';

Future<void> deleteFile(String urifile) async {}

Future<void> downloadFile(BuildContext context, String downloaduri) async {
  ScaffoldMessenger.of(context)
      .showSnackBar(const SnackBar(content: Text('File downloaded (mock)')));
}
