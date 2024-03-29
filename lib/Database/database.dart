import 'package:epilappsy/BrainAnswer/ba_api.dart';
import 'package:epilappsy/Pages/Medication/medications.dart';
import 'package:epilappsy/Widgets/dailytip.dart';
import 'package:epilappsy/Widgets/humor.dart';
import 'package:epilappsy/Pages/Medication/reminders.dart';
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
      .then((value) {
    return value.id;
  });
  print('seizure ID: $seizureId');
}

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
    print(
        'caregiver already has a patient associated: ${documentSnapshot.data().containsKey("patient")}');
    return documentSnapshot.data().containsKey("patient");
  });

  return exists;
}

Future<bool> checkIfProfileComplete() async {
  // firestore
  // checks if patient's profile is complete
  String uid = BAApi.loginToken;

  bool complete = await FirebaseFirestore.instance
      .collection('patients')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    return documentSnapshot.data().length > 1;
  }).catchError((error) async {
    print(error);
    bool exists = await checkIfPatientExists();
    if (!exists) savePatient(Patient(uid: uid));
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
    print(
        'question list: ${documentSnapshot.data()['questionList'].values.toList()}');
    return createSurvey(
        documentSnapshot.data()['questionList'].values.toList().cast<String>());
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
      .then((value) {
    return value.id;
  });
  print('suvey ID: $surveyId');
  return surveyId;
}

Future<dynamic> getHumor() async {
  String uid = BAApi.loginToken;
  String humorDay = 'humor_' +
      DateTime.now().day.toString() +
      '_' +
      DateTime.now().month.toString() +
      '_' +
      DateTime.now().year.toString();
  var humor = await FirebaseFirestore.instance
      .collection('humor-patients')
      .doc(uid)
      .collection('humor')
      .doc(humorDay)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Humor ${documentSnapshot.data()}');
      return documentSnapshot.data();
    } else {
      return null;
      //print('Humor does not exist yet');
      //return [];
    }
  });
  return humor;
}

Future<dynamic> getDailyTip(String tip_of_day) async {
  var daily_tip = await FirebaseFirestore.instance
      .collection('daily-tips')
      .doc(tip_of_day)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      print('Document data: ${documentSnapshot.data()}');
      return documentSnapshot.data();
    } else {
      print('Document does not exist on the database');
    }
  });
  print('EE $daily_tip');
  print(daily_tip.runtimeType);
  return daily_tip;
}

void saveReminder(Reminder reminder) async {
  //firestore
  String uid = BAApi.loginToken;

  String reminderId = await FirebaseFirestore.instance
      .collection('medication-patients')
      .doc(uid)
      .collection('current')
      .add(reminder.toJson())
      .then((value) {
    return value.id;
  });
  print('reminder ID: $reminderId');
}

void saveHumor(String level, DateTime timestamp) async {
  String uid = BAApi.loginToken;
  String humorDay = 'humor_' +
      DateTime.now().day.toString() +
      '_' +
      DateTime.now().month.toString() +
      '_' +
      DateTime.now().year.toString();

  FirebaseFirestore.instance
      .collection('humor-patients')
      .doc(uid)
      .collection('humor')
      .doc(humorDay)
      .set({'level': level, 'timestamp': timestamp}).then((_) {
    print('Success!');
  });
}

void saveMedication(Medication medication) async {
  String uid = BAApi.loginToken;

  String medicationId = await FirebaseFirestore.instance
      .collection('medication')
      .doc(uid)
      .collection('user medications')
      .add(medication.toJson())
      .then((value) {
    return value.id;
  });
  print('medication ID: $medicationId');
}

void deleteMedication(DocumentSnapshot medDoc) async {
  //firestore
  String uid = BAApi.loginToken;

  String medName = await FirebaseFirestore.instance
      .collection('medication-patients')
      .doc(uid)
      .collection('current')
      .doc(medDoc.id)
      .delete()
      .then((value) {
    return medDoc.data()['Medication name'];
  });
  print('Medication $medName deleted successfully!');
}

void updateMedication(String id, String field, dynamic newValue) {
  String uid = BAApi.loginToken;
  FirebaseFirestore.instance
      .collection('medication-patients')
      .doc(uid)
      .collection('current')
      .doc(id)
      .update({field: newValue});
}

/*
void addMedication(MedicationDetails medDoc) async {
  String uid = BAApi.loginToken;

  String medicationId = await FirebaseFirestore.instance
      .collection('medication-patients')
      .doc(uid)
      .collection('history')
      .add(medDoc.toJson())
      .then((value) {
    return medDoc.data()['Medication name'];
  });
  print('medication ID: $medicationId');
}


void moveMedicationToHistory(DocumentSnapshot medDoc) async {
  //firestore
  String uid = BAApi.loginToken;

  String medName = await FirebaseFirestore.instance
      .collection('medication-patients')
      .doc(uid)
      .collection('current')
      .doc(medDoc.id)
      .delete()
      .then((value) {
    return medDoc.data()['Medication name'];
  });
  print('Medication $medName moved to history successfully!');
}
*/