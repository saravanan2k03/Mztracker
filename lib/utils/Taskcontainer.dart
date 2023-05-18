import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:mztrackertodo/functions/variabels.dart';
import '../views/TaskDetailed.dart';

class TaskContainer extends StatefulWidget {
  const TaskContainer({super.key});

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  final StreamController _streamController = StreamController();
  late Timer _timer;

  var dates;
  var profileuri;
  bool clr = true;
  // ignore: non_constant_identifier_names
  List<dynamic> AssignId = [];
  List<dynamic> profile = [];
  List<dynamic> parsedList = [];
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
          });
        }
      }
      AssignId = [];
      for (var element in parsedList) {
        AssignId.add(element["Assigned_Id"]);
      }
      if (kDebugMode) {
        // print(parsedList);
        // print("category:${parsedcategory.length}");
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
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

  ///check date

  check(String data) {
    var assigndate = data;
    var year = assigndate[6] + assigndate[7] + assigndate[8] + assigndate[9];
    var month = assigndate[3] + assigndate[4];
    var senddate = assigndate[0] + assigndate[1];
    int daysBetween(DateTime from, DateTime to) {
      from = DateTime(from.year, from.month, from.day);
      to = DateTime(to.year, to.month, to.day);
      return (to.difference(from).inHours / 24).round();
    }

    final mydate =
        DateTime(int.parse(year), int.parse(month), int.parse(senddate));
    final date2 = DateTime.now();
    final difference = daysBetween(date2, mydate);
    var summa = "d";
    String values = difference.toString();
    dates = values + summa;
    if (values.contains("-")) {
      dates = "0d";
    }

    if (dates == "0d") {
      clr = false;
    } else {
      clr = true;
    }
  }

  bool valuechek = true;
  valuecheckinfo() {
    if (mounted) {
      if (profile.isEmpty) {
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
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => getdata());

    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => getteammember());
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => valuecheckinfo());
    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer.isActive) _timer.cancel();
    if (_timer.isActive) _timer.cancel();
    if (_timer.isActive) _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Column(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 50),
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ],
              ),
            ],
          );
        }
        return ListView.builder(
          itemCount: parsedList.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            var data = parsedList[index];
            check(data["Deadline_date"].toString().trim());
            return InkWell(
              onTap: () {
                if (kDebugMode) {
                  print(index);
                }

                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => TaskDetailed(
                      Id: parsedList[index]["Assigned_Id"].toString().trim(),
                      sendTittle:
                          parsedList[index]["Task_Tittle"].toString().trim(),
                      Description:
                          parsedList[index]["description"].toString().trim(),
                      Deadlinedate:
                          parsedList[index]["Deadline_date"].toString().trim(),
                      Deadlinetime:
                          parsedList[index]["Deadline_time"].toString().trim(),
                      category:
                          parsedList[index]["Category_text"].toString().trim(),
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: MediaQuery.of(context).size.height * .28,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Color.fromARGB(255, 194, 203, 207)
                                .withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                data["Task_Tittle"].toString().trim(),
                                style: GoogleFonts.poppins(
                                  color: blackclr,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.all(10),
                                // ignore: prefer_const_constructors
                                decoration: BoxDecoration(
                                    color: clr ? MainTextColor : Colors.blue,
                                    // ignore: prefer_const_constructors
                                    borderRadius: BorderRadius.all(
                                        // ignore: prefer_const_constructors
                                        Radius.elliptical(100, 50))),
                                child: Text(
                                  "$dates",
                                  style: GoogleFonts.poppins(
                                      color: Colors.white,
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500),
                                ),
                              )
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 7),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Team members",
                                    style: GoogleFonts.poppins(
                                        color: blackclr,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500),
                                  )
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Center(
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: SingleChildScrollView(
                                    child: SizedBox(
                                      height: 50,
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        physics: const ScrollPhysics(),
                                        scrollDirection: Axis.horizontal,
                                        itemCount: valuechek
                                            ? profile[index].length
                                            : 0,
                                        itemBuilder: (context, indexs) {
                                          profileuri =
                                              profile[index][indexs]["profile"];
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(left: 05),
                                            child: SizedBox(
                                              width: 40,
                                              height: 40,
                                              child: CircleAvatar(
                                                backgroundImage:
                                                    NetworkImage(profileuri),
                                                radius: 100,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                )
                                // //CircleAvatar
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 20),
                            child: Center(
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // ignore: prefer_const_constructors
                                  Icon(Icons.calendar_month,
                                      size: 22, color: const Color(0xffFF7360)),
                                  Container(
                                    padding:
                                        const EdgeInsets.only(left: 5, top: 02),
                                    child: Text(
                                      data["Deadline_date"].toString().trim(),
                                      style: GoogleFonts.poppins(
                                          color: blackclr,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.25,
                                  ),
                                  // ignore: prefer_const_constructors
                                  Icon(Icons.timer,
                                      size: 22, color: const Color(0xffFF7360)),
                                  Container(
                                    padding: const EdgeInsets.only(top: 02),
                                    child: Text(
                                      data["Deadline_time"].toString().trim(),
                                      style: GoogleFonts.poppins(
                                          color: blackclr,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
