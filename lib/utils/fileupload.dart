import 'package:flutter/material.dart';
import '../api/FileOperation.dart';

class FileUpload extends StatelessWidget {
  const FileUpload({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => FileOperationdart.Fileopener(context, 'example.pdf'),
          child: const Text('Open File'),
        ),
      ),
    );
  }
}
