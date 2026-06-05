// ignore_for_file: use_build_context_synchronously
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/api_methods.dart';
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
    get_category().whenComplete(() => setState(() {}));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hei = MediaQuery.of(context).size.height;
    final wid = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: colors.background,
      body: SingleChildScrollView(
        child: SafeArea(
          child: Form(
            child: Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  appbar(cont: context),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      SizedBox(
                        width: 120,
                        child: Text('Create New Task',
                            style: GoogleFonts.readexPro(
                                fontSize: wid * 0.06,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                  SizedBox(height: hei * 0.04),
                  title(wid, 'Task title'),
                  SizedBox(height: hei * 0.010),
                  textfield(
                    controller: task_input,
                    wid: wid,
                    icon: Icons.task_alt,
                    hint: 'Enter your task',
                  ),
                  SizedBox(height: hei * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      title(wid, 'Select Category'),
                      IconButton(
                        onPressed: () {
                          cat_text.text = '';
                          _addCategorySheet(context, hei, wid);
                        },
                        icon: Icon(Icons.add_circle_outline_sharp,
                            size: 25, color: primary),
                      )
                    ],
                  ),
                  SizedBox(height: hei * 0.010),
                  dropdown(wid, hei),
                  SizedBox(height: hei * 0.025),
                  title(wid, 'Add Faculty'),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            height: 70,
                            child: ListView.builder(
                              itemCount: selectedItems.length,
                              scrollDirection: Axis.horizontal,
                              shrinkWrap: true,
                              physics: const ScrollPhysics(),
                              itemBuilder: (context, index) => Padding(
                                padding:
                                    const EdgeInsets.only(top: 5, right: 8),
                                child: InkWell(
                                  onLongPress: () => setState(() =>
                                      selectedItems.remove(
                                          selectedItems[index]['employee_name']
                                              .toString())),
                                  child: Column(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: primary,
                                        radius: 20,
                                        child: CircleAvatar(
                                          radius: 16,
                                          backgroundImage: NetworkImage(
                                              MockRepository.currentUser.profile),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(3.5),
                                          color: primary,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(3),
                                          child: Text(
                                            selectedItems[index]['employee_name'],
                                            style: GoogleFonts.poppins(
                                                color: Colors.white, fontSize: 8),
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                          send_dep(selectedValue)
                              .whenComplete(() => _staffSheet(context));
                        },
                        icon: Icon(Icons.group_add_outlined,
                            size: 25, color: primary),
                      )
                    ],
                  ),
                  SizedBox(height: hei * 0.025),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Datepicker(
                        select: 'int_date',
                        hei: hei,
                        wid: wid,
                        title: 'Assign Date',
                        icon: Icons.date_range_outlined,
                      ),
                      Datepicker(
                        select: 'Date',
                        hei: hei,
                        wid: wid,
                        title: 'End Date',
                        icon: Icons.date_range_rounded,
                      ),
                    ],
                  ),
                  SizedBox(height: hei * 0.015),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Datepicker(
                        select: 'int_time',
                        hei: hei,
                        wid: wid,
                        title: 'Assign Time',
                        icon: Icons.access_time_outlined,
                      ),
                      Datepicker(
                        select: 'Time',
                        hei: hei,
                        wid: wid,
                        title: 'End Time',
                        icon: Icons.access_alarm,
                      ),
                    ],
                  ),
                  SizedBox(height: hei * 0.025),
                  title(wid, 'Description'),
                  SizedBox(height: hei * 0.015),
                  textfield(
                    focus: focus,
                    controller: desc_input,
                    hei: hei * 0.2,
                    wid: wid,
                    icon: Icons.edit_note_sharp,
                    hint: 'Write something....',
                  ),
                  SizedBox(height: hei * 0.015),
                  title(wid, 'Attachments'),
                  SizedBox(height: hei * 0.015),
                  attachments(hei, wid),
                  const SizedBox(height: 20),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      height: hei * 0.065,
                      width: wid * 0.7,
                      child: MaterialButton(
                        onPressed: _createTask,
                        color: primary,
                        child: Text('Create Task',
                            style: GoogleFonts.poppins(color: Colors.white)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _createTask() {
    if (task_input.text.trim().isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please enter a task title')));
      return;
    }
    final assignId = Random().nextInt(999999).toString();
    final catIdx = (cat_id != null)
        ? (int.tryParse(cat_id.toString()) ?? 1) - 1
        : 0;
    final catText = catIdx < MockRepository.categories.length
        ? MockRepository.categories[catIdx].categoryText
        : 'General';

    for (final item in selectedItems) {
      MockRepository.createTask(
        assignId: assignId,
        taskTitle: task_input.text,
        assignedBy: box.read('employee').toString(),
        assignedTo: item['employee_id'].toString(),
        deadlineDate: formattedDate,
        deadlineTime: formattedTime,
        description: desc_input.text,
        categoryText: catText,
      );
    }

    if (selectedItems.isEmpty) {
      MockRepository.createTask(
        assignId: assignId,
        taskTitle: task_input.text,
        assignedBy: box.read('employee').toString(),
        assignedTo: box.read('employee').toString(),
        deadlineDate: formattedDate,
        deadlineTime: formattedTime,
        description: desc_input.text,
        categoryText: catText,
      );
    }

    selectedItems.clear();
    file.clear();
    files.clear();
    task_input.clear();
    desc_input.clear();
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Task Created Successfully!')),
    );
  }

  void _addCategorySheet(BuildContext con, hei, wid) {
    showModalBottomSheet(
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      context: con,
      builder: (context) => SizedBox(
        child: Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Wrap(
            children: [
              StatefulBuilder(
                builder: (context, setStatee) => Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Text('Add Category',
                              style: GoogleFonts.poppins(
                                  color: primary,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8),
                      child: textfield(
                          controller: cat_text,
                          icon: Icons.category,
                          hint: 'Enter Category....'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 2, right: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          MaterialButton(
                            onPressed: () async {
                              final text = cat_text.text.trim();
                              if (text.isEmpty) return;
                              final result = await send_cat(text);
                              Navigator.pop(context);
                              if (result == 'Already Exist') {
                                ScaffoldMessenger.of(con).showSnackBar(
                                    const SnackBar(
                                        content: Text(
                                            'This Category Already Exists!')));
                              } else {
                                await get_category();
                                setState(() {});
                                ScaffoldMessenger.of(con).showSnackBar(
                                    const SnackBar(
                                        content: Text('Successfully Added!')));
                              }
                            },
                            color: primary,
                            child: Text('Add',
                                style:
                                    GoogleFonts.poppins(color: Colors.white)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _staffSheet(BuildContext con) {
    final checked = List.filled(userList.length, false);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      context: con,
      builder: (context) => StatefulBuilder(
        builder: (context, setStatee) => SizedBox(
          height: 600,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Select Department:',
                      style: GoogleFonts.poppins(color: primary)),
                  SizedBox(
                    width: 140,
                    child: DropdownButton<String>(
                      hint: const Text('--select-department--'),
                      value: selectedValue,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(value: 'CSE', child: Text('BE-CSE')),
                        DropdownMenuItem(value: 'ECE', child: Text('BE-ECE')),
                        DropdownMenuItem(value: 'EEE', child: Text('BE-EEE')),
                        DropdownMenuItem(value: 'MECH', child: Text('BE-MECH')),
                        DropdownMenuItem(value: 'CIVIL', child: Text('BE-CIVIL')),
                      ],
                      onChanged: (value) {
                        setStatee(() {
                          selectedValue = value!;
                          send_dep(selectedValue).whenComplete(() => setStatee(() {}));
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 300,
                child: FutureBuilder(
                  future: send_dep(selectedValue),
                  builder: (context, snapshot) => ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) => CheckboxListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                NetworkImage(MockRepository.currentUser.profile),
                          ),
                          const SizedBox(width: 30),
                          SizedBox(
                              width: 40,
                              child: Text(userList[index]['employee_id'].toString())),
                          const SizedBox(width: 30),
                          SizedBox(
                              width: 125,
                              child: Text(userList[index]['employee_name'].toString())),
                        ],
                      ),
                      value: checked[index],
                      onChanged: (v) => setStatee(() => checked[index] = v!),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: MaterialButton(
                      onPressed: () {
                        final newItems = <Map<String, dynamic>>[];
                        for (int i = 0; i < userList.length; i++) {
                          if (checked[i] &&
                              !selectedItems.contains(userList[i])) {
                            newItems.add(userList[i] as Map<String, dynamic>);
                          }
                        }
                        setState(() => selectedItems.addAll(newItems));
                        Navigator.pop(context);
                      },
                      color: primary,
                      child: Text('Add',
                          style: GoogleFonts.poppins(color: Colors.white)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
