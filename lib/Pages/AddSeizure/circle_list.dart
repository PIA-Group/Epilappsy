import 'package:flutter/material.dart';

class QuestionnaireCircle extends StatelessWidget {
  final Color color;
  QuestionnaireCircle({this.color});
  
  @override
  Widget build(BuildContext context) {
    return Container(
          width: 10.0,
          height: 10.0,
          decoration: new BoxDecoration(color: color, shape: BoxShape.circle),
        );
  }
}
