// ignore_for_file: unused_field, non_constant_identifier_names, prefer_typing_uninitialized_variables
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';

import '../utils/Status.dart';

class TaskStatus extends StatefulWidget {
  const TaskStatus({super.key});

  @override
  State<TaskStatus> createState() => _TaskStatusState();
}

class _TaskStatusState extends State<TaskStatus> {
  int _currentIndex = 0;
  bool search = false;
  bool valuechek = true;
  bool valuechekDonelate = true;
  bool valuechekCompleted = true;
  bool parsedlistnotask = true;
  bool Donelatenotask = true;
  bool Completednotask = true;
  List<dynamic> AssignId = [];
  List<dynamic> profile = [];
  List<dynamic> parsedList = [[]];
  List<dynamic> DonelateList = [];
  List<dynamic> DonelateAssignId = [];
  List<dynamic> Donelateprofile = [];
  List<dynamic> completedList = [];
  List<dynamic> completedAssignId = [];
  List<dynamic> Completedprofile = [];
  var val;
  late Timer _timer;

  final StreamController _streamController = StreamController();
  final StreamController _DonelateController = StreamController();
  final StreamController _CompletedController = StreamController();

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

  Future<void> Donelatedata() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/mainpage/taskdetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'empid': box.read("employee").toString(),
            'status': "Done late",
          },
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            DonelateList = json.decode(response.body);
            _DonelateController.add(DonelateList);
            if (DonelateList.isEmpty) {
              Donelatenotask = false;
            }
          });
        }
      }
      DonelateAssignId = [];
      for (var element in DonelateList) {
        DonelateAssignId.add(element["Assigned_Id"]);
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Donelateteammember() async {
    try {
      http.Response res = await http.post(
        Uri.parse('http://$ip:$port/mainpage/teammember'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, List>{
            "user": DonelateAssignId,
          },
        ),
      );
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            Donelateprofile = json.decode(res.body);
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

  valuecheckinfodonelate() {
    if (mounted) {
      if (DonelateList.isEmpty) {
        setState(() {
          valuechekDonelate = false;
        });
      } else {
        setState(() {
          valuechekDonelate = true;
        });
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
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => getdata(),
    );
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => getteammember());
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => Donelatedata());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => Donelateteammember());
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => completeddata());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => Completedteammember());
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => valuecheckinfo());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => valuecheckinfodonelate());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => valuecheckinfocompleted());

    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer.isActive) _timer.cancel();
    _streamController.close();
    _CompletedController.close();
    _DonelateController.close();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text("My all task list",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: blackclr)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 35,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                onPressed: () => {
                  setState(() {
                    search = !search;
                  })
                },
                icon: const Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.black,
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Visibility(
                visible: search,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 30,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 15, left: 15),
                          child: TextField(
                            cursorColor: blackclr,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {},
                                // ignore: prefer_const_constructors
                                child: Icon(
                                  Icons.search_sharp,
                                  size: 20,
                                  color: blackclr,
                                ),
                              ),
                              hintText: 'Searched task',
                              hintStyle: GoogleFonts.poppins(fontSize: 12),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: blackclr, width: 32.0),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: blackclr,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              // do something
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                labelColor: MainTextColor,
                unselectedLabelColor: blackclr,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                indicatorColor: MainTextColor,
                tabs: const [
                  Tab(
                    text: "Pending Task",
                    icon: Icon(Icons.run_circle, color: Colors.black),
                  ),
                  Tab(
                    text: "Done Late",
                    icon: Icon(Icons.pending_actions_rounded,
                        color: Colors.black),
                  ),
                  Tab(
                    text: "Completed",
                    icon: Icon(Icons.done, color: Colors.black),
                  ),
                ],
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    children: [
                      SingleChildScrollView(
                        child: StreamBuilder(
                            stream: _streamController.stream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          itemCount:
                                              valuechek ? parsedList.length : 0,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data = parsedList[index];
                                            return StatusContainer(
                                              tittle: parsedList[index]
                                                      ["Task_Tittle"]
                                                  .toString()
                                                  .trim(),
                                              deadlinedate: parsedList[index]
                                                      ["Deadline_date"]
                                                  .toString()
                                                  .trim(),
                                              deadlinetime: parsedList[index]
                                                      ["Deadline_time"]
                                                  .toString()
                                                  .trim(),
                                              indexs: index,
                                              profile: profile.toList(),
                                              percentage: parsedList[index]
                                                      ["percentage"]
                                                  .toString()
                                                  .trim(),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      ),
                      SingleChildScrollView(
                        child: StreamBuilder(
                            stream: _DonelateController.stream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularProgressIndicator(
                                          color: MainTextColor,
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              }
                              return Donelatenotask
                                  ? Column(
                                      children: [
                                        ListView.builder(
                                          itemCount: valuechekDonelate
                                              ? DonelateList.length
                                              : 0,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data = DonelateList[index];
                                            return StatusContainer(
                                              tittle: DonelateList[index]
                                                      ["Task_Tittle"]
                                                  .toString()
                                                  .trim(),
                                              deadlinedate: DonelateList[index]
                                                      ["Deadline_date"]
                                                  .toString()
                                                  .trim(),
                                              deadlinetime: DonelateList[index]
                                                      ["Deadline_time"]
                                                  .toString()
                                                  .trim(),
                                              indexs: index,
                                              profile: Donelateprofile.toList(),
                                              percentage: DonelateList[index]
                                                      ["percentage"]
                                                  .toString()
                                                  .trim(),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      ),
                      SingleChildScrollView(
                        child: StreamBuilder(
                            stream: _CompletedController.stream,
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Center(
                                  child: SizedBox(
                                    height: MediaQuery.of(context).size.height,
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                                          itemCount: valuechekCompleted
                                              ? completedList.length
                                              : 0,
                                          shrinkWrap: true,
                                          physics: const ScrollPhysics(),
                                          itemBuilder: (context, index) {
                                            var data = completedList[index];
                                            return StatusContainer(
                                              tittle: completedList[index]
                                                      ["Task_Tittle"]
                                                  .toString()
                                                  .trim(),
                                              deadlinedate: completedList[index]
                                                      ["Deadline_date"]
                                                  .toString()
                                                  .trim(),
                                              deadlinetime: completedList[index]
                                                      ["Deadline_time"]
                                                  .toString()
                                                  .trim(),
                                              indexs: index,
                                              profile:
                                                  Completedprofile.toList(),
                                              percentage: completedList[index]
                                                      ["percentage"]
                                                  .toString()
                                                  .trim(),
                                            );
                                          },
                                        ),
                                      ],
                                    )
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
