import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/views/Profile.dart';

import 'package:http/http.dart' as http;

class Caty extends StatefulWidget {
  const Caty({super.key});

  @override
  State<Caty> createState() => _CatyState();
}

class _CatyState extends State<Caty> {
  // ignore: unused_field
  final StreamController _streamControllerr = StreamController();
  late Timer _timer;
  List<dynamic> category = [];
  // ignore: non_constant_identifier_names
  Getcategory() async {
    try {
      http.Response res = await http.post(
        Uri.parse('http://$ip:$port/mainpage/getcategories'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (res.statusCode == 200) {
        if (mounted) {
          setState(() {
            category = json.decode(res.body);
            _streamControllerr.add(category);
            if (kDebugMode) {
              // print("ProfileUrl:$profile");
              print(category.length);
            }
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
  void initState() {
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => Getcategory());
    super.initState();
  }

  @override
  void dispose() {
    //cancel the timer
    if (_timer.isActive) _timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamControllerr.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          // ignore: prefer_const_constructors
          Center(
            child: const CircularProgressIndicator(
              color: Colors.red,
            ),
          );
        }

        return SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: category.length,
            itemBuilder: (context, index) {
              // print(cat);
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 03),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                              builder: (context) => const ProfilePage()),
                        );
                      },
                      child: Container(
                        height: MediaQuery.of(context).size.height * .24,
                        width: MediaQuery.of(context).size.width * .44,
                        // ignore: prefer_const_constructors
                        decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 255, 255, 255),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color.fromARGB(255, 194, 203, 207)
                                  .withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 12,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  SingleChildScrollView(
                                    child: Text(
                                      category[index]["category_text"]
                                          .toString()
                                          .trim(),
                                      textAlign: TextAlign.start,
                                      style: GoogleFonts.poppins(
                                          // ignore: prefer_const_constructors
                                          color: blackclr,
                                          fontSize: 15,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10),
                                  child: Text(
                                    "10 Task",
                                    style: GoogleFonts.poppins(
                                        color: blackclr,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w500),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 44.06),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ClipRRect(
                                    // ignore: prefer_const_constructors
                                    borderRadius: BorderRadius.only(
                                      bottomRight: const Radius.circular(15),
                                      topLeft: const Radius.circular(15),
                                    ),
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.10,
                                      width: MediaQuery.of(context).size.width *
                                          0.20,
                                      decoration: const BoxDecoration(
                                        color: Colors.transparent,
                                      ),
                                      child: Image.network(
                                        "https://img.freepik.com/free-vector/personal-files-concept-illustration_114360-4013.jpg?w=740&t=st=1667372239~exp=1667372839~hmac=e001d5549d036a6b558af29ae88d8ef4a07ef329212ff61f0b9a7436ee655c58",
                                        fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}
