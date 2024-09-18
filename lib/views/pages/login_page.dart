// ignore_for_file: unused_field

import 'package:bubbly_chatting/views/components/user_credintial/login_user_form.dart';
import 'package:bubbly_chatting/views/components/user_credintial/signup_user_form.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _formKeySignUp = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isObsecure = true;
  bool isObsecureConfirm = true;
  int initialIndex = 0;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              welcomeMessage(width, height),
              loginOrSignUp(height, context),
              SizedBox(
                height: height * 0.8,
                child: IndexedStack(
                  index: initialIndex,
                  children: const [
                    LoginUserForm(),
                    SignupUserForm(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Container welcomeMessage(double width, double height) {
    return Container(
      width: width,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      margin: EdgeInsets.only(top: height * 0.04, bottom: height * 0.04),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            "Welcome to Bubbly Chatting...",
            style: TextStyle(
              fontSize: width * 0.06,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: height * 0.02),
          Text(
            'Login or Sign up\nto access your account...',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: width * 0.04,
              fontWeight: FontWeight.w600,
              height: 0,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox loginOrSignUp(double height, BuildContext context) {
    return SizedBox(
      height: height * 0.068,
      child: Row(
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  initialIndex = 0;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (initialIndex == 0)
                      ? const Color(0xFF0098FF).withOpacity(0.3)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topRight: Radius.circular(24),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Login",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  initialIndex = 1;
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: (initialIndex == 1)
                      ? const Color(0xFF0098FF).withOpacity(0.3)
                      : Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(24),
                  ),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Sign-up",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
