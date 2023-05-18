import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

title(double wid, text) {
  return Row(
    children: [
      Text(text,
          style: GoogleFonts.poppins(fontSize: wid * 0.04, color: Colors.grey)),
    ],
  );
}
