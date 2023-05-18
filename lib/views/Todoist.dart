// ignore_for_file: use_build_context_synchronously, list_remove_unrelated_type

import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/api_methods.dart';
import 'package:mztrackertodo/functions/upload_file.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/widgets/Date_time_picker.dart';
import 'package:mztrackertodo/widgets/appbar.dart';
import 'package:mztrackertodo/widgets/attachacment_container.dart';
import 'package:mztrackertodo/widgets/category_dropdown.dart';
import 'package:mztrackertodo/widgets/textfield.dart';
import 'package:mztrackertodo/widgets/title.dart';

class assign_task extends StatefulWidget {
  const assign_task({super.key});

  @override
  State<assign_task> createState() => _assign_taskState();
}

class _assign_taskState extends State<assign_task> {
  final task_input = TextEditingController();
  final desc_input = TextEditingController();
  final cat_text = TextEditingController();

  @override
  void initState() {
    setState(() {
      get_category().whenComplete(() {
        setState(
          () {},
        );
        setState(
          () {},
        );
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var hei = MediaQuery.of(context).size.height;
    var wid = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                child: Column(children: [
                  const SizedBox(height: 10),
                  appbar(cont: context),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Container(
                        width: 120,
                        child: Text("Create New Task",
                            style: GoogleFonts.readexPro(
                                fontSize: wid * 0.06,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  SizedBox(height: hei * 0.04),
                  title(wid, "Task title"),
                  SizedBox(height: hei * 0.010),
                  textfield(
                    controller: task_input,
                    wid: wid,
                    icon: Icons.task_alt,
                    hint: "Enter your task",
                  ),
                  SizedBox(height: hei * 0.025),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        title(wid, "Select Category"),
                        IconButton(
                            onPressed: () {
                              cat_text.text = "";
                              add_category(context, hei, wid);
                            },
                            icon: Icon(
                              size: 25,
                              Icons.add_circle_outline_sharp,
                              color: primary,
                            ))
                      ]),
                  SizedBox(height: hei * 0.010),
                  dropdown(wid, hei),
                  SizedBox(height: hei * 0.025),
                  title(wid, "Add Faculty"),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 70,
                                child: ListView.builder(
                                    itemCount: selectedItems.length,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    physics: const ScrollPhysics(),
                                    itemBuilder:
                                        (BuildContext context, int index) {
                                      return Padding(
                                        padding:
                                            EdgeInsets.only(top: 5, right: 8.0),
                                        child: InkWell(
                                          onLongPress: () {
                                            setState(() {
                                              selectedItems.remove(
                                                  selectedItems[index]
                                                          ['employee_name']
                                                      .toString());
                                            });
                                          },
                                          child: Column(
                                            children: [
                                              CircleAvatar(
                                                backgroundColor: primary,
                                                radius: 20,
                                                child: const CircleAvatar(
                                                    radius: 16,
                                                    backgroundImage: NetworkImage(
                                                        "https://img.freepik.com/premium-psd/3d-illustration-caucasian-man-cartoon-close-up-portrait-standing-man-with-mustache-gray-background-3d-avatar-ui-ux_1020-5090.jpg?w=740")),
                                              ),
                                              const SizedBox(
                                                height: 5,
                                              ),
                                              Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            3.5),
                                                    color: primary),
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(3.0),
                                                  child: Text(
                                                    selectedItems[index]
                                                        ['employee_name'],
                                                    style: GoogleFonts.poppins(
                                                        color: Colors.white,
                                                        fontSize: 8),
                                                  ),
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      );
                                    }),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                          onPressed: (() {
                            send_dep(selectedValue)
                                .whenComplete(() => bottomsheet(context));
                          }),
                          icon: Icon(
                            size: 25,
                            Icons.group_add_outlined,
                            color: primary,
                          ))
                    ],
                  ),
                  SizedBox(height: hei * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Datepicker(
                        select: "int_date",
                        hei: hei,
                        wid: wid,
                        title: "Assign Date",
                        icon: Icons.date_range_outlined,
                      ),
                      Datepicker(
                        select: "Date",
                        hei: hei,
                        wid: wid,
                        title: "End Date",
                        icon: Icons.date_range_rounded,
                      ),
                    ],
                  ),
                  SizedBox(height: hei * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Datepicker(
                        select: "int_time",
                        hei: hei,
                        wid: wid,
                        title: "Assign Time",
                        icon: Icons.access_time_outlined,
                      ),
                      Datepicker(
                        select: "Time",
                        hei: hei,
                        wid: wid,
                        title: "End Time",
                        icon: Icons.access_alarm,
                      ),
                    ],
                  ),
                  SizedBox(height: hei * 0.025),
                  title(wid, "Description"),
                  SizedBox(height: hei * 0.015),
                  textfield(
                    focus: focus,
                    controller: desc_input,
                    hei: hei * 0.2,
                    wid: wid,
                    icon: Icons.edit_note_sharp,
                    hint: "Write something....",
                  ),
                  SizedBox(height: hei * 0.015),
                  title(wid, "Attachments"),
                  SizedBox(height: hei * 0.015),
                  attachments(hei, wid),
                  SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: hei * 0.065,
                      width: wid * 0.7,
                      child: MaterialButton(
                          onPressed: () {
                            print(file);

                            Random random = new Random();
                            int randomNumber = random.nextInt(999999);
                            var assign_id = randomNumber.toString();
                            for (var i = 0; i < selectedItems.length; i++) {
                              var id = int.parse(cat_id.toString()) - 1;
                              file_upload(assign_id).whenComplete(
                                () {
                                  if (kDebugMode) {
                                    print(selectedItems);
                                  }
                                  send_task(
                                          assign_id,
                                          task_input.text,
                                          box.read("employee"),
                                          selectedItems[i]['employee_id'],
                                          formattedDate.toString(),
                                          formattedTime.toString(),
                                          desc_input.text,
                                          catid_list[id].toString())
                                      .whenComplete(() {
                                    InsertPercntage(assign_id);
                                  }).whenComplete(() {});
                                  for (var i = 0; i < file.length; i++) {
                                    if (kDebugMode) {
                                      print(files[i]
                                          .toString()
                                          .split("file_picker/")[1]
                                          .split("'")[0]);
                                    }

                                    send_attachment(
                                            assign_id,
                                            files[i]
                                                .toString()
                                                .split("file_picker/")[1]
                                                .split("'")[0],
                                            box.read("employee"))
                                        .whenComplete(() {
                                      selectedItems.clear();
                                      file.clear();
                                      files.clear();
                                      desc_input.clear();
                                    });
                                  }
                                },
                              );
                            }
                          },
                          color: primary,
                          child: Text(
                            "Create Task",
                            style: GoogleFonts.poppins(color: Colors.white),
                          )),
                    ),
                  ),
                  SizedBox(height: 20),
                ])),
          ),
        ),
      ),
    );
  }

  void add_category(BuildContext con, hei, wid) {
    showModalBottomSheet(
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(10.0),
          ),
        ),
        context: con,
        builder: (context) {
          return SizedBox(
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Wrap(children: [
                StatefulBuilder(
                    builder: (BuildContext context, StateSetter setStatee) {
                  return Container(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Text(
                                "Add Category",
                                style: GoogleFonts.poppins(
                                    color: primary,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w500),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: textfield(
                              controller: cat_text,
                              icon: Icons.category,
                              hint: "Enter Category...."),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, right: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              MaterialButton(
                                onPressed: () async {
                                  if (cat_text.text.toString().trim() == "" ||
                                      cat_text.text.toString().trim().isEmpty) {
                                  } else {
                                    var t1 =
                                        await send_cat(cat_text.text.trim());
                                    if (t1 == "Already Exist") {
                                      // ignore: use_build_context_synchronously
                                      Navigator.pop(context);
                                      await ScaffoldMessenger.of(context)
                                          .showSnackBar(const SnackBar(
                                        content: Text(
                                            'This Category is Already Exist !'),
                                      ));
                                    } else {
                                      setStatee(() {
                                        get_category().whenComplete(() {
                                          setState(
                                            () {},
                                          );
                                          Navigator.pop(con);
                                        });
                                      });
                                      setState(() {});
                                      await ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                        content: Text('Successfully Added !'),
                                      ));
                                    }
                                  }
                                },
                                color: primary,
                                child: Text("Add",
                                    style: GoogleFonts.poppins(
                                        color: Colors.white)),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  );
                }),
              ]),
            ),
          );
        });
  }

  void bottomsheet(BuildContext con) {
    List<bool> checked = List.filled(userList.length, false);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(10.0),
        ),
      ),
      context: con,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setStatee) {
            return Container(
              height: 600,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text("Select Department:",
                          style: GoogleFonts.poppins(
                            color: Color(0xffFF7360),
                          )),
                      Container(
                        width: 140,
                        child: DropdownButton<String>(
                          hint: Text("--select-department--"),
                          value: selectedValue,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(
                                value: 'CSE', child: Text('BE-CSE')),
                            DropdownMenuItem(
                                value: 'ECE', child: Text('BE-ECE')),
                            DropdownMenuItem(
                                value: 'EEE', child: Text('BE-EEE')),
                            DropdownMenuItem(
                                value: 'MECH', child: Text('BE-MECH')),
                            DropdownMenuItem(
                                value: 'CIVIL', child: Text('BE-CIVIL')),
                          ],
                          onChanged: (value) {
                            setStatee(() {
                              selectedValue = value!;
                              send_dep(selectedValue);
                              print(userList);
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  SingleChildScrollView(
                    child: SizedBox(
                      height: 300,
                      child: FutureBuilder(
                          future: send_dep(selectedValue),
                          builder: (context, snapshot) {
                            return daata(checked, setStatee);
                          }),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: MaterialButton(
                          onPressed: () {
                            selectedItems = [];
                            setStatee(
                              () {
                                for (int i = 0; i < userList.length; i++) {
                                  if (checked[i]) {
                                    if (!selectedItems.contains(userList[i])) {
                                      selectedItems.add(userList[i]);
                                    }
                                  }
                                }
                              },
                            );
                            setState(() {});
                            Navigator.pop(context);

                            print(selectedItems);
                          },
                          color: primary,
                          child: Text("Add",
                              style: GoogleFonts.poppins(color: Colors.white)),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  ListView daata(List<bool> checked, StateSetter setStatee) {
    return ListView.builder(
      itemCount: userList.length,
      itemBuilder: (BuildContext context, int index) {
        return CheckboxListTile(
          title: Row(
            children: [
              const CircleAvatar(
                backgroundImage: NetworkImage(
                    "https://img.freepik.com/premium-psd/3d-illustration-caucasian-man-cartoon-close-up-portrait-standing-man-with-mustache-gray-background-3d-avatar-ui-ux_1020-5090.jpg?w=740"),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 40,
                child: Text(
                  userList[index]['employee_id'],
                ),
              ),
              const SizedBox(
                width: 30,
              ),
              SizedBox(
                width: 125,
                child: Text(
                  userList[index]['employee_name'],
                ),
              ),
            ],
          ),
          value: checked[index],
          onChanged: (bool? value) {
            setStatee(() {
              checked[index] = value!;
            });
          },
        );
      },
    );
  }
}
