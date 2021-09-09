import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

class Medication extends PropertyChangeNotifier<String> {
  bool _spontaneous = false;
  bool _once = false;
  String _name;
  String _type = 'pill';
  Map<String, dynamic> _dosage = {'dose': null, 'unit': 'pill(s)'};
  Map<String, dynamic> _intakes = {
    'intakeTime': null,
    'interval': null,
    'startTime': TimeOfDay.now()
  };
  DateTime _startDate = DateTime.now();
  DateTime _intakeDate;
  bool _alarm = true;

  bool get spontaneous => _spontaneous;
  bool get once => _once;
  String get name => _name;
  String get type => _type;
  Map<String, dynamic> get dosage => _dosage;
  Map<String, dynamic> get intakes => _intakes;
  DateTime get startDate => _startDate;
  DateTime get intakeDate => _intakeDate;
  bool get alarm => _alarm;

  dynamic get(String key) => <String, dynamic>{
        'once': _once,
        'spontaneous': _spontaneous,
        'name': _name,
        'type': _type,
        'dosage': _dosage,
        'startDate': _startDate,
        'intakeDate': _intakeDate,
        'alarm': _alarm,
      }[key];

  set spontaneous(bool value) {
    _spontaneous = value;
    notifyListeners('spontaneous');
  }

  set once(bool value) {
    _once = value;
    notifyListeners('once');
  }

  set name(String value) {
    _name = value;
    notifyListeners('name');
  }

  set type(String value) {
    _type = value;
    notifyListeners('type');
  }

  set dosage(Map<String, dynamic> value) {
    _dosage = value;
    notifyListeners('dosage');
  }

  set intakes(Map<String, dynamic> value) {
    _intakes = value;
    notifyListeners('intakes');
  }

  set startDate(DateTime value) {
    _startDate = value;
    notifyListeners('startDate');
  }

  set intakeDate(DateTime value) {
    _intakeDate = value;
    notifyListeners('intakeDate');
  }

  set alarm(bool value) {
    _alarm = value;
    notifyListeners('alarm');
  }

  set notes(String value) {
    notifyListeners('notes');
  }

  Map<String, dynamic> toJson(BuildContext context) {
    return {

      'Medication name': this.name, // String
      'Medicine type': this.type, // String
      'Dosage': this.dosage['dose'], // String
      'Unit': this.dosage['unit'], // String
      'Spontaneous': this.spontaneous, // bool
      'Once': this.once,
      'Starting date': this.startDate ?? null, // String
      'Intake date': this.intakeDate ?? null, // String
      'Intake time': this.intakes['intakeTime'] != null
          ? MaterialLocalizations.of(context)
              .formatTimeOfDay(this.intakes['intakeTime'])
          : null,
      'Interval': this.intakes['interval'], // int
      'Starting time': this.intakes['startTime'] != null
          ? MaterialLocalizations.of(context)
              .formatTimeOfDay(this.intakes['startTime'])
          : null, // String
      'Alarm': this.alarm, // bool
    };
  }
}

Medication medicationFromJson(Map<String, dynamic> json) {
  Medication medication = Medication();
  medication.name = json['Medication name'];
  medication.type = json['Medicine type'];
  medication.dosage = {'dose': json['Dosage'], 'unit': json['Unit']};
  medication.spontaneous = json['Spontaneous'];
  medication.once = json['Once'];

  if (json['Starting date'] != null)
    medication.startDate = json['Starting date'].toDate();
  else
    medication.startDate = null;

  if (json['Intake date'] != null)
    medication.intakeDate = json['Intake date'].toDate();
  else
    medication.intakeDate = null;
  medication.alarm = json['Alarm'];
  medication.intakes = {
    'intakeTime': json['Intake time'] != null ? TimeOfDay(
        hour: int.parse(json['Intake time'].split(":")[0]),
        minute: int.parse(json['Intake time'].split(":")[1])) : null,
    'interval': json['Interval'],
    'startTime': json['Starting time'] != null ?TimeOfDay(
        hour: int.parse(json['Starting time'].split(":")[0]),
        minute: int.parse(json['Starting time'].split(":")[1])) : null,
  };
  return medication;
}
