// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/variabels.dart';
import 'utils/Taskcontainer.dart';
import 'utils/category.dart';
import 'views/TaskStatus.dart';

class MainPage extends StatefulWidget {
  final String userdata;
  const MainPage({Key? key, required this.userdata}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  List<dynamic> DetailLength = [];
  final StreamController _streamController = StreamController();
  late Timer _timer;

  void _loadData() {
    final tasks = MockRepository.getTasks(box.read('employee').toString(), 'Pending');
    if (mounted) {
      setState(() {
        DetailLength = tasks;
        _streamController.add(tasks);
      });
    }
  }

  @override
  void initState() {
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _loadData());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    _streamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          title: Text(
            'Hi ${widget.userdata}',
            style: GoogleFonts.poppins(fontSize: 20, color: colors.primary),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: InkWell(
                onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => TaskStatus()),
                ),
                child: CircleAvatar(
                  backgroundImage: NetworkImage(box.read('profile')),
                  backgroundColor: const Color(0xFF507EFF),
                  radius: 17,
                ),
              ),
            )
          ],
        ),
        body: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                  child: CircularProgressIndicator(color: colors.primary));
            }
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(right: 5),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 10),
                      child: Row(
                        children: [
                          Text(
                            '${DetailLength.length} task pending',
                            style: GoogleFonts.poppins(
                                fontSize: 15, color: colors.primary),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, right: 15, left: 15),
                      child: TextField(
                        cursorColor: colors.text,
                        style: TextStyle(color: colors.text),
                        decoration: InputDecoration(
                          suffixIcon:
                              Icon(Icons.search_sharp, size: 20, color: colors.text),
                          hintText: 'Search task',
                          hintStyle: GoogleFonts.poppins(
                              fontSize: 12, color: colors.textMuted),
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
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        children: [
                          Text('Categories',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colors.text)),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    SizedBox(
                      width: MediaQuery.of(context).size.height * 0.80,
                      child: const Caty(),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Ongoing Task',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: colors.text)),
                          Padding(
                            padding: const EdgeInsets.only(right: 20),
                            child: Text('See all',
                                style: TextStyle(
                                    fontSize: 17,
                                    color: colors.primary,
                                    fontWeight: FontWeight.w500)),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.03),
                    const TaskContainer(),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
