// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class WelcomeMessage extends StatelessWidget {
  final double _screenHeight;
  final String _firstMessage;
  final String _secondMessage;

  const WelcomeMessage(
      this._screenHeight, this._firstMessage, this._secondMessage,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 2 * _screenHeight / 18,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _firstMessage,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 32,
            ),
          ),
          Text(
            _secondMessage,
            style: const TextStyle(
              fontSize: 24,
              color: Colors.grey,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}
