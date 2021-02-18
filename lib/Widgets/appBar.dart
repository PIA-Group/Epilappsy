import 'package:flutter/material.dart';

Widget appBarTitle(BuildContext context) {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 22), children: [
      TextSpan(
          text: 'Health',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
      TextSpan(
          text: 'Check',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(142, 255, 249, 1))),
    ]),
  );
}

Widget appBarTitleCG(BuildContext context) {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 22), children: [
      TextSpan(
          text: 'Health',
          style: TextStyle(fontWeight: FontWeight.w500, color: Colors.white)),
      TextSpan(
          text: 'Check',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Color.fromRGBO(219, 213, 110, 1))),
    ]),
  );
}
