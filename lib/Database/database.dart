import 'package:casia/BrainAnswer/ba_api.dart';
import 'package:casia/Pages/Education/WebPage.dart';
import 'package:casia/Pages/Medication/historic_medication.dart';
import 'package:casia/Pages/Medication/medication.dart';
import 'package:casia/Pages/Medication/reminders.dart';
import 'package:casia/Database/Survey.dart';
import 'package:casia/Database/seizures.dart';
import 'package:casia/Models/caregiver.dart';
import 'package:casia/Models/patient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

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
    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;
    print(
        'caregiver already has a patient associated: ${docData.containsKey("patient")}');
    return docData.containsKey("patient");
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
    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;
    return docData.length > 1;
  }).catchError((error) async {
    print(error);
    bool exists = await checkIfPatientExists();
    if (!exists) savePatient(Patient(uid: uid));
  });
  print("patient profile is complete: $complete");
  return complete;
}

Future<Survey> getDefaultSurvey() async {
  String uid = BAApi.loginToken;
  // firestore
  String _defaultSurvey = await FirebaseFirestore.instance
      .collection('patients')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;
    return docData['default survey'];
  });
  print('patient default survey: $_defaultSurvey');

  Survey _survey = await FirebaseFirestore.instance
      .collection('surveys')
      .doc(_defaultSurvey)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    Map<String, dynamic> docData =
        documentSnapshot.data() as Map<String, dynamic>;
    print('question list: ${docData['questionList'].values.toList()}');
    return createSurvey(docData['questionList'].values.toList().cast<String>());
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

void saveReminder(Reminder reminder) async {
  //firestore
  String uid = BAApi.loginToken;

  String reminderId = await FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection('current')
      .add(reminder.toJson())
      .then((value) {
    return value.id;
  });
  print('reminder ID: $reminderId');
}

void saveMedication(Medication medication, BuildContext context) async {
  String uid = BAApi.loginToken;

  String medicationId = await FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection('current')
      .add(medication.toJson(context))
      .then((value) {
    return value.id;
  });
  print('medication ID: $medicationId');
}

void updateMedication(Medication medication, BuildContext context,
    DocumentSnapshot<Object> medDoc) async {
  String uid = BAApi.loginToken;

  await FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection('current')
      .doc(medDoc.id)
      .set(medication.toJson(context), SetOptions(merge: true))
      .then((value) {});
}

void saveHistoricMedication(
    HistoricMedication historicMedication, BuildContext context) async {
  String uid = BAApi.loginToken;

  String medicationId = await FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection('historic')
      .add(historicMedication.toJson(context))
      .then((value) {
    return value.id;
  });
  print('medication ID: $medicationId');
}

void deleteMedication(DocumentSnapshot medDoc, bool isHistory) async {
  //firestore
  String uid = BAApi.loginToken;

  String collection = isHistory ? 'historic' : 'current';

  String medName = await FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection(collection)
      .doc(medDoc.id)
      .delete()
      .then((value) {
    Map<String, dynamic> medDocData = medDoc.data() as Map<String, dynamic>;
    return medDocData['Medication name'];
  });
  print('Medication $medName deleted successfully!');
}

void updateMedicationField(String id, String field, dynamic newValue) {
  String uid = BAApi.loginToken;
  FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection('current')
      .doc(id)
      .update({field: newValue});
}

Future<dynamic> getMedication() async {
  DateTime date = DateTime.now();
  String uid = BAApi.loginToken;
  List meds = [];

  await FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection('current')
      .get()
      .then((value) {
    value.docs.forEach((element) {
      meds.add(element.data());
    });
  });
  print('meds $meds');
  return meds;
}

Stream<dynamic> getMedicationStream() {
  DateTime date = DateTime.now();
  String uid = BAApi.loginToken;
  return FirebaseFirestore.instance
      .collection('patient-medications')
      .doc(uid)
      .collection('current')
      .orderBy('Medication name')
      .snapshots();
}

