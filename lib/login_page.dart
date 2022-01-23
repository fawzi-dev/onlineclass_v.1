import 'package:flutter/material.dart';
import 'package:onlineclass/constants/constants.dart';
import 'package:onlineclass/utlities/colors.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
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
                Flexible(
                  child: Image.asset('assets/logo.png'),
                ),

                /// Text fields
                Expanded(
                  flex: 3,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const TextFields(
                          hintText: 'Username',
                        ),
                        SizedBox(height: constraints.maxHeight * 0.0015),
                        const TextFields(
                          hintText: 'Password',
                        ),
                        SizedBox(height: constraints.maxHeight * 0.02),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/Stages');
                          },
                          child: Container(
                            height: constraints.maxHeight * 0.1,
                            width: double.infinity,
                            decoration: BoxDecoration(
                                color: cyan,
                                borderRadius: BorderRadius.circular(10)),
                            child: const Center(
                              child: Text(
                                'LOGIN',
                                style: kLoginStyle,
                              ),
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
                              'Don\'t have an account?',
                              style: kNoAccount,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              'SIGN UP',
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
    );
  }
}

class TextFields extends StatelessWidget {
  final String hintText;

  const TextFields({Key? key, required this.hintText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
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
