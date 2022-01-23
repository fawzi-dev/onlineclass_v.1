import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:onlineclass/login_page.dart';
import 'package:onlineclass/main_screen.dart';
import 'package:onlineclass/profile_screens.dart';
import 'package:onlineclass/stage_screen.dart';
import 'package:onlineclass/utlities/colors.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle( SystemUiOverlayStyle(
      statusBarColor: colorBack1, systemNavigationBarColor: colorBack1),);
  runApp(
    MaterialApp(
      home: const LoginPage(),
      initialRoute: '/',
      routes: {
        '/Stages': (ctx) => const StageScreen(),
        '/MainScreen': (ctx) => const MainScreen(),
        '/Profile': (ctx) => const ProfileScreen()
      },
    ),
  );
}
