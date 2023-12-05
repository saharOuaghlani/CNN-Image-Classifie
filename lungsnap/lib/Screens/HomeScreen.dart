import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lungsnap/Screens/take_picture_page.dart';

import '../Configs/init_configurations.dart';
import '../Constants/TextInputs.dart';
import '../Services/Service_image.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      ServiceImage().uploadImage(File(pickedFile!.path));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final cameras = await availableCameras();

                  if (context.mounted) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TakePictureScreen(
                          // Pass the appropriate camera to the TakePictureScreen widget.
                          camera: cameras,
                        ),
                      ),
                    );
                  }
                },
                child: Text("Open Camera"),
              ),
              const SizedBox(
                height: 15,
              ),
              ElevatedButton(
                onPressed: () async {
                  await pickImage();
                },
                child: Text("Upload from phone"),
              )
            ],
          ),
        ),
      ),
    );
  }
}
