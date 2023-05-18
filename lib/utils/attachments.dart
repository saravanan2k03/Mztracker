import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import '../api/FileOperation.dart';

class Attachmentdata extends StatefulWidget {
  final String Id;
  const Attachmentdata({super.key, required this.Id});

  @override
  State<Attachmentdata> createState() => _AttachmentdataState();
}

class _AttachmentdataState extends State<Attachmentdata> {
  List<dynamic> data = [];
  late Timer _timer;
  bool noatc = false;
  final StreamController _streamController = StreamController();
  getdata() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/attach/Attachment'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'Id': widget.Id,
          },
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(
            () {
              data = jsonDecode(response.body);
              _streamController.add(data);
              if (data.isEmpty) {
                noatc = true;
              } else {
                noatc = false;
              }
            },
          );
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 15),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.86,
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        child: Row(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: StreamBuilder(
                    stream: _streamController.stream,
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CircularProgressIndicator(
                                color: MainTextColor,
                              ),
                            ],
                          ),
                        );
                      }
                      return noatc
                          ? Center(
                              child: Column(
                                children: [
                                  Text(
                                    "No Attachment",
                                    style: GoogleFonts.poppins(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: blackclr),
                                  ),
                                ],
                              ),
                            )
                          : SizedBox(
                              height: 65,
                              child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const ScrollPhysics(),
                                  scrollDirection: Axis.horizontal,
                                  itemCount: data.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(right: 15),
                                      child: InkWell(
                                        onTap: () {
                                          FileOperationdart.Fileopener(
                                              context,
                                              data[index]["Filename"]
                                                  .toString()
                                                  .trim());
                                        },
                                        child: Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.10,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.86,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 05),
                                                child: SizedBox(
                                                  height: MediaQuery.of(context)
                                                          .size
                                                          .height *
                                                      0.07,
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.20,
                                                  child: const FittedBox(
                                                    child: Icon(
                                                      Icons
                                                          .description_outlined,
                                                      color: Color.fromARGB(
                                                          255, 255, 42, 42),
                                                      size: 30,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SingleChildScrollView(
                                                child: SizedBox(
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.40,
                                                  child: Text(
                                                    data[index]["Filename"]
                                                        .toString()
                                                        .trim(),
                                                    overflow: TextOverflow.clip,
                                                    style: GoogleFonts.poppins(
                                                        fontSize: 13,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: blackclr),
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  if (kDebugMode) {
                                                    print(data[index]
                                                            ["Filename"]
                                                        .toString()
                                                        .trim());
                                                  }
                                                  var uri = data[index]
                                                          ["Filename"]
                                                      .toString()
                                                      .trim();
                                                  FileOperationdart
                                                      .downloadFile(context,
                                                          uri, widget.Id);
                                                },
                                                icon: Icon(
                                                  Icons.download,
                                                  color: MainTextColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }),
                            );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
