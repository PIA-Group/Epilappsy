import 'package:casia/Database/Survey.dart';

class Seizure {
  String _uid;
  List<String> _details;
  //DatabaseReference _id;
  Answers _answers;
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
        'Survey ID': this._answers.getSurveyId(),
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

List<String> getKeys(record) {
  List<String> keys = [];
  record.forEach((key, value) => {keys.add(key)});
  return keys;
}

Map<DateTime, Map<String, dynamic>> getSeizuresDetails(allRecords) {
  Map<DateTime, Map<String, dynamic>> attributes = {};
  DateTime date;
  allRecords.forEach((doc) {
    date = doc.data()['Date'].toDate();
    date = DateTime(date.year, date.month, date.day);
    attributes[date] = doc.data();
  });
  print('HERE');
  print(attributes);

  return attributes;
}
