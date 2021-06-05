
const Map<String, dynamic> alarmDefault = {'active':true, 'startTime': null, 'interval': null};
const Map<String, dynamic> dosageDefault = {'dose': null, 'unit': 'pills'};

class MedicationAnswers {
  MedicationAnswers({this.notes, 
    this.type='Pill',
    this.dosage=dosageDefault,
    this.startDate,
    this.alarm=alarmDefault,
    this.spontaneous=false,
    this.name,
  });

  bool spontaneous;
  String name;
  String type;
  Map<String, dynamic> dosage;
  DateTime startDate;
  Map<String, dynamic> alarm;
  String notes;
}
