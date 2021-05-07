import 'package:epilappsy/BrainAnswer/ba_api.dart';
import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/seizures.dart';
import 'package:epilappsy/Models/caregiver.dart';
import 'package:epilappsy/Models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;

Future<void> registerNewPatient() {
  // firestore
  String uid = BAApi.loginToken;
  CollectionReference patients =
      FirebaseFirestore.instance.collection('patients');
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
  String uid = BAApi.loginToken;
  CollectionReference caregivers =
      FirebaseFirestore.instance.collection('caregivers');
  // Call the user's CollectionReference to add a new user
  return caregivers
      .doc(uid)
      .set({
        'timestamp': new DateTime.now(),
      })
      .then((value) => print("User added"))
      .catchError((error) => print("Failed to add user: $error"));
}

void savePatient(Patient user) {
  // firestore
  String uid = BAApi.loginToken;
  FirebaseFirestore.instance
      .collection('Patients')
      .doc(uid)
      .update(user.toJson());
}

void saveCaregiver(Caregiver user) {
  // firestore
  String uid = BAApi.loginToken;
  FirebaseFirestore.instance
      .collection('Caregivers')
      .doc(uid)
      .update(user.toJson());
}

void addPatient2Caregiver(String patientID) {
  // firestore
  String uid = BAApi.loginToken;
  FirebaseFirestore.instance
      .collection('caregivers')
      .doc(uid)
      .update({'patient': patientID});
}

void saveSeizure(Seizure seizure) async { 
  //firestore
  String uid = BAApi.loginToken;
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

/* Future<List<List<String>>> getAllSeizureDetails(String uid) async {
  DataSnapshot dataSnapshot =
      await databaseReference.child('Seizures/$uid').once();
  List<List<String>> details = List<List<String>>();
  if (dataSnapshot.value != null) {
    dataSnapshot.value.forEach((key, value) {
      details.add(getDetails(value)[0]);
    });
  }
  return details;
} */

/* String saveSurvey(Survey survey) {
  var id = databaseReference.child('Surveys/').push();
  id.set(survey.toJson());
  return id.key;
} */

Future<bool> checkIfPatientExists() async {
  // firestore
  String uid = BAApi.loginToken;
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

Future<bool> checkIfHasPatient(d) async {
  // firestore
  String uid = BAApi.loginToken;
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

Future<bool> checkIfProfileComplete() async { // firestore
// checks if patient's profile is complete
  String uid = BAApi.loginToken;
  bool complete = await FirebaseFirestore.instance
      .collection('patients')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data().length > 1;
  });
  print("patient profile is complete: $complete");
  return complete;
}

/* Future<String> getPatientName() async {
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
} */

/* Future<List<Survey>> getAllSurveys() async {
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
} */

Future<Survey> getDefaultSurvey() async {
  String uid = BAApi.loginToken;
  // firestore
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
  String uid = BAApi.loginToken;
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
