// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class BottomTextSign extends StatelessWidget {
  final String _messageFirst;
  final String _messageSecond;
  final Widget _routingPage;
  final double _screenHeight;

  const BottomTextSign(this._messageFirst, this._messageSecond,
      this._routingPage, this._screenHeight,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: _screenHeight / 18,
      child: RichText(
        text: TextSpan(
          style: const TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          children: <TextSpan>[
            TextSpan(
              text: _messageFirst,
              style: const TextStyle(
                fontSize: 12,
              ),
            ),
            TextSpan(
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (BuildContext context) => _routingPage,
                    ),
                  );
                },
              text: '  $_messageSecond',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
