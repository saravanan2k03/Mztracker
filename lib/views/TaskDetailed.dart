// ignore_for_file: sort_child_properties_last, non_constant_identifier_names, file_names
import 'dart:async';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
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

  const TaskDetailed({
    Key? key,
    required this.Id,
    required this.sendTittle,
    required this.Description,
    required this.Deadlinedate,
    required this.Deadlinetime,
    required this.category,
  }) : super(key: key);

  @override
  State<TaskDetailed> createState() => _TaskDetailedState();
}

class _TaskDetailedState extends State<TaskDetailed> {
  final StreamController _streamController = StreamController();
  List<dynamic> parsedList = [];
  List<dynamic> Assigns = [];
  List<dynamic> statusdata = [[]];
  List<dynamic> getstaff = [];
  List<dynamic> selectedItems = [];
  late Timer _timer;
  bool desc = true;
  bool btn = true;
  bool cmpcheck = false;
  int val = 1;
  var status;

  void _loadData() {
    final details  = MockRepository.getTaskDetails(widget.Id);
    final statuses = MockRepository.getCompletedStatuses(widget.Id);
    final team     = MockRepository.getTeamMemberDetails(widget.Id);
    if (!mounted) return;
    setState(() {
      parsedList = details;
      statusdata = statuses;
      getstaff   = team;
      if (parsedList.isNotEmpty && (parsedList[0] as List).isNotEmpty) {
        final empId   = box.read('employee').toString();
        final first   = (parsedList[0] as List)[0];
        btn           = first['Assigned_by'].toString().trim() == empId;
        Assigns       = [];
        for (final row in parsedList[0] as List) {
          Assigns.add(row['Assigned_to']);
          if (row['Assigned_to'].toString().trim() == empId &&
              first['Assigned_by'].toString().trim() == empId) {
            btn      = true;
            cmpcheck = true;
          }
        }
        val = Assigns.length;
      }
      _streamController.add(parsedList);
    });
  }

  void _checkDeadline(String data) {
    if (data.length < 10) { status = 'Done late'; return; }
    final year  = int.tryParse(data.substring(6, 10)) ?? 2026;
    final month = int.tryParse(data.substring(3, 5)) ?? 1;
    final day   = int.tryParse(data.substring(0, 2)) ?? 1;
    final diff  = DateTime(year, month, day)
        .difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .inDays;
    status = diff < 0 ? 'Done late' : 'Completed';
  }

