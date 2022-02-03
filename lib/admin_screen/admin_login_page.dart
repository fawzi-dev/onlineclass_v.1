import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({Key? key}) : super(key: key);

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  /// Firebase instance
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  ///User instance
  User? loggedUser;

  /// TextEditing controllers
  late String _email, _password;

  /// Spiner sate variable
  bool isSpinning = false;

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
      if (user != null) {
        Navigator.pushNamed(context, '/Stages');
      }
    });
  }

  login() async {
    setState(() {
      isSpinning = true;
    });
    if (_formKey.currentState!.validate()) {
      _formKey.currentState?.save();
      try {
        final user = await _auth.signInWithEmailAndPassword(
            email: _email, password: _password);
        if(user.credential!=null){
          return showError('Credentials are incorrect!');
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
                  /// Logo Container
                  SizedBox(height: constraints.maxHeight * 0.02),
                  Container(
                    height: constraints.maxHeight * 0.35,
                    alignment: Alignment.bottomCenter,
                    child: Image.asset(
                      'assets/logo.png',
                      height: constraints.maxHeight * 0.25,
                    ),
                  ),

                  /// Text fields
                  Expanded(
                    flex: 2,
                    child: Container(
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
                                      validator: (input) {
                                        if (input!.isEmpty) {
                                          return 'Enter Email';
                                        }
                                      },
                                      style: kInputStyle,
                                      decoration:  InputDecoration(
                                        hintStyle: kInputStyle,
                                        prefixIconColor: cyan,
                                        hintText: 'Username',
                                      ),
                                      onSaved: (input) => _email = input!),
                                ),
                                Container(
                                  child: TextFormField(
                                    style: kInputStyle,
                                      validator: (input) {
                                        if (input!.length < 6) {
                                          return 'Provide Minimum 6 Character';
                                        }
                                      },
                                      decoration:  InputDecoration(
                                        hintText: 'Password',
                                        hintStyle: kInputStyle,
                                        prefixIconColor: cyan,
                                      ),
                                      obscureText: true,
                                      onSaved: (input) => _password = input!),
                                ),
                                SizedBox(height: constraints.maxHeight * 0.02),
                              ],
                            ),
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
                          const Text(
                            'Forget Password?',
                            style: kForget,
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
