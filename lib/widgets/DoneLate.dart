// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/utils/Status.dart';

class DoneLate extends StatefulWidget {
  const DoneLate({super.key});

  @override
  State<DoneLate> createState() => _DoneLateState();
}

class _DoneLateState extends State<DoneLate> {
  final StreamController _DonelateController = StreamController();
  bool Donelatenotask = true;
  List<dynamic> DonelateList = [];
  List<dynamic> Donelateprofile = [];
  bool valuechekDonelate = true;
  List<dynamic> DonelateAssignId = [];
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

  late Timer _timer;
  @override
  void initState() {
    // TODO: implement initState
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => Donelatedata());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => Donelateteammember());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => valuecheckinfodonelate());
    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    _DonelateController.close();
    super.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: StreamBuilder(
          stream: _DonelateController.stream,
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
            return Donelatenotask
                ? Column(
                    children: [
                      ListView.builder(
                        itemCount: valuechekDonelate ? DonelateList.length : 0,
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemBuilder: (context, index) {
                          var data = DonelateList[index];
                          if (kDebugMode) {
                            print(data);
                          }
                          return StatusContainer(
                            tittle: DonelateList[index]["Task_Tittle"]
                                .toString()
                                .trim(),
                            deadlinedate: DonelateList[index]["Deadline_date"]
                                .toString()
                                .trim(),
                            deadlinetime: DonelateList[index]["Deadline_time"]
                                .toString()
                                .trim(),
                            indexs: index,
                            profile: Donelateprofile.toList(),
                            percentage: DonelateList[index]["percentage"]
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
