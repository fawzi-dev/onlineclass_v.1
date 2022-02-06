import 'package:flutter/material.dart';
import 'package:onlineclass/utlities/colors.dart';

import '../constants/constants.dart';

class Drawers extends StatelessWidget {
  const Drawers({
    Key? key,
  }) : super(key: key);

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
                children: const [
                  CircleAvatar(
                    child: Icon(Icons.person),
                    radius: 40,
                    backgroundColor: Colors.cyan,
                  ),
                  Flexible(
                    child: ListTile(
                      title: Text(
                        'John Doe',
                        style: kUser,
                      ),
                      subtitle: Padding(
                        padding: EdgeInsets.only(left: 4.0),
                        child: Text(
                          'john_doe1',
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
