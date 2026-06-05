// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/utils/Bottomnavbar.dart';
import 'views/splashscreen.dart';

void main() async {
  await GetStorage.init();
  _initMockUser();
  Loginsucess = true;
  versioncheck = true;
  runApp(MyApp());
}

void _initMockUser() {
  final user = MockRepository.currentUser;
  box.write('employee', user.employeeId);
  box.write('Name', user.employeeName);
  box.write('profile', user.profile);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) {
        return FutureBuilder(
          future: Future.delayed(const Duration(seconds: 2)),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return MaterialApp(
                title: 'Mztracker',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: mode,
                builder: EasyLoading.init(),
                home: const BottomnavbarPage(),
              );
            }
            return MaterialApp(
              title: 'Mztracker',
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: mode,
              home: Splash_Screen(),
            );
          },
        );
      },
    );
  }
}
