// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/utils/Status.dart';

class PendingTask extends StatefulWidget {
  const PendingTask({super.key});

  @override
  State<PendingTask> createState() => _PendingTaskState();
}

class _PendingTaskState extends State<PendingTask> {
  final StreamController _streamController = StreamController();
  List<dynamic> parsedList = [[]];
  bool parsedlistnotask = true;
  bool valuechek = true;
  List<dynamic> profile = [];
  List<dynamic> AssignId = [];
  late Timer _timer;
  Future<void> getdata() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/mainpage/taskdetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'empid': box.read("employee").toString(),
            'status': "Pending",
          },
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            parsedList = json.decode(response.body);
            _streamController.add(parsedList);
            if (parsedList.isEmpty) {
              parsedlistnotask = false;
            }
          });
        }
      }
      AssignId = [];
      for (var element in parsedList) {
        AssignId.add(element["Assigned_Id"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  valuecheckinfo() {
    if (mounted) {
      if (parsedList.isEmpty) {
        setState(() {
          valuechek = false;
        });
      } else {
        setState(() {
          valuechek = true;
        });
      }
    }
  }

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => getdata(),
    );
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => valuecheckinfo());
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => getteammember());
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    if (_timer.isActive) _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  getteammember() async {
    try {
      http.Response res = await http.post(
        Uri.parse('http://$ip:$port/mainpage/teammember'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, List>{
            "user": AssignId,
          },
        ),
      );
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            profile = json.decode(res.body);
          });
        }
      } else {
        if (kDebugMode) {
          print('A unknown error occured. code:${res.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(
                        color: MainTextColor,
                      )
                    ],
                  ),
                ),
              );
            }
            return parsedlistnotask
                ? Column(
                    children: [
                      ListView.builder(
                        itemCount: valuechek ? parsedList.length : 0,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data = parsedList[index];
                          if (kDebugMode) {
                            print(data);
                          }
                          return StatusContainer(
                            tittle: parsedList[index]["Task_Tittle"]
                                .toString()
                                .trim(),
                            deadlinedate: parsedList[index]["Deadline_date"]
                                .toString()
                                .trim(),
                            deadlinetime: parsedList[index]["Deadline_time"]
                                .toString()
                                .trim(),
                            indexs: index,
                            profile: profile.toList(),
                            percentage: parsedList[index]["percentage"]
                                .toString()
                                .trim(),
                          );
                        },
                      ),
                    ],
                  )
                : Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Text(
                          "No Task",
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: blackclr),
                        ),
                      )
                    ],
                  );
          }),
    );
  }
}