  @override
  void initState() {
    _checkDeadline(widget.Deadlinedate);
    desc = widget.Description.isNotEmpty;
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _loadData());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  void _completeTask() {
    MockRepository.completeTask(widget.Id, status ?? 'Completed');
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        content: Text('Task Completed'),
      ),
    );
    Navigator.pop(context);
  }

  void _reassignTask() {
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Task Reassigned')));
  }

  void _individualComplete() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
        content: Text('You Completed The Task 👍'),
      ),
    );
  }

  void _completedfunc() {
    if (Assigns.length == (statusdata[0] as List).length) {
      _completeTask();
    } else if (cmpcheck) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Task Not Completed Please Wait 🤗')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Task Not Completed 🙄')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final hei = MediaQuery.of(context).size.height;
    final wid = MediaQuery.of(context).size.width * 0.75;

    return Scaffold(
      backgroundColor: colors.background,
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: colors.primary,
        child: const Icon(Icons.chat_outlined, size: 30, color: Colors.white),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Padding(
          padding: const EdgeInsets.only(right: 25),
          child: Center(
            child: Text('Task Details',
                style: GoogleFonts.poppins(
                    fontSize: 20, color: colors.text, fontWeight: FontWeight.bold)),
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.chevron_left, color: colors.text, size: 35),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: InkWell(
              onTap: () => Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const assign_task())),
              child: CircleAvatar(
                backgroundImage: NetworkImage(box.read('profile')),
                backgroundColor: const Color(0xFF507EFF),
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
                child: Center(child: CircularProgressIndicator(color: colors.primary)),
              );
            }
            return Column(
              children: [
                SizedBox(height: hei * 0.03),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: TaskTitle(
                    sendTittle: widget.sendTittle,
                    val: val,
                    statuslen: (statusdata[0] as List).length.toString(),
                    category: widget.category.trim(),
                    Id: widget.Id,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Taskdead(
                      Deadlinedate: widget.Deadlinedate,
                      Deadlinetime: widget.Deadlinetime),
                ),
                SizedBox(height: hei * 0.03),
                // Attachments header
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Attachments',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.text)),
                      Padding(
                        padding: const EdgeInsets.only(right: 25),
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => FileDowloadPage(
                                  Id: widget.Id, delchek: btn),
                            ),
                          ),
                          child: Text('See all',
                              style: TextStyle(
                                  fontSize: 17,
                                  color: colors.primary,
                                  fontWeight: FontWeight.w500)),
                        ),
                      ),
                    ],
                  ),
                ),
                Attachmentdata(Id: widget.Id),
                SizedBox(height: hei * 0.03),
                // Upload file
                Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Row(
                    children: [
                      Text('Upload File',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.text)),
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
                            padding: const EdgeInsets.only(left: 8, top: 8),
                            child: Icon(Icons.description_outlined,
                                size: 30, color: colors.primary),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8, top: 8),
                            child: Text('Upload Documents...',
                                style: GoogleFonts.poppins(
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: colors.text)),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(right: 5, top: 8),
                            child: InkWell(
                              onTap: () => FileOperationdart.fileUploadfunc(
                                  widget.Id, widget.Id),
                              child: Icon(Icons.add_box,
                                  size: 30, color: colors.primary),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: hei * 0.03),
                // Team member
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 20, top: 20),
                      child: Text('Team Member',
                          style: GoogleFonts.poppins(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: colors.text)),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 7),
                  child: TeamMember(Assigns: Assigns, Id: widget.Id),
                ),
                SizedBox(height: hei * 0.03),
                // Description
                if (desc) ...[
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text('Description',
                            style: GoogleFonts.poppins(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: colors.text)),
                      ),
                    ],
                  ),
                  SizedBox(height: hei * 0.02),
                  Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Container(
                      width: MediaQuery.of(context).size.width * 0.85,
                      constraints: BoxConstraints(minHeight: hei * 0.20),
                      decoration: BoxDecoration(
                        color: colors.surface,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: colors.shadow.withOpacity(0.15),
                            spreadRadius: 0,
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(widget.Description,
                            style: GoogleFonts.adamina(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colors.text)),
                      ),
                    ),
                  ),
                ],
                SizedBox(height: hei * 0.03),
                // Action buttons
                Visibility(
                  visible: btn,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary),
                          onPressed: () => _reassignSheet(context, colors),
                          child: Text('Reassign',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.white)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 35),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary),
                          onPressed: _completedfunc,
                          child: Text('Completed',
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 13,
                                  color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
                Visibility(
                  visible: !btn,
                  child: Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary),
                      onPressed: _individualComplete,
                      child: Text('Completed',
                          style: GoogleFonts.poppins(
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                              color: Colors.white)),
                    ),
                  ),
                ),
                SizedBox(height: hei * 0.05),
              ],
            );
          },
        ),
      ),
    );
  }

  void _reassignSheet(BuildContext ctx, AppColors colors) {
    final staff   = MockRepository.getTeamMemberDetails(widget.Id);
    final checked = List.filled(staff.length, false);
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(10))),
      backgroundColor: colors.surface,
      context: ctx,
      builder: (_) => StatefulBuilder(
        builder: (_, setS) => SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 10),
              Text('Reassign',
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: colors.primary)),
              const SizedBox(height: 10),
              SizedBox(
                height: 320,
                child: ListView.builder(
                  itemCount: staff.length,
                  itemBuilder: (_, i) {
                    final emp = staff[i][0];
                    return CheckboxListTile(
                      title: Row(
                        children: [
                          CircleAvatar(
                              backgroundImage:
                                  NetworkImage(emp['profile'].toString())),
                          const SizedBox(width: 20),
                          SizedBox(
                              width: 45,
                              child: Text(emp['Employee_id'].toString(),
                                  style: TextStyle(color: colors.text))),
                          const SizedBox(width: 20),
                          SizedBox(
                              width: 120,
                              child: Text(emp['Employee_name'].toString(),
                                  style: TextStyle(color: colors.text))),
                        ],
                      ),
                      value: checked[i],
                      activeColor: colors.primary,
                      onChanged: (v) => setS(() => checked[i] = v!),
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: colors.primary),
                onPressed: () {
                  selectedItems = [
                    for (int i = 0; i < staff.length; i++)
                      if (checked[i]) staff[i][0]['Employee_id']
                  ];
                  Navigator.pop(ctx);
                  _reassignTask();
                },
                child: Text('Done',
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Colors.white)),
              ),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
