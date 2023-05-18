// ignore_for_file: sort_child_properties_last, duplicate_ignore, non_constant_identifier_names, prefer_typing_uninitialized_variables, file_names, use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:dotted_border/dotted_border.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/views/FileDownloadPage.dart';
import 'package:mztrackertodo/views/Todoist.dart';
import '../utils/Taskdeadline.dart';
import '../utils/TasktittleandIndicator.dart';
import '../utils/Teammember.dart';
import '../utils/attachments.dart';

class TaskDetailed extends StatefulWidget {
  final String Id;
  final String sendTittle;
  final String Description;
  final String Deadlinedate;
  final String Deadlinetime;
  final String category;

  const TaskDetailed(
      {Key? key,
      required this.Id,
      required this.sendTittle,
      required this.Description,
      required this.Deadlinedate,
      required this.Deadlinetime,
      required this.category})
      : super(key: key);

  @override
  State<TaskDetailed> createState() => _TaskDetailedState();
}

class _TaskDetailedState extends State<TaskDetailed> {
  final StreamController _streamController = StreamController();

  var tittle = 'React Js';
  List<dynamic> parsedList = [];
  List<dynamic> Assigns = [];
  List<dynamic> statusdata = [];
  List<dynamic> getstaff = [];
  List<dynamic> selectedItems = [];
  late Timer _timer;
  bool desc = true;
  bool btn = true;
  bool cmpcheck = false;
  var val;
  bool isloading = false;
  var profileuri;
  bool isChecked = false;
  var status;
  var reassignid;
  var dates;
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
      setState(() {
        status = "Done late";
      });
    } else {
      setState(() {
        status = "Completed";
      });
    }
    if (kDebugMode) {
      print(status);
    }
  }

  getassigndata() async {
    parsedList = [];
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/details/taskdetails'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, String>{
            'assignid': widget.Id,
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
      if (parsedList[0][0]["Assigned_by"].toString().trim() ==
          box.read("employee").toString()) {
        setState(() {
          btn = true;
        });
      } else {
        btn = false;
      }
      Assigns.clear();
      for (var i = 0; i < parsedList[0].length; i++) {
        Assigns.add(parsedList[0][i]["Assigned_to"]);

        if (parsedList[0][i]["Assigned_to"].toString().trim() ==
                box.read("employee").toString() &&
            parsedList[0][0]["Assigned_by"].toString().trim() ==
                box.read("employee").toString()) {
          setState(() {
            btn = true;
            cmpcheck = true;
          });
        }
      }
      if (kDebugMode) {
        // print("cmpcheck:$cmpcheck");
      }
      val = Assigns.length;
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  getStatus() async {
    final http.Response response = await http.post(
      Uri.parse('http://$ip:$port/details/StatusDetail'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'assignid': widget.Id,
        },
      ),
    );
    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          statusdata = jsonDecode(response.body);
        });
      }
    }
  }

  reassigntaskdata() async {
    try {
      final http.Response response = await http.post(
        Uri.parse('http://$ip:$port/details/teammember/${widget.Id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(
          <String, List>{
            'user': Assigns,
          },
        ),
      );
      if (response.statusCode == 200) {
        if (mounted) {
          setState(() {
            getstaff = json.decode(response.body);
            getstaff.removeWhere((list) => list.isEmpty);
          });
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  completetask() async {
    final http.Response response = await http.post(
      Uri.parse('http://$ip:$port/details/Taskcompleted'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'assignid': widget.Id,
          'status': status,
        },
      ),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          content: Text('Task Completed'),
        ),
      );
      Navigator.pop(context);
    }
  }

  reassigntask() async {
    if (kDebugMode) {
      print(widget.Id);
    }
    final http.Response response = await http.post(
      Uri.parse('http://$ip:$port/details/Reassignedtask/${widget.Id}'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, List>{
          'user': selectedItems,
        },
      ),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reassigned Task'),
        ),
      );
    }
  }

  Future<void> IndividualComplete() async {
    final http.Response response = await http.post(
      Uri.parse('http://$ip:$port/details/Individualcomplete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'Id': widget.Id,
          'assignto': box.read("employee").toString(),
        },
      ),
    );
    if (response.statusCode == 200) {}

    if (Assigns.length == statusdata[0].length) {
      completetask();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task Not Completed Please Wait 🤗'),
        ),
      );
    }
  }

  IndividualCompleteself() async {
    final http.Response response = await http.post(
      Uri.parse('http://$ip:$port/details/Individualcomplete'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(
        <String, String>{
          'Id': widget.Id,
          'assignto': box.read("employee").toString(),
        },
      ),
    );
    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(10.0),
            ),
          ),
          content: Text('You Complete The Task👍'),
        ),
      );
    }
  }

  completedfunc() {
    if (Assigns.length == statusdata[0].length) {
      completetask();
      // if (kDebugMode) {
      //   print("Enter");
      // }
    } else if (cmpcheck == true) {
      IndividualComplete();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task Not Completed 🙄'),
        ),
      );
    }
  }

  Descriptionvisible() {
    if (widget.Description.isEmpty) {
      setState(() {
        desc = false;
      });
    } else {
      desc = true;
    }
  }

  @override
  void initState() {
    _timer =
        Timer.periodic(const Duration(seconds: 3), (timer) => getassigndata());

    _timer = Timer.periodic(const Duration(seconds: 3), (timer) => getStatus());
    _timer = Timer.periodic(
        const Duration(seconds: 3), (timer) => reassigntaskdata());
    check(widget.Deadlinedate);
    setState(() {
      tittle = widget.sendTittle;
    });
    Descriptionvisible();
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
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width * 0.75;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.of(context).push(
          //   MaterialPageRoute(builder: (context) =>print("dfud")),
          // );
        },
        child: const Icon(
          Icons.chat_outlined,
          size: 30,
          color: Colors.white,
        ),
        backgroundColor: MainTextColor,
      ),
      backgroundColor: Appbackgroundcolor,
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.only(left: 08),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 25),
              child: Text(
                "Task Details",
                style: GoogleFonts.poppins(
                    fontSize: 20, color: blackclr, fontWeight: FontWeight.bold),
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => const assign_task(),
                  ),
                );
              },
              child: CircleAvatar(
                backgroundImage: NetworkImage(box.read("profile")),
                backgroundColor: Color.fromARGB(255, 80, 126, 255),
                radius: 17,
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: _streamController.stream,
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  // color: Colors.red,
                  child: const Center(child: CircularProgressIndicator()),
                );
              } else {
                return Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 05),
                      child: TaskTitle(
                        sendTittle: tittle,
                        val: val,
                        statuslen: statusdata[0].length.toString(),
                        category: widget.category.toString().trim(),
                        Id: widget.Id,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 05),
                      child: Taskdead(
                        Deadlinedate: widget.Deadlinedate,
                        Deadlinetime: widget.Deadlinetime,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text("Attachments",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: blackclr)),
                          Padding(
                            padding: const EdgeInsets.only(right: 25),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => FileDowloadPage(
                                      Id: widget.Id,
                                      delchek: btn,
                                    ),
                                  ),
                                );
                              },
                              child: Text(
                                "See all",
                                style: TextStyle(
                                  fontSize: 17,
                                  color: MainTextColor,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Attachmentdata(
                      Id: widget.Id,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 22),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // ignore: prefer_const_literals_to_create_immutables
                        children: [
                          Text("Upload File",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: blackclr)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: SizedBox(
                        height: hei * 0.07,
                        width: wid,
                        child: DottedBorder(
                          color: Colors.blueGrey,
                          radius: const Radius.circular(10),
                          borderType: BorderType.RRect,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 08),
                                child: Icon(
                                  Icons.description_outlined,
                                  size: 30,
                                  color: MainTextColor,
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 8.0, top: 08),
                                child: Text("Upload Documents...",
                                    style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                        color: blackclr)),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, top: 08, right: 05),
                                child: InkWell(
                                  onTap: () {
                                    FileOperationdart.fileUploadfunc(
                                        widget.Id, widget.Id);
                                  },
                                  child: Icon(
                                    Icons.add_box,
                                    size: 30,
                                    color: MainTextColor,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, top: 20),
                          child: Text("Team Member",
                              style: GoogleFonts.poppins(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: blackclr)),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 07),
                      child: TeamMember(
                        Assigns: Assigns,
                        Id: widget.Id,
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Visibility(
                      visible: desc,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                              left: 25,
                            ),
                            child: Text("Description",
                                style: GoogleFonts.poppins(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: blackclr)),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 15),
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(widget.Description,
                              style: GoogleFonts.adamina(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                  color: blackclr)),
                        ),
                        width: MediaQuery.of(context).size.width * 0.85,
                        constraints: BoxConstraints(minHeight: hei * 0.20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
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
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.03,
                    ),
                    Visibility(
                      visible: btn,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 20),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffFF7360),
                                ),
                                onPressed: () {
                                  bottomsheet(context);
                                },
                                onLongPress: () {
                                  if (kDebugMode) {
                                    print("Working");
                                  }
                                },
                                child: Text(
                                  "Reassign",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                )),
                          ),
                          // completebtn
                          Padding(
                            padding: const EdgeInsets.only(right: 35),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xffFF7360),
                                ),
                                onPressed: () {
                                  completedfunc();
                                },
                                child: Text(
                                  "Completed",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                    color: const Color.fromARGB(
                                        255, 255, 255, 255),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: !btn,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 05),
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xffFF7360),
                            ),
                            onPressed: () {
                              IndividualCompleteself();
                            },
                            child: Text(
                              "Completed",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                                color: const Color.fromARGB(255, 255, 255, 255),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }),
      ),
    );
  }

  void bottomsheet(BuildContext con) {
    List<bool> checked = List.filled(getstaff.length, false);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      context: con,
      builder: (context) {
        return FutureBuilder(
            future: reassigntaskdata(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.connectionState == ConnectionState.done) {
                return StatefulBuilder(
                  builder: (BuildContext context, StateSetter setStatee) {
                    return SingleChildScrollView(
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text(
                              "Reassign",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                                color: MainTextColor,
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SingleChildScrollView(
                            child: SizedBox(
                              height: 328,
                              child: daata(checked, setStatee),
                            ),
                          ),
                          const SizedBox(height: 10),
                          Center(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xffFF7360),
                              ),
                              onPressed: () {
                                selectedItems = [];

                                setStatee(
                                  () {
                                    for (int i = 0; i < getstaff.length; i++) {
                                      if (checked[i]) {
                                        if (!selectedItems.contains(
                                            getstaff[i][0]["Employee_id"])) {
                                          selectedItems.add(
                                              getstaff[i][0]["Employee_id"]);
                                        }
                                      }
                                    }
                                  },
                                );
                                Navigator.pop(context);

                                if (kDebugMode) {
                                  print(selectedItems);
                                }
                                reassigntask();
                              },
                              child: Text(
                                "Done",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color:
                                      const Color.fromARGB(255, 255, 255, 255),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }
              return Container();
            });
      },
    );
  }

  ListView daata(List<bool> checked, StateSetter setStatee) {
    return ListView.builder(
      itemCount: getstaff.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(
                    getstaff[index][0]["profile"].toString().trim()),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 40,
                child: Text(
                  getstaff[index][0]["Employee_id"].toString().trim(),
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 125,
                child: Text(
                  getstaff[index][0]["Employee_name"].toString().trim(),
                ),
              ),
            ],
          ),
          value: checked[index],
          onChanged: (bool? value) {
            setStatee(() {
              checked[index] = value!;
              reassignid = getstaff[index][0]["Employee_id"].toString().trim();
              if (checked[index] == true) {}
              if (kDebugMode) {
                print(
                  getstaff[index][0]["Employee_id"].toString().trim(),
                );
              }
            });
          },
        );
      },
    );
  }
}
