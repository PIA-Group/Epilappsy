import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Models/homebuttons.dart';
import 'package:epilappsy/Pages/EducationPage.dart';
import 'package:epilappsy/Pages/PeriodPage.dart';
import 'package:epilappsy/Pages/TOBPage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

class _NavigationPageState extends State<NavigationPage> {
  List buttonsHPList;
  String name = '';
  String email = '';

  void updateUser() {
    getPatientName().then((value) => {
          this.setState(() {
            this.name = value;
          })
        });
  }

  List getbuttonsHPs() {
    return [
      buttonsHP(
        title: AppLocalizations.of(context).translate("introduction to Epilepsy".inCaps),
        subtitle: AppLocalizations.of(context).translate("information".inCaps),
        color1: Color.fromRGBO(179, 244, 86, 0.8),
        color2: Color.fromRGBO(142, 255, 249, 0.7),
        nextPage: EducationalPage(),
        icon: Icons.info,
      ),
      buttonsHP(
        title: AppLocalizations.of(context).translate("connected sevice(s)".inCaps),
        subtitle: AppLocalizations.of(context).translate("information".inCaps),
        color1: Color.fromRGBO(229, 223, 120, 0.9),
        color2: Color.fromRGBO(179, 244, 86, 0.8),
        nextPage: PeriodPage(),
        icon: Icons.device_hub,
      ),
      buttonsHP(
        title: AppLocalizations.of(context).translate("log your sleeping schedule".inCaps),
        subtitle: AppLocalizations.of(context).translate("tool".inCaps),
        color1: Color.fromRGBO(249, 243, 140, 0.95),
        color2: Color.fromRGBO(252, 169, 83, 1),
        nextPage: EducationalPage(),
        icon: Icons.bedtime,
      ),
      buttonsHP(
          title: AppLocalizations.of(context).translate("stressed".inCaps)+"?"+ AppLocalizations.of(context).translate("relax here".inCaps),
          subtitle: AppLocalizations.of(context).translate("tool".inCaps),
          color1: Color.fromRGBO(252, 169, 83, 1),
          color2: Color.fromRGBO(249, 243, 140, 0.9),
          nextPage: TOBPage(),
          icon: Icons.self_improvement_sharp),
    ];
  }

  @override
  void initState() {
    buttonsHPList = getbuttonsHPs();
    email = FirebaseAuth.instance.currentUser.email;
    updateUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(buttonsHP buttonsHP) => ListTile(
          contentPadding:
              EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          leading: Container(
            padding: EdgeInsets.only(right: 12.0),
            decoration: new BoxDecoration(
                border: new Border(
                    right: new BorderSide(width: 1.0, color: Colors.white24))),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(buttonsHP.icon, color: Colors.white),
              ],
            ),
          ),
          title: Text(
            buttonsHP.title,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
          subtitle: Row(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Padding(
                    padding: EdgeInsets.only(left: 10.0),
                    child: Text(buttonsHP.subtitle,
                        style: TextStyle(color: Colors.white))),
              )
            ],
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => buttonsHP.nextPage));
          },
        );

    Card makeCard(buttonsHP buttonsHP) => Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(60),
          ),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(60),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [buttonsHP.color1, buttonsHP.color2])),
            child: makeListTile(buttonsHP),
          ),
        );

    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(100),
            child: FlexibleSpaceBar(
              centerTitle: true,
              title: Center(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          Icons.account_circle,
                          size: 70.0,
                          color: Colors.white,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              name,
                              style: TextStyle(color: Colors.white),
                            ),
                            Text(
                              email,
                              style: TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: Container(
          // decoration: BoxDecoration(color: Color.fromRGBO(58, 66, 86, 1.0)),
          child: ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: buttonsHPList.length,
            itemBuilder: (BuildContext context, int index) {
              return makeCard(buttonsHPList[index]);
            },
          ),
        ));
  }
}

class CustomShapeBorder extends ContinuousRectangleBorder {
  @override
  Path getClip(Size size) {
    Path path = Path();
    path.lineTo(0, size.height);
    path.quadraticBezierTo(
        size.width / 4, size.height - 40, size.width / 2, size.height - 20);
    path.quadraticBezierTo(
        3 / 4 * size.width, size.height, size.width, size.height - 30);
    path.lineTo(size.width, 0);

    return path;
  }
}
