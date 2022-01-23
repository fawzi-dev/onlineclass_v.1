import 'package:flutter/material.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/drawer.dart';
import 'package:onlineclass/utlities/colors.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBack1,
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: colorBack1,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 35,vertical: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              child: const Icon(Icons.person),
              backgroundColor: darkBlue,
              radius: 60,
            ),
            const SizedBox(
              height: 10,
            ),
            const Text('John Doe',style: kUser,),
            const SizedBox(
              height: 3,
            ),
            const Text('john_doe1',style: kUserName,),
            const SizedBox(
              height: 20,
            ),
            const ProfileButtons(
              title: 'Change Username',
              icon: Icons.alternate_email_rounded,
            ),
            const SizedBox(
              height: 20,
            ),
            const ProfileButtons(
              title: 'Change Name',
              icon: Icons.person,
            )
          ],
        ),
      ),
    );
  }
}

class ProfileButtons extends StatelessWidget {
  const ProfileButtons({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){},
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(5),
        width: double.infinity,
        decoration: BoxDecoration(
            color: darkBlue, borderRadius: BorderRadius.circular(3)),
        child: Row(
          children: [
            Icon(
              icon,
              color: cyan,
            ),
            const SizedBox(width: 5),
            Text(
              title,
              style: kProfileBtn,
            )
          ],
        ),
      ),
    );
  }
}
