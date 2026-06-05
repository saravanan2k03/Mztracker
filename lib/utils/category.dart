import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/views/Profile.dart';

class Caty extends StatefulWidget {
  const Caty({super.key});

  @override
  State<Caty> createState() => _CatyState();
}

class _CatyState extends State<Caty> {
  final StreamController _streamController = StreamController();
  late Timer _timer;
  List<dynamic> category = [];

  void _load() {
    final cats = MockRepository.getCategoryMaps();
    if (mounted) {
      setState(() {
        category = cats;
        _streamController.add(cats);
      });
    }
  }

  @override
  void initState() {
    _load();
    _timer = Timer.periodic(const Duration(seconds: 5), (_) => _load());
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

    return StreamBuilder(
      stream: _streamController.stream,
      builder: (context, snapshot) {
        return SizedBox(
          height: 200,
          child: ListView.builder(
            shrinkWrap: true,
            physics: const ScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemCount: category.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(left: 20, right: 3),
                child: InkWell(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(builder: (_) => const ProfilePage()),
                  ),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.24,
                    width: MediaQuery.of(context).size.width * 0.44,
                    decoration: BoxDecoration(
                      color: colors.surface,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: colors.shadow.withOpacity(0.18),
                          spreadRadius: 0,
                          blurRadius: 12,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            category[index]['category_text'].toString().trim(),
                            style: GoogleFonts.poppins(
                                color: colors.text,
                                fontSize: 15,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 12),
                          child: Text('10 Tasks',
                              style: GoogleFonts.poppins(
                                  color: colors.textMuted,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w500)),
                        ),
                        const Spacer(),
                        Align(
                          alignment: Alignment.bottomRight,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.only(
                              bottomRight: Radius.circular(15),
                              topLeft: Radius.circular(15),
                            ),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.09,
                              width: MediaQuery.of(context).size.width * 0.18,
                              color: colors.primary.withOpacity(0.12),
                              child: Icon(Icons.folder_open,
                                  size: 36, color: colors.primary),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
