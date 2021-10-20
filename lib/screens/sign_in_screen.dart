// ignore_for_file: sized_box_for_whitespace, implementation_imports, avoid_print

import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/providers/user_provider.dart';
import 'package:app_and_up_take_home_project/screens/forgot_password_screen.dart';
import 'package:app_and_up_take_home_project/screens/main_screen.dart';
import 'package:app_and_up_take_home_project/screens/sign_up_screen.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:app_and_up_take_home_project/widgets/circular_loading.dart';
import 'package:app_and_up_take_home_project/widgets/custom_sized_box.dart';
import 'package:app_and_up_take_home_project/widgets/custom_text_field.dart';
import 'package:app_and_up_take_home_project/widgets/or_line.dart';
import 'package:app_and_up_take_home_project/widgets/sign_in_bottom_text.dart';
import 'package:app_and_up_take_home_project/widgets/welcome_message.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  FirebaseService firebaseService = FirebaseService();
  bool isLoading = false;
  String errorText = '';
  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData = MediaQuery.of(context);
    var screenWidth = queryData.size.width;
    var screenHeight = queryData.size.height;
    return Scaffold(
      body: SafeArea(
        child: WillPopScope(
          onWillPop: () async => false,
          child: SingleChildScrollView(
            child: Center(
              child: isLoading
                  ? const CircularLoading()
                  : Column(
                      children: [
                        CustomSizedBox(2, screenHeight),
                        WelcomeMessage(
                          screenHeight,
                          'Welcome Back,',
                          'Sign in to continue',
                        ),
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
                            true),
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
                            false),
                        CustomSizedBox(1, screenHeight),
                        _signInButton(screenHeight, screenWidth, 'Sign in'),
                        CustomSizedBox(0.5, screenHeight),
                        OrLine(screenWidth),
                        CustomSizedBox(0.5, screenHeight),
                        Container(
                          height: screenHeight / 18,
                          child: ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.grey),
                              onPressed: () async {
                                final GoogleSignInAccount? googleUser =
                                    await GoogleSignIn().signIn();
                                if (googleUser == null) {
                                  return;
                                }
                                final GoogleSignInAuthentication? googleAuth =
                                    await googleUser.authentication;
                                final credential =
                                    GoogleAuthProvider.credential(
                                  accessToken: googleAuth?.accessToken,
                                  idToken: googleAuth?.idToken,
                                );
                                try {
                                  await firebaseService.firebaseAuth
                                      .signInWithCredential(credential)
                                      .then((value) async {
                                    final userDocument = await firebaseService
                                        .users
                                        .doc(value.user!.uid)
                                        .get();

                                    if (!userDocument.exists) {
                                      firebaseService.users
                                          .doc(value.user!.uid)
                                          .set({
                                        'name': value.user?.displayName
                                            ?.split(' ')
                                            .elementAt(0),
                                        'surname': value.user?.displayName
                                            ?.split(' ')
                                            .elementAt(1),
                                        'email': value.user?.email,
                                        'createdAt': DateTime.now()
                                            .millisecondsSinceEpoch,
                                        'updatedAt': DateTime.now()
                                            .millisecondsSinceEpoch,
                                        'following_books': [],
                                      }).catchError(
                                        (error) =>
                                            print('Failed to add user: $error'),
                                      );
                                    }
                                    var prefs =
                                        await SharedPreferences.getInstance();
                                    await prefs.setBool('isLogged', true);
                                    await prefs.setString(
                                        'uid', value.user!.uid);
                                    context
                                        .read<UserProvider>()
                                        .setUid(prefs.getString('uid') ?? '');
                                    loadFavorites();
                                    await Navigator.of(context).pushReplacement(
                                      MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            const MainScreen(),
                                      ),
                                    );
                                  });
                                } on FirebaseAuthException catch (e) {
                                  if (e.code == 'user-not-found') {
                                    setState(() {
                                      errorText =
                                          'No user found for that email.';
                                    });
                                  } else if (e.code == 'wrong-password') {
                                    setState(() {
                                      errorText =
                                          'Wrong password provided for that user.';
                                    });
                                  } else if (e.code == 'invalid-email') {
                                    setState(() {
                                      errorText =
                                          'Invalid email. Please check your email address.';
                                    });
                                  }
                                }
                              },
                              icon: const Icon(Icons.g_mobiledata_rounded),
                              label: const Text('Sign in with Google')),
                        ),
                        CustomSizedBox(0.5, screenHeight),
                        GestureDetector(
                          onTap: () {
                            Navigator.of(context).push(_routeAndAnimation());
                          },
                          child: Container(
                            height: 0.75 * screenHeight / 18,
                            child: const AutoSizeText(
                              'Forgot password?',
                              maxLines: 1,
                              style: TextStyle(
                                color: mainColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
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
                        BottomTextSign('Don\'t have an account?', '  Sign up',
                            const SignUpScreen(), screenHeight),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _signInButton(var screenHeight, var screenWidth, var text) {
    return Container(
      height: screenHeight / 18,
      width: 18 * screenWidth / 20,
      child: ElevatedButton(
        child: Text(
          text,
          style: const TextStyle(
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
          if (emailController.text.isEmpty || passwordController.text.isEmpty) {
            setState(() {
              errorText = 'Email and Password cannot be empty.';
            });
          } else {
            setState(() {
              isLoading = true;
            });
            try {
              await firebaseService.firebaseAuth
                  .signInWithEmailAndPassword(
                email: emailController.text.trim(),
                password: passwordController.text.trim(),
              )
                  .then((value) async {
                var prefs = await SharedPreferences.getInstance();
                await prefs.setBool('isLogged', true);
                await prefs.setString('uid', value.user!.uid);
                context
                    .read<UserProvider>()
                    .setUid(prefs.getString('uid') ?? '');
                loadFavorites();
                await Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (BuildContext context) => const MainScreen(),
                  ),
                );
              });
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                setState(() {
                  errorText = 'No user found for that email.';
                  emailController.clear();
                  passwordController.clear();
                });
              } else if (e.code == 'wrong-password') {
                setState(() {
                  errorText = 'Wrong password provided for that user.';
                  passwordController.clear();
                });
              } else if (e.code == 'invalid-email') {
                setState(() {
                  errorText = 'Invalid email. Please check your email address.';
                  emailController.clear();
                  passwordController.clear();
                });
              }
            }
            setState(() {
              isLoading = false;
            });
          }
        },
      ),
    );
  }

  Future<void> loadFavorites() async {
    await firebaseService.users
        .doc(context.read<UserProvider>().uid)
        .get()
        .then((value) async {
      for (var i = 0; i < value['following_books'].length; i++) {
        context
            .read<UserProvider>()
            .addFavoriteBook(value['following_books'][i]);
      }
    });
  }

  Route _routeAndAnimation() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          const ForgotPasswordScreen(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = const Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }
}