/*
void addMedication(MedicationDetails medDoc) async {
  String uid = BAApi.loginToken;

  String medicationId = await FirebaseFirestore.instance
      .collection('patient-medications')
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
      .collection('patient-medications')
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

/* Future<dynamic> getMonthlySeizures(int month) async {
  String uid = BAApi.loginToken;
  var date = await FirebaseFirestore.instance
      .collection('seizures')
      .doc(uid)
      .collection('events')
      .where("Date", isGreaterThan: Timestamp.fromDate(DateTime(2021, month)))
      .where("Date", isLessThan: Timestamp.fromDate(DateTime(2021, month + 1)))
      .get();

  return date;
} */

Stream<dynamic> getMonthlyEvents(int month) {
  String uid = BAApi.loginToken;
  int currentYear = DateTime.now().year;

  return FirebaseFirestore.instance
      .collection('seizures')
      .doc(uid)
      .collection('events')
      .where("Date",
          isGreaterThan: Timestamp.fromDate(DateTime(currentYear, month)))
      .where("Date",
          isLessThan: Timestamp.fromDate(DateTime(currentYear, month + 1)))
      .snapshots();
}

Future<dynamic> getSeizuresInRange(DateTime start, DateTime end) async {
  print('Fetching data from $start to $end');
  String uid = BAApi.loginToken;
  List events = [];
  var date = await FirebaseFirestore.instance
      .collection('seizures')
      .doc(uid)
      .collection('events')
      .where("Date", isGreaterThan: Timestamp.fromDate(start))
      .where("Date", isLessThan: Timestamp.fromDate(end))
      .get()
      .then((QuerySnapshot documentSnapshot) {
    if (documentSnapshot.docs.isNotEmpty) {
      documentSnapshot.docs.forEach((element) {
        events.add(element.data());
      });
      return events;
    } else {
      return [];
    }
  });
  return date;
}

Future<dynamic> getSeizuresOfDay(DateTime day) async {
  print('Fetch data from $day');
  String uid = BAApi.loginToken;
  List events = [];
  var date = await FirebaseFirestore.instance
      .collection('seizures')
      .doc(uid)
      .collection('events')
      .where("Date", isEqualTo: Timestamp.fromDate(day))
      .get()
      .then((QuerySnapshot documentSnapshot) {
    if (documentSnapshot.docs.isNotEmpty) {
      documentSnapshot.docs.forEach((element) {
        events.add(element.data());
      });
      return events;
    } else {
      return [];
    }
  });
  print('ttt ${date[0]}');
  return date[0];
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

Future<dynamic> getDailyTip(String tipOfDay) async {
  var dailyTip = await FirebaseFirestore.instance
      .collection('daily-tips')
      .doc(tipOfDay)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    if (documentSnapshot.exists) {
      return documentSnapshot.data();
    } else {
      print('Document does not exist on the database');
    }
  });
  return dailyTip;
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

void saveQuestions(RecordObject record) async {
  //firestore
  String uid = BAApi.loginToken;
  String recordID = await FirebaseFirestore.instance
      .collection('education')
      .doc(uid)
      .collection('questions')
      .add(record.toJson())
      .then((value) {
    return value.id;
  });
  print('record ID: $recordID');
}

Future<List<RecordObject>> getQuestions() async {
  String uid = BAApi.loginToken;
  List listRecords = [];

  var date = await FirebaseFirestore.instance
      .collection('education')
      .doc(uid)
      .collection('questions')
      .get()
      .then((QuerySnapshot documentSnapshot) {
    if (documentSnapshot.docs.isNotEmpty) {
      return documentSnapshot.docs.forEach((element) {
        listRecords.add(element.data());
      });
    }
  });
  List<RecordObject> records = [];

  for (var i = 0; i < listRecords.length; i++) {
    records.add(RecordObject(
        question: listRecords[i]['question'], url: listRecords[i]['url']));
  }
  print('list ${records[0].question}');
  return records;
}

void deleteQuestion(RecordObject record) {
  String uid = BAApi.loginToken;

  FirebaseFirestore.instance
      .collection('education')
      .doc(uid)
      .collection('questions')
      .where("question", isEqualTo: record.question)
      .get()
      .then((value) {
    value.docs.forEach((element) {
      FirebaseFirestore.instance
          .collection("education")
          .doc(uid)
          .collection("questions")
          .doc(element.id)
          .delete()
          .then((value) {
        print('Success!');
      });
    });
  });
}
