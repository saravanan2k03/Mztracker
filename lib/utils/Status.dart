// ignore: file_names
// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';

import 'package:percent_indicator/circular_percent_indicator.dart';

class StatusContainer extends StatefulWidget {
  final String tittle;
  final String deadlinedate;
  final String deadlinetime;
  final int indexs;
  final List<dynamic> profile;
  final String percentage;
  const StatusContainer(
      {super.key,
      required this.tittle,
      required this.deadlinedate,
      required this.deadlinetime,
      required this.indexs,
      required this.profile,
      required this.percentage});

  @override
  State<StatusContainer> createState() => _StatusContainer();
}

class _StatusContainer extends State<StatusContainer> {
  var dates;
  late Timer _timer;
  var saro = 0.0;
  var percentagetext = "0%";
  

  @override
  void initState() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) => check(widget.deadlinedate),
    );
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => valuecheckinfo());
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => Mathfunc());

    super.initState();
  }

  Mathfunc() {
    if (mounted) {
      setState(
        () {
          saro = double.parse(widget.percentage.toString().trim());
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

  bool valuechek = true;
  valuecheckinfo() {
    if (mounted) {
      if (widget.profile.isEmpty) {
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
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double deviceHeight(BuildContext context) =>
        MediaQuery.of(context).size.height;
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(boxShadow: [
              BoxShadow(
                color: const Color.fromARGB(61, 23, 24, 25).withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
              //you can set more BoxShadow() here
            ], color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.tittle,
                        style: GoogleFonts.poppins(
                          color: blackclr,
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 255, 73, 60),
                            borderRadius:
                                BorderRadius.all(Radius.elliptical(100, 50))),
                        child: Text(
                          dates ?? "0d",
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
                                color: Colors.black,
                                fontSize: 14,
                                fontWeight: FontWeight.w500),
                          )
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: SizedBox(
                      height: 75,
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
                                        ? widget.profile[widget.indexs].length
                                        : 0,
                                    itemBuilder: (context, index) {
                                      return Padding(
                                        padding:
                                            const EdgeInsets.only(left: 05),
                                        child: SizedBox(
                                          width: 40,
                                          height: 40,
                                          child: CircleAvatar(
                                            backgroundImage: NetworkImage(widget
                                                .profile[widget.indexs][index]
                                                    ["profile"]
                                                .toString()
                                                .trim()),
                                            radius: 100,
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ),
                          )
                          // //CircleAvatar
                        ],
                      ),
                    ),
                  ),
                  screenWidth <= 392
                      ? Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.only(top: 05),
                              child: CircularPercentIndicator(
                                radius: 50,
                                lineWidth: 5,
                                percent: saro,
                                progressColor:
                                    const Color.fromARGB(255, 255, 73, 60),
                                backgroundColor:
                                    const Color.fromARGB(255, 186, 189, 198),
                                circularStrokeCap: CircularStrokeCap.round,
                                center: Text(
                                  percentagetext,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      color: blackclr),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(
                                top: deviceHeight(context) / 50,
                                bottom: deviceHeight(context) / 150,
                                left: deviceHeight(context) / 200,
                                right: deviceHeight(context) / 200,
                              ),
                              child: Wrap(
                                  crossAxisAlignment: WrapCrossAlignment.center,
                                  children: [
                                    const Icon(Icons.alarm,
                                        size: 22, color: Color(0xffFF7360)),
                                    Container(
                                      padding: const EdgeInsets.only(left: 5),
                                      child: Text(
                                        "${widget.deadlinedate}${"  "} ${widget.deadlinetime}",
                                        style: GoogleFonts.poppins(
                                            color: blackclr,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                  ]),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Wrap(
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  const Icon(Icons.alarm,
                                      size: 22, color: Color(0xffFF7360)),
                                  Container(
                                    padding: const EdgeInsets.only(left: 5),
                                    child: Text(
                                      widget.deadlinetime,
                                      style: GoogleFonts.poppins(
                                          color: blackclr,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ),
                                ]),
                            Container(
                              padding: const EdgeInsets.only(top: 15),
                              child: CircularPercentIndicator(
                                radius: 40,
                                lineWidth: 4,
                                percent: saro,
                                progressColor: const Color(0xffB1D199),
                                backgroundColor:
                                    const Color.fromARGB(255, 186, 189, 198),
                                circularStrokeCap: CircularStrokeCap.round,
                                center: Text(
                                  percentagetext,
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w800,
                                      color: blackclr),
                                ),
                              ),
                            ),
                          ],
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
