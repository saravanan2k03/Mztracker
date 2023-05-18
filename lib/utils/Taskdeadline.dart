import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';

class Taskdead extends StatefulWidget {
  final String Deadlinedate;
  // ignore: non_constant_identifier_names
  final String Deadlinetime;
  const Taskdead(
      {super.key, required this.Deadlinedate, required this.Deadlinetime});

  @override
  State<Taskdead> createState() => _TaskdeadState();
}

class _TaskdeadState extends State<Taskdead> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          margin: const EdgeInsets.only(left: 20),
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 194, 203, 207).withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(children: [
            // ignore: prefer_const_constructors
            Padding(
              padding: const EdgeInsets.only(top: 8, left: 8),
              child: const Icon(
                Icons.calendar_month_outlined,
                color: Color.fromARGB(255, 2, 120, 255),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      padding: const EdgeInsets.only(left: 5),
                      child: Text(
                        "Deadline Date",
                        style: GoogleFonts.roboto(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: blackclr),
                      )),
                  const SizedBox(
                    height: 5,
                  ),
                  Text(
                    widget.Deadlinedate,
                    style: GoogleFonts.poppins(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: blackclr),
                  )
                ],
              ),
            )
          ]),
        ),
        Container(
          margin: const EdgeInsets.only(left: 20),
          height: MediaQuery.of(context).size.height * 0.09,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 194, 203, 207).withOpacity(0.3),
                spreadRadius: 0,
                blurRadius: 12,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(top: 8, left: 8),
                child: Icon(
                  Icons.calendar_month_outlined,
                  color: Color.fromARGB(255, 255, 42, 42),
                ),
              ),
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        padding: const EdgeInsets.only(left: 5),
                        child: Text(
                          "Deadline Time",
                          style: GoogleFonts.roboto(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: blackclr),
                        )),
                    // ignore: prefer_const_constructors
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      widget.Deadlinetime,
                      style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: blackclr),
                    )
                  ],
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
