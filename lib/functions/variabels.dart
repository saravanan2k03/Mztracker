import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

Color MainTextColor = const Color.fromARGB(255, 255, 73, 60);
Color Appbackgroundcolor = const Color.fromARGB(252, 255, 250, 250);
Color blackclr = Colors.black;

bool? status1 = true;
bool? status2 = false;
bool? date_time_status = true;
bool chat_status = false;

Color primary = Color.fromARGB(255, 255, 73, 60);
var actual_text;
List userList = [];
List<File> file = [];
List<File> files = [];
List<dynamic> categoryList = [];
List<Map<String, dynamic>> selectedItems = [];
List<String> cat_list = ["- - Choose-Category - -"];
List<int> catid_list = [];
List chatList = [];

var selectedValue = "CSE";
var selectedcategory = '- - Choose-Category - -';
var cat_id;

var ip = "103.207.1.94";
var port = "8080";
var box = GetStorage();
bool versioncheck = false;
// ignore: non_constant_identifier_names
bool Loginsucess = false;
var version = "1.0";

DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

String initial_Date = DateFormat('dd-MM-yyyy').format(selectedDate);
String formattedDate = DateFormat('dd-MM-yyyy').format(selectedDate);

String initial_Time = DateFormat('h:mm a')
    .format(DateTime(2022, 03, 01, selectedTime.hour, selectedTime.minute));
String formattedTime = DateFormat('h:mm a')
    .format(DateTime(2022, 03, 01, selectedTime.hour, selectedTime.minute));
final focus = FocusNode();

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
    // border: Border(
    //   top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
    // ),

    );

String unicodeToText(String text) {
  List<int> codeUnits = List<int>.from(
      "\u0076\u0061\u0073\u0075\u0020\ud83d\ude00\ud83d\ude00\ud83d\ude00"
          .codeUnits);
  print(utf8.decode(codeUnits));

  return utf8.decode(codeUnits);
}

String textToUnicode(String textString) {
  String unicodeString = "";
  for (int i = 0; i < textString.length; i++) {
    unicodeString +=
        "\\u" + textString.codeUnitAt(i).toRadixString(16).padLeft(4, '0');
  }
  return unicodeString;
}
