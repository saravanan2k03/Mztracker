import 'package:flutter/material.dart';
import 'package:mztrackertodo/utils/Bottomnavbar.dart';

class GoogleSignInApi {
  static Future<void> login() async {}
  static Future<void> logout() async {}

  static void GetInitialData(String email, BuildContext context) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const BottomnavbarPage()),
    );
  }
}
