import 'package:casia/Pages/Medication/historic_medication.dart';
import 'package:casia/Utils/costum_dialogs/date_dialog.dart';
import 'package:casia/Utils/costum_dialogs/list_tile_dialog.dart';
import 'package:casia/Pages/AddSeizure/questionnaire_tiles.dart';
import 'package:casia/Pages/Medication/medication.dart';
import 'package:casia/Pages/Medication/reminders.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';
import 'package:casia/main.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class MedicationEntry extends StatefulWidget {
  final ReminderDetails remDetails;
  final Medication answers;
  final DocumentSnapshot<Object> medDoc;

  MedicationEntry({Key key, this.remDetails, this.answers, this.medDoc})
      : super(key: key);

  @override
  _MedicationEntryState createState() => _MedicationEntryState();
}

class _MedicationEntryState extends State<MedicationEntry> {
  final _formKey = GlobalKey<FormState>();
  List remDetails = List.filled(9, null);

  final List<ImageIconTile> medicineTypeTiles = [
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/pill.png"), size: 30),
        label: 'pill'),
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/syrup.png"), size: 30),
        label: 'syrup'),
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/syringe.png"), size: 30),
        label: 'syringe'),
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/cream.png"), size: 30),
        label: 'cream'),
  ];

  ValueNotifier<int> medicineTypeTilesIndex = ValueNotifier(0);
  ValueNotifier<DateTime> datePicker;

  TextEditingController medicineNameController = TextEditingController();
  TextEditingController medicineDosageController = TextEditingController();

  static const double spacingBeforeAfterDivider = 10;
  static const double spacingWithinBlock = 10;

  @override
  void initState() {
    if (widget.answers.name != null) medicineNameController.text = widget.answers.name;
    if (widget.answers.dosage['dose'] != null) medicineDosageController.text = widget.answers.dosage['dose'];

    datePicker = ValueNotifier(widget.answers.startDate);
    medicineTypeTilesIndex.addListener(() {
      if (medicineTypeTilesIndex.value == 0)
        widget.answers.dosage = {
          'unit': 'pill(s)',
          'dose': widget.answers.dosage['dose']
        };
      else if (medicineTypeTilesIndex.value == 1)
        widget.answers.dosage = {
          'unit': 'ml',
          'dose': widget.answers.dosage['dose']
        };
      else if (medicineTypeTilesIndex.value == 2)
        widget.answers.dosage = {
          'unit': 'ml',
          'dose': widget.answers.dosage['dose']
        };
      else
        widget.answers.dosage = {
          'unit': 'mg',
          'dose': widget.answers.dosage['dose']
        };
      widget.answers.type =
          medicineTypeTiles[medicineTypeTilesIndex.value].label;
    });
    datePicker.addListener(() {
      widget.answers.startDate = datePicker.value;
    });

    super.initState();
  }

  @override
  void dispose() {
    medicineNameController.dispose();
    medicineDosageController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: [
        AppBarAll(
          context: context,
          icon: AssetImage("assets/pill.png"),
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
              child: Listener(
                onPointerDown: (_) {
                  FocusScopeNode currentFocus = FocusScope.of(context);
                  if (!currentFocus.hasPrimaryFocus &&
                      currentFocus.focusedChild != null) {
                    currentFocus.focusedChild.unfocus();
                  }
                },
                child: Center(
                  child: Form(
                    key: _formKey,
                    child: PropertyChangeProvider(
                      value: widget.answers,
                      child: ListView(
                        children: <Widget>[
                          SpontaneousBlock(),
                          SizedBox(height: spacingBeforeAfterDivider),
                          Divider(
                              height: 0,
                              thickness: 2,
                              indent: 15,
                              endIndent: 15),
                          SizedBox(height: spacingBeforeAfterDivider),

                          // MEDICINE INFO
                          Text(
                              AppLocalizations.of(context)
                                  .translate('medicine info')
                                  .inCaps,
                              style: Theme.of(context).textTheme.bodyText2,
                              textAlign: TextAlign.center),
                          SizedBox(height: spacingWithinBlock),
                          MedicineInfoBlock(
                            medicineNameController: medicineNameController,
                            medicineDosageController: medicineDosageController,
                            medicineTypeTiles: medicineTypeTiles,
                            medicineTypeTilesIndex: medicineTypeTilesIndex,
                            datePicker: datePicker,
                          ),
                          SizedBox(height: spacingBeforeAfterDivider),
                          PropertyChangeConsumer<Medication>(
                              properties: ['spontaneous'],
                              builder: (BuildContext context,
                                  Medication answers, _) {
                                if (!answers.spontaneous) {
                                  return Column(children: [
                                    Divider(
                                        height: 0,
                                        thickness: 2,
                                        indent: 15,
                                        endIndent: 15),
                                    SizedBox(height: spacingBeforeAfterDivider),
                                    Text(
                                        AppLocalizations.of(context)
                                            .translate('set intake information')
                                            .inCaps,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyText2,
                                        textAlign: TextAlign.center),
                                    SizedBox(height: spacingWithinBlock),
                                    IntakeBlock(),
                                    SizedBox(height: spacingWithinBlock),
                                    // ACTIVATE/DEACTIVATE REMINDERS
                                    ReminderBlock(),
                                    SizedBox(height: spacingWithinBlock),
                                  ]);
                                } else {
                                  return Container();
                                }
                              }),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: new BorderRadius.circular(30.0),
                                ),
                                primary: DefaultColors.mainColor,
                              ),
                              child: Text(
                                  AppLocalizations.of(context)
                                      .translate("save")
                                      .inCaps,
                                  style: MyTextStyle(
                                      color: DefaultColors.textColorOnDark)),
                              onPressed: () {
                                remDetails[0] = medicineNameController.text;
                                remDetails[1] = widget.answers.type;
                                remDetails[2] = medicineDosageController.text +
                                    ' ' +
                                    widget.answers.dosage['unit'];
                                remDetails[3] = '';
                                remDetails[4] = widget.answers.spontaneous;
                                remDetails[5] = DateFormat('dd-MM-yyyy')
                                    .format(widget.answers.startDate);
                                remDetails[6] = widget.answers.alarm;
                                remDetails[7] = widget
                                    .answers.intakes['interval']
                                    .toString();

                                /* double maxRepeats =
                                    24 / widget.answers.alarm['interval'];

                                remDetails[8] = _fixHours(time);

                                for (int repeats = 1;
                                    repeats < maxRepeats;
                                    repeats++) {
                                  // saves a reminder for each of the hours calculated

                                  //TODO: FALTA VERIFICAR LOCAL NOTIFICATIONS
                                  //LocalNotifications().addReminder(time);

                                  time = time.add(Duration(
                                      hours: widget.answers.alarm['interval']));

                                  // concatenate hours string in each iteration
                                  remDetails[8] =
                                      remDetails[8] + ";" + _fixHours(time);
                                } */

                                if (_formKey.currentState.validate()) {
                                  _formKey.currentState.save();

                                  widget.answers.name =
                                      medicineNameController.text;
                                  widget.answers.dosage['dose'] =
                                      medicineDosageController.text;

                                  // if spontaneous, remove alarm and intake info
                                  if (widget.answers.spontaneous) {
                                    widget.answers.intakeDate =
                                        widget.answers.startDate;
                                    widget.answers.startDate = null;
                                    widget.answers.intakes = {
                                      'intakeTime': null,
                                      'startTime': null,
                                      'interval': null
                                    };
                                    widget.answers.alarm = false;
                                  }

                                  if (widget.answers.once) {
                                    widget.answers.intakeDate =
                                        widget.answers.startDate;
                                    widget.answers.startDate = null;
                                    widget.answers.intakes = {
                                      'intakeTime':
                                          widget.answers.intakes['startTime'],
                                      'startTime': null,
                                      'interval': null
                                    };
                                    widget.answers.alarm = false;
                                  }

                                  if (widget.answers.spontaneous) {
                                    HistoricMedication historicMedication =
                                        HistoricMedication.fromMedication(
                                            widget.answers);
                                    saveHistoricMedication(
                                        historicMedication, context);
                                  } else {
                                    if (widget.medDoc == null)
                                      saveMedication(widget.answers, context);
                                    else
                                      updateMedication(widget.answers, context,
                                          widget.medDoc);
                                  }

                                  /* saveReminder(Reminder(BAApi.loginToken,
                                      remDetails, widget.remDetails)); */

                                  Navigator.of(context).pop();
                                  //pushNewScreen(context, screen: MedicationPage());
                                }
                              }),

                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

class SpontaneousBlock extends StatelessWidget {
  SpontaneousBlock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      PropertyChangeConsumer<Medication>(
          properties: ['spontaneous', 'once'],
          builder: (BuildContext context, Medication answers, _) {
            if (!answers.once) {
              return SwitchListTile(
                activeColor: DefaultColors.logoColor,
                title: Text(
                  AppLocalizations.of(context)
                      .translate('spontaneous intake')
                      .inCaps,
                  style: MyTextStyle(),
                ),
                value: answers.spontaneous,
                onChanged: (bool value) {
                  answers.spontaneous = value;
                  if (answers.spontaneous) answers.alarm = false;
                },
              );
            } else {
              return Container();
            }
          }),
      PropertyChangeConsumer<Medication>(
          properties: ['spontaneous', 'once'],
          builder: (BuildContext context, Medication answers, _) {
            if (!answers.spontaneous) {
              return SwitchListTile(
                activeColor: DefaultColors.logoColor,
                title: Text(
                  AppLocalizations.of(context)
                      .translate('one time scheduled intake')
                      .inCaps,
                  style: MyTextStyle(),
                ),
                value: answers.once,
                onChanged: (bool value) {
                  answers.once = value;
                  if (answers.once) answers.alarm = false;
                },
              );
            } else {
              return Container();
            }
          }),
    ]);
  }
}

class MedicineInfoBlock extends StatelessWidget {
  final TextEditingController medicineNameController;
  final TextEditingController medicineDosageController;
  final List medicineTypeTiles;
  final ValueNotifier<int> medicineTypeTilesIndex;
  final ValueNotifier<DateTime> datePicker;

  MedicineInfoBlock({
    Key key,
    this.medicineNameController,
    this.medicineDosageController,
    this.medicineTypeTiles,
    this.medicineTypeTilesIndex,
    this.datePicker,
  }) : super(key: key);

  static const List<String> dosageUnitList = [
    'mg',
    'tablespoons',
    'ml',
    'pill(s)'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      ListTile(
        title: Text(
            AppLocalizations.of(context).translate('medicine name').inCaps),
        subtitle: new Container(
          width: 150.0,
          child: new Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              new Expanded(
                flex: 3,
                child: new TextFormField(
                  style: MyTextStyle(color: Colors.grey[600], fontSize: 16),
                  controller: medicineNameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)
                          .translate('please enter the medicine name')
                          .inCaps;
                    }
                    return null;
                  },
                  decoration: new InputDecoration(
                      isDense: true,
                      hintText: AppLocalizations.of(context)
                          .translate('type here')
                          .inCaps),
                ),
              ),
            ],
          ),
        ),
      ),

      // MEDICINE TYPE
      PropertyChangeConsumer<Medication>(
          properties: ['type'],
          builder: (BuildContext context, Medication answers, _) {
            return ListTile(
              title: Text(AppLocalizations.of(context)
                  .translate('medicine type')
                  .inCaps),
              subtitle: Text(
                  AppLocalizations.of(context).translate(answers.type).inCaps,
                  style: MyTextStyle(color: Colors.grey[600], fontSize: 16)),
              trailing: ImageIcon(
                  AssetImage("assets/" + answers.type.toLowerCase() + ".png"),
                  size: 30,
                  color: DefaultColors.mainColor),
              onTap: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return ListTileDialog(
                        listOfTiles: medicineTypeTiles,
                        selectedIndex: medicineTypeTilesIndex,
                        icon: MdiIcons.pill,
                        title: AppLocalizations.of(context)
                            .translate('medicine type')
                            .inCaps,
                      );
                    });
              },
            );
          }),

      // DOSAGE
      PropertyChangeConsumer<Medication>(
          properties: ['dosage'],
          builder: (BuildContext context, Medication answers, _) {
            return ListTile(
              title:
                  Text(AppLocalizations.of(context).translate('dosage').inCaps),
              subtitle: new Container(
                width: 150.0,
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    new Expanded(
                      flex: 3,
                      child: new TextFormField(
                        controller: medicineDosageController,
                        keyboardType: TextInputType.phone,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly
                        ], // Only numbers can be entered
                        style:
                            MyTextStyle(color: Colors.grey[600], fontSize: 16),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)
                                .translate('please enter the medicine dosage')
                                .inCaps;
                          }
                          return null;
                        },
                        decoration: new InputDecoration(
                            isDense: true,
                            hintText: AppLocalizations.of(context)
                                .translate('type here')
                                .inCaps),
                      ),
                    ),
                    Spacer(
                      flex: 1,
                    ),
                    new Expanded(
                      flex: 3,
                      child: DropdownButton(
                        isDense: true,
                        hint: Text(
                            AppLocalizations.of(context)
                                .translate(dosageUnitList[0]),
                            style: MyTextStyle(
                                color: Colors.grey[600], fontSize: 16)),
                        icon: Icon(Icons.arrow_drop_down),
                        iconSize: 16,
                        isExpanded: true,
                        underline: SizedBox(),
                        value: answers.dosage['unit'],
                        onChanged: (newValue) {
                          answers.dosage = {
                            'unit': newValue,
                            'dose': answers.dosage['dose']
                          };
                        },
                        items: dosageUnitList.map((valueItem) {
                          return DropdownMenuItem(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate(valueItem),
                                style: MyTextStyle(
                                    color: Colors.grey[600], fontSize: 16)),
                            value: valueItem,
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

      PropertyChangeConsumer<Medication>(
          properties: ['spontaneous', 'startDate'],
          builder: (BuildContext context, Medication answers, _) {
            if (answers.startDate != null) {
              return ListTile(
                title: answers.spontaneous
                    ? Text(AppLocalizations.of(context)
                        .translate('date of intake')
                        .inCaps)
                    : Text(AppLocalizations.of(context)
                        .translate('starting date')
                        .inCaps),
                subtitle: Text(
                    DateFormat('dd-MM-yyyy').format(answers.startDate),
                    style: MyTextStyle(color: Colors.grey[600], fontSize: 16)),
                trailing: Icon(Icons.calendar_today_outlined,
                    color: DefaultColors.mainColor),
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return DateDialog(
                          datePicker: datePicker,
                          icon: Icons.calendar_today_outlined,
                          title: AppLocalizations.of(context)
                              .translate('starting date')
                              .inCaps,
                          allowMultiple: false,
                        );
                      });
                },
              );
            } else {
              return Container();
            }
          }),
    ]);
  }
}

