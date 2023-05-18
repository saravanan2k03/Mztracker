import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../functions/variabels.dart';

doc_container(double wid, hei) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter sets) {
    return Expanded(
      child: SingleChildScrollView(
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: files.length,
          physics: BouncingScrollPhysics(),
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: hei * 0.08,
                width: wid * 0.8,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    width: 4,
                    color: primary,
                  ),
                  boxShadow: const [
                    BoxShadow(
                        offset: Offset(1, 1),
                        blurRadius: 3,
                        color: Color.fromARGB(255, 186, 186, 186))
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(width: wid * 0.001),
                    const Icon(
                      Icons.description_outlined,
                      color: Colors.blueGrey,
                      size: 30,
                    ),
                    Container(
                      width: wid * 0.41,
                      child: Text(
                        files[index].toString().split("file_picker/")[1],
                        style: GoogleFonts.poppins(color: Colors.black),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          sets(
                            () {
                              files.removeAt(index);
                              print(files);
                            },
                          );
                        },
                        icon: Icon(Icons.cancel_outlined, color: Colors.red))
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  });
}
