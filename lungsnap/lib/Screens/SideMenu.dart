import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lungsnap/Constants/appColors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({Key? key});

  @override
  Widget build(BuildContext context) {
    Future<void> exitApp() {
      return showDialog<void>(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Exit the application')),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Are you sure you want to exit the application?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: const Text('Cancel',
                    style: TextStyle(color: secondaryColor)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              TextButton(
                child: const Text('Exit',
                    style: TextStyle(
                        color: errorColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                onPressed: () {
                  SystemChannels.platform.invokeMethod('SystemNavigator.pop');
                },
              )
            ],
          );
        },
      );
    }

    Future<void> shareApp() {
      return showDialog<void>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Center(
                child: Text(
              'Rate and Share ',
              style: TextStyle(
                  color: primaryColor,
                  fontStyle: FontStyle.italic,
                  fontSize: 35),
            )),
            content: SingleChildScrollView(
              child: ListBody(
                children: <Widget>[
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return Icon(
                        index < 4 ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 45,
                      );
                    }),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Tell your friends, family, and neighbors about LungSnap.',
                    style: TextStyle(fontStyle: FontStyle.italic),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      IconButton(
                          color: Color.fromARGB(255, 44, 44, 44),
                          iconSize: 50,
                          onPressed: () => print("share on Tiktok"),
                          icon: const Icon(Icons.tiktok)),
                      IconButton(
                          color: const Color.fromRGBO(56, 83, 149, 1),
                          iconSize: 50,
                          onPressed: () => print("share on Facebook"),
                          icon: const Icon(Icons.facebook)),
                      IconButton(
                          color: const Color.fromRGBO(3, 169, 244, 0.9),
                          iconSize: 50,
                          onPressed: () => print("share via Message"),
                          icon: const Icon(Icons.message_outlined)),
                    ],
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  "Close",
                  style: TextStyle(fontSize: 15, color: Colors.grey),
                ),
              ),
            ],
          );
        },
      );
    }

    return SafeArea(
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(' '),
              accountEmail: Text(" "),
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/welcomeImages/sideBar.jpg")),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Share LungSnap'),
              onTap: () => shareApp(),
            ),
            const Divider(),
            ListTile(
              title: const Text('Exit application'),
              leading: const Icon(Icons.exit_to_app),
              onTap: () => exitApp(),
            ),
          ],
        ),
      ),
    );
  }
}
