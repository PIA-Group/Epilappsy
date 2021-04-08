class Caregiver {
  String _uid;
  String _name;
  //DatabaseReference _id;
  String _patientid;
  Caregiver();

  /* DatabaseReference getId() {
    return this._id;
  } */

  void setName(String name) {
    this._name = name;
  }

  void setUserId(String uid) {
    this._uid = uid;
  }

  Caregiver.fromJson(Map<String, dynamic> json) {
    this._uid = json['User ID'];
    this._name = json['Name'];
  }

  /* void setId(DatabaseReference id) {
    this._id = id;
  } */

  Map<String, dynamic> toJson() {
    return {
      'User ID': this._uid,
      'Name': this._name,
      'Patient ID': this._patientid,
    };
  }
}
