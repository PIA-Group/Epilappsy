import 'package:epilappsy/Pages/AlertScreen.dart';
import 'package:epilappsy/Pages/NavigationPage.dart';
import 'package:epilappsy/Pages/SeizureDiaryPage.dart';
import 'package:epilappsy/Pages/UserPage.dart';
import 'package:epilappsy/Screens/SurveyPage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import '../app_localizations.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => new _HomePageState();
}

class _HomePageState extends State<HomePage> {
  PersistentTabController _controller;
  bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    
    _controller = PersistentTabController(initialIndex: 0);
    _hideNavBar = false;
  }

  List<Widget> _screens() {
    return [
      NavigationPage(),
      SurveyPage(),
      Container(),
      SeizureDiary(),
      UserPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        title: AppLocalizations.of(context).translate("Home"),
        titleStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColor: Color.fromRGBO(142, 255, 249, 1),
        inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.book),
        title: (AppLocalizations.of(context).translate("Surveys")),
        titleStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColor: Color.fromRGBO(252, 169, 83, 1),
        inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.sentiment_very_dissatisfied_outlined),
        activeColor: Colors.red,
        inactiveColor: Colors.grey,
        activeContentColor: Colors.white,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.notes),
        title: (AppLocalizations.of(context).translate("Seizures")),
        titleStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColor: Color.fromRGBO(179, 244, 86, 1),
        inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(Icons.account_circle),
        title: (AppLocalizations.of(context).translate("User")),
        titleStyle: TextStyle(fontWeight: FontWeight.bold),
        activeColor: Color.fromRGBO(249, 243, 140, 1),
        inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        controller: _controller,
        screens: _screens(),
        items: _navBarsItems(),
        confineInSafeArea: true,
        backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: _hideNavBar,
        popActionScreens: PopActionScreensType.once,
        bottomScreenMargin: 0.0,
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.indigo,
            borderRadius: BorderRadius.circular(20.0)),
        popAllScreensOnTapOfSelectedTab: true,
        itemAnimationProperties: ItemAnimationProperties(
          duration: Duration(milliseconds: 400),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 200),
        ),
        navBarStyle:
            NavBarStyle.style15, // Choose the nav bar style with this property
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        height: 100.0,
        width: 100.0,
        child: FittedBox(
          child: FloatingActionButton(
            backgroundColor: Colors.red,
            onPressed: () {
              pushDynamicScreen(
                context,
                screen: AlertScreen(),
                withNavBar: false,
              );
            },
            tooltip: 'Increment',
            child:
                new Icon(Icons.sentiment_very_dissatisfied_outlined, size: 40),
          ),
        ),
      ),
    );
  }
}
