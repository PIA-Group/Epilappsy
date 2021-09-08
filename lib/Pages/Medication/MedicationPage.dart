import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Pages/Medication/NewMedicationEntry.dart';
import 'package:casia/Pages/Medication/medication_answers.dart';
import 'package:casia/Pages/Medication/medication_dialog.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/main.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MedicationPage extends StatefulWidget {
  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AppBarAll(
          context: context,
          titleH: 'medication',
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
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ListView(children: [
                SizedBox(
                  height: 15,
                ),
                Text(
                    AppLocalizations.of(context)
                        .translate('active medications')
                        .inCaps,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center),
                currentMedication(),
                Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
                historicMedication(),
              ]),
            ),
          ),
        ),
      ]),
      floatingActionButton: Align(
        alignment: Alignment(0.98, 0.82),
        child: FloatingActionButton(
          backgroundColor: Colors.white,
          onPressed: () {
            pushNewScreen(context,
                screen: MedicationEntry(
                  answers: MedicationAnswers(),
                ),
                withNavBar: false);
          },
          child: const Icon(Icons.add, size: 30),
        ),
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
          return documents.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("press + to add a medication")
                        .inCaps,
                    textAlign: TextAlign.center,
                    style: MyTextStyle(color: Colors.grey[400]),
                  ))
              : ListView(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: documents.map((doc) {
                    Map<String, dynamic> docData =
                        doc.data() as Map<String, dynamic>;
                    return Row(children: [
                      Expanded(
                        child: ListTile(
                          title: Text(
                            docData['Medication name'],
                            style: MyTextStyle(),
                          ),
                          subtitle: Text(
                            AppLocalizations.of(context)
                                    .translate('intake times')
                                    .inCaps +
                                ': ' +
                                docData['Hours'].split(';').join(', '),
                            style: MyTextStyle(
                                color: Colors.grey[600], fontSize: 16),
                          ),
                          //trailing: Icon(Icons.alarm_on_outlined),
                          onTap: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return MedicationDialog(
                                    type: docData['Medicine type'],
                                    dosage: docData['Dosage'],
                                    startingDate: docData['Starting date'],
                                    hours:
                                        docData['Hours'].split(';').join(', '),
                                    medDoc: doc,
                                  );
                                });
                          },
                        ),
                      ),
                      IconButton(
                          icon: Icon(
                            Icons.alarm_on_outlined,
                            color: docData['Alarm']
                                ? DefaultColors.mainColor
                                : Colors.grey[400],
                          ),
                          onPressed: () {
                            updateMedication(
                                doc.id, 'Alarm', !docData['Alarm']);
                          }),
                    ]);
                  }).toList(),
                );
        } else {
          return Container();
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
          return documents.isEmpty
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    AppLocalizations.of(context)
                        .translate("press + to add a medication")
                        .inCaps,
                    textAlign: TextAlign.center,
                    style: MyTextStyle(color: Colors.grey[400]),
                  ))
              : ExpansionTile(
                  title: Text(
                    AppLocalizations.of(context)
                        .translate('medication history')
                        .inCaps,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center,
                  ),
                  children: documents.map((doc) {
                    Map<String, dynamic> docData =
                        doc.data() as Map<String, dynamic>;
                    print('document data: $docData');
                    return ListTile(
                      title: Text(docData['Medication name']),
                      subtitle: Text('Final date: ' + docData['Final date'],
                          style: MyTextStyle(
                              color: Colors.grey[600], fontSize: 16)),
                      onTap: null,
                    );
                  }).toList());
        } else {
          print('Could not access any data');
          return Container();
        }
      });
}
