import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class BottomTabIcon extends StatefulWidget {
  int index;
  List<bool> currentTab;
  Function onPressedFunction;
  BottomTabIcon(this.index, this.currentTab, this.onPressedFunction, {Key? key})
      : super(key: key);

  @override
  _BottomTabIconState createState() => _BottomTabIconState();
}

class _BottomTabIconState extends State<BottomTabIcon> {
  @override
  Widget build(BuildContext context) {
    return IconButton(
      splashColor: Colors.transparent,
      highlightColor: Colors.transparent,
      icon: bottomTabIcons[widget.index],
      color: widget.currentTab[widget.index] == true ? mainColor : Colors.black,
      onPressed: () {
        widget.onPressedFunction(widget.index);
      },
    );
  }
}
