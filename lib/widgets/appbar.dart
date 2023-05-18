import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../functions/variabels.dart';
import '../utils/Bottomnavbar.dart';

class appbar extends StatelessWidget {
  final cont;
  appbar({required this.cont});

  @override
  Widget build(cont) {
    var hei = MediaQuery.of(cont).size.height;
    var wid = MediaQuery.of(cont).size.width;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        IconButton(
            onPressed: () {
              Navigator.of(cont).pushReplacement(
                MaterialPageRoute(
                    builder: (context) => const BottomnavbarPage()),
              );
            },
            icon: const Icon(Icons.arrow_back_ios_new)),
        Text("Todays Task",
            style: GoogleFonts.poppins(
                fontSize: wid * 0.05, fontWeight: FontWeight.w500)),
        CircleAvatar(
          backgroundImage: NetworkImage(box.read("profile")),
        )
      ],
    );
  }
}
