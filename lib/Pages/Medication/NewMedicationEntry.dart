import 'package:epilappsy/BrainAnswer/ba_api.dart';
import 'package:epilappsy/Pages/AddSeizure/costum_dialogs/date_dialog.dart';
import 'package:epilappsy/Pages/AddSeizure/costum_dialogs/list_tile_dialog.dart';
import 'package:epilappsy/Pages/AddSeizure/questionnaire_tiles.dart';
import 'package:epilappsy/Pages/Medication/medication_answers.dart';
import 'package:epilappsy/Pages/Medication/medications.dart';
import 'package:epilappsy/Pages/Medication/reminders.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/app_localizations.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:intl/intl.dart';

class NewMedicationEntry extends StatefulWidget {
  final ReminderDetails remDetails;
  final MedicationDetails medDetails;
  final ValueNotifier<MedicationAnswers> answers;

  NewMedicationEntry({Key key, this.remDetails, this.medDetails, this.answers})
      : super(key: key);

  @override
  _NewMedicationEntryState createState() => _NewMedicationEntryState();
}

class _NewMedicationEntryState extends State<NewMedicationEntry> {
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> formData;
  List<String> medicationNames = [/*LIST ALL MEDICATIONS ON FIRESTORE*/];
  String _mode = "Take with food";

  final List dosageUnitList = ['mg', 'tablespoons', 'ml', 'pills'];
  final List<int> intervalList = const [6, 8, 12, 24];

  FirebaseFirestore firestore;
  DocumentSnapshot reminder;
  List medDetails = List.filled(7, null);
  List remDetails = List.filled(9, null);

