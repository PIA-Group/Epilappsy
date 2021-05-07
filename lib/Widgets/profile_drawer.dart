import 'package:epilappsy/Pages/Modules/ConnectedDevices.dart';
import 'package:epilappsy/Pages/SettingsPage.dart';
import 'package:epilappsy/Pages/UserPage.dart';
import 'package:epilappsy/main.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

Widget createDrawerHeader(
    {LinearGradient bckgcolor, Color txtcolor, String txt, double height}) {
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
            bottom: 12.0,
            left: 16.0,
            child: Text(txt,
                style: TextStyle(
                    color: txtcolor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]),
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

class ProfileDrawer extends StatelessWidget {
  final Color txtcolor = Color(0xFF1D3557);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          createDrawerHeader(
              bckgcolor: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [mycolor, Theme.of(context).accentColor]),
              txtcolor: Theme.of(context).unselectedWidgetColor,
              txt: "Person Name",
              height: MediaQuery.of(context).size.height * (0.14) + 56),
          Padding(
            padding:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.05),
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              createDrawerBodyItem(
                  icon: Icons.person,
                  txtcolor: txtcolor,
                  text: 'User Info',
                  onTap: () {
                    pushNewScreen(context,
                        screen: UserPage(), withNavBar: false);
                    /* Navigator.push(context,
                        MaterialPageRoute(builder: (context) => UserPage())); */
                  }),
              createDrawerBodyItem(
                  icon: Icons.settings,
                  txtcolor: txtcolor,
                  text: 'Settings',
                  onTap: () {
                    pushNewScreen(context,
                        screen: SettingsPage(), withNavBar: false);
                    /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => SettingsPage())); */
                  }),
              createDrawerBodyItem(
                  icon: Icons.device_hub,
                  txtcolor: txtcolor,
                  text: 'Connect Device',
                  onTap: () {
                    pushNewScreen(context,
                        screen: ConnectedDevicesPage(), withNavBar: false);
                    /* Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ConnectedDevicesPage())); */
                  }),
              
              createDrawerBodyItem(
                  //TODO
                  icon: Icons.file_download,
                  text: 'PDF Export',
                  txtcolor: txtcolor,
                  onTap: () {
                    pushNewScreen(context,
                        screen: Container(), withNavBar: false);
                    /* Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ConnectPage())); */
                  }),
              createDrawerBodyItem(
                  icon: Icons.logout,
                  text: 'Log Out',
                  txtcolor: txtcolor,
                  onTap: () {
                    //TODO: logout
                  }),
            ]),
          ),
        ],
      ),
    );
  }
}
