import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/seizures.dart';
import 'package:epilappsy/Models/caregiver.dart';
import 'package:epilappsy/Models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';


final databaseReference = FirebaseDatabase.instance.reference();
final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> registerNewPatient() {
  // firestore
  CollectionReference patients =
      FirebaseFirestore.instance.collection('patients');
  String uid = FirebaseAuth.instance.currentUser.uid;
  // Call the user's CollectionReference to add a new user
  return patients
      .doc(uid)
      .set({
        'timestamp': new DateTime.now(),
      })
      .then((value) => print("User added"))
      .catchError((error) => print("Failed to add user: $error"));
}

Future<void> registerNewCaregiver() {
  // firestore
  CollectionReference caregivers =
      FirebaseFirestore.instance.collection('caregivers');
  String uid = FirebaseAuth.instance.currentUser.uid;
  // Call the user's CollectionReference to add a new user
  return caregivers
      .doc(uid)
      .set({
        'timestamp': new DateTime.now(),
      })
      .then((value) => print("User added"))
      .catchError((error) => print("Failed to add user: $error"));
}

void savePatient(String uid, Patient user) {
  // firestore
  FirebaseFirestore.instance
      .collection('Patients')
      .doc(uid)
      .update(user.toJson());
}

void saveCaregiver(String uid, Caregiver user) {
  // firestore
  FirebaseFirestore.instance
      .collection('Caregivers')
      .doc(uid)
      .update(user.toJson());
}

void addPatient2Caregiver(String uid, String patientID) {
  // firestore
  FirebaseFirestore.instance
      .collection('caregivers')
      .doc(uid)
      .update({'patient': patientID});
}

void saveSeizure(Seizure seizure) async { 
  //firestore
  String uid = FirebaseAuth.instance.currentUser.uid;

  String seizureId = await FirebaseFirestore.instance
  .collection('seizures')
  .doc(uid)
  .collection('events')
  .add(seizure.toJson())
  .then((value){
    return value.id;
  });
  print('seizure ID: $seizureId');

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

Future<bool> checkIfPatient() async {
  // firestore
  String uid = FirebaseAuth.instance.currentUser.uid;
  print("current user: $uid");
  bool exists = await FirebaseFirestore.instance
      .collection('patients')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    print("patient exists in database: ${documentSnapshot.exists}");
    return documentSnapshot.exists;
  });

  return exists;
}

Future<bool> checkIfHasPatient(String uid) async {
  // firestore
// checks if caregiver has a patient associated 
  bool exists = await FirebaseFirestore.instance
      .collection('caregivers')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
        print('caregiver already has a patient associated: ${documentSnapshot.data().containsKey("patient")}');
    return documentSnapshot.data().containsKey("patient");
  });

  return exists;
}

Future<bool> checkIfRegistered(String uid) async { // firestore
// checks if patient's profile is complete
  bool registered = await FirebaseFirestore.instance
      .collection('patients')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data().length > 1;
  });
  print("patient profile is complete: $registered");
  return registered;
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
  // firestore
  String uid = FirebaseAuth.instance.currentUser.uid;

  String _defaultSurvey = await FirebaseFirestore.instance
  .collection('patients')
  .doc(uid)
  .get()
  .then((DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data()['default survey'];
  });
  print('patient default survey: $_defaultSurvey');

  Survey _survey = await FirebaseFirestore.instance
  .collection('surveys')
  .doc(_defaultSurvey)
  .get()
  .then((DocumentSnapshot documentSnapshot) {
    print('question list: ${documentSnapshot.data()['questionList'].values.toList()}');
    return createSurvey(documentSnapshot.data()['questionList'].values.toList().cast<String>());
  });
  return _survey;
  
}

Future<String> saveAnswers(Answers answers) async {
  //firestore
  String uid = FirebaseAuth.instance.currentUser.uid;

  String surveyId = await FirebaseFirestore.instance
  .collection('surveys-patients')
  .doc(uid)
  .collection('seizures')
  .add(answers.toJson())
  .then((value){
    return value.id;
  });
  print('suvey ID: $surveyId');
  return surveyId;
}
