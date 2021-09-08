import 'package:flutter/material.dart';
import 'package:property_change_notifier/property_change_notifier.dart';

Map<String, dynamic> alarmDefault = {
  'active': true,
  'startTime': TimeOfDay.now(),
  'interval': null
};
const Map<String, dynamic> dosageDefault = {'dose': null, 'unit': 'pills'};

class MedicationAnswers extends PropertyChangeNotifier<String> {
  bool _spontaneous = false;
  String _name;
  String _type = 'pills';
  Map<String, dynamic> _dosage = dosageDefault;
  DateTime _startDate = DateTime.now();
  Map<String, dynamic> _alarm = alarmDefault;
  String _notes;

  bool get spontaneous => _spontaneous;
  String get name => _name;
  String get type => _type;
  Map<String, dynamic> get dosage => _dosage;
  DateTime get startDate => _startDate;
  Map<String, dynamic> get alarm => _alarm;
  String get notes => _notes;

  dynamic get(String key) => <String, dynamic>{
        'spontaneous': _spontaneous,
        'name': _name,
        'type': _type,
        'dosage': _dosage,
        'startDate': _startDate,
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

  set alarm(Map<String, dynamic> value) {
    _alarm = value;
    notifyListeners('alarm');
  }

  set notes(String value) {
    _notes = value;
    notifyListeners('notes');
  }
}
