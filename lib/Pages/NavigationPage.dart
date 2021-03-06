import 'package:epilappsy/Authentication/SharedPref.dart';
import 'package:epilappsy/Pages/Medication/MedicationPage.dart';
import 'package:epilappsy/Pages/HomePageCasia.dart';
import 'package:epilappsy/Pages/SeizureDiaryPage.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
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
    logout.addListener(() {if (logout.value) _logout(context);});
  }

  List<Widget> _screens(BuildContext context) {
    return [
      HomePage(logout: logout),
      Container(),
      SeizureDiary(),
      MedicationPage(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems(context) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.home,
          size: 35.0,
        ),
        activeColor: Theme.of(context)
            .unselectedWidgetColor, //Color.fromRGBO(142, 255, 249, 1),
        inactiveColor: Theme.of(context)
            .unselectedWidgetColor, //Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.insert_chart_outlined_rounded,
          size: 35.0,
        ),
        activeColor: Theme.of(context)
            .unselectedWidgetColor, //activeColor: Color.fromRGBO(252, 169, 83, 1),
        inactiveColor: Theme.of(context)
            .unselectedWidgetColor, //inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.calendar_today,
          size: 35,
        ),
        activeColor: Theme.of(context)
            .unselectedWidgetColor, //activeColor: Color.fromRGBO(179, 244, 86, 1),
        inactiveColor: Theme.of(context)
            .unselectedWidgetColor, //Color.fromRGBO(64, 61, 88, 0.5),
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          MdiIcons.pill,
          size: 35.0,
        ),
        activeColor: Theme.of(context)
            .unselectedWidgetColor, //activeColor: Color.fromRGBO(249, 243, 140, 1),
        inactiveColor: Theme.of(context)
            .unselectedWidgetColor, //inactiveColor: Color.fromRGBO(64, 61, 88, 0.5),
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
