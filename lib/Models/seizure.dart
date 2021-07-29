
import 'package:epilappsy/BrainAnswer/form_data.dart';

class Seizure {

  String _uid;
  List dates;
  String time;
  String duration;
  String location;
  String type;
  List triggers;
  List auras;
  List postSeizure;
  List duringSeizure;
  bool emergencyTreatment;
  String comments;

  

  Seizure(this._uid,
          this.dates,
          this.time,
          this.duration,
          this.location,
          this.type,
          this.triggers,
          this.auras,
          this.postSeizure,
          this.duringSeizure,
          this.emergencyTreatment,
          this.comments);
  
  //SeizureDetails _answers = [];
  
  Seizure.fromFieldData(List<FieldData> form) {
    form.forEach((entry) {
      if (entry.hidden) {
        if (entry.label == 'type') type = entry.question;
        if (entry.label == 'duringSeizure') duringSeizure = entry.options;
      }
    });
  }


  void setUid(String uid) {
    this._uid = uid;
  }

  // void setDetails(List<String> list) {
  //   this._details = list;
  // }

  String getUid() {
    return this._uid;
  }

  Seizure.fromJson(Map<String, dynamic> json) {
    this.dates = json['Dates'];
    this.time = json['Time'];
    this.duration = json['Duration'];
    this.location = json['Location'];
    this.type = json['Type'];
    this.triggers = json['Triggers'];
    this.auras = json['Auras'];
    this.postSeizure = json['Symptoms Post-Seizure'];
    this.duringSeizure = json['Symptoms During Seizure'];
    this.emergencyTreatment = json['Emergency treatment'];
    this.comments = json['Notes'];
    //this._answers = json['Answer List'];
  }

  /* void setId(DatabaseReference id) {
    this._id = id;
  } */

  Map<String, dynamic> toJson() {
    if (this.type != null) {
      return {
        'Dates': this.dates,
        'Time': this.time,
        'Duration': this.duration,
        'Location': this.location,
        'Type': this.type,
        'Triggers': this.triggers,
        'Auras': this.auras,
        'Symptoms Post-Seizure': this.postSeizure,
        'Symptoms During Seizure': this.duringSeizure,
        'Emergency treatment': this.emergencyTreatment,
        'Notes': this.comments,
        //'Answer List': this._answers.values,
      };
    }

    return {
        'Dates': this.dates,
        'Time': this.time,
        'Duration': this.duration,
        'Location': this.location,
        'Type': this.type,
        'Triggers': this.triggers,
        'Auras': this.auras,
        'Symptoms Post-Seizure': this.postSeizure,
        'Symptoms During Seizure': this.duringSeizure,
        'Emergency treatment': this.emergencyTreatment,
        'Notes': this.comments,
        //'Answer List': this._answers.values,
    };
  }
}

List<List<String>> getDetails(record) {
  Map<String, dynamic> attributes = {
    'Dates': '',
    'Time': '',
    'Duration': '',
    'Location': '',
    'Type': '',
    'Triggers': '',
    'Auras': '',
    'Symptoms Post-Seizure': '',
    'Symptoms During Seizure': '',
    'Emergency treatment': '',
    'Notes': '',
    'Answer List': [],
  };
  record.forEach((key, value) => {attributes[key] = value});

  List<String> _answers = [];

  for (var i = 0; i < attributes['Answer List'].length; i++) {
    _answers.add(attributes['Answer List'][i].toString());
  }
  List<List<String>> _list = [
    [
      attributes['Dates'],
      attributes['Time'],
      attributes['Duration'],
      attributes['Location'],
      attributes['Type'],
      attributes['Triggers'],
      attributes['Auras'],
      attributes['Symptoms Post-Seizure'],
      attributes['Symptoms During Seizure'],
      attributes['Emergency treatment'],
      attributes['Notes'],
      //attributes['Answer List'],
    ],
    _answers
  ];

  return _list;

}



class SeizureDetails {
  List<String> values;
  String _seizureId;

  SeizureDetails();

  void setAnswers(List<String> answers) {
    this.values = answers;
  }

  void setSeizureId(String id) {
    this._seizureId = id;
  }

  String getSeizureId() {
    return this._seizureId;
  }

  Map<String, dynamic> toJson() {
    return {
      'Values': this.values,
    };
  }

  SeizureDetails.fromJson(Map<String, dynamic> json) {
    this.values = json['Values'];
  }
}
