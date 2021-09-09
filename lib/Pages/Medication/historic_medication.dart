import 'package:casia/Pages/Medication/medication.dart';
import 'package:flutter/material.dart';

class HistoricMedication {
  String name;
  String type;
  Map<String, dynamic> dosage;
  Map<String, dynamic> intakes;
  DateTime startDate;
  DateTime endDate;
  DateTime intakeDate;

  HistoricMedication(
    this.name,
    this.type,
    this.dosage,
    this.intakes,
    this.startDate,
    this.endDate,
    this.intakeDate,
  );

  HistoricMedication.fromJson(Map<String, dynamic> json)
      : name = json['Medication name'],
        type = json['Medicine type'],
        dosage = {'dose': json['Dosage'], 'unit': json['Unit']},
        startDate = json['Starting date'] != null
            ? json['Starting date'].toDate()
            : null,
        endDate =
            json['Ending date'] != null ? json['Ending date'].toDate() : null,
        intakeDate =
            json['Intake date'] != null ? json['Intake date'].toDate() : null,
        intakes = {
          'intakeTime': json['Intake time'] != null
              ? TimeOfDay(
                  hour: int.parse(json['Intake time'].split(":")[0]),
                  minute: int.parse(json['Intake time'].split(":")[1]))
              : null,
          'interval': json['Interval'],
          'startTime': json['Starting time'] != null
              ? TimeOfDay(
                  hour: int.parse(json['Starting time'].split(":")[0]),
                  minute: int.parse(json['Starting time'].split(":")[1]))
              : null,
        };

  HistoricMedication.fromMedication(Medication medication)
      : name = medication.name,
        type = medication.type,
        dosage = medication.dosage,
        startDate = medication.startDate,
        endDate = medication.startDate != null ? DateTime.now() : null,
        intakeDate = medication.intakeDate,
        intakes = medication.intakes;

  Map<String, dynamic> toJson(BuildContext context) => {
        'Medication name': name,
        'Medicine type': type,
        'Dosage': dosage['dose'],
        'Unit': dosage['unit'],
        'Starting date': startDate,
        'Ending date': endDate,
        'Intake date': intakeDate,
        'Intake time': intakes['intakeTime'] != null
            ? MaterialLocalizations.of(context).formatTimeOfDay(intakes['intakeTime'])
            : null,
        'Interval': intakes['interval'],
        'Starting time': intakes['startTime'] != null
            ? MaterialLocalizations.of(context)
                .formatTimeOfDay(intakes['startTime'])
            : null,
      };
}
