import 'package:casia/Pages/Education/EducationPage.dart';
import 'package:casia/Pages/Hamburguer/TOBPage.dart';
import 'package:casia/Pages/Hamburguer/UserPage.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

Widget createDrawerHeader(
    {LinearGradient bckgcolor,
    Color txtcolor,
    String txt,
    double height,
    TextStyle textstyle}) {
  return Container(
    height: height,
    child: DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        gradient: bckgcolor,
      ),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0, left: 16.0, child: Text(txt, style: textstyle)),
      ]),
    ),
  );
}

Widget createImageHeader({double height}) {
  return Container(
    height: height,
    child: DrawerHeader(
        margin: EdgeInsets.zero,
        padding: EdgeInsets.zero,
        //decoration: BoxDecoration(
        //gradient: bckgcolor,
        //),
        child: Image(
            image:
                AssetImage('assets/images/casia_')) // Stack(children: <Widget>[
        //Positioned(
        //  bottom: 12.0, left: 16.0, child: Text(txt, style: textstyle)),
        //]),
        ),
  );
}

Widget createDrawerBodyItem(
    {IconData icon, String text, Color txtcolor, GestureTapCallback onTap}) {
  return Container(
      color: mycolor,
      child: ListTile(
        title: Row(
          children: <Widget>[
            Icon(
              icon,
              color: txtcolor,
            ),
            Padding(
              padding: EdgeInsets.only(left: 8.0),
              child: Text(text, style: TextStyle(color: txtcolor)),
            )
          ],
        ),
        onTap: onTap,
      ));
}

class ProfileDrawer extends StatefulWidget {
  final ValueNotifier<bool> logout;
  ProfileDrawer({this.logout});

  @override
  _ProfileDrawerState createState() => _ProfileDrawerState();
}

class _ProfileDrawerState extends State<ProfileDrawer> {
  final Color txtcolor = Color(0xFF1D3557);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Stack(
      children: [
        AppBarAll(
          context: context,
          titleH: 'settings',
        ),
        Positioned(
          top: AppBarAll.appBarHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: DefaultColors.backgroundColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                )),
            child: Column(
              children: <Widget>[
                //bckgcolor: LinearGradient(
                //  begin: Alignment.topRight,
                //end: Alignment.bottomLeft,
                //colors: [mycolor, Theme.of(context).accentColor]),
                //txtcolor: Theme.of(context).unselectedWidgetColor,
                //txt: "Person Name",
                //textstyle: Theme.of(context).textTheme.headline1,
                //height: MediaQuery.of(context).size.height * (0.14) + 56),
                Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.05),
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        createDrawerBodyItem(
                            icon: Icons.person,
                            txtcolor: DefaultColors.mainColor,
                            text: AppLocalizations.of(context)
                                .translate('profile')
                                .inCaps,
                            onTap: () {
                              pushNewScreen(context,
                                  screen: UserPage(), withNavBar: false);
                              /* Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserPage())); */
                            }),
                        /* createDrawerBodyItem(
                  icon: Icons.settings,
                  txtcolor: txtcolor,
                  text: AppLocalizations.of(context).translate('Settings'),
                  onTap: () {
                    pushNewScreen(context,
                        screen: SettingsPage(), withNavBar: false);
                    /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage())); */
                  }), */
                        createDrawerBodyItem(
                            icon: Icons.school,
                            txtcolor: DefaultColors.mainColor,
                            text: AppLocalizations.of(context)
                                .translate('education')
                                .inCaps,
                            onTap: () {
                              pushNewScreen(context,
                                  screen: EducationalPage(), withNavBar: false);
                              /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectedDevicesPage())); */
                            }),
                        createDrawerBodyItem(
                            icon: Icons.self_improvement,
                            txtcolor: DefaultColors.mainColor,
                            text: AppLocalizations.of(context)
                                .translate('breathing exercises')
                                .inCaps,
                            onTap: () {
                              pushNewScreen(context,
                                  screen: TOBPage(), withNavBar: false);
                              /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectedDevicesPage())); */
                            }),
                        /* createDrawerBodyItem(
                  icon: Icons.device_hub,
                  txtcolor: txtcolor,
                  text:
                      AppLocalizations.of(context).translate('Connect Device'),
                  onTap: () {
                    pushNewScreen(context,
                        screen: ConnectedDevicesPage(), withNavBar: false);
                    /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectedDevicesPage())); */
                  }), */
                        createDrawerBodyItem(
                            //TODO
                            icon: Icons.file_download,
                            text: AppLocalizations.of(context)
                                .translate('PDF export')
                                .inCaps,
                            txtcolor: DefaultColors.mainColor,
                            onTap: () {
                              pushNewScreen(context,
                                  screen: Container(), withNavBar: false);
                              /* Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ConnectPage())); */
                            }),
                        createDrawerBodyItem(
                            icon: Icons.logout,
                            text: AppLocalizations.of(context)
                                .translate('log out')
                                .inCaps,
                            txtcolor: DefaultColors.mainColor,
                            onTap: () {
                              setState(() => widget.logout.value = true);
                            }),
                      ]),
                ),
              ],
            ),
          ),
        ),
      ],
    ));
  }
}
