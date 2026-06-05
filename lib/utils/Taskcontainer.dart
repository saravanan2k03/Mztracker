import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import '../views/TaskDetailed.dart';

class TaskContainer extends StatefulWidget {
  const TaskContainer({super.key});

  @override
  State<TaskContainer> createState() => _TaskContainerState();
}

class _TaskContainerState extends State<TaskContainer> {
  final StreamController _streamController = StreamController();
  late Timer _timer;

  var dates;
  bool clr = true;
  List<dynamic> parsedList = [];
  List<dynamic> profile = [];
  List<dynamic> AssignId = [];

  void _loadData() {
    final empId = box.read('employee').toString();
    final tasks = MockRepository.getTasks(empId, 'Pending');
    AssignId = tasks.map((t) => t['Assigned_Id']).toList();
    final profiles = MockRepository.getTeamProfiles(AssignId);
    if (mounted) {
      setState(() {
        parsedList = tasks;
        profile = profiles;
        _streamController.add(parsedList);
      });
    }
  }

  void _checkDeadline(String data) {
    if (data.length < 10) {
      dates = '0d';
      clr = false;
      return;
    }
    final year = int.tryParse(data.substring(6, 10)) ?? 2026;
    final month = int.tryParse(data.substring(3, 5)) ?? 1;
    final day = int.tryParse(data.substring(0, 2)) ?? 1;
    final diff = DateTime(year, month, day)
        .difference(DateTime(
            DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .inDays;
    dates = '${diff < 0 ? 0 : diff}d';
    clr = diff >= 0;
  }

  @override
  void initState() {
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _loadData());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: CircularProgressIndicator(color: colors.primary),
            ),
          );
        }
        return ListView.builder(
          itemCount: parsedList.length,
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemBuilder: (context, index) {
            final data = parsedList[index];
            _checkDeadline(data['Deadline_date'].toString().trim());
            final taskProfiles = (profile.isNotEmpty && index < profile.length)
                ? profile[index] as List
                : [];

            return InkWell(
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => TaskDetailed(
                    Id: data['Assigned_Id'].toString().trim(),
                    sendTittle: data['Task_Tittle'].toString().trim(),
                    Description: data['description'].toString().trim(),
                    Deadlinedate: data['Deadline_date'].toString().trim(),
                    Deadlinetime: data['Deadline_time'].toString().trim(),
                    category: data['Category_text'].toString().trim(),
                  ),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.28,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: colors.surface,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: colors.shadow.withOpacity(0.18),
                        spreadRadius: 0,
                        blurRadius: 12,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              data['Task_Tittle'].toString().trim(),
                              style: GoogleFonts.poppins(
                                  color: colors.text,
                                  fontSize: 17,
                                  fontWeight: FontWeight.w800),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: clr ? colors.primary : Colors.blue,
                              borderRadius: const BorderRadius.all(
                                  Radius.elliptical(100, 50)),
                            ),
                            child: Text('$dates',
                                style: GoogleFonts.poppins(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 7),
                        child: Row(
                          children: [
                            Text('Team members',
                                style: GoogleFonts.poppins(
                                    color: colors.textMuted,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500)),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 50,
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: taskProfiles.length,
                          itemBuilder: (_, i) => Padding(
                            padding: const EdgeInsets.only(left: 5),
                            child: SizedBox(
                              width: 40,
                              height: 40,
                              child: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    taskProfiles[i]['profile'].toString()),
                                radius: 100,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 20),
                        child: Row(
                          children: [
                            Icon(Icons.calendar_month,
                                size: 22, color: colors.primary),
                            Padding(
                              padding: const EdgeInsets.only(left: 5, top: 2),
                              child: Text(
                                  data['Deadline_date'].toString().trim(),
                                  style: GoogleFonts.poppins(
                                      color: colors.text,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                            SizedBox(
                                width:
                                    MediaQuery.of(context).size.width * 0.22),
                            Icon(Icons.timer, size: 22, color: colors.primary),
                            Padding(
                              padding: const EdgeInsets.only(top: 2),
                              child: Text(
                                  data['Deadline_time'].toString().trim(),
                                  style: GoogleFonts.poppins(
                                      color: colors.text,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}
