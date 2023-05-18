import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../functions/pick_file.dart';
import '../functions/variabels.dart';
import 'document_container.dart';

attachments(hei, wid) {
  return StatefulBuilder(builder: (BuildContext context, StateSetter set) {
    return DottedBorder(
        color: Colors.blueGrey,
        radius: const Radius.circular(10),
        borderType: BorderType.RRect,
        child: Container(
            constraints: BoxConstraints(maxHeight: double.infinity),
            width: wid,
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 255, 255, 255),
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                    offset: Offset(1, 1),
                    blurRadius: 2,
                    color: Color.fromARGB(255, 231, 231, 231))
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                status2!
                    ? doc_container(wid, hei)
                    : const Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Icon(
                          Icons.description_outlined,
                          size: 30,
                        ),
                      ),
                Visibility(
                  visible: status1!,
                  child: Text("Add Documents or images....",
                      style: GoogleFonts.poppins(
                          color: Color.fromARGB(255, 94, 94, 94))),
                ),
                IconButton(
                    onPressed: () {
                      filepickfunc().whenComplete(() {
                        if (files.length == 0) {
                          set(
                            () {
                              status1 = true;
                              status2 = false;
                            },
                          );
                        }
                        if (files.length > 0) {
                          set(
                            () {
                              status1 = false;
                              status2 = true;
                            },
                          );
                        }
                      });
                    },
                    icon: Icon(
                      Icons.add_box_outlined,
                      size: 35,
                      color: primary,
                    )),
              ],
            )));
  });
}
