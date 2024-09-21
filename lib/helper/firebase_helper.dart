import 'package:bubbly_chatting/helper/ui_helper.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../model/user_crediential_model.dart';

class FirebaseHelper {
  FirebaseHelper._();

  static FirebaseHelper firebaseHelper = FirebaseHelper._();

  FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  static final GoogleSignIn googleSignIn = GoogleSignIn();

  // Anonymous
  Future<User?> anonymousLogIn({required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInAnonymously();
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case "network-request-failed":
          UiHelper.showCustomDialog(
              context: context, title: "No Internet Available");
          break;
        case "operation-not-allowed":
          UiHelper.showCustomDialog(
              context: context, title: "This is disabled by admin.");
          break;
        default:
          UiHelper.showCustomDialog(
              context: context, title: "An error occurred: ${e.code}");
      }
      return null;
    }
  }

  // Sign up
  Future<User?> signUpUser(
      {required UserCredientialModel model,
      required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.createUserWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'weak-password':
          UiHelper.showCustomDialog(context: context, title: 'Weak Password');
          break;
        case 'email-already-in-use':
          UiHelper.showCustomDialog(
              context: context, title: 'Email Already in Use');
          break;
        case 'invalid-email':
          UiHelper.showCustomDialog(context: context, title: 'Invalid Email');
          break;
        case 'network-request-failed':
          UiHelper.showCustomDialog(
              context: context, title: 'Network Request Failed');
          break;
        default:
          UiHelper.showCustomDialog(
              context: context, title: 'An error occurred: ${e.code}');
          break;
      }
      return null;
    }
  }

  // Sign In
  Future<User?> signInUser(
      {required UserCredientialModel model,
      required BuildContext context}) async {
    try {
      UserCredential userCredential =
          await firebaseAuth.signInWithEmailAndPassword(
        email: model.email,
        password: model.password,
      );
      User? user = userCredential.user;
      return user;
    } on FirebaseAuthException catch (e) {
      String errorMessage = '';
      switch (e.code) {
        case 'invalid-email':
          errorMessage = 'Invalid email address';
          break;
        case 'user-not-found':
          errorMessage = 'No user found with this email';
          break;
        case 'wrong-password':
          errorMessage = 'Incorrect password';
          break;
        case 'user-disabled':
          errorMessage = 'User account is disabled';
          break;
        default:
          errorMessage = 'Invalid Credintials...';
      }
      UiHelper.showCustomDialog(context: context, title: errorMessage);
      return null;
    }
  }

  // Sign out
  signOutUser() async {
    await firebaseAuth.signOut();
    await googleSignIn.signOut();
  }

  // keytool -list -v -alias androiddebugkey -keystore C:\\Users\\princ\\.android\\debug.keystore

  // Login with google
  Future<User?> signInWithGoogle({required BuildContext context}) async {
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication? googleAuth =
          await googleUser?.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);
      User? user = userCredential.user;
      return user;
    } catch (e) {
      UiHelper.showCustomDialog(context: context, title: e.toString());
      return null;
    }
  }
}
