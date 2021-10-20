import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:app_and_up_take_home_project/screens/home_screen.dart';
import 'package:app_and_up_take_home_project/screens/favorites_screen.dart';
import 'package:app_and_up_take_home_project/screens/profile_screen.dart';
import 'package:app_and_up_take_home_project/widgets/bottom_tab_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/src/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<bool> currentTab = [true, false, false];

  final tabs = [
    (input) => HomeScreen(input),
    (input) => FavoritesScreen(input),
    (input) => ProfileScreen(input),
  ];

  var currentTabIndex = 0;
  final TextEditingController searchBarTextController = TextEditingController();
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    searchBarTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var topPadding = MediaQuery.of(context).padding.top;

    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.dark,
        child: SafeArea(
          bottom: false,
          child: WillPopScope(
            onWillPop: () async => false,
            child: SingleChildScrollView(
              child: Center(
                  child: Column(
                children: [
                  tabs[currentTabIndex](topPadding),
                  bottomTabBar(screenHeight, topPadding),
                ],
              )),
            ),
          ),
        ),
      ),
    );
  }

  Container bottomTabBar(double screenHeight, double paddingTop) {
    return Container(
      height: 1.5 * (screenHeight - paddingTop) / 18,
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Colors.grey,
            width: 0.25,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          for (var i = 0; i < bottomTabIcons.length; i++)
            BottomTabIcon(i, currentTab, bottomTabIconFunc),
        ],
      ),
    );
  }

  void bottomTabIconFunc(int index) {
    if (index == 1) {}
    if (mounted) {
      setState(() {
        for (var j = 0; j < bottomTabIcons.length; j++) {
          currentTab[j] = false;
        }
        currentTab[index] = true;
        currentTabIndex = index;

        if (index != 1) {
          //isSearchResultsLoading = true;
        }
      });
    }
  }
}
