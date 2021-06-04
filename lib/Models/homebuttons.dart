import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/my_flutter_app_icons.dart';
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

Widget medButton(
    {String message, TextStyle message_style, GestureTapCallback onPressed}) {
  return Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black26))),
      child: Column(children: <Widget>[
        //Spacer(flex: 1),
        Text(message, style: message_style),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[Expanded()])
      ]));
}

Widget statsButton() {
  return Container();
}

Widget mood(
    {IconData icon1,
    Color color1,
    IconData icon2,
    Color color2,
    IconData icon3,
    Color color3,
    String message,
    TextStyle message_style,
    GestureTapCallback onPressed}) {
  return Column(children: <Widget>[
    Spacer(),
    Text(message, style: message_style),
    Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(top: 20.0),
              child: IconButton(
                  icon: Icon(icon1), color: color1, onPressed: onPressed))),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: IconButton(
                  icon: Icon(icon2), color: color2, onPressed: onPressed))),
      Expanded(
          child: Padding(
              padding: EdgeInsets.all(20.0),
              child: IconButton(
                  icon: Icon(icon3), color: color3, onPressed: onPressed)))
    ])
  ]);
}

Widget moodButton({TextStyle message_style, GestureTapCallback onPressed}) {
  return mood(
      icon1: MyFlutterApp.storm,
      icon2: MyFlutterApp.cloudy,
      icon3: MyFlutterApp.sunny_day,
      message: 'How is your mood today?',
      message_style: message_style,
      onPressed: onPressed);
}

Widget relaxButton({TextStyle message_style, GestureTapCallback onPressed}) {
  return mood(
      icon1: Icons.eco,
      icon2: Icons.hotel,
      icon3: Icons.self_improvement,
      message: 'Relax',
      message_style: message_style);
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
        icon: Icon(icon, size: 35, color: Colors.white),
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
