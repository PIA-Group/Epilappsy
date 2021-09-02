import 'package:casia/Pages/Emergency/AlertScreen.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/Widgets/humor.dart';
import 'package:casia/Widgets/dailytip.dart';
import 'package:casia/Pages/Hamburguer/profile_drawer.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/my_flutter_app_icons.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Models/homebuttons.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:casia/Pages/Hamburguer/RelaxationPage.dart';
import 'package:casia/main.dart';

//for the dictionaries
import '../app_localizations.dart';
import 'AddSeizure/NewSeizureTransitionPage.dart';

class HomePage extends StatefulWidget {
  final ValueNotifier<bool> logout;
  HomePage({this.logout});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List buttonsHPList;
  String userName = '';
  ValueNotifier<List<int>> homelist;
  double progress = 0.0;

  @override
  void initState() {
    /* Future.delayed(Duration.zero, () {
      registerPopUp();
    }); */
    //updateUser();
    super.initState();
    //_getDailyTip();

    homelist = ValueNotifier([0, 1, 2, 3]);
    //initHome();
  }

  Widget rowRelax() {
    return Column(children: <Widget>[
      Text(
          AppLocalizations.of(context)
                  .translate('join us in a breathing exercise')
                  .inCaps +
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
    int hour = 0;
    int min = 0;
    int secs = 30;
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Container(
            height: MediaQuery.of(context).size.width * 0.55,
            child:
                ListView(scrollDirection: Axis.horizontal, children: <Widget>[
              //Container(
              //  width: MediaQuery.of(context).size.width * 0.4,
              // child: humorBlock(context)),
              Container(width: 10, color: DefaultColors.backgroundColor),
              Container(
                width: MediaQuery.of(context).size.height * 0.22,
                child: homeBox(
                    context,
                    DefaultColors.boxHomeRed,
                    'assets/images/sleeping.png',
                    AppLocalizations.of(context)
                        .translate('new seizure')
                        .capitalizeFirstofEach,
                    NewSeizureTransitionPage(
                        duration: ValueNotifier('$hour:$min:$secs.0'))),
              ),
              Container(width: 10, color: DefaultColors.backgroundColor),
              Container(
                  width: MediaQuery.of(context).size.height * 0.22,
                  child: rowEdu(context, DefaultColors.boxHomePurple,
                      "assets/images/TIP_DAY.png")),
            ])));
  }

  Widget getHomeTile(context, int i, List homeList) {
    if (homeList[i] == 0) {
      return horizontalList(context);
    } //else if (homeList[i] == 1) {
    //return Container(child: humorQuestion(context));
    //}
    else if (homeList[i] == 3) {
      return Container(child: slideQuestion(context));
    } else {
      return Container();
    }
  }

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      drawer: ProfileDrawer(logout: widget.logout),
      body: Stack(children: [
        const AppBarHome(),
        Positioned(
          left: 10,
          top: AppBarHome.appBarHeight * 1 / 2,
          child: IconButton(
              icon: Icon(Icons.menu, color: DefaultColors.backgroundColor),
              onPressed: () => _scaffoldState.currentState.openDrawer()),
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
            child: Padding(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).size.height * 0.22),
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
              ]),
            ),
          ),
        ),
      ]),
      floatingActionButton: alarmButton(
          icon: MyFlutterApp.ambulance,
          height: MediaQuery.of(context).size.width * 0.12,
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
