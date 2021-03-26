import 'dart:ffi';

import 'package:flutter/material.dart';

class buttonsHP {
  String title;
  //String subtitle;
  Color color1;
  Color color2;
  Widget nextPage;
  IconData icon;

  buttonsHP(
      {this.title,
      //this.subtitle,
      this.color1,
      this.color2,
      this.nextPage,
      this.icon});
}

Widget alarmButton(
    {IconData icon,
    double height,
    double width,
    GestureTapCallback onPressed}) {
  return Align(
    alignment: Alignment(0.8, 0.8),
    child: Container(
      height: 90.0,
      width: 90.0,
      child: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: onPressed,
        tooltip: 'Increment',
        child: new Icon(icon, size: 70, color: Colors.white),
      ),
    ),
  );
}

class Alarmbuttons {
  IconData icon;
  Color bckgColor;
  double height;
  Widget alarmButton;
  double width;

  Alarmbuttons(
      {this.icon, this.bckgColor, this.height, this.alarmButton, this.width});
}

class GradientIcon extends StatelessWidget {
  GradientIcon(
    this.icon,
    this.size,
    this.gradient,
  );

  final IconData icon;
  final double size;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      child: SizedBox(
        width: size * 1.2,
        height: size * 1.2,
        child: Icon(
          icon,
          size: size,
          color: Colors.white,
        ),
      ),
      shaderCallback: (Rect bounds) {
        final Rect rect = Rect.fromLTRB(0, 0, size, size);
        return gradient.createShader(rect);
      },
    );
  }
}

Widget iconSample({icon, size}) {
  return GradientIcon(
    icon,
    size,
    LinearGradient(
      colors: <Color>[
        Color(0xFF457B9D),
        Color(0xFF1D3557),
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
  );
}
