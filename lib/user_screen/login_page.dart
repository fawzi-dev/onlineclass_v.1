import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/user_screen/user_main_screen.dart';
import 'package:onlineclass/utlities/colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utlities/getStoredString.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  /// Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///User instance
  User? loggedUser;

  /// TextEditing controllers
  late String _email, _password;

  /// Spiner sate variable
  bool isSpinning = false;

  String dropDownValue = 'Select Stage';

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
    // TODO: implement initState
    super.initState();
    checkAuthentication();
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

  checkAuthentication() async {
    _auth.authStateChanges().listen((user) {
       if(dropDownValue!='Select Stage'){
        if(user!=null){
          Navigator.pushNamed(context, '/MainScreen');
        }
      }
    });
  }

  getInfo() async{
    debugPrint('Shared Pref is called');
    int? isSelected=0;
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setInt('stageKeys', isSelected);
    debugPrint(preferences.getInt('stageKeys').toString());
  }

  login() async {
    setState(() {
      isSpinning = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      try {
        final user = await _auth.signInWithEmailAndPassword(email: _email, password: _password);
          if(dropDownValue!='Select Stage'){
            if(user.user!=null){
              Navigator.pushNamed(context, '/MainScreen');
            }
            await GetStoredData.setString(dropDownValue);
            getInfo();
          }
          else {
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please select a stage'),));
          }
      } catch (e) {
        print(e);
      }
    }
    setState(() {
      isSpinning = false;
    });
  }

  // /// Getting current user
  // void getCurrentUser() async {
  //   final user = _auth.currentUser;
  //   if (user != null) {
  //     loggedUser = user;
  //   }
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
                  grey0,
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
                        Container(
                          height: constraints.maxHeight * 0.25,
                          alignment: Alignment.bottomCenter,
                          child: Image.asset(
                            'assets/logo.png',
                            height: constraints.maxHeight * 0.25,
                          ),
                        ),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: <Widget>[
                              SizedBox(
                                child: TextFormField(
                                    validator: (input) {
                                      if (input!.isEmpty) {
                                        return 'Enter Email';
                                      }
                                    },
                                    style: kInputStyle,
                                    decoration: InputDecoration(
                                      hintStyle: kInputStyle,
                                      prefixIconColor: cyan,
                                      hintText: 'Username',
                                    ),
                                    onSaved: (input) => _email = input!),
                              ),
                              TextFormField(
                                  style: kInputStyle,
                                  validator: (input) {
                                    if (input!.length < 6) {
                                      return 'Provide Minimum 6 Character';
                                    }
                                  },
                                  decoration: InputDecoration(
                                    hintText: 'Password',
                                    hintStyle: kInputStyle,
                                    prefixIconColor: cyan,
                                  ),
                                  obscureText: true,
                                  onSaved: (input) => _password = input!),
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
                              child: Text(stage ,style: dropDownStyle,),
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
                        SizedBox(height: constraints.maxHeight * 0.025),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Login as Admin',
                              style: kSignUp,
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
