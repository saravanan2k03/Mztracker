// ignore_for_file: unused_field, non_constant_identifier_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'package:mztrackertodo/widgets/Completed.dart';
import 'package:mztrackertodo/widgets/DoneLate.dart';
import 'package:mztrackertodo/widgets/PendingTask.dart';

class TaskStatus extends StatefulWidget {
  const TaskStatus({super.key});

  @override
  State<TaskStatus> createState() => _TaskStatusState();
}

class _TaskStatusState extends State<TaskStatus> {
  int _currentIndex = 0;
  bool search = false;
  var val;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text("My all task list",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: blackclr)),
            centerTitle: true,
            leading: IconButton(
              icon: const Icon(
                Icons.chevron_left,
                color: Colors.black,
                size: 35,
              ),
              // the method which is called
              // when button is pressed
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            actions: [
              IconButton(
                onPressed: () => {
                  setState(() {
                    search = !search;
                  })
                },
                icon: const Icon(
                  Icons.search,
                  size: 25,
                  color: Colors.black,
                ),
              )
            ],
          ),
          backgroundColor: Colors.white,
          body: Column(
            children: [
              Visibility(
                visible: search,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 30,
                  child: Stack(
                    children: [
                      SizedBox(
                        width: 400,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 20, right: 15, left: 15),
                          child: TextField(
                            cursorColor: blackclr,
                            decoration: InputDecoration(
                              suffixIcon: InkWell(
                                onTap: () {},
                                // ignore: prefer_const_constructors
                                child: Icon(
                                  Icons.search_sharp,
                                  size: 20,
                                  color: blackclr,
                                ),
                              ),
                              hintText: 'Searched task',
                              hintStyle: GoogleFonts.poppins(fontSize: 12),
                              contentPadding: const EdgeInsets.all(15),
                              border: OutlineInputBorder(
                                borderSide:
                                    BorderSide(color: blackclr, width: 32.0),
                                borderRadius: BorderRadius.circular(30),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(30),
                                borderSide: BorderSide(
                                  color: blackclr,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              // do something
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              TabBar(
                onTap: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                labelColor: MainTextColor,
                unselectedLabelColor: blackclr,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                indicatorColor: MainTextColor,
                tabs: const [
                  Tab(
                    text: "Pending Task",
                    icon: Icon(Icons.run_circle, color: Colors.black),
                  ),
                  Tab(
                    text: "Done Late",
                    icon: Icon(Icons.pending_actions_rounded,
                        color: Colors.black),
                  ),
                  Tab(
                    text: "Completed",
                    icon: Icon(Icons.done, color: Colors.black),
                  ),
                ],
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      ////////////
                      PendingTask(),
                      //////////////////////
                      DoneLate(),
                      /////////////////
                      CompletedPage()
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
