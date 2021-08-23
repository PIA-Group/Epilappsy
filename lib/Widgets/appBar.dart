import 'package:flutter/material.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/Widgets/profile_drawer.dart';

Widget appBarTitle(BuildContext context, String title) {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 30), children: [
      TextSpan(
        text: title /* .toUpperCase() */,
        style: Theme.of(context).textTheme.headline1,
      ),
    ]),
  );
}

Widget appBarHome(BuildContext context, List<Widget> _actions) {
  return PreferredSize(
      preferredSize: Size.fromHeight(150.0),
      child: AppBar(
        toolbarHeight: 150,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 32
              //right: MediaQuery.of(context).size.width * 0.45,
              //top: 32,
              ),
          child: Image.asset(
            "assets/images/roxo circular.png",
            fit: BoxFit.fill,
          ),
        ),
        centerTitle: true,
        title: Text('Hello!',
            style: TextStyle(
                fontSize: 70,
                fontFamily: 'canter',
                color: DefaultColors.backgroundColor)),
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: DefaultColors.mainColor,
            size: 30), //Theme.of(context).accentColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: _actions,
      ));
}

Widget appBarEmergency(
    BuildContext context, List<Widget> _actions, String titleH) {
  return PreferredSize(
    preferredSize: Size.fromHeight(150.0),
    child: AppBar(
        centerTitle: true,
        toolbarHeight: 150,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 32
              //right: MediaQuery.of(context).size.width * 0.45,
              //top: 32,
              ),
          child: Image.asset(
            "assets/images/barra.png",
            fit: BoxFit.contain,
          ),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: DefaultColors.mainColor,
            size: 20), //Theme.of(context).accentColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: _actions,
        title: appBarTitle(context, titleH)),
  );
}

Widget appBarAll(BuildContext context, List<Widget> _actions, String titleH) {
  return PreferredSize(
    preferredSize: Size.fromHeight(150.0),
    child: AppBar(
        centerTitle: true,
        toolbarHeight: 150,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 32
              //right: MediaQuery.of(context).size.width * 0.45,
              //top: 32,
              ),
          child: Image.asset(
            "assets/images/barra_roxo.png",
            fit: BoxFit.contain,
          ),
        ),
        elevation: 0.0,
        iconTheme: IconThemeData(
            color: DefaultColors.mainColor,
            size: 20), //Theme.of(context).accentColor),
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        actions: _actions,
        title: appBarTitle(context, titleH)),
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
      iconTheme: IconThemeData(color: Colors.white),
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
