import 'dart:math';

import 'package:flutter/material.dart';

const mainColor = Color(0xffff4f00);
const chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
const numbers = '0123456789';

Random rgen = Random();

final List<Icon> bottomTabIcons = [
  const Icon(
    Icons.home_outlined,
    size: 24,
  ),
  const Icon(
    Icons.favorite_border_outlined,
    size: 24,
  ),
  const Icon(
    Icons.account_circle_outlined,
    size: 24,
  )
];
