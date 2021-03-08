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
  // 'answers' is used to see if the visibility rules are true; it is not the final answer variable
  // that is retrieved in the end, as attributes from the SurveyQuestion widgets
  ValueNotifier<Map> answers = ValueNotifier({});
  User currentUser;
  FirebaseFirestore firestore;
  String uid;
  // initiate surveyQuestionList like this in case there's a problem on loading the questions from firestore
  ValueNotifier<List<SurveyQuestion>> surveyQuestionList = ValueNotifier([
    SurveyQuestion(
      widgetType: 'Processing',
    )
  ]);
  DocumentSnapshot survey;
  List<Map<String, String>> visibilityRules = [];

  @override
  void initState() {
    currentUser = FirebaseAuth.instance.currentUser;
    firestore = FirebaseFirestore.instance;
    uid = FirebaseAuth.instance.currentUser.uid;
    callInitSurveyWidgetList(answers);
    answers.addListener(() =>
        updateSurveyWidgetList()); // listens to changes in the user's answers
    super.initState();
  }

  callInitSurveyWidgetList(answers) async {
    await initSurveyWidgetList(answers)
        .then((value) => setState(() => surveyQuestionList.value = value));
  }

  Future<List<Widget>> initSurveyWidgetList(ValueNotifier<Map> answers) async {
    // initiate list of widgets [Widget, Widget, ...] according to the info on firestore
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

    survey = await firestore
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

    surveyQuestionList.value.removeAt(0);

    for (var i = 0; i < survey.data()['order'].length; i++) {
      if (!survey.data()['fromTemplate']) {
        //if not from template, get questions from surveys-doctors, else from surveys_templates
        // FALTA DEFINIR ESTA OPÇÃO!!
        final aux = await survey.reference
            .collection('questions')
            .doc(survey.data()['order'][i])
            .get()
            .then((question) {
          getVisibilityRules(question);
          return getSurveyWidget(question, answers);
        });
        surveyQuestionList.value.add(aux);
      }
    }
    return surveyQuestionList.value;
  }

  Widget getSurveyWidget(
      DocumentSnapshot question, ValueNotifier<Map> answers) {
    // returns a Widget correspinding to 'question'
    return SurveyQuestion(
      question: question.data()['text'],
      type: question.data()['type'],
      options: question.data()['options'],
      answers: answers,
    );
  }

  void getVisibilityRules(DocumentSnapshot question) async {
    // visibilityRules: [{}, {question: value, question: value}, {}] is a list of maps, each corresponding
    // to the widget with the same index; 'question' is the text of the question that must have be 'value'
    // in the user's answers so that question[i] is visible
    Map<String, String> rules = {};
    if (question.data()['visible'] != null) {
      question.data()['visible'].forEach((key, ruleValue) async {
        await survey.reference
            .collection('questions')
            .doc(key)
            .get()
            .then((ruleQuestion) {
          rules[ruleQuestion['text']] = ruleValue;
        });
      });
    }
    visibilityRules.add(rules);
  }

  void updateSurveyWidgetList() async {
    // everytime the answers are changed, the visibility rules for each question/Widget are verified and
    // the Widget gets rebuilt if 1) the rules are not 'checked' or if 2) the the rules are 'checked' but
    // the Widget was "erased"
    for (var i = 0; i < visibilityRules.length; i++) {
      bool checked = true;
      visibilityRules[i].forEach((key, value) {
        if (answers.value[key] != value) checked = false;
      });
      DocumentSnapshot question = await survey.reference
          .collection('questions')
          .doc(survey.data()['order'][i])
          .get()
          .then((question) {
        return question;
      });
      if (checked && surveyQuestionList.value[i].widgetType == 'Container') {
        setState(() =>
            surveyQuestionList.value[i] = getSurveyWidget(question, answers));
      } else if (!checked) {
        setState(() => surveyQuestionList.value[i] = SurveyQuestion(
              widgetType: 'Container',
              question: question.data()['text'],
            ));
      }
    }
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
      body: ValueListenableBuilder(
          // listens to changes in the variable surveyQuestionList
          valueListenable: surveyQuestionList,
          builder: (BuildContext context, List questions, Widget child) {
            return SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: questions.length,
                  itemBuilder: (context, index) {
                    return questions[index];
                  },
                ),
                SizedBox(height: 20),
                ElevatedButton(
                  child: Text('Submit'),
                  onPressed: () {
                    for (var i = 0; i < surveyQuestionList.value.length; i++) {
                      // if not answered (e.g. not question not visible) the answer will be null
                      print('question: ${surveyQuestionList.value[i].question}');
                      print('answer: ${surveyQuestionList.value[i].answer}');
                      //TODO: FALTA ENVIAR AS RESPOSTAS PARA O FIRESTORE
                    }
                  },
                )
              ]),
            );
          }),
    );
  }
}
