import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';

class ButtonsHP {
  String title;
  Color color1;
  Color color2;
  Widget nextPage;
  IconData icon;

  ButtonsHP(
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
    alignment: Alignment(0.5, 0.8),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(60),
        color: DefaultColors.alarmColor,
      ),
      height: height,
      width: width,
      child: IconButton(
        icon: Icon(icon, size: 25, color: Colors.white),
        onPressed: onPressed,
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
