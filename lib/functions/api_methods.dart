// ignore_for_file: non_constant_identifier_names

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/functions/variabels.dart';

Future send_dep(var dep) async {
  try {
    var result = await http.post(
      Uri.parse('http://103.207.1.94:8080/getstaff_details'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'department': dep}),
    );
    if (result.statusCode == 200) {
      userList = json.decode(result.body);
    } else {
      print(result.body);
    }
    print(userList);
  } catch (ex) {
    print(ex.toString());
  }
}

Future InsertPercntage(var Id) async {
  try {
    var result = await http.post(
      Uri.parse('http://$ip:$port/percentage/insertpercentage'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'Id': Id,
        'percentage': '0',
      }),
    );
    if (result.statusCode == 200) {
    } else {}
  } catch (ex) {
    if (kDebugMode) {
      print(ex.toString());
    }
  }
}

Future get_category() async {
  try {
    var result = await http.get(
      Uri.parse('http://103.207.1.94:8080/getcategory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    if (result.statusCode == 200) {
      categoryList = json.decode(result.body);
      cat_list = ["- - Choose-Category - -"];
      for (var i = 0; i < categoryList.length; i++) {
        cat_list.add(categoryList[i]['category_text']);
        catid_list.add(categoryList[i]['category_id']);
      }
      print(cat_list);
      print(catid_list);
    } else {
      print(result.body);
    }
  } catch (ex) {
    print(ex.toString());
  }
}

Future<dynamic> send_cat(dynamic text) async {
  try {
    var result = await http.post(
      Uri.parse('http://103.207.1.94:8080/addcategory'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({'cat_text': text}),
    );
    if (result.statusCode == 200) {
      if (result.body == "Already Exist") {
        return result.body.toString();
      }
    } else {
      print(result.body);
    }
  } catch (ex) {
    print(ex.toString());
  }
}

Future send_task(var assignId, taskTitle, assignBy, assignTo, dDate, dTime,
    desc, catId) async {
  try {
    var result = await http.post(
      Uri.parse('http://103.207.1.94:8080/addtask'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'assign_id': assignId,
        'task_title': taskTitle,
        'assign_by': assignBy,
        'assign_to': assignTo,
        'd_date': dDate,
        'd_time': dTime,
        'desc': desc,
        'cat_id': catId
      }),
    );
    if (result.statusCode == 200) {
      FileOperationdart.sendnotification(assignTo, taskTitle, desc, taskTitle);
    } else {
      if (kDebugMode) {
        print(result.body);
      }
    }
  } catch (ex) {
    if (kDebugMode) {
      print(ex.toString());
    }
  }
}

Future send_attachment(var assignId, filename, uploadedby) async {
  try {
    var result = await http.post(
      Uri.parse('http://103.207.1.94:8080/addattachment'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode({
        'assignid': assignId,
        'filename': filename,
        'uploadby': uploadedby,
      }),
    );
    if (result.statusCode == 200) {
      if (kDebugMode) {
        print(result.body);
      }
    } else {
      if (kDebugMode) {
        print(result.body);
      }
    }
  } catch (ex) {
    if (kDebugMode) {
      print(ex.toString());
    }
  }
}
