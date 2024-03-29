import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilappsy/Authentication/RegisteringPage.dart';
import 'package:epilappsy/Pages/AddSeizure/NewSeizureTransitionPage.dart';
import 'package:epilappsy/Pages/Emergency/AlertScreen.dart';
import 'package:epilappsy/Widgets/humor.dart';
import 'package:epilappsy/Widgets/dailytip.dart';
import 'package:epilappsy/Widgets/profile_drawer.dart';
import 'package:epilappsy/Pages/Education/WebPageCasia.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/my_flutter_app_icons.dart';
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

class _HomePageState extends State<HomePage> {
  List buttonsHPList;
  String userName = '';
  ValueNotifier<List<int>> homelist;
  double progress = 0.0;

  String dailyTip =
      'Praticar desporto é importante também para quem tem epilepsia.';

  String linkTip = 'https://epilepsia.pt/epilepsia-e-o-desporto/';
  String ReadMore = '\n Carregue para ler mais';
  String tip_of_day = 'tip' + DateTime.now().day.toString();
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      registerPopUp();
    });
    //updateUser();
    super.initState();
    //_getDailyTip();

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
      Text(
          AppLocalizations.of(context)
                  .translate('Join us in a meditation exercise') +
              ':',
          textAlign: TextAlign.center,
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

  Widget humorBlock(context) {
    return FutureBuilder<dynamic>(
        future: getHumor(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            print('HERE ${snapshot.data['level']}');
            return filledhumor(
                context, snapshot.data['level']); //Text('Humor filled');
          } else {
            return newhumor(context);
          }
        });
  }

  Widget horizontalList(context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
        child: Container(
            height: MediaQuery.of(context).size.width * 0.55,
            child:
                ListView(scrollDirection: Axis.horizontal, children: <Widget>[
              //Container(
              //  width: MediaQuery.of(context).size.width * 0.4,
              // child: humorBlock(context)),
              Container(width: 10, color: DefaultColors.backgroundColor),
              Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: homeBox(
                      context,
                      DefaultColors.boxHomeRed,
                      'assets/images/sleeping.png',
                      Icons.brightness_2_outlined,
                      'Sleep Time')),
              Container(width: 10, color: DefaultColors.backgroundColor),
              Container(
                  width: MediaQuery.of(context).size.width * 0.4,
                  child: rowEdu(context, DefaultColors.boxHomePurple,
                      "assets/images/TIP_DAY.png", MyFlutterApp.home)),
            ])));
  }

  Widget getHomeTile(context, int i, List homelist_) {
    if (homelist_[i] == 0) {
      return horizontalList(context);
    } else if (homelist_[i] == 1) {
      return Container(child: humorQuestion(context));
    } else if (homelist_[i] == 3) {
      return Container(child: pillQuestion(context));
    } else {
      return Container();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //extendBodyBehindAppBar: true,
      appBar: appBarHome(context, [
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
      ]),
      drawer: ProfileDrawer(logout: widget.logout),
      body: Padding(
        padding:
            EdgeInsets.only(bottom: MediaQuery.of(context).size.height * 0.22),
        child: ListView(scrollDirection: Axis.vertical, children: [
          ValueListenableBuilder(
            builder: (BuildContext context, List homelist, Widget child) {
              return ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, position) {
                  return getHomeTile(context, position, homelist);
                },
                itemCount: homelist.length,
              );
            },
            valueListenable: homelist,
          ),
          SizedBox(height: 20),
        ]),
      ),

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
