import 'package:epilappsy/Widgets/profile_drawer.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/SettingsPage.dart';
import 'package:epilappsy/main.dart';

Widget appBarTitle(BuildContext context, String title) {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 22), children: [
      TextSpan(
        text: title.toUpperCase(),
        style: Theme.of(context).textTheme.headline1,
      ),
      //TextStyle(
      //  color: mycolor,
      //letterSpacing: 1.5,
      //fontFamily: 'Montserrat',
      //fontWeight: FontWeight.w500)),
      //TextSpan(
      //  text: 'Check',
      //style: TextStyle(
      //  fontWeight: FontWeight.bold,
      // color: Color.fromRGBO(142, 255, 249, 1))),
    ]),
  );
}

Widget appBarAll(BuildContext context, _actions, title) {
  return AppBar(
      elevation: 0.0,
      iconTheme: IconThemeData(
          color: mycolor), //Theme.of(context).accentColor),
      backgroundColor: Theme.of(context).unselectedWidgetColor,
      actions: _actions,
      title: appBarTitle(context, title));
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
