// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/widgets/Completed.dart';
import 'package:mztrackertodo/widgets/DoneLate.dart';
import 'package:mztrackertodo/widgets/PendingTask.dart';

class TaskStatus extends StatefulWidget {
  const TaskStatus({super.key});

  @override
  State<TaskStatus> createState() => _TaskStatusState();
}

class _TaskStatusState extends State<TaskStatus> {
  bool search = false;

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return DefaultTabController(
      length: 3,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: colors.background,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: colors.surface,
            title: Text('My all task list',
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 21,
                    color: colors.text)),
            centerTitle: true,
            leading: IconButton(
              icon: Icon(Icons.chevron_left, color: colors.text, size: 35),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                onPressed: () => setState(() => search = !search),
                icon: Icon(Icons.search, size: 25, color: colors.text),
              )
            ],
          ),
          body: Column(
            children: [
              // Search bar
              AnimatedCrossFade(
                duration: const Duration(milliseconds: 200),
                firstChild: const SizedBox.shrink(),
                secondChild: Padding(
                  padding:
                      const EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 5),
                  child: TextField(
                    cursorColor: colors.text,
                    style: TextStyle(color: colors.text),
                    decoration: InputDecoration(
                      suffixIcon:
                          Icon(Icons.search_sharp, size: 20, color: colors.text),
                      hintText: 'Search task',
                      hintStyle:
                          GoogleFonts.poppins(fontSize: 12, color: colors.textMuted),
                      filled: true,
                      fillColor: colors.surface,
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(color: colors.inputBorder),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide(color: colors.inputBorder),
                      ),
                    ),
                  ),
                ),
                crossFadeState:
                    search ? CrossFadeState.showSecond : CrossFadeState.showFirst,
              ),
              // Tab bar
              TabBar(
                labelColor: colors.primary,
                unselectedLabelColor: colors.textMuted,
                indicatorSize: TabBarIndicatorSize.label,
                indicatorWeight: 3,
                indicatorColor: colors.primary,
                tabs: const [
                  Tab(text: 'Pending Task', icon: Icon(Icons.run_circle)),
                  Tab(text: 'Done Late', icon: Icon(Icons.pending_actions_rounded)),
                  Tab(text: 'Completed', icon: Icon(Icons.done)),
                ],
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 15),
                  child: TabBarView(
                    physics: BouncingScrollPhysics(),
                    children: [
                      PendingTask(),
                      DoneLate(),
                      CompletedPage(),
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
