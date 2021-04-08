import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/main.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/RelaxationPage.dart';

//for the dictionaries
import '../app_localizations.dart';

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
  /* double _inhale = 0.0;
  double _exhale = 0.0;
  double _hold1 = 0.0;
  double _hold2 = 0.0; */

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: mycolor,
        appBar: AppBar(
              elevation: 0.0,
              title: appBarTitle(context, 'Types'),
              backgroundColor: Theme.of(context).unselectedWidgetColor,
              ),
        body: Column(mainAxisAlignment: MainAxisAlignment.start, children: <
            Widget>[
          Divider(
            height: 20,
            color: Colors.green,
          ),
          Text(
            AppLocalizations.of(context).translate("Inhale-Hold-Exhale-Hold"),
          ),
          RadioListTile(
            value: 1,
            groupValue: selectedRadio,
            title: Text(AppLocalizations.of(context).translate("Custom")),
            subtitle: Text("5-2-6-2"),
            onChanged: (val) {
              setSelectedRadio(val);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        RelaxationPage(5.0, 2.0, 6.0, 2.0, 120, "", "Custom"),
                  ));
            },
            activeColor: Colors.red,
            selected: false,
          ),
          RadioListTile(
            value: 2,
            groupValue: selectedRadio,
            title: Text(AppLocalizations.of(context).translate("Awake")),
            subtitle: Text("6-0-2-0"),
            onChanged: (val) {
              setSelectedRadio(val);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelaxationPage(
                        6.0,
                        0.0,
                        2.0,
                        0.0,
                        120,
                        "First thing in the morning relaxation exercize for a quick burst of energy and alertness.",
                        "Awake"),
                  ));
            },
            activeColor: Colors.red,
            selected: false,
          ),
          RadioListTile(
            value: 3,
            groupValue: selectedRadio,
            title: Text(AppLocalizations.of(context).translate("Deep Calm")),
            subtitle: Text(
                "4-7-8-0                                                                               This breathing exercise is a natural tranquilizer for the nervous system."),
            onChanged: (val) {
              setSelectedRadio(val);
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
            activeColor: Colors.red,
            selected: false,
          ),
          RadioListTile(
            value: 4,
            groupValue: selectedRadio,
            title: Text(AppLocalizations.of(context).translate("Pranayama")),
            subtitle: Text("7-4-8-4"),
            onChanged: (val) {
              setSelectedRadio(val);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelaxationPage(
                        7.0,
                        4.0,
                        8.0,
                        4.0,
                        120,
                        "Formal practice which is the source of prana, or vital life force.",
                        "Pranayama"),
                  ));
            },
            activeColor: Colors.red,
            selected: false,
          ),
          RadioListTile(
            value: 5,
            groupValue: selectedRadio,
            title: Text(AppLocalizations.of(context).translate("Square")),
            subtitle: Text("4-4-4-4"),
            onChanged: (val) {
              setSelectedRadio(val);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => RelaxationPage(
                        4.0,
                        4.0,
                        4.0,
                        4.0,
                        120,
                        "Four-square breathing, sometimes referred to as the box breathing technique, helps any time you feel stressed.",
                        "Square"),
                  ));
            },
            activeColor: Colors.red,
            selected: false,
          ),
          RadioListTile(
            value: 6,
            groupValue: selectedRadio,
            title: Text(AppLocalizations.of(context).translate("Ujjayi")),
            subtitle: Text("7-0-7-0"),
            onChanged: (val) {
              setSelectedRadio(val);
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
            activeColor: Colors.red,
            selected: false,
          ),
        ]));
  }
}
