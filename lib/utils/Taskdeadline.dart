import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';

class Taskdead extends StatelessWidget {
  final String Deadlinedate;
  // ignore: non_constant_identifier_names
  final String Deadlinetime;
  const Taskdead(
      {super.key, required this.Deadlinedate, required this.Deadlinetime});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return Row(
      children: [
        _card(
          context, colors,
          icon: Icons.calendar_month_outlined,
          iconColor: const Color(0xFF0278FF),
          label: 'Deadline Date',
          value: Deadlinedate,
        ),
        _card(
          context, colors,
          icon: Icons.access_alarm,
          iconColor: colors.primary,
          label: 'Deadline Time',
          value: Deadlinetime,
        ),
      ],
    );
  }

  Widget _card(
    BuildContext context,
    AppColors colors, {
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
  }) {
    return Container(
      margin: const EdgeInsets.only(left: 20),
      height: MediaQuery.of(context).size.height * 0.09,
      width: MediaQuery.of(context).size.width * 0.4,
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
            padding: const EdgeInsets.only(top: 8, left: 8),
            child: Icon(icon, color: iconColor),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(label,
                      style: GoogleFonts.roboto(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.textMuted)),
                ),
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(left: 5),
                  child: Text(value,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colors.text)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
