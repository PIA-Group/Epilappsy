import 'package:epilappsy/Pages/ConnectPage.dart';
import 'package:epilappsy/Pages/HomePage.dart';
import 'package:epilappsy/Pages/Modules/ConnectedDevices.dart';
import 'package:epilappsy/Pages/SettingsPage.dart';
import 'package:epilappsy/Pages/UserPage.dart';
import 'package:epilappsy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

Widget createDrawerHeader({Color bckgcolor, Color txtcolor, String txt}) {
  return DrawerHeader(
      margin: EdgeInsets.zero,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
          color: bckgcolor,
          image: DecorationImage(
              fit: BoxFit.fill, image: AssetImage('images/bg_header.jpeg'))),
      child: Stack(children: <Widget>[
        Positioned(
            bottom: 12.0,
            left: 16.0,
            child: Text(txt,
                style: TextStyle(
                    color: txtcolor,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500))),
      ]));
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
  Color txtcolor = Color(0xFF1D3557);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          createDrawerHeader(
              bckgcolor: Theme.of(context).accentColor,
              txtcolor: mycolor,
              txt: "Person Name"),
          createDrawerBodyItem(
              icon: Icons.person,
              txtcolor: txtcolor,
              text: 'User Info',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => UserPage()));
              }),
          createDrawerBodyItem(
              icon: Icons.settings,
              txtcolor: txtcolor,
              text: 'Settings',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              }),
          createDrawerBodyItem(
              icon: Icons.device_hub,
              txtcolor: txtcolor,
              text: 'Connect Device',
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => ConnectedDevicesPage()));
              }),
          createDrawerBodyItem(
              icon: Icons.qr_code,
              txtcolor: txtcolor,
              text: 'Connect to Caregiver',
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnectPage()));
              }),
          createDrawerBodyItem(
              icon: Icons.file_download,
              text: 'PDF Export',
              txtcolor: txtcolor,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => ConnectPage()));
              }),
          createDrawerBodyItem(
              icon: Icons.logout,
              text: 'Log Out',
              txtcolor: txtcolor,
              onTap: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingsPage()));
              }),
        ],
      ),
    );
  }
}
