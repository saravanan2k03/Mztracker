// ignore_for_file: unnecessary_null_comparison
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/constant/app_theme.dart';
import 'package:mztrackertodo/functions/variabels.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? file;
  final ImagePicker imagePicker = ImagePicker();

  Future<void> _pickFromGallery() async {
    final img = await imagePicker.pickImage(source: ImageSource.gallery);
    if (img != null) setState(() => file = File(img.path));
  }

  Future<void> _pickFromCamera() async {
    final img = await imagePicker.pickImage(source: ImageSource.camera);
    if (img != null) setState(() => file = File(img.path));
  }

  void _showPicker(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (_) => SimpleDialog(
        title: const Text('Pick an image'),
        children: [
          SimpleDialogOption(
            onPressed: () async { Navigator.pop(context); await _pickFromGallery(); },
            child: const Text('Gallery'),
          ),
          SimpleDialogOption(
            onPressed: () async { Navigator.pop(context); await _pickFromCamera(); },
            child: const Text('Camera'),
          ),
          SimpleDialogOption(
            onPressed: () => Navigator.pop(context),
            child: const Center(child: Text('Cancel')),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;

    return SafeArea(
      child: Scaffold(
        backgroundColor: colors.background,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () => Navigator.pop(context),
            child: Icon(Icons.chevron_left, color: colors.text, size: 35),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              // Avatar picker
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () => _showPicker(context),
                    child: AvatarGlow(
                      glowColor: colors.primary,
                      glowRadiusFactor: 0.3,
                      duration: const Duration(seconds: 2),
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: colors.surface,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: file == null
                              ? Image.network(box.read('profile'), fit: BoxFit.cover)
                              : Image.file(file!, fit: BoxFit.fill),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.20),
              // Name field
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  cursorColor: colors.text,
                  style: TextStyle(color: colors.text),
                  decoration: InputDecoration(
                    labelText: 'Name',
                    labelStyle: TextStyle(color: colors.primary),
                    filled: true,
                    fillColor: colors.surface,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.primary, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: colors.primary, width: 2),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 20),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Update button
              ElevatedButton(
                onPressed: () async {
                  await FileOperationdart.Editprofiledata(
                      file, box.read('employee'), box.read('employee'));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                  padding: const EdgeInsets.symmetric(
                      horizontal: 70, vertical: 15),
                ),
                child: const Text('UPDATE',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
