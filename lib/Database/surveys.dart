import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

final FirebaseFirestore firestore = FirebaseFirestore.instance;
final String uid = FirebaseAuth.instance.currentUser.uid;

Future getSurveyWidgetList(double screenWidth) async {
  String surveyID = await firestore
      .collection('patients')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    print("default survey ID: ${documentSnapshot.data()['default survey']}");
    return documentSnapshot.data()['default survey'];
  });

  String doctorID = await firestore
      .collection('patients')
      .doc(uid)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    print("doctor ID: ${documentSnapshot.data()['doctor']}");
    return documentSnapshot.data()['doctor'];
  });

  final survey = await firestore
      .collection('surveys-doctors')
      .doc(doctorID)
      .collection('surveys')
      .doc(surveyID)
      .get()
      .then((DocumentSnapshot documentSnapshot) {
    print("survey: $documentSnapshot");
    return documentSnapshot;
  });

  print("survey info: ${survey.data()}");

  for (var questionID in survey.data()['order']) {
    if (!survey.data()['fromTemplate']) {
      //if not from template, get questions from surveys-doctors, else from surveys_templates
      final cenas = survey.reference
          .collection('questions')
          .doc(questionID)
          .get()
          .then((question) => getSurveyWidget(question, screenWidth));
    }
  }
}

Future getSurveyWidget(DocumentSnapshot question, double screenWidth) async {
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(30),
    ),
    height: double.infinity,
    width: screenWidth - 20,
    child: Column(
      children: [
        Text(question.data()['text']),
        Padding(
          padding: EdgeInsets.only(top: 10),
          child: ToggleButtons(
            children: <Widget>[
              Icon(Icons.ac_unit),
              Icon(Icons.call),
              Icon(Icons.cake),
            ],
          ),
        )
      ],
    ),
  );
}
