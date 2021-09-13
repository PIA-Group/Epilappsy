import 'package:casia/Database/database.dart';
import 'package:casia/Pages/Education/EducationPage.dart';
import 'package:casia/Pages/Education/WebPageCasia.dart';
import 'package:casia/Pages/Emergency/AlertScreen.dart';
import 'package:casia/Pages/HomePage/UserPage.dart';
import 'package:casia/Pages/HomePage/shared_prefs.dart';
import 'package:casia/Pages/Medication/medication.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/Models/homebuttons.dart';
import 'package:casia/design/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:casia/main.dart';
import 'package:intl/intl.dart';

//for the dictionaries
import '../../Utils/app_localizations.dart';
import '../AddSeizure/NewSeizureTransitionPage.dart';

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
  ValueNotifier<Map<String, dynamic>> dailySchedule = ValueNotifier({});
/*
  Stream<String> _getMedication() async* {
    // This loop will run forever because _running is always true
    await Future<void>.delayed(Duration(seconds: 1)).then(() {getMedication()});
      // This will be displayed on the screen as current time
      yield "${_now.hour} : ${_now.minute} : ${_now.second}";
    
  }*/

  @override
  void initState() {
    initDailySchedule(dailySchedule);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      //drawer: ProfileDrawer(logout: widget.logout),
      body: Stack(children: [
        const AppBarHome(
          titleH: 'hello',
        ),
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
                pushNewScreen(context, screen: UserPage(logout: widget.logout,), withNavBar: false),
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
                DailySchedule(dailySchedule: dailySchedule),

                /* FutureBuilder(
                    future: getMedication(),
                    builder: (context, snapshot) {
                      List datas = [];
                      if (snapshot.hasData) {
                        datas = snapshot.data;
                        dailySchedule(datas);
                        print('Daily data $datas');
                      }
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: datas.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              leading: Icon(Icons.ac_unit),
                              title: Text(datas[index]['Medication name']),
                              subtitle: Text(datas[index]['Starting time']),
                              trailing: TextButton(
                                onPressed: () {},
                                style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          DefaultColors.boxHomeRed),
                                ),
                                child: Text('Done'),
                              ),
                            );
                          });
                    }),*/
                SizedBox(height: _intraGroupSpacing),
              ]),
            ),
          ),
        ),
      ]),
      floatingActionButton: alarmButton(
          icon: Icons.add_alert_sharp,
          height: MediaQuery.of(context).size.height * 0.07,
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
              color: DefaultColors.boxHomePurple,
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
              color: DefaultColors.boxHomeRed,
              imagePath: 'assets/images/sleep.png',
              title: AppLocalizations.of(context)
                  .translate('daily tip')
                  .capitalizeFirstofEach,
              destination: WebViewContainer(),
              newScreen: true,
            ),
            Container(width: 10, color: DefaultColors.backgroundColor),
            Banner(
              message: AppLocalizations.of(context).translate('soon'),
              location: BannerLocation.topEnd,
              child: HorizontalTile(
                context: context,
                color: DefaultColors.boxHomePurple,
                imagePath: 'assets/images/relax_pink.png',
                title: AppLocalizations.of(context)
                    .translate('relax here')
                    .capitalizeFirstofEach,
                destination: null, //TOBPage(),
                newScreen: true,
              ),
            ),
            Container(width: 10, color: DefaultColors.backgroundColor),
            HorizontalTile(
              context: context,
              color: DefaultColors.boxHomeRed,
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
            if (destination != null) {
              if (newScreen)
                pushNewScreen(context, screen: destination, withNavBar: false);
              else
                pushDynamicScreen(
                  context,
                  screen: destination,
                  withNavBar: false,
                );
            }
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
                /* imagePath.contains('svg')
                    ? Container(
                        height: MediaQuery.of(context).size.height * 0.15,
                        child: SvgPicture.asset(imagePath, alignment: Alignment.topRight),
                      )
                    :  */
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

class DailySchedule extends StatelessWidget {
  final ValueNotifier<Map<String, dynamic>> dailySchedule;

  DailySchedule({Key key, this.dailySchedule}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: dailySchedule,
        builder: (BuildContext context, Map<String, dynamic> previousSchedule,
            Widget _) {
          return StreamBuilder<QuerySnapshot>(
            stream: getMedicationStream(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                final List<DocumentSnapshot> documents = snapshot.data.docs;
                Map<String, dynamic> newDailySchedule =
                    getDailySchedule(context, documents);
                newDailySchedule.forEach((key, value) {
                  if (dailySchedule.value.containsKey(key))
                    newDailySchedule[key] = dailySchedule.value[key];
                });
                return Container(
                  alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.2,
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: newDailySchedule.length,
                      itemBuilder: (context, index) {
                        String key = newDailySchedule.keys.elementAt(index);
                        String medInfo = key.split(',')[0];
                        String intakeTime = key.split(',')[1];
                        return ListTile(
                          visualDensity:
                              VisualDensity(horizontal: 0, vertical: -4),
                          leading: newDailySchedule[key]
                              ? Icon(Icons.check_circle_rounded,
                                  size: 30,
                                  color: (index % 2 == 0)
                                      ? DefaultColors.boxHomeRed
                                      : DefaultColors.boxHomePurple)
                              : Icon(Icons.circle_outlined,
                                  size: 30,
                                  color: (index % 2 == 0)
                                      ? DefaultColors.boxHomeRed
                                      : DefaultColors.boxHomePurple),
                          title: Text(intakeTime),
                          subtitle: Text(medInfo),
                          trailing: newDailySchedule[key]
                              ? null
                              : ElevatedButton(
                                  onPressed: () {
                                    newDailySchedule[key] = true;
                                    updateDailySchedule(newDailySchedule);
                                    dailySchedule.value = newDailySchedule;
                                  },
                                  style: ElevatedButton.styleFrom(
                                      shadowColor: Colors.white,
                                      padding: EdgeInsets.zero,
                                      fixedSize: Size(80, 10),
                                      shape: StadiumBorder(),
                                      primary: (index % 2 == 0)
                                          ? DefaultColors.boxHomeRed
                                          : DefaultColors.boxHomePurple),
                                  child: Text(
                                    AppLocalizations.of(context)
                                        .translate('done')
                                        .inCaps,
                                    style: MyTextStyle(
                                        fontSize: 16,
                                        color: DefaultColors.backgroundColor),
                                  ),
                                ),
                        );
                      }),
                );
              } else {
                return Container();
              }
            },
          );
        });
  }
}

