import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onlineclass/admin_screen/admin_users_list.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:onlineclass/utlities/snack_bar.dart';
import '../utlities/user_model.dart';
FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;


class AdminAddUser extends StatefulWidget {
  const AdminAddUser({Key? key, this.tappedButton, this.userDocumentID}) : super(key: key);

  final String? tappedButton;
  final String? userDocumentID;

  @override
  State<AdminAddUser> createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
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

  showError(String errormessage) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('ERROR'),
            content: Text(errormessage),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: const Text('OK'),
              )
            ],
          );
        });
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

  signup() async {
    setState(() {
      isSpinning = true;
    });
    List<String> usersname = [];
    final user = await _firebase.collection('users').get();
    for (var userInfo in user.docs) {
      final username = userInfo.get('username');
      usersname.add(username);
    }

    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      String? stage;
      try {
        // check if user exists with the same name
        if (usersname.any((element) => element == userId)) {
          showSnackBar(context, 'Username already in use!', Colors.redAccent);
        }
        // check if textBox are not empty
        else if (name == '' || userId == '' || password == '') {
          showSnackBar(
              context, 'Please input information correctly', Colors.redAccent);
        }
        // check if user role is selected with proper stage
        else if (userValue == 'User' && dropDownValue != stages[0]) {
          stage = dropDownValue;
          getFunc(userId!, userValue, stage);
        }
        // check if admin is selected
        else if (userValue == 'Admin') {
          stage = "";
          getFunc(userId!, userValue, stage);
        } else {
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

 getFunc(String username, String role, String stage)async{
   if(widget.tappedButton=='Add'){
    UserModel userModel = UserModel();
    userModel.username = userId;
    userModel.password = password;
    userModel.name = name;
    userModel.userRole = role;
    userModel.stage = stage;
    await firebaseFirestore.collection("users").doc().set(userModel.toMap());
    showSnackBar(context, 'User created', Colors.green);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => AdminUsersList(
          key: UniqueKey(),
        ),
      ),
     (Route<dynamic> route) => false
    );
   }
   else{
    UserModel userModel = UserModel();
    userModel.username = userId;
    userModel.password = password;
    userModel.name = name;
    userModel.userRole = role;
    userModel.stage = stage;
    await firebaseFirestore.collection("users").doc(widget.userDocumentID).update(userModel.toMap());
    showSnackBar(context, 'User info updated!', Colors.green);
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (ctx) => AdminUsersList(
          key: UniqueKey(),
        ),
      ),
     (Route<dynamic> route) => false
    );
   }
 }

  @override
  Widget build(BuildContext context) {
    debugPrint(widget.tappedButton!+''+widget.userDocumentID.toString());
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
                                      errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.orange
                                                  .withOpacity(0.4))),
                                      hintStyle: kInputStyle,
                                      prefixIconColor: cyan,
                                      hintText: 'Name',
                                    ),
                                    onSaved: (input) => name = input!),
                              ),
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
                                  });
                                },
                              )
                            : Container(),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        SizedBox(
                          width: constraints.maxWidth * 0.9,
                          child: ElevatedButton(
                            onPressed: signup,
                            child:  Text(
                              widget.tappedButton as String,
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
