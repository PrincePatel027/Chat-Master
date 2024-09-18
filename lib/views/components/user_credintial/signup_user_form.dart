import 'package:bubbly_chatting/helper/firebase_helper.dart';
import 'package:bubbly_chatting/helper/ui_helper.dart';
import 'package:bubbly_chatting/model/user_crediential_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignupUserForm extends StatefulWidget {
  const SignupUserForm({super.key});

  @override
  State<SignupUserForm> createState() => _SignupUserFormState();
}

class _SignupUserFormState extends State<SignupUserForm> {
  final _formKeySignUp = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  bool isObsecure = true;
  bool isObsecureConfirm = true;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(20),
      color: const Color(0xFF0098FF).withOpacity(0.3),
      child: Form(
        key: _formKeySignUp,
        child: Column(
          children: [
            GestureDetector(
              onTap: () async {
                User? user = await FirebaseHelper.firebaseHelper
                    .signInWithGoogle(context: context);
                if (user != null) {
                  UiHelper.customSnackbar(
                    context: context,
                    message: "Google login Succesfull...",
                  );
                  Navigator.pushReplacementNamed(context, "/", arguments: user);
                } else {
                  UiHelper.errorCustomSnackbar(
                    context: context,
                    message: "Google login Failed...",
                  );
                }
              },
              child: Container(
                height: height * 0.068,
                margin: EdgeInsets.only(
                  top: height * 0.02,
                  bottom: height * 0.01,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.circular(12),
                ),
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(CupertinoIcons.game_controller_solid),
                    SizedBox(width: width * 0.06),
                    Text(
                      "Login with Google",
                      style: Theme.of(context).textTheme.titleMedium!.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                    ),
                  ],
                ),
              ),
            ),
            Text(
              "or continue with email",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            SizedBox(height: height * 0.02),
            TextFormField(
              controller: emailController,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter an email';
                }
                String emailRegex =
                    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                RegExp regExp = RegExp(emailRegex);
                if (!regExp.hasMatch(value)) {
                  return 'Invalid email format';
                }
                return null;
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                prefixIcon: const Icon(Icons.email_outlined),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(
                labelText: 'Username',
                prefixIcon: const Icon(Icons.person_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a username';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: passwordController,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObsecure = !isObsecure;
                    });
                  },
                  icon: (isObsecure)
                      ? const Icon(CupertinoIcons.eye_solid)
                      : const Icon(CupertinoIcons.eye_slash_fill),
                ),
              ),
              obscureText: isObsecure,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter a password';
                } else if (value.length < 6) {
                  return 'Password must be at least 6 characters long';
                } else if (!RegExp(r'^(?=.*[a-zA-Z])(?=.*[0-9]).{6,}$')
                    .hasMatch(value)) {
                  return 'Password must contain at least one letter and one number';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            TextFormField(
              controller: confirmPasswordController,
              decoration: InputDecoration(
                labelText: 'Confirm Password',
                prefixIcon: const Icon(Icons.lock_outline),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: IconButton(
                  onPressed: () {
                    setState(() {
                      isObsecureConfirm = !isObsecureConfirm;
                    });
                  },
                  icon: (isObsecureConfirm)
                      ? const Icon(CupertinoIcons.eye_solid)
                      : const Icon(CupertinoIcons.eye_slash_fill),
                ),
              ),
              obscureText: isObsecureConfirm,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please confirm your password';
                } else if (confirmPasswordController.text !=
                    passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
            ),
            SizedBox(height: height * 0.02),
            GestureDetector(
              onTap: () async {
                if (_formKeySignUp.currentState!.validate()) {
                  _formKeySignUp.currentState!.save();

                  UserCredientialModel userData = UserCredientialModel(
                    email: emailController.text,
                    password: passwordController.text,
                  );

                  User? user = await FirebaseHelper.firebaseHelper.signUpUser(
                    context: context,
                    model: userData,
                  );

                  if (user != null) {
                    //
                    await user.updateProfile(
                      displayName: usernameController.text,
                    );

                    UiHelper.customSnackbar(
                      context: context,
                      message: "SignUp Succesfull...",
                    );

                    emailController.clear();
                    passwordController.clear();
                    usernameController.clear();
                    setState(() {});
                    // Navigator.pushReplacementNamed(
                    //   context,
                    //   "/",
                    //   arguments: user,
                    // );
                  } else {
                    UiHelper.errorCustomSnackbar(
                      context: context,
                      message: "SignUp Failed...",
                    );
                  }

                  setState(() {
                    usernameController.clear();
                    emailController.clear();
                    passwordController.clear();
                    confirmPasswordController.clear();
                  });
                }
              },
              child: Container(
                height: height * 0.068,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                alignment: Alignment.center,
                child: Text(
                  "Sign up",
                  style: TextStyle(
                    fontSize: width * 0.048,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(height: height * 0.01),
            Text(
              "Already have an account? Login",
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            RichText(
              textAlign: TextAlign.center,
              text: const TextSpan(
                style: TextStyle(
                  color: Colors.black,
                ),
                children: [
                  TextSpan(
                    text:
                        "By signing in with an account, you agree to Bubbly Chatting's Terms of Service and ",
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