class IntakeBlock extends StatelessWidget {
  const IntakeBlock({Key key}) : super(key: key);

  static const List<int> intervalList = [6, 8, 12, 24];

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      PropertyChangeConsumer<Medication>(
          properties: ['startTime', 'once'],
          builder: (BuildContext context, Medication answers, _) {
            return Column(children: <Widget>[
              ListTile(
                title: answers.once
                    ? Text(AppLocalizations.of(context)
                        .translate('intake time')
                        .inCaps)
                    : Text(AppLocalizations.of(context)
                        .translate('starting time')
                        .inCaps),
                subtitle: Text(
                    MaterialLocalizations.of(context)
                        .formatTimeOfDay(answers.intakes['startTime']),
                    //'${answers.alarm['startTime'].hour}:${answers.alarm['startTime'].minute}',
                    style: MyTextStyle(color: Colors.grey[600], fontSize: 16)),
                trailing:
                    Icon(Icons.timer_rounded, color: DefaultColors.mainColor),
                onTap: () {
                  _selectAlarmTime(context, answers);
                },
              ),
              if (!answers.once)
                ListTile(
                  title: Text(AppLocalizations.of(context)
                      .translate('select interval between intakes')
                      .inCaps),
                  subtitle: new Container(
                    width: 150.0,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        new Expanded(
                            flex: 3,
                            child: new Text(
                                AppLocalizations.of(context)
                                    .translate('take every')
                                    .inCaps,
                                style: MyTextStyle(
                                    color: Colors.grey[600], fontSize: 16))),
                        new Expanded(
                          flex: 1,
                          child: FittedBox(
                            fit: BoxFit.scaleDown,
                            child: DropdownButton(
                              isDense: true,
                              icon: Icon(Icons.arrow_drop_down),
                              iconSize: 16,
                              value: answers.intakes['interval'],
                              onChanged: (newValue) {
                                answers.intakes = {
                                  'intakeTime': answers.intakes['intakeTime'],
                                  'startTime': answers.intakes['startTime'],
                                  'interval': newValue,
                                };
                              },
                              items: intervalList.map((valueItem) {
                                return DropdownMenuItem(
                                  child: Text(
                                    valueItem.toString(),
                                    style: MyTextStyle(
                                        color: Colors.grey[600], fontSize: 16),
                                  ),
                                  value: valueItem,
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        new Expanded(
                          flex: 1,
                          child: new Text(
                              AppLocalizations.of(context).translate('hours'),
                              style: MyTextStyle(
                                  color: Colors.grey[600], fontSize: 16)),
                        ),
                      ],
                    ),
                  ),
                ),
            ]);
          }),
    ]);
  }

  Future<TimeOfDay> _selectAlarmTime(
      BuildContext context, Medication answers) async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: answers.intakes['startTime'],
        initialEntryMode: TimePickerEntryMode.dial,
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                // change the border color
                primary: DefaultColors.logoColor,
                // change the text color
                onSurface: DefaultColors.logoColor,
              ),
            ),
            child: MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child,
            ),
          );
        });
    if (picked != null && picked != answers.intakes['startTime']) {
      answers.intakes = {
        'intakeTime': answers.intakes['intakeTime'],
        'startTime': picked,
        'interval': answers.intakes['interval'],
      };
    }
    return picked;
  }
}

class ReminderBlock extends StatelessWidget {
  const ReminderBlock({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PropertyChangeConsumer<Medication>(
        properties: ['alarm', 'once'],
        builder: (BuildContext context, Medication answers, _) {
          if (!answers.once) {
            return SwitchListTile(
              activeColor: DefaultColors.logoColor,
              title: Text(
                AppLocalizations.of(context)
                    .translate('activate reminders for this medication')
                    .inCaps,
                style: MyTextStyle(),
              ),
              value: answers.alarm,
              onChanged: (bool value) {
                answers.alarm = value;
                if (!answers.alarm)
                  answers.intakes = {
                    'intakeTime': answers.intakes['intakes'],
                    'startTime': TimeOfDay.now(),
                    'interval': answers.intakes['interval'],
                  };
              },
            );
          } else {
            return Container();
          }
        });
  }
}
