import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onlineclass/admin_screen/admin_screen.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/user_screen/user_main_screen.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/snack_bar.dart';
import '../utlities/getStoredString.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key, this.tappedButton, this.userDocumentID})
      : super(key: key);

  final String? tappedButton;
  final String? userDocumentID;

  @override
  State<UserLogin> createState() => _UserLoginState();
}

class _UserLoginState extends State<UserLogin> {
  /// Firebase instance
  final _firebase = FirebaseFirestore.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///User instance
  User? loggedUser;

  /// TextEditing controllers
  String? userId, password, name, stage;

  /// Spiner sate variable
  bool isSpinning = false;

  String dropDownValue = 'Select Stage';
  String? userType;

  List<String> stages = [
    'Select Stage',
    'Stage1',
    'Stage2',
    'Stage3',
    'Stage 4 - Programming',
    'Stage 5 - Programming',
    'Stage 4 - Network',
    'Stage 5 - Network'
  ];

  @override
  void initState() {
    super.initState();
    userType = GetUserData.getString() ?? 'Null';
    debugPrint('User Data' + userType!);
    // debugPrint('User Stage'+GetStoredData.getString().toString());
  }

  // checkAuthentication() async {
  //   _auth.authStateChanges().listen((user) {
  //     if(dropDownValue!='Select Stage'){
  //       if(user!=null){
  //         Navigator.pushNamed(context, '/MainScreen');
  //       }
  //     }
  //   });
  // }

  // getInfo() async{
  //   debugPrint('Shared Pref is called');
  //   int? isSelected=0;
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   preferences.setInt('stageKeys', isSelected);
  //   debugPrint(preferences.getInt('stageKeys').toString());
  // }

  login() async {
    setState(() {
      isSpinning = true;
    });

    // username...
    List<String> usersname = [];
    List<String> passwords = [];
    List<String> userStages = [];
    List<String> userTypes = [];
    List<String> names = [];

    // Get  users
    final user = await _firebase.collection('users').get();
    for (var userInfo in user.docs) {
      /// name = ali
      final name = userInfo.get('name');
      // useranme = ali
      final username = userInfo.get('username');
      // password = 111
      final password = userInfo.get('password');
      // stage = .....
      final stage = userInfo.get('stage');
      /// userType = ....
      final userType = userInfo.get('userrole');

      names.add(name);
      usersname.add(username);
      passwords.add(password);
      userStages.add(stage);
      userTypes.add(userType);
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      try {
        for (var i = 0; i < usersname.length; i++) {
          if (usersname[i] == userId &&
              passwords[i] == password &&
              userTypes[i] == 'Admin') {
            
            /// To notify user that they are logged in
            showSnackBar(context, 'Admin logged in!', Colors.green);

            /// to persist  data  in local database
            await GetUserData.setString('Admin', names[i], usersname[i]);

            //  To navigate
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const AdminScreen(),
                ),
                (Route<dynamic> route) => false);
          }
          // check if user credentials are correct
          else if (usersname[i] == userId &&
              passwords[i] == password &&
              userTypes[i] == 'User' &&
              dropDownValue != 'Select Stage' &&
              userStages[i] == dropDownValue) {

                /// To notify
            showSnackBar(context, 'User logged in!', Colors.green);

            /// .....
            await GetUserData.setString('User', names[i], usersname[i]);

            ///  Stage 1
            GetStoredData.setString(dropDownValue);
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (ctx) => const UserMainScreen(),
                ),
                (Route<dynamic> route) => false);
            break;
          }
          // check if textBox are not empty
          else if (userId == '' || password == '') {
            showSnackBar(context, 'Please input information correctly',
                Colors.redAccent);
            break;
          } else if (usersname[i].contains(userId!) == true ||
              usersname[i].contains(password!) == true) {
            showSnackBar(
                context,
                'Username or password is incorrect, or stage may not be selected!',
                Colors.redAccent);
            break;
          }
        }
      } catch (e) {
       
        showSnackBar(context, 'Some errors occurred!', Colors.black38);
      }
    }
    setState(() {
      isSpinning = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isSpinning,
        child: SafeArea(
          child: LayoutBuilder(
            builder: (ctx, constraints) => Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [
                  colorBack1,
                  darkBlue,
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  /// Text fields
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                child: TextFormField(
                                    style: kInputStyle,
                                    decoration: InputDecoration(
                                      hintStyle: kInputStyle,
                                      prefixIconColor: cyan,
                                      hintText: 'Username',
                                    ),
                                    onSaved: (input) => userId = input!),
                              ),
                              TextFormField(
                                  style: kInputStyle,
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: kInputStyle,
                                    prefixIconColor: cyan,
                                  ),
                                  obscureText: true,
                                  onSaved: (input) => password = input!),
                              SizedBox(height: constraints.maxHeight * 0.02),
                            ],
                          ),
                        ),
                        DropdownButton(
                          // Initial Value
                          value: dropDownValue,

                          // Down Arrow Icon
                          icon: const Icon(Icons.keyboard_arrow_down),

                          // Color
                          dropdownColor: skyBlue,
                          // Array list of items
                          items: stages.map((String stage) {
                            return DropdownMenuItem(
                              value: stage,
                              child: Text(
                                stage,
                                style: dropDownStyle,
                              ),
                            );
                          }).toList(),
                          // After selecting the desired option,it will
                          // change button value to selected value
                          onChanged: (String? newValue) {
                            setState(() {
                              dropDownValue = newValue!;
                              debugPrint(
                                  'Selected Value ::::: ' + dropDownValue);
                            });
                          },
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        SizedBox(
                          width: constraints.maxWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: login,
                            child: const Text(
                              'Login',
                              style: kLoginStyle,
                            ),
                          ),
                        ),
                        SizedBox(height: constraints.maxHeight * 0.025),
                        const Divider(
                          height: 1,
                          thickness: 1.5,
                          color: Colors.white24,
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class TextFields extends StatelessWidget {
  final String hintText;
  final Function(String) onChanged;

  const TextFields({Key? key, required this.hintText, required this.onChanged})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      decoration: InputDecoration(
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white24),
        ),
        hintText: hintText,
        hintStyle: kTextField,
        prefix: const SizedBox(width: 25),
      ),
      style: kInputStyle,
    );
  }
}
