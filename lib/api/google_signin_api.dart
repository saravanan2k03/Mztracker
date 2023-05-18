// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/views/LoginPage.dart';

import '../utils/Bottomnavbar.dart';

class GoogleSignInApi {
  static final _googleSignIn = GoogleSignIn();

  static Future<GoogleSignInAccount?> login() => _googleSignIn.signIn();

  static Future<GoogleSignInAccount?> logout() => _googleSignIn.signOut();

  static GetInitialData(String email, BuildContext context) async {
    print(email);
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/login/LoginPage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'email': email,
          },
        ),
      );
      if (response.statusCode == 200) {
        List<dynamic> userList = [];
        if (kDebugMode) {
          print(response.body);
        }

        userList = json.decode(response.body);
        if (kDebugMode) {
          print("TestEmail:${userList[0]["Employee_id"].toString()}");
        }
        box.write("employee", userList[0]["Employee_id"].toString());
        box.write("profile", userList[0]["profile"].toString());
        if (kDebugMode) {
          print(box.read("employee").toString());
        }
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const BottomnavbarPage()),
        );
      } else {
        await _googleSignIn.signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(10.0),
              ),
            ),
            content: Text('SignIn Failed!'),
          ),
        );
        if (kDebugMode) {
          print("api sign Failed");
        }
      }
    } catch (e) {
      await _googleSignIn.signOut();
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const LoginPage()),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          content: Text('SignIn Failed!'),
        ),
      );

      if (kDebugMode) {
        print(e);
        print("catch sign Failed");
      }
    }
  }
}
