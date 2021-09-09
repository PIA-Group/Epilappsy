import 'package:casia/Authentication/SharedPref.dart';
import 'package:casia/Pages/Medication/MedicationPage.dart';
import 'package:casia/Pages/HomePage/HomePageCasia.dart';
import 'package:casia/Pages/Calendar/CalendarPage.dart';
import 'package:casia/Pages/StatisticsPage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:casia/design/my_flutter_app_icons.dart';
import 'package:casia/design/colors.dart';

//for the dictionaries

class NavigationPage extends StatefulWidget {
  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  ValueNotifier<bool> logout = ValueNotifier(false);

  void _logout(BuildContext context) async {
    await SharedPref.logout();
    Navigator.of(context).pushReplacementNamed("/login");
  }

  @override
  void initState() {
    super.initState();
    logout.addListener(() {
      if (logout.value) _logout(context);
    });
  }

  List<Widget> _screens(BuildContext context) {
    return [
      HomePage(logout: logout),
      StatisticsPage(),
      TableCalendarPage(),
      MedicationPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          MyFlutterApp.home,
          size: 35.0,
        ),
        activeColor:
            DefaultColors.purpleLogo, //Color.fromRGBO(142, 255, 249, 1),
        inactiveColor:
            DefaultColors.purpleLogo, //Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          MyFlutterApp.statistics,
          size: 35.0,
        ),
        activeColor: DefaultColors
            .purpleLogo, //activeColor: Color.fromRGBO(252, 169, 83, 1),
        inactiveColor: DefaultColors
            .purpleLogo, //inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          MyFlutterApp.calender,
          size: 35,
        ),
        activeColor: DefaultColors
            .purpleLogo, //activeColor: Color.fromRGBO(179, 244, 86, 1),
        inactiveColor:
            DefaultColors.purpleLogo, //Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          MyFlutterApp.medicine,
          size: 35.0,
        ),
        activeColor: DefaultColors
            .purpleLogo, //activeColor: Color.fromRGBO(249, 243, 140, 1),
        inactiveColor: DefaultColors
            .purpleLogo, //inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PersistentTabView(
        controller: PersistentTabController(initialIndex: 0),
        screens: _screens(context),
        items: _navBarsItems(context),
        confineInSafeArea: true,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardShows: true,
        hideNavigationBar: false,
        popActionScreens: PopActionScreensType.once,
        bottomScreenMargin: 0.0,
        decoration: NavBarDecoration(
            colorBehindNavBar: Colors.white,
            borderRadius: BorderRadius.circular(1.0)),
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
        navBarStyle: NavBarStyle.style3,
        // Choose the nav bar style with this property
      ),
    );
  }
}
