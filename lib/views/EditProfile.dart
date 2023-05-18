// ignore_for_file: unnecessary_null_comparison
import 'dart:io';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mztrackertodo/api/FileOperation.dart';
import 'package:mztrackertodo/functions/variabels.dart';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  File? file;
  final ImagePicker imagePicker = ImagePicker();

  getImageFromGallery() async {
    var img = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
    return File(img!.path);
  }

  getImageFromCamera() async {
    var img = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {
      file = File(img!.path);
    });
    return File(img!.path);
  }

  Future<File?> show(BuildContext context) {
    return showDialog<File?>(
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          title: const Text('Pick an image'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () async {
                getImageFromGallery();
                Navigator.of(context)
                    .pop(file!.path != null ? File(file!.path) : null);
                if (kDebugMode) {
                  print(file);
                }
                Navigator.pop(context);
              },
              child: const Text('Gallery'),
            ),
            SimpleDialogOption(
              onPressed: () async {
                getImageFromCamera();
                Navigator.of(context)
                    .pop(file!.path != null ? File(file!.path) : null);
                if (kDebugMode) {
                  print(file);
                }
                Navigator.pop(context);
              },
              child: const Text('Camera'),
            ),
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Center(child: Text('Cancel')),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.chevron_left,
              color: Colors.black,
              size: 35,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  InkWell(
                    onTap: () {
                      show(context);
                    },
                    child: AvatarGlow(
                      endRadius: 70,
                      glowColor: Colors.black,
                      duration: const Duration(seconds: 2),
                      child: Container(
                        margin: const EdgeInsets.all(15),
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.black38,
                          borderRadius: BorderRadius.circular(100),
                        ),
                        child: file == null
                            // ignore: prefer_const_constructors
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.network(box.read("profile")),
                              )
                            : ClipRRect(
                                borderRadius: BorderRadius.circular(100),
                                child: Image.file(file!, fit: BoxFit.fill)),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.25),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: TextField(
                    cursorColor: Colors.black,
                    decoration: InputDecoration(
                      labelText: "Name",
                      // ignore: prefer_const_constructors
                      labelStyle: TextStyle(
                        color: MainTextColor,
                      ),
                      border: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MainTextColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: MainTextColor,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 30,
                        vertical: 20,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  FileOperationdart.Editprofiledata(getImageFromGallery(),
                      box.read("employee"), box.read("employee"));
                },
                // ignore: sort_child_properties_last
                child: const Text(
                  "UPDATE",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: MainTextColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(100),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 70,
                    vertical: 15,
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
