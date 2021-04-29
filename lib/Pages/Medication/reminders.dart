class Reminder {
  String _uid;
  List<String> _fields;
  ReminderDetails _answers;
  //DatabaseReference _id;
  Reminder(this._uid, this._fields, this._answers);

  /* DatabaseReference getId() {
    return this._id;
  } */

  void setUid(String uid) {
    this._uid = uid;
  }

  void setFields(List<String> list) {
    this._fields = list;
  }

  String getUid() {
    return this._uid;
  }

  Reminder.fromJson(Map<String, dynamic> json) {
    this._fields[0] = json['Medication name'];
    this._fields[1] = json['Dosage'];
    this._fields[2] = json['Medicine type'];
    this._fields[3] = json['Interval'];
    this._fields[4] = json['Starting time'];

    this._answers = json['Answer List'];
  }

  /* void setId(DatabaseReference id) {
    this._id = id;
  } */

  Map<String, dynamic> toJson() {
    if (this._answers != null) {
      return {
        'Medication name': this._fields[0],
        'Dosage': this._fields[1],
        'Medicine type': this._fields[2],
        'Interval': this._fields[3],
        'Starting time': this._fields[4],
        'Reminder ID': this._answers.getReminderId(),
        'Answer List': this._answers.values,
      };
    }

    return {
      'Medication name': this._fields[0],
      'Dosage': this._fields[1],
      'Medicine type': this._fields[2],
      'Interval': this._fields[3],
      'Starting time': this._fields[4],
    };
  }
}

List<List<String>> getFields(record) {
  Map<String, dynamic> attributes = {
    'Medication name': '',
    'Dosage': '',
    'Medicine type': '',
    'Interval': '',
    'Starting time': '',
  
    'Answer List': [],
  };
  record.forEach((key, value) => {attributes[key] = value});

  List<String> _answers = List<String>();

  for (var i = 0; i < attributes['Answer List'].length; i++) {
    _answers.add(attributes['Answer List'][i].toString());
  }
  List<List<String>> _list = [
    [
      attributes['Medication name'],
      attributes['Dosage'],
      attributes['Medicine type'],
      attributes['Interval'],
      attributes['Starting time'],
    ],
    _answers
  ];

  return _list;
}


class ReminderDetails {
  List<String> values;
  String _reminderId;

  ReminderDetails();

  void setAnswers(List<String> answers) {
    this.values = answers;
  }

  void setReminderId(String id) {
    this._reminderId = id;
  }

  String getReminderId() {
    return this._reminderId;
  }

  Map<String, dynamic> toJson() {
    return {
      'Values': this.values,
    };
  }

  ReminderDetails.fromJson(Map<String, dynamic> json) {
    this.values = json['Values'];
  }
}