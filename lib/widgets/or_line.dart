// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';

class OrLine extends StatelessWidget {
  final double _screenWidth;
  const OrLine(this._screenWidth, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 1.5 * _screenWidth / 20,
          child: const Divider(
            color: Colors.black,
          ),
        ),
        const Text('  OR  '),
        Container(
          width: 1.5 * _screenWidth / 20,
          child: const Divider(
            color: Colors.black,
          ),
        ),
      ],
    );
  }
}
