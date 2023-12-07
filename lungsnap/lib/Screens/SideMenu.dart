import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lungsnap/Constants/appColors.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({super.key});

  @override
  Widget build(BuildContext context) {
    Future ExitApp() {
      return showDialog<void>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Center(child: Text('Quitter l\'application')),
            content: SingleChildScrollView(
              child: ListBody(
                children: const <Widget>[
                  Text('Vous allez quitter l\'application ?'),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('Annuler',
                      style: TextStyle(color: secondaryColor)),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                child: const Text('Quitter',
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

    Future shareApp() {
      return showDialog<void>(
        context: context,
        barrierDismissible: true, // user must tap button!
        builder: (BuildContext context) {
          return AlertDialog(
            actionsAlignment: MainAxisAlignment.center,
            title: const Center(
                child: Text(
              'Noter et partager ',
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
                      })),
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Parlez-en à vos amis, à votre famille et à vos voisins.',
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
                          color: const Color.fromARGB(255, 10, 233, 2),
                          iconSize: 50,
                          onPressed: () => print("share what's up"),
                          icon: const Icon(Icons.whatshot)),
                      IconButton(
                          color: const Color.fromRGBO(56, 83, 149, 1),
                          iconSize: 50,
                          onPressed: () => print("share facebook"),
                          icon: const Icon(Icons.facebook)),
                      IconButton(
                          color: const Color.fromRGBO(3, 169, 244, 0.9),
                          iconSize: 50,
                          onPressed: () => print("share what's up"),
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
                  "Fermer",
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
          // Remove padding
          padding: EdgeInsets.zero,
          children: [
            const UserAccountsDrawerHeader(
              accountName: Text(' '),
              accountEmail: Text(" "),
              decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.fill,
                    image: AssetImage("assets/welcomeImages/123.jpg")),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.share),
              title: const Text('Partager'),
              onTap: () => shareApp(),
            ),
            const Divider(),
            ListTile(
                title: const Text('Fermer l\'applcation'),
                leading: const Icon(Icons.exit_to_app),
                onTap: () => ExitApp() //=> exit application(),
                ),
          ],
        ),
      ),
    );
  }
}
