import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class TaskTitle extends StatefulWidget {
  final String sendTittle;
  final int val;
  final String statuslen;
  final String category;
  final String Id;

  const TaskTitle({
    super.key,
    required this.sendTittle,
    required this.val,
    required this.statuslen,
    required this.category,
    required this.Id,
  });

  @override
  State<TaskTitle> createState() => _TaskTitleState();
}

class _TaskTitleState extends State<TaskTitle> {
  double saro = 0.0;
  String percentagetext = '0%';
  late Timer _timer;

  @override
  void initState() {
    _computePercent();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _computePercent());
    super.initState();
  }

  void _computePercent() {
    if (!mounted || widget.val == 0) return;
    setState(() {
      saro = ((1.0 / widget.val) * int.parse(widget.statuslen)).clamp(0.0, 1.0);
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

    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.50,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.sendTittle,
                      style: GoogleFonts.poppins(
                          color: colors.text,
                          fontSize: 20,
                          fontWeight: FontWeight.w700)),
                  const SizedBox(height: 4),
                  Text('For ${widget.category}',
                      style: GoogleFonts.poppins(
                          color: colors.primary,
                          fontSize: 14,
                          fontWeight: FontWeight.w500)),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5, top: 10),
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            width: MediaQuery.of(context).size.width * 0.40,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: CircularPercentIndicator(
                radius: 50,
                lineWidth: 10,
                percent: saro,
                progressColor: colors.primary,
                backgroundColor: colors.shadow.withOpacity(0.2),
                circularStrokeCap: CircularStrokeCap.round,
                center: Text(percentagetext,
                    style: GoogleFonts.poppins(
                        fontSize: 20,
                        color: colors.text,
                        fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
