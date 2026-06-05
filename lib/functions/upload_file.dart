import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:mztrackertodo/functions/variabels.dart';

// ignore: non_constant_identifier_names
Future file_upload(String dynamiclocation) async {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = primary
    ..textColor = blackclr
    ..indicatorColor = primary
    ..maskColor = primary.withOpacity(0.1)
    ..dismissOnTap = false;
  EasyLoading.show(status: 'Uploading...');
  await Future.delayed(const Duration(milliseconds: 500));
  EasyLoading.showSuccess('Files uploaded!');
}
