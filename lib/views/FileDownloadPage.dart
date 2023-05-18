// ignore_for_file: prefer_const_constructors, duplicate_ignore, non_constant_identifier_names, unused_local_variable, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/functions/variabels.dart';

class FileDowloadPage extends StatefulWidget {
  final String Id;
  const FileDowloadPage({super.key, required this.Id, required this.delchek});
  final bool delchek;
  @override
  State<FileDowloadPage> createState() => _FileDowloadPageState();
}

class _FileDowloadPageState extends State<FileDowloadPage> {
  Icon down = Icon(
    Icons.download_for_offline_rounded,
    size: 30,
    color: MainTextColor,
  );
  List<dynamic> data = [];
  late Timer _timer;
  bool noatc = false;
  final StreamController _streamController = StreamController();
  bool checking = true;
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
          setState(() {
            data = jsonDecode(response.body);
            _streamController.add(data);
            if (data.isEmpty) {
              noatc = true;
            }
            if (kDebugMode) {
              // print("Data:$data");
            }
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  FileDelateData(String Name, String Id) async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/attach/Attachmentdelete'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'Id': Id,
            'Name': Name,
          },
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          EasyLoading.instance
            ..loadingStyle = EasyLoadingStyle.custom
            ..backgroundColor = Colors.white
            ..textColor = Colors.black
            ..indicatorColor = MainTextColor
            ..maskColor = Colors.white
            ..dismissOnTap = false;

          EasyLoading.showSuccess('File Deleted!');
        }
        FileOperationdart.Filedeleting(Id, Name);
      }
    } catch (e) {
      EasyLoading.dismiss();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Appbackgroundcolor,
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.only(left: 08),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(right: 25),
                child: Text(
                  "File Download",
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: blackclr,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
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
            Padding(
              padding: EdgeInsets.all(8.0),
              child: CircleAvatar(
                backgroundImage: NetworkImage(box.read("profile")),
                backgroundColor: Color.fromARGB(255, 80, 126, 255),
                radius: 17,
              ),
            )
          ],
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.03,
            ),
            StreamBuilder(
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
                    : Expanded(
                        child: GridView.builder(
                          itemCount: data.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          itemBuilder: (context, index) {
                            return Center(
                              child: InkWell(
                                onLongPress: () {
                                  if (widget.delchek == true) {
                                    FileDelateData(
                                      data[index]["Filename"].toString().trim(),
                                      widget.Id,
                                    );
                                  } else {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.vertical(
                                            top: Radius.circular(10.0),
                                          ),
                                        ),
                                        content: Text(
                                            'You Not Alow To  Delete The Documents!'),
                                      ),
                                    );
                                  }
                                },
                                onTap: () {
                                  FileOperationdart.Fileopener(
                                      context,
                                      data[index]["Filename"]
                                          .toString()
                                          .trim());
                                },
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.40,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Color.fromARGB(61, 23, 24, 25)
                                            .withOpacity(0.3),
                                        spreadRadius: 0,
                                        blurRadius: 10,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Center(
                                        child: Icon(
                                          Icons.description_outlined,
                                          size: 50,
                                          color: MainTextColor,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          data[index]["Filename"]
                                              .toString()
                                              .trim(),
                                          style: GoogleFonts.poppins(
                                            fontSize: 13,
                                            color: blackclr,
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            SizedBox(
                                              height: 30,
                                              child: Center(
                                                child: InkWell(
                                                  onTap: () {
                                                    FileOperationdart
                                                        .downloadFile(
                                                            context,
                                                            data[index]
                                                                    ["Filename"]
                                                                .toString()
                                                                .trim(),
                                                            widget.Id);
                                                  },
                                                  child: Icon(
                                                    Icons
                                                        .download_for_offline_rounded,
                                                    size: 30,
                                                    color: MainTextColor,
                                                  ),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      );
              },
            )
          ],
        ),
      ),
    );
  }
}
