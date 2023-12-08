import 'dart:io';

import 'package:flutter/material.dart';
import 'package:lungsnap/Constants/appColors.dart';

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
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.file(
                widget.image,
                fit: BoxFit.fitWidth,
                alignment: Alignment.bottomCenter,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: FutureBuilder(
                  future: ServiceImage().uploadImage(widget.image),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done &&
                        snapshot.hasData) {
                      Map<String, dynamic> res =
                          snapshot.data as Map<String, dynamic>;
                      return Text(res["test"]);
                    } else {
                      return const CircularProgressIndicator();
                    }
                  }),
            ),
            const SizedBox(
              height: 20,
            )
          ],
        ),
      ),
    );
  }
}
