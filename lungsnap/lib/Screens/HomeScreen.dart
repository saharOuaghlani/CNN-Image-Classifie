import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lungsnap/Constants/appColors.dart';
import 'package:lungsnap/Screens/SideMenu.dart';
import 'package:lungsnap/Screens/resultScreen.dart';
import 'package:lungsnap/Screens/take_picture_page.dart';

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
        title: const Text("LungSnap",
            style: TextStyle(
                color: Colors.black,
                fontSize: 26,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        shape:
            const Border(bottom: BorderSide(width: 1.5, color: secondaryColor)),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/welcomeImages/landpage.png",
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                    "Tap the camera button to take a new scan. Ensure good lighting for accurate results.",
                    style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 10.0),
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
                          size: 26,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Open camera',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              const Padding(
                padding: EdgeInsets.all(15.0),
                child: Text(
                    "Use the gallery button to upload an existing image. Choose from your saved scans or X-rays.",
                    style: TextStyle(fontSize: 16)),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 40.0, vertical: 10.0),
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
                          size: 26,
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        Text(
                          'Upload image from gallery',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
