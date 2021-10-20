import 'package:flutter/material.dart';

class CustomSizedBox extends StatelessWidget {
  final double _proportion;
  final double _screenHeight;

  const CustomSizedBox(this._proportion, this._screenHeight, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: _proportion * _screenHeight / 18);
  }
}
