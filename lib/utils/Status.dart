// ignore_for_file: non_constant_identifier_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class StatusContainer extends StatefulWidget {
  final String tittle;
  final String deadlinedate;
  final String deadlinetime;
  final int indexs;
  final List<dynamic> profile;
  final String percentage;

  const StatusContainer({
    super.key,
    required this.tittle,
    required this.deadlinedate,
    required this.deadlinetime,
    required this.indexs,
    required this.profile,
    required this.percentage,
  });

  @override
  State<StatusContainer> createState() => _StatusContainerState();
}

class _StatusContainerState extends State<StatusContainer> {
  var dates;
  late Timer _timer;
  double saro = 0.0;
  String percentagetext = '0%';

  @override
  void initState() {
    _checkDeadline(widget.deadlinedate);
    _computePercent();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      _checkDeadline(widget.deadlinedate);
      _computePercent();
    });
    super.initState();
  }

  void _checkDeadline(String data) {
    if (data.length < 10) { dates = '0d'; return; }
    final year  = int.tryParse(data.substring(6, 10)) ?? 2026;
    final month = int.tryParse(data.substring(3, 5)) ?? 1;
    final day   = int.tryParse(data.substring(0, 2)) ?? 1;
    final diff  = DateTime(year, month, day)
        .difference(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day))
        .inDays;
    if (mounted) setState(() => dates = '${diff < 0 ? 0 : diff}d');
  }

  void _computePercent() {
    if (!mounted) return;
    final val = double.tryParse(widget.percentage) ?? 0.0;
    setState(() {
      saro = val.clamp(0.0, 1.0);
      percentagetext = '${(saro * 100).round()}%';
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final screenWidth = MediaQuery.of(context).size.width;
    final hei = MediaQuery.of(context).size.height;

    final hasMemberData = widget.profile.isNotEmpty &&
        widget.indexs < widget.profile.length;
    final members = hasMemberData ? widget.profile[widget.indexs] as List : [];

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
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
            // Title + days badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(widget.tittle,
                      style: GoogleFonts.poppins(
                          color: colors.text,
                          fontSize: 17,
                          fontWeight: FontWeight.w800),
                      overflow: TextOverflow.ellipsis),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colors.primary,
                    borderRadius:
                        const BorderRadius.all(Radius.elliptical(100, 50)),
                  ),
                  child: Text(dates ?? '0d',
                      style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w500)),
                ),
              ],
            ),
            // Team label
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
            // Team avatars
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: SizedBox(
                height: 55,
                child: ListView.builder(
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemCount: members.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(left: 5),
                    child: SizedBox(
                      width: 40,
                      height: 40,
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(members[i]['profile'].toString().trim()),
                        radius: 100,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Date + progress
            screenWidth <= 392
                ? Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: CircularPercentIndicator(
                          radius: 50,
                          lineWidth: 5,
                          percent: saro,
                          progressColor: colors.primary,
                          backgroundColor: colors.shadow.withOpacity(0.2),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(percentagetext,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800, color: colors.text)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(vertical: hei / 150),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.alarm, size: 22, color: colors.primary),
                            const SizedBox(width: 5),
                            Text(
                              '${widget.deadlinedate}  ${widget.deadlinetime}',
                              style: GoogleFonts.poppins(
                                  color: colors.text,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.alarm, size: 22, color: colors.primary),
                          const SizedBox(width: 5),
                          Text(widget.deadlinetime,
                              style: GoogleFonts.poppins(
                                  color: colors.text,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500)),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: CircularPercentIndicator(
                          radius: 40,
                          lineWidth: 4,
                          percent: saro,
                          progressColor: const Color(0xFFB1D199),
                          backgroundColor: colors.shadow.withOpacity(0.2),
                          circularStrokeCap: CircularStrokeCap.round,
                          center: Text(percentagetext,
                              style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w800, color: colors.text)),
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}
