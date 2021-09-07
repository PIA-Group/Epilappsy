import 'package:casia/Pages/Education/EducationPage.dart';
import 'package:casia/Pages/Education/WebPageCasia.dart';
import 'package:casia/Pages/Emergency/AlertScreen.dart';
import 'package:casia/Pages/Hamburguer/TOBPage.dart';
import 'package:casia/Pages/Hamburguer/UserPage.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/my_flutter_app_icons.dart';
import 'package:casia/Models/homebuttons.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
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
  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();

  static const double _interGroupSpacing = 30;
  static const double _intraGroupSpacing = 15;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      //drawer: ProfileDrawer(logout: widget.logout),
      body: Stack(children: [
        const AppBarHome(),
        Positioned(
          left: 10,
          top: AppBarHome.appBarHeight * 0.45,
          child: IconButton(
            icon: Icon(
              Icons.person,
              color: DefaultColors.backgroundColor,
              size: 30,
            ),
            onPressed: () =>
                pushNewScreen(context, screen: UserPage(), withNavBar: false),
          ),
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
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ListView(shrinkWrap: true, children: [
                Text(
                  AppLocalizations.of(context)
                      .translate('explore these functionalities')
                      .inCaps,
                  style: TextStyle(
                      fontFamily: 'canter',
                      color: DefaultColors.purpleLogo,
                      fontSize: MediaQuery.of(context).size.width * 0.09),
                ),
                SizedBox(height: _intraGroupSpacing),
                HorizontalListTile(),
                SizedBox(height: _interGroupSpacing),
                Text(
                  AppLocalizations.of(context)
                      .translate('take a look at your day')
                      .inCaps,
                  style: TextStyle(
                      fontFamily: 'canter',
                      color: DefaultColors.purpleLogo,
                      fontSize: MediaQuery.of(context).size.width * 0.09),
                ),
                SizedBox(height: _intraGroupSpacing),
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

class HorizontalListTile extends StatelessWidget {
  const HorizontalListTile({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
      child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: <Widget>[
            HorizontalTile(
              context: context,
              color: DefaultColors.boxHomeRed,
              imagePath: 'assets/images/sleeping.png',
              title: AppLocalizations.of(context)
                  .translate('new seizure')
                  .capitalizeFirstofEach,
              destination: NewSeizureTransitionPage(
                  duration: ValueNotifier('00:00:30.0')),
              newScreen: false,
            ),
            Container(width: 10, color: DefaultColors.backgroundColor),
            HorizontalTile(
              context: context,
              color: DefaultColors.boxHomePurple,
              imagePath: 'assets/images/TIP_DAY.png',
              title: AppLocalizations.of(context)
                  .translate('daily tip')
                  .capitalizeFirstofEach,
              destination: WebViewContainer(),
              newScreen: true,
            ),
            Container(width: 10, color: DefaultColors.backgroundColor),
            HorizontalTile(
              context: context,
              color: DefaultColors.boxHomeRed,
              imagePath: 'assets/images/exercises.png',
              title: AppLocalizations.of(context)
                  .translate('relax here')
                  .capitalizeFirstofEach,
              destination: TOBPage(),
              newScreen: true,
            ),
            Container(width: 10, color: DefaultColors.backgroundColor),
            HorizontalTile(
              context: context,
              color: DefaultColors.boxHomePurple,
              imagePath: 'assets/images/TIP_DAY.png',
              title: AppLocalizations.of(context)
                  .translate('education')
                  .capitalizeFirstofEach,
              destination: EducationalPage(),
              newScreen: true,
            ),
          ]),
    );
  }
}

class HorizontalTile extends StatelessWidget {
  final BuildContext context;
  final Color color;
  final String title;
  final String imagePath;
  final destination;
  final bool newScreen;

  const HorizontalTile({
    Key key,
    this.context,
    this.color,
    this.title,
    this.imagePath,
    this.destination,
    this.newScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.35,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
        child: ElevatedButton(
          onPressed: () {
            if (newScreen)
              pushNewScreen(context, screen: destination, withNavBar: false);
            else
              pushDynamicScreen(
                context,
                screen: destination,
                withNavBar: false,
              );
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            elevation: 5,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: color,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(imagePath),
                        alignment: Alignment.topRight),
                  ),
                ),
                Spacer(),
                Expanded(
                  child: Text(
                    title,
                    textAlign: TextAlign.start,
                    maxLines: 2,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                )
              ]),
        ),
      ),
    );
  }
}
