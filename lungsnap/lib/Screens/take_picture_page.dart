import 'dart:developer' as developer;
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:lungsnap/Services/Service_image.dart';

class TakePictureScreen extends StatefulWidget {
  const TakePictureScreen({
    super.key,
    required this.camera,
  });

  final List<CameraDescription> camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();
}

class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late bool _isRearCameraSelected;
  late bool confirm;
  late bool isFlash;
  late XFile image;

  Future<void> initCamera(CameraDescription cameraDescription) async {
    _controller = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await _controller.initialize();
      _controller.setFocusMode(FocusMode.locked);

      if (!mounted) return;

      setState(() {});
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }

  @override
  void initState() {
    super.initState();
    _isRearCameraSelected = true;
    confirm = false;
    isFlash = false;
    initCamera(widget.camera[0])
        .whenComplete(() => _controller.setFlashMode(FlashMode.off));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    return SafeArea(child: Scaffold(
      body: OrientationBuilder(
        builder: (context, orientation) {
          return (orientation == Orientation.portrait)
              ? Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.black,
                      height: size.height * 0.08,
                      child: (confirm)
                          ? null
                          : Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_back,
                                      size: (size.height * 0.03),
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 30.0),
                                  child: IconButton(
                                    icon: Icon(
                                      (isFlash)
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                      size: (size.height * 0.03),
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (isFlash) {
                                        isFlash = !isFlash;
                                        _controller.setFlashMode(FlashMode.off);
                                      } else {
                                        isFlash = !isFlash;
                                        _controller
                                            .setFlashMode(FlashMode.torch);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Expanded(
                      child: (!confirm)
                          ? (_controller.value.isInitialized)
                              ? CameraPreview(_controller)
                              : Container(
                                  color: Colors.black,
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                          : SizedBox(
                              height: size.height * 0.8,
                              width: size.width,
                              child: Image.file(
                                File(image.path),
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                    (!confirm)
                        ? Container(
                            color: Colors.black,
                            height: size.height * 0.1,
                            padding: EdgeInsets.symmetric(
                                horizontal: size.width * 0.07),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: size.height * 0.03,
                                  icon: const Icon(Icons.cameraswitch_outlined,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() => _isRearCameraSelected =
                                        !_isRearCameraSelected);
                                    initCamera(widget
                                        .camera[_isRearCameraSelected ? 0 : 1]);
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      image = await _controller.takePicture();
                                      if (!_isRearCameraSelected) {
                                        img.Image flippedImage = img.decodeJpg(
                                            await image.readAsBytes())!;
                                        flippedImage =
                                            img.flipHorizontal(flippedImage);
                                        await img.encodeJpgFile(
                                            image.path, flippedImage);
                                      }
                                      // display the confirm
                                      setState(() {
                                        confirm = !confirm;
                                      });
                                    } catch (e) {
                                      developer.log(e.toString(),
                                          name: "exception in takePicture");
                                    }
                                  },
                                  icon: Container(
                                    width: size.height * 0.05,
                                    height: size.height * 0.05,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.photo_camera,
                                        color: Colors.white,
                                        size: size.height * 0.035),
                                  ),
                                ),
                                SizedBox(
                                  width: size.height * 0.045,
                                  height: size.height * 0.045,
                                ),
                              ],
                            ),
                          )
                        : Container(
                            color: Colors.black,
                            height: size.height * 0.08,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      _controller
                                          .setFocusMode(FocusMode.locked);

                                      //     await _initializeControllerFuture;
                                      setState(() {
                                        confirm = !confirm;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.repeat_rounded,
                                      color: Colors.white,
                                      size: size.height * 0.03,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
                                      ServiceImage()
                                          .uploadImage(File(image.path));
                                      Navigator.pop(context);

                                      /* try {
                                        //getting the audit folder name if exists
                                         int auditId =
                                            Provider.of<CurrentWorkingAudit>(
                                                    context,
                                                    listen: false)
                                                .workingAudit
                                                .id!;
                                        String pathToFolder =
                                            await InitConfiguration
                                                .createAuditFolderInAppDocDir(
                                                    auditId.toString());

                                        String imageName = DateTime.now()
                                            .toString()
                                            .substring(0, 19);
                                        await image.saveTo(
                                            '$pathToFolder$imageName.jpeg');  
                                        //await Future.delayed(const Duration(seconds: 1));

                                        if (!mounted) return;

                                        await Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DisplayPictureScreen(
                                              // Pass the generated path to
                                              // the DisplayPictureScreen widget + criteria id .
                                              imagePath:
                                                  pathToFolder + imageName,
                                              idCriteria: widget.idCriteria,
                                            ),
                                          ),
                                        );
                                      } on Exception catch (e) {
                                        developer.log(e.toString(),
                                            name: "exception in saving image");
                                      } */
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: size.height * 0.035,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                )
              : Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      color: Colors.black,
                      width: size.width * 0.08,
                      child: (confirm)
                          ? null
                          : Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30.0),
                                  child: IconButton(
                                    icon: Icon(
                                      (isFlash)
                                          ? Icons.flash_on
                                          : Icons.flash_off,
                                      size: (size.height * 0.03),
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      if (isFlash) {
                                        isFlash = !isFlash;
                                        _controller.setFlashMode(FlashMode.off);
                                      } else {
                                        isFlash = !isFlash;
                                        _controller
                                            .setFlashMode(FlashMode.torch);
                                      }
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 30.0),
                                  child: IconButton(
                                    icon: Icon(
                                      Icons.arrow_forward,
                                      size: (size.height * 0.03),
                                      color: Colors.white,
                                    ),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                  ),
                                ),
                              ],
                            ),
                    ),
                    Expanded(
                      child: (!confirm)
                          ? (_controller.value.isInitialized)
                              ? CameraPreview(_controller)
                              : Container(
                                  color: Colors.black,
                                  child: const Center(
                                      child: CircularProgressIndicator()))
                          : SizedBox(
                              height: size.height * 0.8,
                              width: size.width,
                              child: Image.file(
                                File(image.path),
                                fit: BoxFit.fill,
                              ),
                            ),
                    ),
                    (!confirm)
                        ? Container(
                            color: Colors.black,
                            width: size.width * 0.1,
                            padding: EdgeInsets.symmetric(
                                vertical: size.width * 0.07),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                IconButton(
                                  padding: EdgeInsets.zero,
                                  constraints: const BoxConstraints(),
                                  iconSize: size.height * 0.03,
                                  icon: const Icon(Icons.cameraswitch_outlined,
                                      color: Colors.white),
                                  onPressed: () {
                                    setState(() => _isRearCameraSelected =
                                        !_isRearCameraSelected);
                                    initCamera(widget
                                        .camera[_isRearCameraSelected ? 0 : 1]);
                                  },
                                ),
                                IconButton(
                                  onPressed: () async {
                                    try {
                                      image = await _controller.takePicture();
                                      if (!_isRearCameraSelected) {
                                        img.Image flippedImage = img.decodeJpg(
                                            await image.readAsBytes())!;
                                        flippedImage =
                                            img.flipHorizontal(flippedImage);
                                        await img.encodeJpgFile(
                                            image.path, flippedImage);
                                      }
                                      // display the confirm
                                      setState(() {
                                        confirm = !confirm;
                                      });
                                    } catch (e) {
                                      developer.log(e.toString(),
                                          name: "exception in takePicture");
                                    }
                                  },
                                  icon: Container(
                                    width: size.height * 0.05,
                                    height: size.height * 0.05,
                                    decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Colors.white, width: 2.0),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.photo_camera,
                                        color: Colors.white,
                                        size: size.height * 0.035),
                                  ),
                                ),
                                SizedBox(
                                  width: size.height * 0.045,
                                  height: size.height * 0.045,
                                ),
                              ],
                            ),
                          )
                        : //image is taken : validation of image
                        Container(
                            color: Colors.black,
                            height: size.height * 0.08,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  IconButton(
                                    onPressed: () async {
                                      _controller
                                          .setFocusMode(FocusMode.locked);

                                      //     await _initializeControllerFuture;
                                      setState(() {
                                        confirm = !confirm;
                                      });
                                    },
                                    icon: Icon(
                                      Icons.repeat_rounded,
                                      color: Colors.white,
                                      size: size.height * 0.03,
                                    ),
                                  ),
                                  IconButton(
                                    onPressed: () async {
//upload image to base

                                      /*              try {
                                        //getting the audit folder name if exists
                                        int auditId =
                                            Provider.of<CurrentWorkingAudit>(
                                                    context,
                                                    listen: false)
                                                .workingAudit
                                                .id!;
                                        String pathToFolder =
                                            await InitConfiguration
                                                .createAuditFolderInAppDocDir(
                                                    auditId.toString());

                                        String imageName = DateTime.now()
                                            .toString()
                                            .substring(0, 19);
                                        image.saveTo(
                                            '$pathToFolder$imageName.jpeg');

                                        if (!mounted) return;

                                        await Navigator.of(context)
                                            .pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                DisplayPictureScreen(
                                              // Pass the generated path to
                                              // the DisplayPictureScreen widget + criteria id .
                                              imagePath:
                                                  pathToFolder + imageName,
                                              idCriteria: widget.idCriteria,
                                            ),
                                          ),
                                        );
                                      } on Exception catch (e) {
                                        developer.log(e.toString(),
                                            name: "exception in saving image");
                                      } */
                                    },
                                    icon: Icon(
                                      Icons.check,
                                      color: Colors.white,
                                      size: size.height * 0.035,
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 30,
                                  ),
                                ],
                              ),
                            ),
                          )
                  ],
                );
        },
      ),
    ));
  }
}
