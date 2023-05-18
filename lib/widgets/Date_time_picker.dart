import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../functions/variabels.dart';

class Datepicker extends StatefulWidget {
  const Datepicker({
    Key? key,
    required this.hei,
    required this.wid,
    required this.title,
    this.icon,
    this.select,
    this.output,
  }) : super(key: key);

  final double hei;
  final double wid;
  final title;
  final output;
  final icon;
  final select;

  @override
  State<Datepicker> createState() => _DatepickerState();
}

class _DatepickerState extends State<Datepicker> {
  var out;
  @override
  Widget build(BuildContext context) {
    if (widget.select == "Date") {
      date_time_status = false;
      out = formattedDate;
    } else if (widget.select == "Time") {
      date_time_status = false;
      out = formattedTime;
    } else if (widget.select == "int_date") {
      date_time_status = true;
      out = initial_Date;
    } else if (widget.select == "int_time") {
      date_time_status = true;
      out = initial_Time;
    }
    return GestureDetector(
      onTap: () {
        if (widget.select == "Date") {
          date_time_status = false;
          _selectDate(context);
        }
        if (widget.select == "Time") {
          date_time_status = false;
          _selectTime(context);
        }
      },
      child: Container(
          height: widget.hei * 0.1,
          width: widget.wid * 0.43,
          decoration: BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.white,
            ),
            boxShadow: const [
              BoxShadow(
                  offset: Offset(1, 1),
                  blurRadius: 2,
                  color: Color.fromARGB(255, 231, 231, 231))
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Icon(widget.icon, color: primary),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.title,
                      style: GoogleFonts.poppins(fontSize: widget.wid * 0.035)),
                  Text(out.toString(),
                      style: GoogleFonts.poppins(
                          fontSize: widget.wid * 0.035,
                          fontWeight: FontWeight.w500))
                ],
              ),
            ],
          )),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        String Date = DateFormat('dd-MM-yyyy').format(picked);
        formattedDate = Date;
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) {
      setState(() {
        String Time = DateFormat('h:mm a')
            .format(DateTime(2022, 03, 01, picked.hour, picked.minute));
        formattedTime = Time;
      });
    }
  }
}
