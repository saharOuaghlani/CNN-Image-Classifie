import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:lungsnap/Constants/appColors.dart';
import 'package:lungsnap/Screens/SideMenu.dart';
import 'package:lungsnap/Screens/resultScreen.dart';
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
  @override
  Widget build(BuildContext context) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      drawer: const SideMenu(),
      appBar: AppBar(
        leading: IconButton(
          color: primaryColor,
          icon: const Icon(Icons.menu),
          onPressed: () {
            scaffoldKey.currentState!.openDrawer();
          },
        ),
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: Text("",
            style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        shape:
            const Border(bottom: BorderSide(width: 1.5, color: secondaryColor)),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.cyan, Colors.indigo])),
                  child: ElevatedButton(
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
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Open camera',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 20.0),
                child: Container(
                  height: 60,
                  decoration: const BoxDecoration(
                      gradient:
                          LinearGradient(colors: [Colors.cyan, Colors.indigo])),
                  child: ElevatedButton(
                    onPressed: () async {
                      final pickedFile = await ImagePicker()
                          .pickImage(source: ImageSource.gallery);
                      if (context.mounted) {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ResultScreen(
                                // Pass the appropriate camera to the TakePictureScreen widget.
                                image: File(pickedFile!.path),
                              ),
                            ));
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0)),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.upload,
                          color: Colors.white,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Upload image from gallery',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
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
