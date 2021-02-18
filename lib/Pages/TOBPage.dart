import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Pages/RelaxationPage.dart';

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
  double _inhale = 0.0;
  double _exhale = 0.0;
  double _hold1 = 0.0;
  double _hold2 = 0.0;

  void initState() {
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
        backgroundColor: Colors.green[100],
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Divider(
                height: 20,
                color: Colors.green,
              ),
              Text(
                "Inhale-Hold-Exhale-Hold",
              ),
              RadioListTile(
                value: 1,
                groupValue: selectedRadio,
                title: Text("Custom"),
                subtitle: Text("5-2-6-2"),
                onChanged: (val) {
                  setSelectedRadio(val);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RelaxationPage(5.0, 2.0, 6.0, 2.0, 120),
                      ));
                },
                activeColor: Colors.red,
                selected: false,
              ),
              RadioListTile(
                value: 2,
                groupValue: selectedRadio,
                title: Text("Awake"),
                subtitle: Text(
                    "6-0-2-0                                                                               Using this technique first thing in the morning for quick burst of energy and alertness."),
                onChanged: (val) {
                  setSelectedRadio(val);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RelaxationPage(6.0, 0.0, 2.0, 0.0, 120),
                      ));
                },
                activeColor: Colors.red,
                selected: false,
              ),
              RadioListTile(
                value: 3,
                groupValue: selectedRadio,
                title: Text("Deep Calm"),
                subtitle: Text(
                    "4-7-8-0                                                                               This breathing exercise is a natural tranquilizer for the nervous system."),
                onChanged: (val) {
                  setSelectedRadio(val);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RelaxationPage(4.0, 7.0, 8.0, 0.0, 120),
                      ));
                },
                activeColor: Colors.red,
                selected: false,
              ),
              RadioListTile(
                value: 4,
                groupValue: selectedRadio,
                title: Text("Pranayama"),
                subtitle: Text(
                    "7-4-8-4                                                                               Is the formal practice of controling the breath which is the source of our prana, or vital life force."),
                onChanged: (val) {
                  setSelectedRadio(val);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RelaxationPage(7.0, 4.0, 8.0, 4.0, 120),
                      ));
                },
                activeColor: Colors.red,
                selected: false,
              ),
              RadioListTile(
                value: 5,
                groupValue: selectedRadio,
                title: Text("Square"),
                subtitle: Text(
                    "4-4-4-4                                                                               Four-square breathing, sometimes referred to as the box breathing technique, helps any time you feel stressed."),
                onChanged: (val) {
                  setSelectedRadio(val);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RelaxationPage(4.0, 4.0, 4.0, 4.0, 120),
                      ));
                },
                activeColor: Colors.red,
                selected: false,
              ),
              RadioListTile(
                value: 6,
                groupValue: selectedRadio,
                title: Text("Ujjayi"),
                subtitle: Text(
                    "7-0-7-0                                                                               It allows a balancing influence on the entire cardiorespiratory system. releases feeling of irritation and frustration, and helps calm the mind and the body."),
                onChanged: (val) {
                  setSelectedRadio(val);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            RelaxationPage(7.0, 0.0, 7.0, 0.0, 120),
                      ));
                },
                activeColor: Colors.red,
                selected: false,
              ),
            ]));
  }
}
