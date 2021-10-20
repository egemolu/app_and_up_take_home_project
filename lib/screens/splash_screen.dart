// ignore_for_file: implementation_imports

import 'dart:async';
import 'dart:convert';

import 'package:app_and_up_take_home_project/model/book_model.dart';
import 'package:app_and_up_take_home_project/providers/book_provider.dart';
import 'package:app_and_up_take_home_project/providers/user_provider.dart';
import 'package:app_and_up_take_home_project/screens/main_screen.dart';
import 'package:app_and_up_take_home_project/services/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/src/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'sign_in_screen.dart';

class SplashScreen extends StatefulWidget {
  final Color backgroundColor;

  const SplashScreen({Key? key, required this.backgroundColor})
      : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final FirebaseService firebaseService = FirebaseService();

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadAndNavigate();
  }

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    var screenHeight = queryData.size.height;
    var screenWidth = queryData.size.width;
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Container(
          height: screenHeight,
          width: screenWidth,
          color: widget.backgroundColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              Center(
                child: Text(
                  'App & Up',
                  style: TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 14,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _loadAndNavigate() async {
    await loadBookData();
    var prefs = await SharedPreferences.getInstance();
    if (prefs.getBool('isLogged') ?? false) {
      final userDocument =
          await firebaseService.users.doc(prefs.getString('uid')).get();

      if (userDocument.exists) {
        context.read<UserProvider>().setUid(prefs.getString('uid') ?? '');
        await prefs.setBool('isLogged', true);
        loadFavorites();
        await Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (BuildContext context) => const MainScreen(),
          ),
        );
      }
    } else {
      await prefs.setBool('isLogged', false);
      await prefs.setString('uid', '');
      await Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (BuildContext context) => const SignInScreen(),
        ),
      );
    }
  }

  Future<void> loadBookData() async {
    var query =
        'https://www.googleapis.com/books/v1/volumes?q=novel&maxResults=40';

    final result = await http.get(Uri.parse(query));
    if (result.statusCode == 200) {
      final list = (jsonDecode(result.body))['items'] as List<dynamic>?;
      if (list == null) return;
      for (var e in list) {
        Book b = Book.fromJson(e);
        if (b.id != '' &&
            b.author.isNotEmpty &&
            b.averageRating > 0 &&
            b.category.isNotEmpty) {
          context.read<BookProvider>().addBook(Book.fromJson(e));
        }
      }
      return;
    } else {
      throw (result.body);
    }
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
}
