import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:onlineclass/admin_screen/admin_add_user.dart';
import 'package:onlineclass/admin_screen/admin_screen.dart';
import 'package:onlineclass/admin_screen/admin_users_list.dart';
import 'package:onlineclass/user_screen/login_screen.dart';
import 'package:onlineclass/user_screen/profile_screens.dart';
import 'package:onlineclass/user_screen/user_main_screen.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/getStoredString.dart';
import 'package:shared_preferences/shared_preferences.dart';

int? isSelected;
String? userType;

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
        statusBarColor: colorBack1, systemNavigationBarColor: colorBack1),
  );
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  await GetUserData.init();
  await GetStoredData.init();

  userType = GetUserData.getString()??'';
  getClass(){
    if(userType=='Admin'){
      return const AdminScreen();
    }
    else if(userType=='User') {
      return const UserMainScreen();
    }
    else {
      return const UserLogin();
    }
  }

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      home:const UserLogin(),
      routes: {
        '/UserMainScreen': (ctx) => const UserMainScreen(),
        '/Profile': (ctx) => const ProfileScreen(),
        '/AdminScreen':(ctx)=> const AdminScreen(),
        '/AdminLoginPage':(ctx)=> const AdminAddUser(),
        '/AdminUsersList':(ctx)=> const AdminUsersList()
      },
    ),
  );
}
