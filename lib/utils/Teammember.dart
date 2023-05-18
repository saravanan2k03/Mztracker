import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';

class TeamMember extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final List<dynamic> Assigns;
  final String Id;
  const TeamMember({
    super.key,
    required this.Assigns,
    required this.Id,
  });

  @override
  State<TeamMember> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
  late Timer _timer;
  List<dynamic> Data = [];
  var profileuri;
  bool isLoading = true;
  final StreamController _streamController = StreamController();

  @override
  void initState() {
    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => getdata());
    super.initState();
  }

  getdata() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/details/teammember/${widget.Id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, List>{
            'user': widget.Assigns,
          },
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            Data = json.decode(response.body);
            Data.removeWhere((list) => list.isEmpty);
            _streamController.add(Data);
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
  void dispose() {
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
          isLoading = false;
        } else {
          isLoading = true;
        }
        return isLoading
            ? ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemCount: Data.length,
                padding: const EdgeInsets.only(right: 16, left: 16),
                itemBuilder: (context, index) {
                  bool checkmark = false;
                  profileuri = Data[index][0]["profile"].toString().trim();
                  var process =
                      Data[index][0]["Individual_status"].toString().trim();
                  if (process == 'Pending') {
                    checkmark = false;
                  }
                  if (process == 'Completed') {
                    checkmark = true;
                  }

                  return Padding(
                    padding: const EdgeInsets.only(right: 15, top: 10),
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.10,
                      width: MediaQuery.of(context).size.width * 0.80,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
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
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 05),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.23,
                              // ignore: prefer_const_constructors
                              child: FittedBox(
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(profileuri ??
                                      "https://www.mrdustbin.com/en/wp-content/uploads/2021/05/dwayne-johnson.jpg"),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: MediaQuery.of(context).size.width * 0.40,
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Text(
                                  Data[index][0]["Employee_name"]
                                      .toString()
                                      .trim(),
                                  style: GoogleFonts.poppins(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: blackclr)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: SizedBox(
                              width: MediaQuery.of(context).size.width * 0.10,
                              child: checkmark
                                  ? const Icon(
                                      Icons.check,
                                      color: Color.fromARGB(255, 255, 42, 42),
                                    )
                                  : const Icon(
                                      Icons.close,
                                      color: Color.fromARGB(255, 255, 42, 42),
                                    ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              )
            : SizedBox(
                height: MediaQuery.of(context).size.height * 0.30,
                width: MediaQuery.of(context).size.width * 0.85,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Center(
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              );
      },
    );
  }
}
