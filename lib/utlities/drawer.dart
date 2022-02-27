import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/user_screen/login_screen.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/getStoredString.dart';

import '../constants/constants.dart';
import '../user_screen/user_main_screen.dart';

class Drawers extends StatefulWidget {
  const Drawers({
    Key? key,
  }) : super(key: key);

  @override
  State<Drawers> createState() => _DrawersState();
}

class _DrawersState extends State<Drawers> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? name;
  String? username;
  List<String> nameSplited=[];

  @override
  void initState() {
    super.initState();
    name = GetUserData.getNameString()??'Name';
    username = GetUserData.getUsernameString();
    name?.split('').forEach((element) {nameSplited.add(element);});
  }


  @override
  Widget build(BuildContext context) {
      debugPrint(nameSplited.first);
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              color: colorBack1,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   CircleAvatar(
                    child: Text(nameSplited.first.toUpperCase() +''+nameSplited.last.toUpperCase(),style: circleAvatar,),
                    radius: 40,
                    backgroundColor: darkBlue,
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text(
                        name as String,
                        style: kUser,
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Text(
                          username as String,
                          style: kUserName,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            flex: 2,
            child: SizedBox(
              child: Column(
                children: [
                  DrawerButtons(
                    title: 'Home',
                    icon: Icons.home,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  DrawerButtons(
                    title: 'Log out',
                    icon: Icons.exit_to_app_sharp,
                    onTap: () {
                      Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (ctx) =>  const UserLogin(),
                          ),
                          (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class DrawerButtons extends StatelessWidget {
  const DrawerButtons({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  final String title;
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: ListTile(
        leading: Icon(
          icon,
          size: 35,
          color: darkBlue,
        ),
        title: Text(
          title,
          style: kDrawerBtn,
        ),
      ),
    );
  }
}
