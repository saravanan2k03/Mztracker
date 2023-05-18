import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:mztrackertodo/functions/variabels.dart';

Future filepickfunc() async {
  FilePickerResult? result =
      await FilePicker.platform.pickFiles(allowMultiple: true);
  if (result != null) {
    file = result.paths.map((path) => File(path!)).toList();
    if (kDebugMode) {
      for (var i = 0; i < file.length; i++) {
        files.add(file[i]);
      }
      print(files);
      print(files.length);
    }
  } else {
    if (kDebugMode) {
      print("User canceled the picker");
    }
  }
}
