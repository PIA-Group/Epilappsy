

class Patient {
  String _uid;
  List<String> _userDetails = List.filled(7, '');
  List<bool> _userSideEffects = List.filled(6, true);
  //DatabaseReference _id;
  String _defaultSurvey;
  Patient() {
    this._defaultSurvey = '-ML4nUK-snBG-7FLR4xU';
  }

  /* DatabaseReference getId() {
    return this._id;
  } */

  void setUserDetails(List<String> _list) {
    this._userDetails = _list;
  }

  void setUserSideEffects(List<bool> _list) {
    this._userSideEffects = _list;
  }

  void setUserId(String uid) {
    this._uid = uid;
  }

  Patient.fromJson(Map<String, dynamic> json) {
    this._userDetails[0] = json['Name'];
    this._userDetails[1] = json['Age'];
    this._userDetails[2] = json['Gender'];
    this._userDetails[3] = json['Seizure Frequency'];
    this._userDetails[4] = json['Common Seizures'];
    this._userDetails[5] = json['Medication'];
    this._userDetails[6] = json['Other Medication'];
    this._userSideEffects[0] = json['Diziness'];
    this._userSideEffects[1] = json['Headaches'];
    this._userSideEffects[2] = json['Irritability'];
    this._userSideEffects[3] = json['Mood Changes'];
    this._userSideEffects[4] = json['Skipping Menstrual Cycle'];
    this._userSideEffects[5] = json['Somnolence'];
    this._defaultSurvey = json['Default Survey'];
  }

  /* void setId(DatabaseReference id) {
    this._id = id;
  }
 */
  Map<String, dynamic> toJson() {
    return {
      'User ID': this._uid,
      'Name': this._userDetails[0],
      'Age': this._userDetails[1],
      'Gender': this._userDetails[2],
      'Seizure Frequency': this._userDetails[3],
      'Common Seizures': this._userDetails[4],
      'Medication': this._userDetails[5],
      'Other Medication': this._userDetails[6],
      'Diziness': this._userSideEffects[0],
      'Headaches': this._userSideEffects[1],
      'Irritability': this._userSideEffects[2],
      'Mood Changes': this._userSideEffects[3],
      'Skipping Menstrual Cycle': this._userSideEffects[4],
      'Somnolence': this._userSideEffects[5],
      'Default Survey': this._defaultSurvey,
    };
  }
}
