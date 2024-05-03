import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/utils/Status.dart';

class CompletedPage extends StatefulWidget {
  const CompletedPage({super.key});

  @override
  State<CompletedPage> createState() => _CompletedPageState();
}

class _CompletedPageState extends State<CompletedPage> {
  bool valuechekCompleted = true;
  bool Completednotask = true;
  List<dynamic> completedList = [];
  List<dynamic> completedAssignId = [];
  List<dynamic> Completedprofile = [];
  late Timer _timer;
  final StreamController _CompletedController = StreamController();
  Future<void> completeddata() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/mainpage/taskdetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'empid': box.read("employee").toString(),
            'status': "Completed",
          },
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            completedList = json.decode(response.body);
            _CompletedController.add(completedList);
            if (kDebugMode) {
              print("enter");
            }

            print(completedList);
            if (completedList.isEmpty) {
              Completednotask = false;
            }
          });
        }
      }
      completedAssignId = [];
      for (var element in completedList) {
        completedAssignId.add(element["Assigned_Id"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Completedteammember() async {
    try {
      http.Response res = await http.post(
        Uri.parse('http://$ip:$port/mainpage/teammember'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, List>{
            "user": completedAssignId,
          },
        ),
      );
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            Completedprofile = json.decode(res.body);
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

  valuecheckinfocompleted() {
    if (mounted) {
      if (completedList.isEmpty) {
        setState(() {
          valuechekCompleted = false;
        });
      } else {
        setState(() {
          valuechekCompleted = true;
        });
      }
    }
  }

  @override
  void initState() {
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => completeddata());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => Completedteammember());

    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => valuecheckinfocompleted());

    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _CompletedController.close();
    if (_timer.isActive) _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _CompletedController.stream,
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
            return Completednotask
                ? Column(
                    children: [
                      ListView.builder(
                        itemCount:
                            valuechekCompleted ? completedList.length : 0,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data = completedList[index];
                          if (kDebugMode) {
                            print("CompletedTask:" + data);
                          }
                          return StatusContainer(
                            tittle: completedList[index]["Task_Tittle"]
                                .toString()
                                .trim(),
                            deadlinedate: completedList[index]["Deadline_date"]
                                .toString()
                                .trim(),
                            deadlinetime: completedList[index]["Deadline_time"]
                                .toString()
                                .trim(),
                            indexs: index,
                            profile: Completedprofile.toList(),
                            percentage: completedList[index]["percentage"]
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
