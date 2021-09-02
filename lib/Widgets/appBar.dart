import 'package:casia/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';

Widget appBarTitle(BuildContext context, String title) {
  return RichText(
    text: TextSpan(style: TextStyle(fontSize: 80), children: [
      TextSpan(
        text: AppLocalizations.of(context)
            .translate(title)
            .inCaps /* .toUpperCase() */,
        style: Theme.of(context).textTheme.headline1,
      ),
    ]),
  );
}

/* class AppBarHome extends StatelessWidget {
  //final BuildContext context;
  final List<Widget> actions;
  static double appBarHeight = 170.0;

  const AppBarHome({
    //this.context,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: CustomPaint(
        isComplex: true,
        size: Size(MediaQuery.of(context).size.width, appBarHeight),
        painter: AppBarBackground(Size(MediaQuery.of(context).size.width, appBarHeight)),
        child: Container(
          height: appBarHeight,
          child: Center(
            child: Column(children: [
              SizedBox(height: 80),
              Text(AppLocalizations.of(context).translate('hello').inCaps + '!',
                  style: TextStyle(
                      fontSize: 70,
                      fontFamily: 'canter',
                      color: DefaultColors.backgroundColor)),
            ]),
          ),
        ),
      ),
    );
  }
} */

class AppBarHome extends StatelessWidget {
  //final BuildContext context;
  final List<Widget> actions;
  static double appBarHeight = 110.0;

  const AppBarHome({
    //this.context,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: appBarHeight * 2,
        color: DefaultColors.mainColor,
        child: Center(
          child: Column(children: [
            SizedBox(
              height: appBarHeight - 65,
            ),
            Text(AppLocalizations.of(context).translate('hello').inCaps + '!',
                style: TextStyle(
                    fontSize: 70,
                    fontFamily: 'canter',
                    color: DefaultColors.backgroundColor)),
          ]),
        ),
      ),
    );
  }
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

class AppBarAll extends StatelessWidget {
  final BuildContext context;
  final List<Widget> actions;
  final String titleH;
  static double appBarHeight = 110.0;

  AppBarAll({
    this.context,
    this.actions,
    this.titleH,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        height: appBarHeight * 1,
        color: DefaultColors.mainColor,
        child: Center(
          child: Column(children: [
            SizedBox(
              height: appBarHeight / 2,
            ),
            /* CircleAvatar(
              backgroundColor: Colors.white,
              radius: 15,
              child: Icon(Icons.calendar_today_rounded,
                  color: DefaultColors.mainColor),
            ), */
            appBarTitle(context, titleH),
          ]),
        ),
      ),
    );
  }
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