Future<void> initDailySchedule(
    ValueNotifier<Map<String, dynamic>> dailySchedule) async {
  DateTime today = DateTime.now();
  Map<String, dynamic> schedule =
      await SharedPref.read('dailySchedule').then((value) {
    print('saved schedule: $value');
    if (value != null && value['day'] == DateFormat('yyyy-MM-dd').format(today))
      return value;
    else
      return null;
  });
  if (schedule != null) dailySchedule.value = schedule['schedule'];
}

Map<String, dynamic> getDailySchedule(
    BuildContext context, List<DocumentSnapshot> documents) {
  List<String> aux = [];
  Map<String, dynamic> schedule = {};
  documents.forEach((element) {
    Medication medInfo = medicationFromJson(element.data());
    List<String> times = getlistIntakeTimes(medInfo.intakes['startTime'],
        medInfo.intakes['intakeTime'], medInfo.intakes['interval'], context);

    times.forEach((time) {
      aux.add(
          '$time,${medInfo.name} (${medInfo.dosage["dose"]} ${AppLocalizations.of(context).translate(medInfo.dosage["unit"])})');
    });
    print('aux: $aux');

    /* for (String time in times) {
      schedule[
              '${medInfo.name} (${medInfo.dosage["dose"]} ${AppLocalizations.of(context).translate(medInfo.dosage["unit"])}),$time'] =
          false;
    } */
  });
  aux.sort((a, b) => a.compareTo(b));
  print('aux final: $aux');
  for (String s in aux) {
    schedule[s] = false;
  }

  return schedule;
}

void updateDailySchedule(Map<String, dynamic> newDailySchedule) {
  DateTime today = DateTime.now();
  SharedPref.save('dailySchedule', {
    'day': DateFormat('yyyy-MM-dd').format(today),
    'schedule': newDailySchedule
  });
  print('updated daily schedule');
}

List<String> getlistIntakeTimes(TimeOfDay startTime, TimeOfDay intakeTime,
    int interval, BuildContext context) {
  if (startTime == null) {
    return null;
  } else {
    DateTime auxDateTime = DateTime(0, 0, 0, startTime.hour, startTime.minute);

    List<String> intakeTimes = [
      MaterialLocalizations.of(context).formatTimeOfDay(startTime)
    ];

    TimeOfDay newIntakeTime =
        TimeOfDay.fromDateTime(auxDateTime.add(Duration(hours: interval)));

    while (newIntakeTime.hour != startTime.hour) {
      intakeTimes += [
        MaterialLocalizations.of(context).formatTimeOfDay(newIntakeTime)
      ];

      auxDateTime = DateTime(0, 0, 0, newIntakeTime.hour, newIntakeTime.minute);
      newIntakeTime =
          TimeOfDay.fromDateTime(auxDateTime.add(Duration(hours: interval)));
    }

    intakeTimes.sort((a, b) => a.compareTo(b));

    return intakeTimes;
  }
}
