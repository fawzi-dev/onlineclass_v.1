import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:onlineclass/admin_screen.dart';
import 'package:onlineclass/user_screen/main_screen.dart';
import 'package:onlineclass/user_screen/profile_screens.dart';
import 'package:onlineclass/user_screen/stage_screen.dart';
import 'package:onlineclass/utlities/colors.dart';

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: colorBack1, systemNavigationBarColor: colorBack1),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MaterialApp(
      home: const AdminScreen(),
      initialRoute: '/',
      routes: {
        '/Stages': (ctx) => const StageScreen(),
        '/MainScreen': (ctx) => const MainScreen(),
        '/Profile': (ctx) => const ProfileScreen()
      },
    ),
  );
}
