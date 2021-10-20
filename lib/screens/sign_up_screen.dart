// ignore_for_file: sized_box_for_whitespace, invalid_return_type_for_catch_error, avoid_print, implementation_imports

import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/providers/user_provider.dart';
import 'package:app_and_up_take_home_project/screens/main_screen.dart';
import 'package:app_and_up_take_home_project/screens/sign_in_screen.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:app_and_up_take_home_project/services/helper_methods.dart';
import 'package:app_and_up_take_home_project/widgets/custom_sized_box.dart';
import 'package:app_and_up_take_home_project/widgets/custom_text_field.dart';
import 'package:app_and_up_take_home_project/widgets/sign_in_bottom_text.dart';
import 'package:app_and_up_take_home_project/widgets/welcome_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  HelperMethods helperMethods = HelperMethods();
  String errorText = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    surnameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomSizedBox(2, screenHeight),
                  WelcomeMessage(
                    screenHeight,
                    'Welcome,',
                    'Sign up to continue',
                  ),
                  CustomTextField(
                    screenWidth,
                    screenHeight,
                    const Icon(
                      Icons.account_circle_outlined,
                      color: mainColor,
                    ),
                    'Name',
                    nameController,
                    10,
                    false,
                    false,
                  ),
                  CustomSizedBox(0.25, screenHeight),
                  CustomTextField(
                    screenWidth,
                    screenHeight,
                    const Icon(
                      Icons.supervisor_account_outlined,
                      color: mainColor,
                    ),
                    'Surname',
                    surnameController,
                    10,
                    false,
                    false,
                  ),
                  CustomSizedBox(0.25, screenHeight),
                  CustomTextField(
                    screenWidth,
                    screenHeight,
                    const Icon(
                      Icons.email_outlined,
                      color: mainColor,
                    ),
                    'Email',
                    emailController,
                    50,
                    false,
                    true,
                  ),
                  CustomSizedBox(0.25, screenHeight),
                  CustomTextField(
                    screenWidth,
                    screenHeight,
                    const Icon(
                      Icons.lock_outlined,
                      color: mainColor,
                    ),
                    'Password',
                    passwordController,
                    20,
                    true,
                    false,
                  ),
                  CustomSizedBox(0.5, screenHeight),
                  Padding(
                    padding: EdgeInsets.only(
                      left: screenWidth / 20,
                      right: screenWidth / 20,
                    ),
                    child: const Text(
                      'At least 8 characters, 1 uppercase letter, 1 number, 1 symbol',
                      maxLines: 1,
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  CustomSizedBox(0.5, screenHeight),
                  _signUpButton(screenHeight, screenWidth, 'Sign up'),
                  CustomSizedBox(0.5, screenHeight),
                  Container(
                    height: screenHeight / 18,
                    child: Text(
                      errorText,
                      maxLines: 1,
                      style: const TextStyle(
                        color: mainColor,
                      ),
                    ),
                  ),
                  BottomTextSign('Already have an account?', '  Sign in',
                      const SignInScreen(), screenHeight),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signUpButton(var screenHeight, var screenWidth, var text) {
    return Container(
      height: screenHeight / 18,
      width: 18 * screenWidth / 20,
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: mainColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onPressed: () async {
            if (helperMethods
                    .isPasswordCompliant(passwordController.text.trim()) &&
                nameController.text.isNotEmpty &&
                surnameController.text.isNotEmpty) {
              try {
                await firebaseService.firebaseAuth
                    .createUserWithEmailAndPassword(
                  email: emailController.text.trim(),
                  password: passwordController.text.trim(),
                )
                    .then((value) {
                  firebaseService.users.doc(value.user!.uid).set({
                    'name': nameController.text.trim(),
                    'surname': surnameController.text.trim(),
                    'email': emailController.text.trim(),
                    'createdAt': DateTime.now().millisecondsSinceEpoch,
                    'updatedAt': DateTime.now().millisecondsSinceEpoch,
                    'following_books': [],
                  }).then(
                    (_) async {
                      var prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('isLogged', true);
                      await prefs.setString('uid', value.user!.uid);
                      context
                          .read<UserProvider>()
                          .setUid(prefs.getString('uid') ?? '');
                      await Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (BuildContext context) => const MainScreen(),
                        ),
                      );
                    },
                  ).catchError(
                    (error) => print('Failed to add user: $error'),
                  );
                });
              } on FirebaseAuthException catch (e) {
                if (e.code == 'weak-password') {
                  setState(() {
                    errorText = 'Weak Password.';
                  });
                } else if (e.code == 'email-already-in-use') {
                  setState(() {
                    errorText = 'Email already in use.';
                  });
                } else if (e.code == 'invalid-email') {
                  setState(() {
                    errorText = 'Please enter a valid email address.';
                  });
                }
              } catch (e) {
                print(e);
              }
            } else if (!helperMethods
                .isPasswordCompliant(passwordController.text.trim())) {
              setState(() {
                errorText = 'You did not provide the password rules';
              });
            } else if (emailController.text.isEmpty) {
              setState(() {
                errorText = 'Email cannot be empty';
              });
            } else if (nameController.text.isEmpty) {
              setState(() {
                errorText = 'Name cannot be empty';
              });
            } else if (surnameController.text.isEmpty) {
              setState(() {
                errorText = 'Surname cannot be empty';
              });
            }
          },
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
            ),
          )),
    );
  }
}
