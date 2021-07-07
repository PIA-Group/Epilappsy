import 'package:epilappsy/Database/Survey.dart';

class Seizure {
  String _uid;
  List<String> _details;
  //DatabaseReference _id;
  SeizureDetails _answers;
  Seizure(this._uid, this._details, this._answers);

  /* DatabaseReference getId() {
    return this._id;
  } */

  void setUid(String uid) {
    this._uid = uid;
  }

  void setDetails(List<String> list) {
    this._details = list;
  }

  String getUid() {
    return this._uid;
  }

  Seizure.fromJson(Map<String, dynamic> json) {
    this._details[0] = json['Date'];
    this._details[1] = json['Time'];
    this._details[2] = json['Duration'];
    this._details[3] = json['Type'];
    this._details[4] = json['Mood'];
    this._details[5] = json['Trigger'];
    this._details[6] = json['Trigger Notes'];
    this._details[7] = json['Description'];
    this._details[8] = json['Description Notes'];
    this._details[9] = json['Post Events'];
    this._details[10] = json['Post Events Notes'];
    this._answers = json['Answer List'];
  }

  /* void setId(DatabaseReference id) {
    this._id = id;
  } */

  Map<String, dynamic> toJson() {
    if (this._answers != null) {
      return {
        'Date': this._details[0],
        'Time': this._details[1],
        'Duration': this._details[2],
        'Type': this._details[3],
        'Mood': this._details[4],
        'Trigger': this._details[5],
        'Trigger Notes': this._details[6],
        'Description': this._details[7],
        'Description Notes': this._details[8],
        'Post Event': this._details[9],
        'Post Event Notes': this._details[10],
        'Survey ID': this._answers.getSeizureId(),
        'Answer List': this._answers.values,
      };
    }

    return {
      'Date': this._details[0],
      'Time': this._details[1],
      'Duration': this._details[2],
      'Type': this._details[3],
      'Mood': this._details[4],
      'Trigger': this._details[5],
      'Trigger Notes': this._details[6],
      'Description': this._details[7],
      'Description Notes': this._details[8],
      'Post Event': this._details[9],
      'Post Event Notes': this._details[10],
    };
  }
}

List<List<String>> getDetails(record) {
  Map<String, dynamic> attributes = {
    'Details': '',
    'Date': '',
    'Time': '',
    'Duration': '',
    'Type': '',
    'Mood': '',
    'Trigger': '',
    'Trigger Notes': '',
    'Description': '',
    'Description Notes': '',
    'Post Event': '',
    'Post Event Notes': '',
    'Answer List': [],
  };
  record.forEach((key, value) => {attributes[key] = value});

  List<String> _answers = [];

  for (var i = 0; i < attributes['Answer List'].length; i++) {
    _answers.add(attributes['Answer List'][i].toString());
  }
  List<List<String>> _list = [
    [
      attributes['Date'],
      attributes['Time'],
      attributes['Duration'],
      attributes['Type'],
      attributes['Mood'],
      attributes['Trigger'],
      attributes['Trigger Notes'],
      attributes['Description'],
      attributes['Description Notes'],
      attributes['Post Event'],
      attributes['Post Event Notes'],
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
