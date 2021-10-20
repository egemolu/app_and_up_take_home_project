// ignore_for_file: sized_box_for_whitespace

import 'package:app_and_up_take_home_project/constants/constants.dart';
import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final double _screenWidth;
  final double _screenHeight;
  final Icon _icon;
  final String _hintText;
  final int _maxLength;
  final TextEditingController _controller;
  final bool _isObscure;
  final bool _isEmail;
  const CustomTextField(
      this._screenWidth,
      this._screenHeight,
      this._icon,
      this._hintText,
      this._controller,
      this._maxLength,
      this._isObscure,
      this._isEmail,
      {Key? key})
      : super(key: key);

  TextEditingController getController() {
    return _controller;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1.25 * _screenHeight / 18,
      width: 18 * _screenWidth / 20,
      child: TextField(
        keyboardType:
            _isEmail ? TextInputType.emailAddress : TextInputType.text,
        obscureText: _isObscure,
        controller: _controller,
        maxLength: _maxLength,
        style: const TextStyle(
          textBaseline: TextBaseline.alphabetic,
        ),
        cursorColor: mainColor,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.only(left: 10, right: 10),
          labelText: _hintText,
          labelStyle: const TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w400,
            fontSize: 16,
          ),
          focusedBorder: const OutlineInputBorder(
            borderSide: BorderSide(
              width: 1,
              color: mainColor,
            ),
          ),
          hintText: _hintText,
          prefixIcon: _icon,
          counterText: '',
        ),
      ),
    );
  }
}
