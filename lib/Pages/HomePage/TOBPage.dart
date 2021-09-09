import 'package:casia/Pages/HomePage/BreathPage.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import '../../Utils/app_localizations.dart';

class TOBPage extends StatefulWidget {
  TOBPage({Key key}) : super(key: key);

  @override
  _TOBPageState createState() => _TOBPageState();
}

/*class TOBList{
  double inhale;
  double exhale;
  double hold1;
  double hold2;

  TOBList({this.inhale, this.exhale, this.hold1, this.hold2,});

}*/
class _TOBPageState extends State<TOBPage> {
  int selectedRadio;
  static const double _interGroupSpacing = 30;
  static const TextStyle styleExercise = TextStyle(
      fontFamily: 'canter', color: DefaultColors.purpleLogo, fontSize: 40);
  /* double _inhale = 0.0;
  double _exhale = 0.0;
  double _hold1 = 0.0;
  double _hold2 = 0.0; */
  //final List items = ["deep calm", "awake", "pranayama", "square"];
  final List images = [
    "relax_custom",
    "relax_awake",
    "relax_square",
    "relax_pranayama",
  ];
  ValueNotifier<double> _durationNotifier = ValueNotifier<double>(120.0);
  ValueListenable<double> get duration => _durationNotifier;

  final List colors = [
    DefaultColors.boxHomePurple,
    DefaultColors.boxHomeRed,
    DefaultColors.boxHomePurple,
    DefaultColors.boxHomeRed
  ];
  final Map<String, String> descriptions = {
    "deep calm":
        "natural and tranquilizing breathing exercise for the nervous system",
    "awake":
        "first thing in the morning relaxation exercize for a quick burst of energy and alertness",
    "pranayama":
        "formal practice which is the source of prana, or vital life force",
    "square":
        "four-square breathing, sometimes referred to as the box breathing technique, helps any time you feel stressed"
  };

  final Map<String, List> destinations = {
    "deep calm": [
      4.0,
      7.0,
      8.0,
      0.0,
    ],
    "awake": [
      6.0,
      0.0,
      2.0,
      0.0,
    ],
    "pranayama": [
      7.0,
      4.0,
      8.0,
      4.0,
    ],
    "square": [
      4.0,
      4.0,
      4.0,
      4.0,
    ]
  };

  @override
  void initState() {
    super.initState();

    selectedRadio = 0;
  }

  setSelectedRadio(int val) {
    setState(() {
      selectedRadio = val;
    });
  }

  void changeDuration(int time) {
    _durationNotifier.value = 60.0 * time;
  }

  @override
  Widget build(BuildContext context) {
    List<String> items = descriptions.keys.toList();
    items.shuffle();
    return Scaffold(
      backgroundColor: mycolor,
      body: Stack(children: [
        AppBarAll(
            context: context,
            //titleH: 'breathing exercises',
            icon: Icons.self_improvement_rounded),
        Positioned(
          left: 10,
          top: AppBarHome.appBarHeight * 0.45,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: DefaultColors.backgroundColor,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: AppBarAll.appBarHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                  color: DefaultColors.backgroundColor,
                  borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(30.0),
                    topRight: const Radius.circular(30.0),
                  )),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Expanded(
                      child: Text(
                          AppLocalizations.of(context)
                              .translate(
                                  'press anywhere to start, slide right for other exercises')
                              .inCaps,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyText2),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      // padding: EdgeInsets.all(0.0),
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        return Center(
                            child: ExerciseTile(
                          context: context,
                          color: colors[index],
                          imagePath: 'assets/images/' + images[index] + '.gif',
                          title: AppLocalizations.of(context)
                              .translate(items[index])
                              .capitalizeFirstofEach,
                          description: AppLocalizations.of(context)
                              .translate(descriptions[items[index]])
                              .inCaps,
                          destination: destinations[items[index]],
                          duration: 60.0,
                          newScreen: true,
                        ));
                      },
                    ),
                  ),
                ],
              )),
        ),
      ]),
    );
  }
}

class ExerciseTile extends StatelessWidget {
  final BuildContext context;
  final Color color;
  final String title;
  final String imagePath;
  final String description;
  final duration;
  final destination;
  final bool newScreen;

  const ExerciseTile({
    Key key,
    this.context,
    this.color,
    this.title,
    this.description,
    this.imagePath,
    this.destination,
    this.duration,
    this.newScreen,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 10.0),
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => BreathePage(
                        destination[0],
                        destination[1],
                        destination[2],
                        destination[3],
                        duration,
                        description,
                        title,
                        color)));
          },
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(vertical: 5.0, horizontal: 5.0),
            elevation: 0,
            //shape:
            //  RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            primary: DefaultColors.backgroundColor,
          ),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.35,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(imagePath),
                        alignment: Alignment.center),
                  ),
                ),
                //Spacer(),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      title,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      style: Theme.of(context).textTheme.headline3,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      maxLines: 4,
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ),
                // Spacer(),
              ]),
        ),
      ),
    );
  }
}
