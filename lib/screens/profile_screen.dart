// ignore_for_file: implementation_imports, sized_box_for_whitespace

import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/providers/user_provider.dart';
import 'package:app_and_up_take_home_project/screens/sign_in_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  double topPadding;
  ProfileScreen(this.topPadding, {Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Container(
        height: 16.5 * (screenHeight - widget.topPadding) / 18,
        child: Center(
          child: ElevatedButton(
            onPressed: () async {
              var prefs = await SharedPreferences.getInstance();
              await prefs.setBool('isLogged', false);
              await prefs.setString('uid', '');
              context.read<UserProvider>().setUid('');
              context.read<UserProvider>().favoriteBooks.clear();

              await Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (BuildContext context) => const SignInScreen(),
                ),
              );
            },
            child: const Text('Sign Out'),
            style: ElevatedButton.styleFrom(primary: mainColor),
          ),
        ));
  }
}
