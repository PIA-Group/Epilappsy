import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/Models/survey_questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  ValueNotifier<Map> answers = ValueNotifier({});
  List surveyQuestionList;
  String userName = '';
  User currentUser;
  FirebaseFirestore firestore;
  String uid;
  List<bool> isSelected = [true, false];

  /* void updateUser() {
    getPatientName().then((value) => {
          this.setState(() {
            this.name = value;
          })
        });
  } */

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    firestore = FirebaseFirestore.instance;
    uid = FirebaseAuth.instance.currentUser.uid;
    super.initState();
  }

  Future<List<Widget>> getSurveyWidgetList(ValueNotifier<Map> answers) async {
    List<Widget> listQuestions = [];
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

    for (var i = 0; i < survey.data()['order'].length; i++) {
      if (!survey.data()['fromTemplate']) {
        //if not from template, get questions from surveys-doctors, else from surveys_templates
        final aux = await survey.reference
            .collection('questions')
            .doc(survey.data()['order'][i])
            .get()
            .then((question) => getSurveyWidget(question, i, answers));
        listQuestions.add(aux);
      }
    }
    return listQuestions;
  }

  Widget getSurveyWidget(DocumentSnapshot question, int questionIndex, ValueNotifier<Map> answers) {
    return SurveyQuestion(
      question: question.data()['text'],
      type: question.data()['type'],
      options: question.data()['options'],
      questionIndex: questionIndex,
      answers: answers,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: appBarTitle(context),
        backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(100),
          child: FlexibleSpaceBar(
            centerTitle: true,
            title: Center(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.account_circle,
                        size: 70.0,
                        color: Colors.white,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          /* Text(
                              userName,
                              style: TextStyle(color: Colors.white),
                            ), */
                          Text(
                            '',
                            //currentUser.email,
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: FutureBuilder(
          future: getSurveyWidgetList(answers),
          builder: (context, AsyncSnapshot snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            } else {
              return Container(
                child: ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: snapshot.data.length,
                  itemBuilder: (context, index) {
                    return snapshot.data[index];
                  },
                ),
              );
            }
          }),
    );
  }
}
