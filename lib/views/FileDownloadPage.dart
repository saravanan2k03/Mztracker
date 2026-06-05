// ignore_for_file: prefer_const_constructors, non_constant_identifier_names
import 'dart:async';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';
import 'package:mztrackertodo/functions/variabels.dart';

class FileDowloadPage extends StatefulWidget {
  final String Id;
  final bool delchek;
  const FileDowloadPage({super.key, required this.Id, required this.delchek});

  @override
  State<FileDowloadPage> createState() => _FileDowloadPageState();
}

class _FileDowloadPageState extends State<FileDowloadPage> {
  List<dynamic> data = [];
  bool noatc = false;
  final StreamController _streamController = StreamController();
  late Timer _timer;

  void _loadData() {
    final attachments = MockRepository.getAttachments(widget.Id);
    if (mounted) {
      setState(() {
        data  = attachments;
        noatc = attachments.isEmpty;
        _streamController.add(data);
      });
    }
  }

  void _deleteFile(String name, AppColors colors) {
    MockRepository.deleteAttachment(widget.Id, name);
    EasyLoading.instance
      ..loadingStyle = EasyLoadingStyle.custom
      ..backgroundColor = colors.surface
      ..textColor = colors.text
      ..indicatorColor = colors.primary
      ..maskColor = Colors.black26
      ..dismissOnTap = false;
    EasyLoading.showSuccess('File Deleted!');
    _loadData();
  }

  @override
  void initState() {
    _loadData();
    _timer = Timer.periodic(const Duration(seconds: 3), (_) => _loadData());
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
          backgroundColor: Colors.transparent,
          elevation: 0,
          title: Padding(
            padding: const EdgeInsets.only(right: 25),
            child: Center(
              child: Text('File Download',
                  style: GoogleFonts.poppins(
                      fontSize: 20,
                      color: colors.text,
                      fontWeight: FontWeight.bold)),
            ),
          ),
          leading: IconButton(
            icon: Icon(Icons.chevron_left, color: colors.text, size: 35),
            onPressed: () => Navigator.pop(context),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundImage: NetworkImage(box.read('profile')),
                backgroundColor: const Color(0xFF507EFF),
                radius: 17,
              ),
            )
          ],
        ),
        body: Column(
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            StreamBuilder(
              stream: _streamController.stream,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                      child: CircularProgressIndicator(color: colors.primary));
                }
                if (noatc) {
                  return Center(
                    child: Text('No Attachment',
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colors.textMuted)),
                  );
                }
                return Expanded(
                  child: GridView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: data.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemBuilder: (context, index) {
                      final filename = data[index]['Filename'].toString().trim();
                      return InkWell(
                        onLongPress: () {
                          if (widget.delchek) {
                            _deleteFile(filename, colors);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('You are not allowed to delete documents!'),
                              ),
                            );
                          }
                        },
                        onTap: () =>
                            FileOperationdart.Fileopener(context, filename),
                        child: Container(
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: colors.shadow.withOpacity(0.15),
                                spreadRadius: 0,
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.description_outlined,
                                  size: 50, color: colors.primary),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: Text(filename,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                        fontSize: 12, color: colors.text)),
                              ),
                              InkWell(
                                onTap: () => FileOperationdart.downloadFile(
                                    context, filename, widget.Id),
                                child: Icon(Icons.download_for_offline_rounded,
                                    size: 28, color: colors.primary),
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
