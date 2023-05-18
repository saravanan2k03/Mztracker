// ignore_for_file: unused_local_variable
import 'dart:convert';
import 'dart:async';
import 'dart:core';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:http/http.dart' as http;

class TaskTitle extends StatefulWidget {
  final String sendTittle;
  final int val;
  final String statuslen;
  final String category;
  final String Id;
  const TaskTitle(
      {super.key,
      required this.sendTittle,
      required this.val,
      required this.statuslen,
      required this.category,
      required this.Id});

  @override
  State<TaskTitle> createState() => _TaskTitleState();
}

class _TaskTitleState extends State<TaskTitle> {
  var saro = 0.0;
  var percentagetext = "0%";
  late Timer _timer;
  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => MathFunc());

    super.initState();
  }

  sendpercentage(double percentage) async {
    if (kDebugMode) {
      print("percentage${percentage.toString()}");
    }
    try {
      http.Response res = await http.post(
        Uri.parse('http://$ip:$port/percentage/percentage'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            "Id": widget.Id,
            "percentage": percentage.toString(),
          },
        ),
      );
      if (res.statusCode == 200) {
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

  // ignore: non_constant_identifier_names
  MathFunc() {
    int ele = 0;
    var value = 100 / widget.val;
    var dec = value / 100;

    if (mounted) {
      setState(
        () {
          ele = int.parse(widget.statuslen);
          saro = dec * int.parse(widget.statuslen);
          sendpercentage(saro);
          if (saro == 1.0) {
            percentagetext = "${100}%";
          } else if (saro == 0) {
            percentagetext = "${0}%";
          } else if (saro == 0.1) {
            percentagetext = "${10}%";
          } else if (saro == 0.2) {
            percentagetext = "${20}%";
          } else if (saro == 0.3) {
            percentagetext = "${30}%";
          } else if (saro == 0.4) {
            percentagetext = "${40}%";
          } else if (saro == 0.5) {
            percentagetext = "${50}%";
          } else if (saro == 0.6) {
            percentagetext = "${60}%";
          } else if (saro == 0.7) {
            percentagetext = "${70}%";
          } else if (saro == 0.8) {
            percentagetext = "${80}%";
          } else if (saro == 0.9) {
            percentagetext = "${90}%";
          } else {
            percentagetext =
                "${saro.toString().split('.')[1].toString().substring(0, 2)}%";
          }
        },
      );
    }
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: SizedBox(
            // color: Colors.red,
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Text(
                      widget.sendTittle,
                      style: GoogleFonts.poppins(
                          color: blackclr,
                          fontSize: 20,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  Text(
                    "For ${widget.category}",
                    style: GoogleFonts.poppins(
                        color: MainTextColor,
                        fontSize: 14,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 05, top: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.40,
            // color: Color.fromARGB(255, 255, 255, 255),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  CircularPercentIndicator(
                    radius: 50,
                    lineWidth: 10,
                    percent: saro,
                    progressColor: MainTextColor,
                    circularStrokeCap: CircularStrokeCap.round,
                    center: Text(
                      percentagetext,
                      style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: blackclr,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
      ],
    );
  }
}
