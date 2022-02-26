import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/getStoredString.dart';

import '../constants/constants.dart';

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



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    name = GetUserData.getNameString();
    username = GetUserData.getUsernameString();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: Container(
              alignment: Alignment.bottomLeft,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              color: skyBlue,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children:  [
                  const CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 40,
                    backgroundColor: Colors.cyan,
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text(
                        name as String,
                        style: kUser,
                      ),
                      subtitle:  Padding(
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
                    title: 'Profile',
                    icon: Icons.person,
                    onTap: () {
                      Navigator.pushNamed(context, '/Profile');},
                  ),
                  DrawerButtons(
                    title: 'Settings',
                    icon: Icons.settings,
                    onTap: () {},
                  ),
                  DrawerButtons(
                    title: 'Exit',
                    icon: Icons.exit_to_app_sharp,
                    onTap: () {},
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
          color: skyBlue,
        ),
        title: Text(
          title,
          style: kDrawerBtn,
        ),
      ),
    );
  }
}
