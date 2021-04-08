import 'package:epilappsy/Caregiver/ConnectPatient.dart';
import 'package:epilappsy/Pages/Education/EducationPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Models/homebuttons.dart';
import 'package:epilappsy/Pages/PeriodPage.dart';
import 'package:epilappsy/Pages/SettingsPage.dart';
import 'package:epilappsy/Pages/TOBPage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import '../app_localizations.dart';

class CGHomePage extends StatefulWidget {
  CGHomePage({Key key}) : super(key: key);

  @override
  _CGHomePageState createState() => _CGHomePageState();
}

class _CGHomePageState extends State<CGHomePage> {
  List buttonsHPList;
  User currentUser;

  Future getbuttonsHPs() async {
    return [
      ButtonsHP(
        title:
            AppLocalizations.of(context).translate("Introduction to Epilepsy"),
        color1: Color.fromRGBO(179, 244, 86, 0.8),
        color2: Color.fromRGBO(142, 255, 249, 0.7),
        nextPage: EducationalPage(),
        icon: Icons.info,
      ),
      ButtonsHP(
        title: AppLocalizations.of(context).translate("Patients"),
        color1: Color.fromRGBO(229, 223, 120, 0.9),
        color2: Color.fromRGBO(179, 244, 86, 0.8),
        nextPage: PeriodPage(),
        icon: Icons.device_hub,
      ),
      ButtonsHP(
        title: AppLocalizations.of(context).translate("Camera Access"),
        color1: Color.fromRGBO(249, 243, 140, 0.95),
        color2: Color.fromRGBO(252, 169, 83, 1),
        nextPage: EducationalPage(),
        icon: Icons.camera,
      ),
      ButtonsHP(
          title: AppLocalizations.of(context).translate("Record Seizure"),
          color1: Color.fromRGBO(252, 169, 83, 1),
          color2: Color.fromRGBO(249, 243, 140, 0.9),
          nextPage: TOBPage(),
          icon: Icons.note_add),
    ];
  }

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    Future.delayed(Duration.zero, () {
      associatePatientPopUp();
    });
    super.initState();
  }

  void associatePatientPopUp() async {
    bool hasPatient = await checkIfHasPatient(currentUser.uid);
    print("patient associated: $hasPatient");
    if (!hasPatient) {
      _associatePatientDialog();
    }
  }

  Future<void> _associatePatientDialog() async {
    await Future.delayed(Duration.zero);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)
                .translate('No patient associated yet!'),
            textAlign: TextAlign.start,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(right: 15.0, left: 15.0),
                  child: Text(
                    AppLocalizations.of(context).translate(
                        'We noticed there is still no patient associated to your account, please associate one.'),
                    textAlign: TextAlign.justify,
                  ),
                ),
                ButtonBar(
                    alignment: MainAxisAlignment.center,
                    children: <Widget>[
                      ElevatedButton(
                        child: Text(AppLocalizations.of(context)
                            .translate("Associate now!")),
                        onPressed: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ConnectPatientPage()),
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

  @override
  Widget build(BuildContext context) {
    ListTile makeListTile(ButtonsHP buttonsHP) => ListTile(
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
          trailing:
              Icon(Icons.keyboard_arrow_right, color: Colors.white, size: 30.0),
          onTap: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => buttonsHP.nextPage));
          },
        );

    Card makeCard(ButtonsHP buttonsHP) => Card(
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
        title: appBarTitleCG(context),
        backgroundColor: Color.fromRGBO(71, 98, 123, 1),
        actions: [
          IconButton(
            icon: Icon(Icons.settings, color: Colors.white),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => SettingsPage()));
            },
          )
        ],
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
                            AppLocalizations.of(context).translate('Caregiver'),
                            style: TextStyle(color: Colors.white),
                          ),
                          Text(
                            currentUser.email,
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
      body: FutureBuilder(
          future: getbuttonsHPs(),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return Column(
                      children: <Widget>[makeCard(snapshot.data[index])],
                    );
                  },
                ),
              );
            }
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
