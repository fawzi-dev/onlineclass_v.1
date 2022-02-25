import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onlineclass/admin_screen/admin_users_list.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/snack_bar.dart';
import '../utlities/user_model.dart';

class UserLogin extends StatefulWidget {
  const UserLogin({Key? key, this.tappedButton, this.userDocumentID}) : super(key: key);

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
  String userValue = 'Select Role';

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

  List<String> roles = [
    'Select Role',
    'Admin',
    'User',
  ];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // checkAuthentication();
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
    List<String> usersname = [];
    List<String> passwords = [];
    List<String> userStages = [];
    List<String> userTypes = [];

    final user = await _firebase.collection('users').get();
    for (var userInfo in user.docs) {
      final username = userInfo.get('username');
      final password = userInfo.get('password');
      final stage = userInfo.get('stage');
      final userType = userInfo.get('userrole');
      usersname.add(username);
      passwords.add(password);
      userStages.add(stage);
      userTypes.add(userType);
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      String? stage;
      try {
        // check if user exists with the same name
        if (usersname.any((element) => element == userId && passwords.any((element) => element == password&&userTypes.any((element) => element=='Admin')))) {
          showSnackBar(context, 'Admin logged in!', Colors.redAccent);
        }
        else if(usersname.any((element) => element == userId && passwords.any((element) => element == password&&userTypes.any((element) => element=='User' && userStages.any((element) => element==dropDownValue))))){
          showSnackBar(context, 'User logged in!', Colors.redAccent);
        }
        // check if textBox are not empty
        else if (name == '' || userId == '' || password == '') {
          showSnackBar(
              context, 'Please input information correctly', Colors.redAccent);
        }
          else {
          showSnackBar(
              context, 'Please input information correctly', Colors.redAccent);
        }
      } catch (e) {
        if (e.hashCode == 34618382) {
          showSnackBar(context, 'Email already in use', Colors.black38);
        }
      }
    }
    setState(() {
      isSpinning = false;
    });
  }

  // postDetailsToFirestore(String username, String role, String stage) async {
  //   FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
  //   UserModel userModel = UserModel();
  //   userModel.username = userId;
  //   userModel.password = password;
  //   userModel.name = name;
  //   userModel.userRole = role;
  //   userModel.stage = stage;
  //   await firebaseFirestore.collection("users").doc().set(userModel.toMap());
  //   showSnackBar(context, 'User created', Colors.green);
  //   Navigator.pushAndRemoveUntil(
  //     context,
  //     MaterialPageRoute(
  //       builder: (ctx) => AdminUsersList(
  //         key: UniqueKey(),
  //       ),
  //     ),
  //    (Route<dynamic> route) => false
  //   );
  // }

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
                        userValue == roles[2]
                            ? DropdownButton(
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
                                    debugPrint('Selected Value ::::: ' +
                                        dropDownValue);
                                  });
                                },
                              )
                            : Container(),
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            DropdownButton(
                              // Initial Value
                              value: userValue,

                              // Down Arrow Icon
                              icon: const Icon(Icons.keyboard_arrow_down),

                              // Color
                              dropdownColor: skyBlue,
                              // Array list of items
                              items: roles.map((String roles) {
                                return DropdownMenuItem(
                                  value: roles,
                                  child: Text(
                                    roles,
                                    style: dropDownStyle,
                                  ),
                                );
                              }).toList(),
                              // After selecting the desired option,it will
                              // change button value to selected value
                              onChanged: (String? newValue) {
                                setState(() {
                                  userValue = newValue!;
                                });
                              },
                            ),
                          ],
                        )
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