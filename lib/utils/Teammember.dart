import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';

class TeamMember extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final List<dynamic> Assigns;
  final String Id;
  const TeamMember({super.key, required this.Assigns, required this.Id});

  @override
  State<TeamMember> createState() => _TeamMemberState();
}

class _TeamMemberState extends State<TeamMember> {
  late Timer _timer;
  List<dynamic> Data = [];
  final StreamController _streamController = StreamController();

  void _loadData() {
    final members = MockRepository.getTeamMemberDetails(widget.Id);
    if (mounted) {
      setState(() {
        Data = members;
        _streamController.add(Data);
      });
    }
  }

  @override
  void initState() {
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

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        if (!snapshot.hasData || Data.isEmpty) {
          return SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: Center(child: CircularProgressIndicator(color: colors.primary)),
          );
        }
        return ListView.builder(
          shrinkWrap: true,
          physics: const ScrollPhysics(),
          itemCount: Data.length,
          padding: const EdgeInsets.only(right: 16, left: 16),
          itemBuilder: (context, index) {
            final member = Data[index][0];
            final done = member['Individual_status'].toString().trim() == 'Completed';

            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Container(
                height: MediaQuery.of(context).size.height * 0.10,
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
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.23,
                        child: FittedBox(
                          child: CircleAvatar(
                            backgroundImage:
                                NetworkImage(member['profile'].toString().trim()),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Text(member['Employee_name'].toString().trim(),
                            style: GoogleFonts.poppins(
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: colors.text)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Icon(
                        done ? Icons.check_circle : Icons.cancel_outlined,
                        color: done ? Colors.green : colors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }
}
