import 'package:epilappsy/Authentication/RegisteringPage.dart';
import 'package:epilappsy/Pages/AlertScreen.dart';
import 'package:epilappsy/Pages/BreathPage.dart';
import 'package:epilappsy/Pages/Education/EducationPage.dart';
import 'package:epilappsy/Pages/RelaxationPage.dart';
import 'package:epilappsy/Pages/TOBPage.dart';
import 'package:epilappsy/Widgets/profile_drawer.dart';
import 'package:epilappsy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Models/homebuttons.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//for the dictionaries
import '../app_localizations.dart';

class NavigationPage extends StatefulWidget {
  NavigationPage({Key key}) : super(key: key);

  @override
  _NavigationPageState createState() => _NavigationPageState();
}

Widget story() {
  return Text("Here will be a short story over the seizures");
}

class _NavigationPageState extends State<NavigationPage> {
  List buttonsHPList;
  String userName = '';
  User currentUser;

  /* void updateUser() {
    getPatientName().then((value) => {
          this.setState(() {
            this.name = value;
          })
        });
  } */

  Future getbuttonsHPs() async {
    return [
      buttonsHP(
        title: "Learning",
        //AppLocalizations.of(context).translate("Introduction to Epilepsy"),
        //subtitle: AppLocalizations.of(context).translate("Information"),
        color1: Theme.of(context).accentColor,
        color2:
            Theme.of(context).accentColor, //Color.fromRGBO(142, 255, 249, 0.7),
        nextPage: EducationalPage(),
        icon: Icons.school,
      ),
      buttonsHP(
        title: "Meditation",
        //AppLocalizations.of(context).translate("Introduction to Epilepsy"),
        //subtitle: AppLocalizations.of(context).translate("Information"),
        color1: Theme.of(context).accentColor,
        color2:
            Theme.of(context).accentColor, //Color.fromRGBO(142, 255, 249, 0.7),
        nextPage: TOBPage(),
        icon: Icons.self_improvement,
      ),
    ];
  }

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration.zero, () {
      registerPopUp();
    });
    //updateUser();
    super.initState();
  }

  void registerPopUp() async {
    bool isRegistered = await checkIfRegistered(currentUser.uid);
    print("patient registered: $isRegistered");
    if (!isRegistered) {
      _registerDialog();
    }
  }

  Future<void> _registerDialog() async {
    await Future.delayed(Duration.zero);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context).translate('Profile incomplete!'),
            textAlign: TextAlign.start,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Text(
                    AppLocalizations.of(context).translate(
                        'We noticed your profile is incomplete, please complete it.'),
                    textAlign: TextAlign.justify,
                  ),
                ),
                ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      RaisedButton(
                        child: Text(AppLocalizations.of(context)
                            .translate("Complete now!")),
                        onPressed: () {
                          //Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RegisteringPage()),
                          );
                        },
                      ),
                      RaisedButton(
                        child: Text(AppLocalizations.of(context)
                            .translate("Keep exploring!")),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ]),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(buttonsHP buttonsHP) => ListTile(
          dense: true,
          contentPadding: EdgeInsets.only(left: 20.0, right: 12.0),
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(buttonsHP.icon, color: Colors.white),
            ],
          ),
          title: Text(
            buttonsHP.title,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15), //, fontWeight: FontWeight.bold, ),
          ),
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 20.0),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => buttonsHP.nextPage));
          },
        );

    Card makeCard(buttonsHP buttonsHP) => Card(
          color: Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 0.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 0.0),
          child: Container(
            height: 30.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    colors: [
                      Colors.blueGrey.shade100,
                      Colors.blueGrey.shade100
                    ])),
            child: makeListTile(buttonsHP),
          ),
        );

    return Scaffold(
      drawer: ProfileDrawer(),
      extendBodyBehindAppBar: true,
      appBar: appBarAll(
          context,
          [
            TextButton(
                onPressed: () {
                  pushDynamicScreen(
                    context,
                    screen: AlertScreen(),
                    withNavBar: false,
                  );
                },
                child: Text(
                  '?',
                  textScaleFactor: 2,
                )),
            Padding(
              padding: EdgeInsets.only(left: 20.0, right: 12.0),
            ),
          ],
          'Home Page'),
      body: FutureBuilder(
          future: getbuttonsHPs(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Stack(children: [
                Column(children: [
                  Expanded(
                    flex: 5,
                    child: Container(
                        color: Theme.of(context).unselectedWidgetColor,
                        child: Row(
                          children: <Widget>[
                            Expanded(child: makeCard(snapshot.data[0])),
                            Expanded(child: makeCard(snapshot.data[1])),
                          ],
                        ) /*ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return Column(
                            children: <Widget>[
                              Container(height: 20),

                              makeCard(snapshot.data[index]),

                              //Container(height: 20),
                              //Container(
                              //height: MediaQuery.of(context).size.height * 0.4,
                              //width: 300,
                              //child: story(),
                              //color: mycolor,
                              // ),
                            ],
                          );
                        },
                      ),*/
                        ),
                  ),
                  Expanded(flex: 5, child: Container(color: mycolor))
                ]),
                Positioned(
                    top: MediaQuery.of(context).size.height * 0.3,
                    left: 20,
                    right: 20,
                    child: Container(
                      height: MediaQuery.of(context).size.height * 0.4,
                      child: Card(
                        color: Colors.white,
                        elevation: 10.0,
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Text(
                            "Your Text here",
                          ),
                        ),
                      ),
                    ))
              ]);
            }
          }),
      floatingActionButton: alarmButton(
          icon: Icons.notifications,
          height: 100.0,
          width: 100.0,
          onPressed: () {
            pushDynamicScreen(
              context,
              screen: AlertScreen(),
              withNavBar: false,
            );
          }),
    );
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
