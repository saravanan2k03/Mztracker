import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../functions/variabels.dart';

dropdown(wid, hei) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter setst) {
    return Container(
      height: hei * 0.058,
      width: wid,
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
      child: Padding(
        padding: const EdgeInsets.only(left: 18.0),
        child: DropdownButton(
          menuMaxHeight: 250,
          isExpanded: true,
          underline: Container(),
          value: selectedcategory,
          items: cat_list.map((String items) {
            return DropdownMenuItem(
              value: items,
              child: Text(
                items,
                style: GoogleFonts.poppins(
                    color: Colors.black,
                    fontSize: wid * 0.038,
                    fontWeight: FontWeight.w500),
              ),
            );
          }).toList(),
          onChanged: (value) {
            setst(() {
              selectedcategory = value!;
              cat_id = cat_list.indexOf(value);
            });
          },
        ),
      ),
    );
  });
}
