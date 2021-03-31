import 'package:epilappsy/Pages/AddSeizure/circle_list.dart';
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
    ]),
  );
}

Widget appBarAll(BuildContext context, _actions, title) {
  return AppBar(
      elevation: 0.0,
      iconTheme:
          IconThemeData(color: mycolor), //Theme.of(context).accentColor),
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

class AppBarAddSeizure extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final ValueNotifier<List<Widget>> circleList;

  AppBarAddSeizure({
    this.title,
    this.circleList,
  });

  @override
  Size get preferredSize => const Size.fromHeight(100);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: mycolor),
      backgroundColor: Theme.of(context).unselectedWidgetColor,
      title: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.headline1,
      ),
      flexibleSpace: Padding(
        padding: EdgeInsets.only(top: 90),
        child: ValueListenableBuilder(
          builder: (BuildContext context, List<Widget> list, Widget child) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: list,
            );
          },
          valueListenable: circleList,
        ),
      ),
    );
  }
}
