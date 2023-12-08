import 'package:flutter/material.dart';
import 'package:lungsnap/Constants/appColors.dart';
import 'package:lungsnap/Screens/HomeScreen.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

List items = [
  {
    "header": "Test Lung Images",
    "description":
        "Explore the power of our machine learning model by testing various lung images. Determine the accuracy in classifying COVID, NORMAL, and PNEUMONIA cases.",
    "image": "assets/welcomeImages/123.jpg",
  },
  {
    "header": "Health Insights",
    "description":
        "Unlock a wealth of health information as we analyze and interpret your X-ray images, offering detailed insights into your thoracic well-being.",
    "image": "assets/welcomeImages/456.png",
  },
];

class _WelcomeScreenState extends State<WelcomeScreen> {
  double currentPage = 0.0;
  final _pageViewController = new PageController();
  List<Widget> slides = items
      .map((item) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 18.0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 50,
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Image.asset(
                  item['image'],
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.bottomCenter,
                ),
              ),
              Flexible(
                flex: 1,
                fit: FlexFit.tight,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Column(
                    children: <Widget>[
                      Text(item['header'],
                          style: const TextStyle(
                              fontSize: 30.0,
                              fontWeight: FontWeight.w300,
                              color: Color(0XFF3F3D56),
                              height: 2.0)),
                      Text(
                        item['description'],
                        style: const TextStyle(
                            color: Colors.grey,
                            letterSpacing: 1.2,
                            fontSize: 16.0,
                            height: 1.3),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              )
            ],
          )))
      .toList();
  List<Widget> indicator() => List<Widget>.generate(
      slides.length,
      (index) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 3.0),
            height: 10.0,
            width: 10.0,
            decoration: BoxDecoration(
                color: currentPage.round() == index
                    ? const Color(0XFF256075)
                    : const Color(0XFF256075).withOpacity(0.2),
                borderRadius: BorderRadius.circular(10.0)),
          ));
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: <Widget>[
            Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 70.0),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: indicator(),
                  ),
                )),
            PageView.builder(
              controller: _pageViewController,
              itemCount: slides.length,
              itemBuilder: (BuildContext context, int index) {
                _pageViewController.addListener(() {
                  setState(() {
                    currentPage = _pageViewController.page!;
                  });
                });
                return slides[index];
              },
            ),
            if (currentPage.round() == 1.0)
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  margin: const EdgeInsets.only(top: 70.0),
                  padding: const EdgeInsets.symmetric(vertical: 40.0),
                  child: Padding(
                    padding: const EdgeInsets.all(50.0),
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor),
                        onPressed: () {
                          print("btn pushed");
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const HomeScreen()));
                        },
                        child: const Text(
                          "Start",
                          style: TextStyle(color: Colors.white, fontSize: 20),
                        )),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
