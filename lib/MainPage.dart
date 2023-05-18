// ignore_for_file: prefer_const_constructors, use_build_context_synchronously, non_constant_identifier_names
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/views/LoginPage.dart';
import 'package:http/http.dart' as http;
import 'api/google_signin_api.dart';
import 'utils/Taskcontainer.dart';
import 'utils/category.dart';
import 'views/TaskStatus.dart';

class MainPage extends StatefulWidget {
  final String userdata;
  const MainPage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> DetailLength = [[]];
  final StreamController _streamController = StreamController();
  late Timer _timer;

  bool loading = true;
  getdata() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://103.207.1.94:8080/mainpage/taskdetails'),
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
            // if (kDebugMode) {
            //   print(box.read("employee").toString());
            // }
            DetailLength = json.decode(response.body);
            DetailLength.length;
            _streamController.add(DetailLength);
            // if (kDebugMode) {
            //   print(DetailLength);
            // }
          });
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
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => getdata());

    super.initState();
  }

  @override
  void dispose() {
    if (_timer.isActive) _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Appbackgroundcolor,
        appBar: AppBar(
          title: Text(
            "Hi ${widget.userdata}",
            style: GoogleFonts.poppins(fontSize: 20, color: MainTextColor),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => TaskStatus()),
                  );
                },
                child: CircleAvatar(
                  backgroundImage: NetworkImage(
                    box.read("profile"),
                  ),
                  backgroundColor: Color.fromARGB(255, 80, 126, 255),
                  radius: 17,
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Scaffold(
                  body: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: CircularProgressIndicator(
                          color: MainTextColor,
                        ),
                      )
                    ],
                  ),
                );
              }
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 05),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 15.0, bottom: 10),
                            child: Text(
                              "${DetailLength.length}${" "}task pending",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  color:
                                      const Color.fromARGB(255, 255, 95, 83)),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
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
                                      child: Icon(
                                        Icons.search_sharp,
                                        size: 20,
                                        color: blackclr,
                                      ),
                                    ),
                                    hintText: 'Searched task',
                                    hintStyle:
                                        GoogleFonts.poppins(fontSize: 12),
                                    contentPadding: const EdgeInsets.all(15),
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: blackclr, width: 32.0),
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
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          children: const [
                            Text(
                              "Categories",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.height * 0.80,
                        child: Caty(),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Ongoing Task",
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(right: 20),
                              child: Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: MainTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.03,
                      ),
                      InkWell(
                        onTap: () {},
                        child: TaskContainer(),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }

  Future signout() async {
    await GoogleSignInApi.logout();

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
