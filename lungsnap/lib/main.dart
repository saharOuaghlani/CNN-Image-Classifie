import 'package:flutter/material.dart';
import 'package:lungsnap/Screens/welcomeScreen.dart';
import 'package:lungsnap/Services/Service_image.dart';

void main() async {
  await ServiceImage().connectToServer();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LungSnap',
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(),
    );
  }
}
