import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/data/mock_repository.dart';

class Attachmentdata extends StatefulWidget {
  final String Id;
  const Attachmentdata({super.key, required this.Id});

  @override
  State<Attachmentdata> createState() => _AttachmentdataState();
}

class _AttachmentdataState extends State<Attachmentdata> {
  List<dynamic> data = [];
  bool noatc = false;
  final StreamController _streamController = StreamController();
  late Timer _timer;

  void _loadData() {
    final attachments = MockRepository.getAttachments(widget.Id);
    if (mounted) {
      setState(() {
        data   = attachments;
        noatc  = attachments.isEmpty;
        _streamController.add(data);
      });
    }
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

    return Padding(
      padding: const EdgeInsets.only(right: 10, top: 15),
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.86,
        child: StreamBuilder(
          stream: _streamController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator(color: colors.primary));
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
            return SizedBox(
              height: 65,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const ScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: data.length,
                itemBuilder: (context, index) {
                  final filename = data[index]['Filename'].toString().trim();
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: InkWell(
                      onTap: () => FileOperationdart.Fileopener(context, filename),
                      child: Container(
                        height: MediaQuery.of(context).size.height * 0.10,
                        width: MediaQuery.of(context).size.width * 0.70,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: colors.shadow.withOpacity(0.12),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.07,
                              width: MediaQuery.of(context).size.width * 0.18,
                              child: FittedBox(
                                child: Icon(Icons.description_outlined,
                                    color: colors.primary, size: 30),
                              ),
                            ),
                            Expanded(
                              child: Text(filename,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.poppins(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: colors.text)),
                            ),
                            IconButton(
                              onPressed: () => FileOperationdart.downloadFile(
                                  context, filename, widget.Id),
                              icon: Icon(Icons.download, color: colors.primary),
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
        ),
      ),
    );
  }
}
