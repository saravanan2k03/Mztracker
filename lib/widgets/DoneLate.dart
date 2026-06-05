import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/utils/Status.dart';

class DoneLate extends StatefulWidget {
  const DoneLate({super.key});

  @override
  State<DoneLate> createState() => _DoneLateState();
}

class _DoneLateState extends State<DoneLate> {
  final StreamController _controller = StreamController();
  List<dynamic> DonelateList = [];
  List<dynamic> profile = [];
  late Timer _timer;

  void _loadData() {
    final empId = box.read('employee').toString();
    final tasks = MockRepository.getTasks(empId, 'Done late');
    final ids = tasks.map((t) => t['Assigned_Id']).toList();
    if (mounted) {
      setState(() {
        DonelateList = tasks;
        profile = MockRepository.getTeamProfiles(ids);
        _controller.add(DonelateList);
      });
    }
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
    _controller.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    return SingleChildScrollView(
      child: StreamBuilder(
        stream: _controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.6,
                child: Center(
                    child: CircularProgressIndicator(color: colors.primary)),
              ),
            );
          }
          if (DonelateList.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text('No Tasks',
                    style: GoogleFonts.roboto(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: colors.textMuted)),
              ),
            );
          }
          return Column(
            children: [
              ListView.builder(
                itemCount: DonelateList.length,
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                itemBuilder: (_, index) => StatusContainer(
                  tittle: DonelateList[index]['Task_Tittle'].toString().trim(),
                  deadlinedate: DonelateList[index]['Deadline_date'].toString().trim(),
                  deadlinetime: DonelateList[index]['Deadline_time'].toString().trim(),
                  indexs: index,
                  profile: profile,
                  percentage: DonelateList[index]['percentage'].toString().trim(),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
