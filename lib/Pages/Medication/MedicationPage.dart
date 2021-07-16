import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Pages/Medication/NewMedicationEntry.dart';
import 'package:casia/Pages/Medication/medication_answers.dart';
import 'package:casia/Pages/Medication/medication_dialog.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MedicationPage extends StatefulWidget {
  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAll(
          context,
          [
            IconButton(
                onPressed: () {
                  pushNewScreen(context,
                      screen: NewMedicationEntry(
                          answers: ValueNotifier(MedicationAnswers(
                        startDate: DateTime.now(),
                        alarm: {
                          'active': true,
                          'startTime': TimeOfDay.now(),
                          'interval': null
                        },
                      ))),
                      withNavBar: false);
                },
                icon: Icon(Icons.add_circle_outline_rounded, size: 30)),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
            ),
          ],
          'Medication'),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: ListView(children: [
          SizedBox(
            height: 15,
          ),
          Text(AppLocalizations.of(context).translate('Active medications'),
              style: Theme.of(context).textTheme.bodyText1,
              textAlign: TextAlign.center),
          currentMedication(),
          Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
          historicMedication(),
        ]),
      ),
    );
  }
}

Widget currentMedication() {
  String uid = BAApi.loginToken;
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medication-patients')
          .doc(uid)
          .collection('current')
          .orderBy('Medication name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data.docs;
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: documents.isEmpty
                ? Padding(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Text(
                      AppLocalizations.of(context)
                          .translate("Press + to add a reminder"),
                      textAlign: TextAlign.center,
                      style: MyTextStyle(color: Colors.grey[400]),
                    ))
                : ListView(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    children: documents
                        .map(
                          (doc) => Row(children: [
                            Expanded(
                              child: ListTile(
                                title: Text(
                                  doc.data()['Medication name'],
                                  style: MyTextStyle(),
                                ),
                                subtitle: Text(
                                    AppLocalizations.of(context)
                                            .translate('Intake times') +
                                        ': ' +
                                        doc
                                            .data()['Hours']
                                            .split(';')
                                            .join(', '),
                                    style: MyTextStyle(
                                        color: Colors.grey[600], fontSize: 16)),
                                //trailing: Icon(Icons.alarm_on_outlined),
                                onTap: () {
                                  showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return MedicationDialog(
                                          type: doc.data()['Medicine type'],
                                          dosage: doc.data()['Dosage'],
                                          startingDate:
                                              doc.data()['Starting date'],
                                          hours: doc
                                              .data()['Hours']
                                              .split(';')
                                              .join(', '),
                                          medDoc: doc,
                                        );
                                      });
                                },
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.alarm_on_outlined,
                                  color: doc.data()['Alarm']
                                      ? DefaultColors.mainColor
                                      : Colors.grey[400],
                                ),
                                onPressed: () {
                                  updateMedication(
                                      doc.id, 'Alarm', !doc.data()['Alarm']);
                                }),
                          ]),
                        )
                        .toList()),
          );
        } else {
          print('something went wrong');
          return Text(
              AppLocalizations.of(context).translate("Something went wrong!"));
        }
      });
}

Widget historicMedication() {
  String uid = BAApi.loginToken;
  return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('medication-patients')
          .doc(uid)
          .collection('history')
          .orderBy('Medication name')
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          final List<DocumentSnapshot> documents = snapshot.data.docs;
          return Theme(
            data: ThemeData().copyWith(
                dividerColor: Colors.transparent,
                accentColor: DefaultColors.logoColor),
            child: ExpansionTile(
                title: Text(
                  AppLocalizations.of(context).translate('Medication history'),
                  style: Theme.of(context).textTheme.bodyText1,
                  textAlign: TextAlign.center,
                ),
                children: documents
                    .map((doc) => ListTile(
                          title: Text(doc.data()['Medication name']),
                          subtitle: Text(
                              'Final date: ' + doc.data()['Final date'],
                              style: MyTextStyle(
                                  color: Colors.grey[600], fontSize: 16)),
                          onTap: null,
                        ))
                    .toList()),
          );
        } else {
          print('something went wrong');
          return Text(
              AppLocalizations.of(context).translate("Something went wrong!"));
        }
      });
}
