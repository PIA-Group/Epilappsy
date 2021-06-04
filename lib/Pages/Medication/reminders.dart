class Reminder {
  String _uid;
  List _fields;
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
    this._fields[1] = json['Medicine type'];
    this._fields[2] = json['Dosage'];
    this._fields[3] = json['Take with food'];
    this._fields[4] = json['Spontaneous'];
    this._fields[5] = json['Starting date'];
    this._fields[6] = json['Alarm'];
    this._fields[7] = json['Interval'];
    this._fields[8] = json['Hours'];

    this._answers = json['Answer List'];
  }

  /* void setId(DatabaseReference id) {
    this._id = id;
  } */

  Map<String, dynamic> toJson() {
    if (this._answers != null) {
      return {
        'Medication name': this._fields[0],
        'Medicine type': this._fields[1],
        'Dosage': this._fields[2],
        'Take with food': this._fields[3],
        'Spontaneous': this._fields[4],
        'Starting date': this._fields[5],
        'Alarm': this._fields[6],
        'Interval': this._fields[7],
        'Hours': this._fields[8],


        'Reminder ID': this._answers.getReminderId(),
        'Answer List': this._answers.values,
      };
    }

    return {
      'Medication name': this._fields[0],
        'Medicine type': this._fields[1],
        'Dosage': this._fields[2],
        'Take with food': this._fields[3],
        'Spontaneous': this._fields[4],
        'Starting date': this._fields[5],
        'Alarm': this._fields[6],
        'Interval': this._fields[7],
        'Hours': this._fields[8],
    };
  }
}

List<List<String>> getFields(record) {
  Map<String, dynamic> attributes = {
    'Medication name': '',
    'Medicine type': '',
    'Dosage': '',
    'Take with food': '',
    'Spontaneous': '',
    'Starting date': '',
    'Alarm': '',
    'Interval': '',
    'Hours': '',
  
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
      attributes['Medicine type'],
      attributes['Dosage'],
      attributes['Take with food'],
      attributes['Spontaneous'],
      attributes['Starting date'],
      attributes['Alarm'],
      attributes['Interval'],
      attributes['Hours'],
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