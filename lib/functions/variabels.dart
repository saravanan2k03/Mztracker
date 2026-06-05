import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';

// Global theme notifier — toggled from Profile settings
final themeNotifier = ValueNotifier<ThemeMode>(ThemeMode.light);

// Legacy colour aliases kept for non-widget code (EasyLoading, etc.)
const Color MainTextColor    = Color(0xFFFF4940);
const Color Appbackgroundcolor = Color(0xFFFFFAFA);
const Color blackclr         = Color(0xFF1A1A1A);
const Color primary          = Color(0xFFFF4940);

bool? status1 = true;
bool? status2 = false;
bool? date_time_status = true;
bool chat_status = false;

var actual_text;
List userList = [];
List<File> file = [];
List<File> files = [];
List<dynamic> categoryList = [];
List<Map<String, dynamic>> selectedItems = [];
List<String> cat_list = ['- - Choose-Category - -'];
List<int> catid_list = [];
List chatList = [];

var selectedValue = 'CSE';
var selectedcategory = '- - Choose-Category - -';
var cat_id;

var box = GetStorage();
// ignore: non_constant_identifier_names
bool Loginsucess = false;
bool versioncheck = true;
// ignore: non_constant_identifier_names
var version = '1.0';

DateTime selectedDate = DateTime.now();
TimeOfDay selectedTime = TimeOfDay.now();

String initial_Date = DateFormat('dd-MM-yyyy').format(DateTime.now());
String formattedDate = DateFormat('dd-MM-yyyy').format(DateTime.now());

String initial_Time = DateFormat('h:mm a')
    .format(DateTime(2022, 03, 01, TimeOfDay.now().hour, TimeOfDay.now().minute));
String formattedTime = DateFormat('h:mm a')
    .format(DateTime(2022, 03, 01, TimeOfDay.now().hour, TimeOfDay.now().minute));
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

const kMessageContainerDecoration = BoxDecoration();