  final List<ImageIconTile> medicineTypeTiles = [
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/pill.png"), size: 30),
        label: 'Pill'),
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/syrup.png"), size: 30),
        label: 'Syrup'),
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/syringe.png"), size: 30),
        label: 'Syringe'),
    ImageIconTile(
        icon: ImageIcon(AssetImage("assets/cream.png"), size: 30),
        label: 'Cream'),
  ];

  ValueNotifier<int> medicineTypeTilesIndex = ValueNotifier(0);
  ValueNotifier<DateTime> datePicker;

  TextEditingController medicineNameController = TextEditingController();
  TextEditingController medicineDosageController = TextEditingController();

  FocusNode focusName = FocusNode();
  FocusNode focusDosage = FocusNode();

  @override
  void initState() {
    firestore = FirebaseFirestore.instance;
    datePicker = ValueNotifier(widget.answers.value.startDate);
    medicineTypeTilesIndex.addListener(() {
      if (medicineTypeTilesIndex.value == 0)
        setState(() => widget.answers.value.dosage = {
              'unit': 'pills',
              'dose': widget.answers.value.dosage['dose']
            });
      else if (medicineTypeTilesIndex.value == 1)
        setState(() => widget.answers.value.dosage = {
              'unit': 'ml',
              'dose': widget.answers.value.dosage['dose']
            });
      else if (medicineTypeTilesIndex.value == 2)
        setState(() => widget.answers.value.dosage = {
              'unit': 'ml',
              'dose': widget.answers.value.dosage['dose']
            });
      else
        setState(() => widget.answers.value.dosage = {
              'unit': 'mg',
              'dose': widget.answers.value.dosage['dose']
            });
      setState(() => widget.answers.value.type =
          medicineTypeTiles[medicineTypeTilesIndex.value].label);
    });
    datePicker.addListener(() {
      setState(() => widget.answers.value.startDate = datePicker.value);
    });
    super.initState();
  }

  Future<TimeOfDay> _selectAlarmTime() async {
    final TimeOfDay picked = await showTimePicker(
        context: context,
        initialTime: widget.answers.value.alarm['startTime'],
        initialEntryMode: TimePickerEntryMode.input,
        builder: (BuildContext context, Widget child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
            child: child,
          );
        });
    if (picked != null && picked != widget.answers.value.alarm['startTime']) {
      setState(() {
        widget.answers.value.alarm['startTime'] = picked;
      });
    }
    return picked;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarAll(context, [], 'Medication'),
      body: Listener(
        onPointerDown: (_) {
          FocusScopeNode currentFocus = FocusScope.of(context);
          if (!currentFocus.hasPrimaryFocus &&
              currentFocus.focusedChild != null) {
            currentFocus.focusedChild.unfocus();
          }
        },
        /* GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          }, */
        child: Center(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ValueListenableBuilder(
                  valueListenable: widget.answers,
                  builder: (BuildContext context, MedicationAnswers _answers,
                      Widget child) {
                    return Form(
                      key: _formKey,
                      child: ListView(
                        children: <Widget>[
                          // TOMA ESPONTÂNEA
                          SwitchListTile(
                            activeColor: DefaultColors.logoColor,
                            title: Text(
                              'Toma espontânea',
                              style: MyTextStyle(),
                            ),
                            value: _answers.spontaneous,
                            onChanged: (bool value) {
                              setState(() {
                                _answers.spontaneous = value;
                              });
                              if (_answers.spontaneous)
                                _answers.alarm['active'] = false;
                            },
                          ),
                          Divider(
                              height: 0,
                              thickness: 2,
                              indent: 15,
                              endIndent: 15),
                          SizedBox(height: 10),
                          Text(AppLocalizations.of(context)
                                      .translate('Medicine info'),
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center),
                          ListTile(
                            title: Text(AppLocalizations.of(context)
                                      .translate('Medicine name')),
                            subtitle: new Container(
                              width: 150.0,
                              child: new Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: <Widget>[
                                  new Expanded(
                                    flex: 3,
                                    child: new TextFormField(
                                      style: MyTextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16),
                                      controller: medicineNameController,
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)
                                      .translate('Please enter the medicine name');
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                          isDense: true,
                                          hintText: AppLocalizations.of(context)
                                      .translate('Type here')),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // MEDICINE TYPE
                          ListTile(
                            title: Text(AppLocalizations.of(context)
                                      .translate('Medicine type')),
                            subtitle: Text(AppLocalizations.of(context)
                                      .translate(_answers.type),
                                style: MyTextStyle(
                                    color: Colors.grey[600], fontSize: 16)),
                            trailing: ImageIcon(
                                AssetImage("assets/" +
                                    _answers.type.toLowerCase() +
                                    ".png"),
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
                                      .translate('Medicine type'),
                                    );
                                  });
                            },
                          ),

                          // DOSAGE
                          ListTile(
                            title: Text(AppLocalizations.of(context)
                                      .translate('Dosage')),
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
                                      style: MyTextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16),
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return AppLocalizations.of(context)
                                      .translate('Please enter the medicine dosage');
                                        }
                                        return null;
                                      },
                                      decoration: new InputDecoration(
                                          isDense: true, hintText: AppLocalizations.of(context)
                                      .translate('Type here')),
                                    ),
                                  ),
                                  Spacer(
                                    flex: 1,
                                  ),
                                  new Expanded(
                                    flex: 2,
                                    child: DropdownButton(
                                      isDense: true,
                                      hint: Text(dosageUnitList[0],
                                          style: MyTextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16)),
                                      icon: Icon(Icons.arrow_drop_down),
                                      iconSize: 16,
                                      isExpanded: true,
                                      underline: SizedBox(),
                                      value: _answers.dosage['unit'],
                                      onChanged: (newValue) {
                                        setState(() {
                                          _answers.dosage = {
                                            'unit': newValue,
                                            'dose': _answers.dosage['dose']
                                          };
                                        });
                                      },
                                      items: dosageUnitList.map((valueItem) {
                                        return DropdownMenuItem(
                                          child: Text(valueItem,
                                              style: MyTextStyle(
                                                  color: Colors.grey[600],
                                                  fontSize: 16)),
                                          value: valueItem,
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          ListTile(
                            title: _answers.spontaneous
                                ? Text(AppLocalizations.of(context)
                                      .translate('Date of intake'))
                                : Text(AppLocalizations.of(context)
                                      .translate('Start date')),
                            subtitle: Text(
                                DateFormat('dd-MM-yyyy')
                                    .format(_answers.startDate),
                                style: MyTextStyle(
                                    color: Colors.grey[600], fontSize: 16)),
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
                                      .translate('Starting date'),
                                      allowMultiple: false,
                                    );
                                  });
                            },
                          ),

                          // ACTIVATE/DEACTIVATE REMINDERS
                          Divider(
                              height: 0,
                              thickness: 2,
                              indent: 15,
                              endIndent: 15),
                          SizedBox(height: 10),
                          Text(AppLocalizations.of(context)
                                      .translate('Set reminder'),
                              style: Theme.of(context).textTheme.bodyText1,
                              textAlign: TextAlign.center),
                          SwitchListTile(
                            activeColor: DefaultColors.logoColor,
                            title: Text(
                              AppLocalizations.of(context)
                                      .translate('Activate reminders for this medication'),
                              style: MyTextStyle(),
                            ),
                            value: _answers.alarm['active'],
                            onChanged: (bool value) {
                              setState(() => _answers.alarm['active'] = value);
                            },
                          ),
                          Column(children: <Widget>[
                            if (_answers.alarm['active'])
                              Column(children: <Widget>[
                                ListTile(
                                  title: Text(AppLocalizations.of(context)
                                      .translate('Starting time')),
                                  subtitle: Text(
                                      DateFormat("HH:mm").format(DateTime(
                                          0,
                                          0,
                                          0,
                                          _answers.alarm['startTime'].hour,
                                          _answers.alarm['startTime'].minute)),
                                      style: MyTextStyle(
                                          color: Colors.grey[600],
                                          fontSize: 16)),
                                  trailing: Icon(Icons.timer_rounded,
                                      color: DefaultColors.mainColor),
                                  onTap: () {
                                    _selectAlarmTime();
                                    /* showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return TimeDialog(
                                    //duration: widget.duration,
                                    icon: Icons.timer_rounded,
                                    title: 'Starting time',
                                  );
                                }); */
                                  },
                                ),

                                ListTile(
                                  title:
                                      Text(AppLocalizations.of(context)
                                      .translate('Select interval between intakes')),
                                  subtitle: new Container(
                                    width: 150.0,
                                    child: new Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        new Expanded(
                                            flex: 3,
                                            child: new Text(AppLocalizations.of(context)
                                      .translate('Remind me every'),
                                                style: MyTextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16))),
                                        new Expanded(
                                          //flex: 1,
                                          child: FittedBox(
                                            fit: BoxFit.scaleDown,
                                            child: DropdownButton(
                                              isDense: true,
                                              icon: Icon(Icons.arrow_drop_down),
                                              iconSize: 16,
                                              value: _answers.alarm['interval'],
                                              onChanged: (newValue) {
                                                setState(() {
                                                  _answers.alarm['interval'] =
                                                      newValue;
                                                });
                                              },
                                              items:
                                                  intervalList.map((valueItem) {
                                                return DropdownMenuItem(
                                                  child: Text(
                                                    valueItem.toString(),
                                                    style: MyTextStyle(
                                                        color: Colors.grey[600],
                                                        fontSize: 16),
                                                  ),
                                                  value: valueItem,
                                                );
                                              }).toList(),
                                            ),
                                          ),
                                        ),
                                        new Expanded(
                                            flex: 1,
                                            child: new Text(AppLocalizations.of(context)
                                      .translate('hours'),
                                                style: MyTextStyle(
                                                    color: Colors.grey[600],
                                                    fontSize: 16))),
                                        Spacer()
                                      ],
                                    ),
                                  ),
                                ),

                                // TAKE WITH OR WITHOUT FOOD
                                /*  ListTile(
                                  title: const Text("Take with food"),
                                  leading: Radio<String>(
                                    value: "Take with food",
                                    groupValue: _mode,
                                    onChanged: (String value) {
                                      setState(() {
                                        _mode = value;
                                      });
                                    },
                                  ),
                                ),
                                ListTile(
                                  title: const Text("Take on empty stomach"),
                                  leading: Radio<String>(
                                    value: "Take on empty stomach",
                                    groupValue: _mode,
                                    onChanged: (String value) {
                                      setState(() {
                                        _mode = value;
                                      });
                                    },
                                  ),
                                ), */
                                SizedBox(
                                  height: 15,
                                ),
                              ]),
                          ]),
                          /* Padding(
                            padding: EdgeInsets.symmetric(horizontal: MediaQuery.of(context).size.width*0.2),
                            child:  */ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(30.0),
                                  ),
                                  primary: DefaultColors.mainColor,
                                ),
                                child: Text(AppLocalizations.of(context)
                                      .translate("Save"),
                                    style: MyTextStyle(
                                        color: DefaultColors.textColorOnDark)),
                                onPressed: () {
                                  remDetails[0] = medicineNameController.text;
                                  remDetails[1] = _answers.type;
                                  remDetails[2] =
                                      medicineDosageController.text +
                                          ' ' +
                                          _answers.dosage['unit'];
                                  remDetails[3] = _mode;
                                  remDetails[4] = _answers.spontaneous;
                                  remDetails[5] = DateFormat('dd-MM-yyyy')
                                      .format(_answers.startDate);
                                  remDetails[6] = _answers.alarm['active'];
                                  remDetails[7] =
                                      _answers.alarm['interval'].toString();

                                  medDetails[0] = medicineNameController.text;
                                  medDetails[1] = _answers.type;
                                  medDetails[2] =
                                      medicineDosageController.text +
                                          ' ' +
                                          _answers.dosage['unit'];
                                  //medDetails[3] = _mode;
                                  medDetails[4] = _answers.spontaneous;
                                  medDetails[5] = DateFormat('dd-MM-yyyy')
                                      .format(_answers.startDate);
                                  medDetails[6] =
                                      _answers.alarm['interval'].toString();

                                  DateTime time = DateTime(
                                    0,
                                    0,
                                    0,
                                    _answers.alarm['startTime'].hour,
                                    _answers.alarm['startTime'].minute,
                                  );

                                  double maxRepeats =
                                      24 / _answers.alarm['interval'];

                                  remDetails[8] = _fixHours(time);

                                  for (int repeats = 1;
                                      repeats < maxRepeats;
                                      repeats++) {
                                    // saves a reminder for each of the hours calculated

                                    //TODO: FALTA VERIFICAR LOCAL NOTIFICATIONS
                                    //LocalNotifications().addReminder(time);

                                    time = time.add(Duration(
                                        hours: _answers.alarm['interval']));

                                    // concatenate hours string in each iteration
                                    remDetails[8] =
                                        remDetails[8] + ";" + _fixHours(time);
                                  }

                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    saveMedication(Medication(BAApi.loginToken,
                                        medDetails, widget.medDetails));

                                    saveReminder(Reminder(BAApi.loginToken,
                                        remDetails, widget.remDetails));

                                    Navigator.of(context).pop();
                                    //pushNewScreen(context, screen: MedicationPage());
                                  }
                                }),
                         
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    );
                  })),
        ),
      ),
    );
  }

  String _fixHours(DateTime time) {
    return DateFormat("HH:mm").format(time);
  }
}
