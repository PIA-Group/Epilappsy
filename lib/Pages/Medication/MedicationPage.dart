import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Pages/Medication/NewMedicationEntry.dart';
import 'package:casia/Pages/Medication/historic_medication.dart';
import 'package:casia/Pages/Medication/medication.dart';
import 'package:casia/Utils/costum_dialogs/historic_medication_dialog.dart';
import 'package:casia/Utils/costum_dialogs/medication_dialog.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:casia/Utils/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/main.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:intl/intl.dart';

class MedicationPage extends StatefulWidget {
  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  static const double spacingBeforeAfterDivider = 10;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AppBarHome(
          //context: context,
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
                        .translate('active medication')
                        .inCaps,
                    style: Theme.of(context).textTheme.bodyText2,
                    textAlign: TextAlign.center),
                CurrentMedicationBlock(),
                SizedBox(height: spacingBeforeAfterDivider),
                Divider(height: 0, thickness: 2, indent: 15, endIndent: 15),
                HistoricMedicationBlock(),
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
                  answers: Medication(),
                ),
                withNavBar: false);
          },
          child: const Icon(Icons.add, size: 30),
        ),
      ),
    );
  }
}

class CurrentMedicationBlock extends StatelessWidget {
  CurrentMedicationBlock({Key key}) : super(key: key);

  final String uid = BAApi.loginToken;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('patient-medications')
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
                      Medication medication = medicationFromJson(docData);
                      final String intakeTimes = getIntakeTimes(
                        medication.intakes['startTime'],
                        medication.intakes['intakeTime'],
                        medication.intakes['interval'],
                        context,
                      );
                      return Row(children: [
                        Expanded(
                          child: ListTile(
                            title: Text(
                              '${medication.name} (${medication.dosage['dose']} ${AppLocalizations.of(context).translate(medication.dosage['unit'])})',
                              style: MyTextStyle(),
                            ),
                            subtitle: Text(
                              AppLocalizations.of(context)
                                      .translate('intake time(s)')
                                      .inCaps +
                                  ': ' +
                                  intakeTimes,
                              style: MyTextStyle(
                                  color: Colors.grey[600], fontSize: 16),
                            ),
                            onTap: () {
                              showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return MedicationDialog(
                                      medication: medication,
                                      hours: intakeTimes,
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
                              updateMedicationField(
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
}

class HistoricMedicationBlock extends StatelessWidget {
  HistoricMedicationBlock({Key key}) : super(key: key);

  final String uid = BAApi.loginToken;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('patient-medications')
            .doc(uid)
            .collection('historic')
            .orderBy('Medication name')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final List<DocumentSnapshot> documents = snapshot.data.docs;
            return ExpansionTile(
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
                  HistoricMedication historicMedication =
                      HistoricMedication.fromJson(docData);
                  final String intakeTimes = getIntakeTimes(
                    historicMedication.intakes['startTime'],
                    historicMedication.intakes['intakeTime'],
                    historicMedication.intakes['interval'],
                    context,
                  );
                  print('intake : $intakeTimes');
                  return ListTile(
                    title: Text(
                        '${historicMedication.name} (${historicMedication.dosage["dose"]} ${historicMedication.dosage["unit"]})'),
                    subtitle: Text(
                        historicMedication.intakeDate == null
                            ? '${DateFormat('dd-MM-yyyy').format(historicMedication.startDate)} ${AppLocalizations.of(context).translate("until")} ${DateFormat('dd-MM-yyyy').format(historicMedication.endDate)}'
                            : DateFormat('dd-MM-yyyy')
                                .format(historicMedication.intakeDate),
                        style:
                            MyTextStyle(color: Colors.grey[600], fontSize: 16)),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return HistoricMedicationDialog(
                              historicMedication: historicMedication,
                              type: historicMedication.type,
                              dosage:
                                  '${historicMedication.dosage['dose']} ${historicMedication.dosage['unit']}',
                              startingDate: historicMedication.startDate,
                              endingDate: historicMedication.endDate,
                              hours: intakeTimes,
                              medDoc: doc,
                            );
                          });
                    },
                  );
                }).toList());
          } else {
            return Container();
          }
        });
  }
}

String getIntakeTimes(TimeOfDay startTime, TimeOfDay intakeTime, int interval,
    BuildContext context) {
  if (startTime == null) {
    if (intakeTime != null)
      return MaterialLocalizations.of(context).formatTimeOfDay(intakeTime);
    else
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

    return intakeTimes.join(', ');
  }
}
