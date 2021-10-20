// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:app_and_up_take_home_project/widgets/custom_sized_box.dart';
import 'package:app_and_up_take_home_project/widgets/custom_text_field.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  bool _isLoading = false;
  bool _isSent = false;
  String _errorText = '';
  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mainColor,
        title: const Text('Forgot Password'),
      ),
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            CustomSizedBox(0.50, screenHeight),
            _isLoading == false
                ? Padding(
                    padding: EdgeInsets.only(left: screenWidth / 20),
                    child: Column(
                      children: [
                        CustomSizedBox(0.50, screenHeight),
                        CustomTextField(
                            screenWidth,
                            screenHeight,
                            const Icon(
                              Icons.email_outlined,
                              color: mainColor,
                            ),
                            'Email',
                            _emailController,
                            50,
                            false,
                            true),
                        CustomSizedBox(0.5, screenHeight),
                        _isSent == false
                            ? _resetButton(screenHeight, screenWidth)
                            : const Icon(
                                Icons.check,
                                color: mainColor,
                              ),
                        CustomSizedBox(0.50, screenHeight),
                        _errorTextContainer()
                      ],
                    ),
                  )
                : const Center(
                    child: CircularProgressIndicator(),
                  ),
          ],
        ),
      ),
    );
  }

  AutoSizeText _errorTextContainer() {
    return AutoSizeText(
      _errorText,
      maxLines: 1,
      style: const TextStyle(color: mainColor),
    );
  }

  Widget _resetButton(double screenHeight, double screenWidth) {
    return Container(
      height: 0.75 * screenHeight / 18,
      width: 9 * screenWidth / 20,
      child: ElevatedButton(
        child: const AutoSizeText(
          'Reset password',
          maxLines: 1,
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
          ),
        ),
        style: ElevatedButton.styleFrom(
          primary: mainColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () async {
          setState(() {
            _isLoading = true;
            _errorText = '';
          });
          try {
            await firebaseService.firebaseAuth
                .sendPasswordResetEmail(email: _emailController.text.trim());
            setState(() {
              _isLoading = false;
              _isSent = true;
            });
          } on FirebaseAuthException catch (e) {
            print(e.code);
            setState(() {
              _isLoading = false;
              _errorText = 'Invalid Email Address.';
            });
          }
        },
      ),
    );
  }
}
