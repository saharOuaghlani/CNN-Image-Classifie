import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lungsnap/Constants/appColors.dart';
import 'package:lungsnap/Screens/ResultCard.dart';

import '../Services/Service_image.dart';

class ResultScreen extends StatefulWidget {
  const ResultScreen({super.key, required this.image});
  final File image;
  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          color: primaryColor,
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: backgroundColor,
        centerTitle: true,
        title: const Text("Scan results",
            style: TextStyle(
                color: Colors.black,
                fontSize: 22,
                fontWeight: FontWeight.bold)),
        elevation: 0,
        shape:
            const Border(bottom: BorderSide(width: 1.5, color: secondaryColor)),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              FutureBuilder(
                  future: ServiceImage().uploadImageAndPredict(widget.image),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      Map<String, dynamic> res =
                          snapshot.data as Map<String, dynamic>;

                      return Column(
                        children: [
                          ResultCard(
                            label: res['class_name'], //res["test"],
                            probability: res['prediction'],
                            description: getDescription(res['class_name']),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Image.file(
                              widget.image,
                              fit: BoxFit.fitWidth,
                              alignment: Alignment.bottomCenter,
                            ),
                          ),
                        ],
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
              const SizedBox(
                height: 20,
              )
            ],
          ),
        ),
      ),
    );
  }

  String getDescription(String label) {
    // Provide descriptions for each classification label
    switch (label) {
      case 'NORMAL':
        return 'Your lung image appears normal. No signs of abnormalities detected.';
      case 'COVID':
        return 'There are indications of COVID-19 in your lung image. Please consult with a healthcare professional for further evaluation.';
      // Add more cases for other classifications as needed
      default:
        return 'Description not available.';
    }
  }
}
