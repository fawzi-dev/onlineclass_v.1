import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:onlineclass/admin_screen/admin_stage_screen.dart';
import 'package:onlineclass/user_screen/login_page.dart';
import 'package:onlineclass/user_screen/profile_screens.dart';
import 'package:onlineclass/user_screen/user_main_screen.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/getStoredString.dart';
import 'package:shared_preferences/shared_preferences.dart';
int? isSelected;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: colorBack1, systemNavigationBarColor: colorBack1),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  GetStoredData.init();
  SharedPreferences pref = await SharedPreferences.getInstance();
  isSelected=pref.getInt('stageKeys');


  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:isSelected!=0?const LoginPage():const AdminStageScreen(),
      initialRoute: '/',
      routes: {
        '/MainScreen': (ctx) => const UserMainScreen(),
        '/Profile': (ctx) => const ProfileScreen()
      },
    ),
  );
}
