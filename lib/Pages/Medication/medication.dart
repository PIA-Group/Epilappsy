import 'dart:io';

import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:intl/intl.dart';

class Medication extends PropertyChangeNotifier<String> {
  bool _spontaneous = false;
  String _name;
  String _type = 'pill';
  Map<String, dynamic> _dosage = {'dose': null, 'unit': 'pills'};
  DateTime _startDate = DateTime.now();
  DateTime _intakeDate = DateTime.now();
  Map<String, dynamic> _alarm = {
    'active': true,
    'startTime': TimeOfDay.now(),
    'interval': null
  };
  String _notes;

  bool get spontaneous => _spontaneous;
  String get name => _name;
  String get type => _type;
  Map<String, dynamic> get dosage => _dosage;
  DateTime get startDate => _startDate;
  DateTime get intakeDate => _intakeDate;
  Map<String, dynamic> get alarm => _alarm;
  String get notes => _notes;

  dynamic get(String key) => <String, dynamic>{
        'spontaneous': _spontaneous,
        'name': _name,
        'type': _type,
        'dosage': _dosage,
        'startDate': _startDate,
        'intakeDate': _intakeDate,
        'alarm': _alarm,
        'notes': _notes,
      }[key];

  set spontaneous(bool value) {
    _spontaneous = value;
    notifyListeners('spontaneous');
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

  set startDate(DateTime value) {
    _startDate = value;
    notifyListeners('startDate');
  }

  set intakeDate(DateTime value) {
    _intakeDate = value;
    notifyListeners('intakeDate');
  }

  set alarm(Map<String, dynamic> value) {
    _alarm = value;
    notifyListeners('alarm');
  }

  set notes(String value) {
    _notes = value;
    notifyListeners('notes');
  }

  Map<String, dynamic> toJson(BuildContext context) {
    print('start date: ${this.startDate}');
    return {
      'Medication name': this.name, // String
      'Medicine type': this.type, // String
      'Dosage': this.dosage['dose'], // String
      'Unit': this.dosage['unit'], // String
      'Spontaneous': this.spontaneous, // bool
      'Starting date':this.startDate ?? null, // String
      'Intake date': this.intakeDate ?? null, // String
      'Interval': this.alarm['interval'], // int
      'Starting time': MaterialLocalizations.of(context)
          .formatTimeOfDay(this.alarm['startTime']), // String
      'Alarm': this.alarm['active'], // bool
    };
  }
}

Medication medicationFromJson(Map<String, dynamic> json) {
  Medication medication = Medication();
  medication.name = json['Medication name'];
  medication.type = json['Medicine type'];
  medication.dosage = {'dose': json['Dosage'], 'unit': json['Unit']};
  medication.spontaneous = json['Spontaneous'];
  if (medication.startDate != null)
    medication.startDate = json['Starting date'].toDate();

  else
    medication.startDate = null;
  if (medication.intakeDate != null)
    medication.intakeDate = json['Intake date'].toDate();
  else
    medication.intakeDate = null;
  medication.alarm = {
    'interval': json['Interval'],
    'active': json['Alarm'],
    'startTime': TimeOfDay(
        hour: int.parse(json['Starting time'].split(":")[0]),
        minute: int.parse(json['Starting time'].split(":")[1])),
  };
  return medication;
}
