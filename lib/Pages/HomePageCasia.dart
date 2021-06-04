import 'package:epilappsy/Authentication/RegisteringPage.dart';
import 'package:epilappsy/Pages/AddSeizure/NewSeizureTransitionPage.dart';
import 'package:epilappsy/Pages/AlertScreen.dart';
import 'package:epilappsy/Pages/Education/EducationPage.dart';
import 'package:epilappsy/Pages/TOBPage.dart';
import 'package:epilappsy/Widgets/profile_drawer.dart';

import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/my_flutter_app_icons.dart';
import 'package:epilappsy/main.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Models/homebuttons.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:epilappsy/Pages/RelaxationPage.dart';

//for the dictionaries
import '../app_localizations.dart';

class HomePage extends StatefulWidget {
  ValueNotifier<bool> logout;
  HomePage({this.logout});

  @override
  _HomePageState createState() => _HomePageState();
}

Widget story() {
  return Text("Here will be a short story over the seizures");
}

class _HomePageState extends State<HomePage> {
  List buttonsHPList;
  String userName = '';
  //List<int> homelist = [0, 1, 2];
  ValueNotifier<List<int>> homelist;

  Future getbuttonsHPs() async {
    return [
      ButtonsHP(
        title: "Learning",
        //AppLocalizations.of(context).translate("Introduction to Epilepsy"),
        //subtitle: AppLocalizations.of(context).translate("Information"),
        color1: Theme.of(context).accentColor,
        color2:
            Theme.of(context).accentColor, //Color.fromRGBO(142, 255, 249, 0.7),
        nextPage: EducationalPage(),
        icon: Icons.school,
      ),
      ButtonsHP(
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
    Future.delayed(Duration.zero, () {
      registerPopUp();
    });
    //updateUser();
    super.initState();

    homelist = ValueNotifier([0, 1, 2, 3]);
    initHome();
  }

  void initHome() {
    homelist.notifyListeners();
  }

  void registerPopUp() async {
    bool isRegistered = await checkIfProfileComplete();
    print("patient registered: $isRegistered");
    if (!isRegistered) {
      _registerDialog();
    }
  }

//  final List<IconTile> moodTiles = [
  //  IconTile(icon: MyFlutterApp.storm, label: 'Angry'),
  //IconTile(icon: MyFlutterApp.cloudy, label: 'Sad'),
  // IconTile(icon: MyFlutterApp.sunny_day, label: 'Happy'),
  //];

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
                      ElevatedButton(
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
                      ElevatedButton(
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

  Widget rowRelax() {
    return Column(children: <Widget>[
      Text('Join us in a meditation exercise:',
          style: Theme.of(context).textTheme.bodyText1),
      //Spacer(flex: 1),
      SizedBox(height: 20),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelaxationPage(
                        7.0,
                        0.0,
                        7.0,
                        0.0,
                        120,
                        "Allows a balancing influence on the entire cardiorespiratory system. releases feeling of irritation and frustration, and helps calm the mind and the body.",
                        "Ujjayi"),
                  ));
            },
            child: Icon(Icons.eco, size: 40, color: DefaultColors.mainColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelaxationPage(
                        6.0,
                        0.0,
                        2.0,
                        0.0,
                        120,
                        "First thing in the morning relaxation exercise for a quick burst of energy and alertness.",
                        "Awake"),
                  ));
            },
            child: Icon(Icons.hotel, size: 40, color: DefaultColors.mainColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelaxationPage(
                        4.0,
                        7.0,
                        8.0,
                        0.0,
                        120,
                        "Natural and tranquilizing breathing exercise for the nervous system.",
                        "Deep Calm"),
                  ));
            },
            child: Icon(Icons.self_improvement,
                size: 40, color: DefaultColors.mainColor),
          ),
        ),
      ]),
      SizedBox(height: 10),
      Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
      SizedBox(height: 10),
    ]);
  }

  Widget rowMed({context}) {
    return Column(children: <Widget>[
      Text('Did you miss any medication?',
          style: Theme.of(context).textTheme.bodyText1),
      //Spacer(flex: 1),
      SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: ElevatedButton(
            onPressed: () {
              print('YES');
              //homelist.remove(0);
            },
            style: ElevatedButton.styleFrom(
                primary: DefaultColors.mainColor,
                onPrimary: Colors.white,
                textStyle: Theme.of(context).textTheme.bodyText1),
            child: const Text('Yes'),
          ),
        ),
        Container(
          //flex: 1,
          //child: Container(
          width: MediaQuery.of(context).size.width * 0.2,
          child: ElevatedButton(
            onPressed: () {
              print('NO');
              //homelist.remove(0);
            },
            style: ElevatedButton.styleFrom(
                primary: DefaultColors.mainColor,
                onPrimary: Colors.white,
                textStyle: Theme.of(context).textTheme.bodyText1),
            child: const Text('No'),
          ),
        ),
      ]),
      SizedBox(height: 10),
      Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
      SizedBox(height: 10),
    ]);
  }

  Widget rowMood({context, List homelist_}) {
    return Column(children: <Widget>[
      Text('How is your mood today?',
          style: Theme.of(context).textTheme.bodyText1),
      //Spacer(flex: 1),
      SizedBox(height: 10),
      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              print('STORM');
              //homelist.remove(0);
            },
            child: Icon(MyFlutterApp.storm,
                size: 40, color: DefaultColors.mainColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              //homelist_.remove(0);
              print('CLOUD');
              print(homelist_);
              //homelist.remove(0);
            },
            child: Icon(MyFlutterApp.cloudy,
                size: 40, color: DefaultColors.mainColor),
          ),
        ),
        Expanded(
          flex: 1,
          child: GestureDetector(
            onTap: () {
              print('SUNNY');
              //homelist.remove(0);
            },
            child: Icon(MyFlutterApp.sunny_day,
                size: 40, color: DefaultColors.mainColor),
          ),
        ),
      ]),
      SizedBox(height: 10),
      Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
      SizedBox(height: 10),
    ]);
  }

  Widget rowEdu({context}) {
    return Column(children: <Widget>[
      //Row(children: <Widget>[
      Text('Daily Tip', style: Theme.of(context).textTheme.bodyText1),
      //GestureDetector(
      //onTap: () {
      //homelist_.remove(0);
      //print('Web Page');
      //homelist.remove(0);
      //},
      //child: Icon(Icons.arrow_forward,
      //  size: 20, color: DefaultColors.mainColor),
      //),
      //]),
      SizedBox(height: 10),
      Container(
        width: MediaQuery.of(context).size.width * 0.85,
        height: MediaQuery.of(context).size.height * 0.1,
        child: ElevatedButton(
          onPressed: () {
            print('YES');
            //homelist.remove(0);
          },
          style: ElevatedButton.styleFrom(
              primary: Colors.white,
              onPrimary: DefaultColors.purpleLogo,
              textStyle: Theme.of(context).textTheme.bodyText1),
          child: Text('As pessoas com epilepsia podem praticar desporto?'),
        ),
      ),
      SizedBox(
        height: MediaQuery.of(context).size.height * 0.15,
      )
      //Spacer(flex: 1),
      // Expanded(
      // flex: 1,
      // child: Text('As podem praticar desporto?'),
      //),
    ]);
  }

  Widget getHomeTile(context, int i, List homelist_) {
    if (homelist_[i] == 0) {
      return rowMood(context: context, homelist_: homelist_);
    } else if (homelist_[i] == 1) {
      return rowRelax();
    } else if (homelist_[i] == 2) {
      return rowMed(context: context);
    } else if (homelist_[i] == 3) {
      return rowEdu(context: context);
    }
    //return medButton(message: 'Missed any medication?');
    //}
    else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: appBarAll(
          context,
          [
            IconButton(
                onPressed: () {
                  pushDynamicScreen(
                    context,
                    screen: NewSeizureTransitionPage(),
                    withNavBar: false,
                  );
                  /* pushNewScreen(context,
                      screen: BAAddSeizurePage(), withNavBar: false); */
                },
                icon: Icon(Icons.add_circle_outline_rounded, size: 30)),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
            ),
          ],
          'Home Page'),
      drawer: ProfileDrawer(logout: widget.logout),
      body: DecoratedBox(
          decoration: BoxDecoration(
              //image: DecorationImage(
              //  image: AssetImage("assets/images/casia_home.png"),
              //fit: BoxFit.contain),
              ),
          child: ListView(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: ValueListenableBuilder(
                  builder: (BuildContext context, List homelist, Widget child) {
                    print(homelist);
                    return ListView.builder(
                      //physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, position) {
                        return getHomeTile(context, position, homelist);
                      },
                      itemCount: homelist.length,
                    );
                  },
                  valueListenable: homelist,
                ),
              ),
            ],
          )),

      //);
      //}
      //}),
      //);//,
      floatingActionButton: alarmButton(
          icon: MyFlutterApp.ambulance,
          height: MediaQuery.of(context).size.width * 0.15,
          width: MediaQuery.of(context).size.width * 0.8,
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
