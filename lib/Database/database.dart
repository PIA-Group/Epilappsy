import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/seizures.dart';
import 'package:epilappsy/Models/caregiver.dart';
import 'package:epilappsy/Models/patient.dart';

final databaseReference = FirebaseDatabase.instance.reference();

DatabaseReference savePatient(Patient user) {
  var id = databaseReference.child('Patients/').push();
  id.set(user.toJson());
  return id;
}

DatabaseReference saveCaregiver(Caregiver user) {
  var id = databaseReference.child('Caregivers/').push();
  id.set(user.toJson());
  return id;
}

DatabaseReference saveSeizure(Seizure seizure) {
  var id = databaseReference.child('Seizures/${seizure.getUid()}').push();
  id.set(seizure.toJson());
  return id;
}

Future<List<List<String>>> getAllSeizureDetails(String uid) async {
  DataSnapshot dataSnapshot =
      await databaseReference.child('Seizures/$uid').once();
  List<List<String>> details = List<List<String>>();
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      details.add(getDetails(value)[0]);
    });
  }
  return details;
}

String saveSurvey(Survey survey) {
  var id = databaseReference.child('Surveys/').push();
  id.set(survey.toJson());
  return id.key;
}

Future<bool> checkPatient() {
  String uid = FirebaseAuth.instance.currentUser.uid;
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('Patients/');
  return dbRef.orderByChild("User ID").equalTo(uid).once().then((snapshot) {
    return snapshot.value != null;
  });
}

Future<String> getPatientName() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  String name = '';
  DatabaseReference dbRef =
      FirebaseDatabase.instance.reference().child('Patients/');
  DataSnapshot dataSnapshot =
      await dbRef.orderByChild("User ID").equalTo(uid).once();
  dataSnapshot.value.forEach((key, value) {
    value.forEach((key2, value2) {
      if (key2 == 'Name') {
        name = value2;
      }
    });
  });
  return name;
}

Future<List<Survey>> getAllSurveys() async {
  DataSnapshot dataSnapshot = await databaseReference.child("Surveys/").once();
  List<Survey> surveys = [];
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      Survey survey = createSurvey(value);
      survey.setId(databaseReference.child('Surveys/' + key).key);
      surveys.add(survey);
    });
  }
  return surveys;
}

Future<Survey> getDefaultSurvey() async {
  String uid = FirebaseAuth.instance.currentUser.uid;
  DataSnapshot dataSnapshot = await databaseReference
      .child("Patients/")
      .orderByChild("User ID")
      .equalTo(uid)
      .once();
  if (dataSnapshot.value != null) {
    String _surveyRef = '';
    dataSnapshot.value.forEach((key, value) {
      value.forEach((key2, value2) {
        if (key2 == 'Default Survey') {
          _surveyRef = value2;
        }
      });
    });
    if (_surveyRef != '') {
      DataSnapshot dataSnapshot2 =
          await databaseReference.child("Surveys/$_surveyRef").once();
      if (dataSnapshot2.value != null) {
        Survey _survey = createSurvey(dataSnapshot2.value);
        _survey.setId(_surveyRef);
        return _survey;
      }
    }
  }
  return Survey();
}

DatabaseReference saveAnswers(Answers answers) {
  String uid = FirebaseAuth.instance.currentUser.uid;
  var id =
      databaseReference.child('Answers/$uid/${answers.getSurveyId()}').push();
  id.set(answers.toJson());
  return id;
}
