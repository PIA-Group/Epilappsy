import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/Models/survey_questions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class SurveyPage extends StatefulWidget {
  SurveyPage({this.duration});

  final String duration;

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
  ValueNotifier<List<SurveyQuestion>> surveyQuestionList =
      ValueNotifier([SurveyQuestion(widgetType: 'Processing')]);
  DocumentSnapshot survey;
  DocumentSnapshot patientProfile;
  List<Map> visibilityRules = [];

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
    await initSurveyWidgetList(answers).then((value) {
      removeLoading();
      setState(() => surveyQuestionList.value = value);
    });
  }

  void removeLoading() {
    setState(() => surveyQuestionList.value[0] = SurveyQuestion(
          widgetType: 'Container',
        ));
  }

  Future<List<Widget>> initSurveyWidgetList(ValueNotifier<Map> answers) async {
    // initiate list of widgets [Widget, Widget, ...] according to the info on firestore
    patientProfile = await firestore
        .collection('patients')
        .doc(uid)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      print("patient profile: $documentSnapshot");
      return documentSnapshot;
    });

    String surveyID = patientProfile.data()['default survey'];
    print("default survey ID: $surveyID");

    String doctorID = patientProfile.data()['doctor'];
    print("doctor ID: $doctorID");

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
    // returns a Widget corresponding to 'question'

    if (question.data()['options'] is String) {
      List options = patientProfile.data()[question.data()['options']];
      return SurveyQuestion(
        question: question.data()['text'],
        type: question.data()['type'],
        options: options,
        answers: answers,
      );
    } else if (question.data()['text'] == 'Duração' &&
        widget.duration != null) {
      List options = [widget.duration];
      return SurveyQuestion(
        question: question.data()['text'],
        type: question.data()['type'],
        options: options,
        answers: answers,
      );
    } else {
      return SurveyQuestion(
        question: question.data()['text'],
        type: question.data()['type'],
        options: question.data()['options'],
        answers: answers,
        widgetType: 'Widget',
      );
    }
  }

  void getVisibilityRules(DocumentSnapshot question) async {
    // visibilityRules: [{}, {question: value, question: value}, {}] is a list of maps, each corresponding
    // to the widget with the same index; 'question' is the text of the question that must have be 'value'
    // in the user's answers so that question[i] is visible
    Map rules = {};
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

    // NOTE: in relation to surveyQuestionList the indexes are i+1 because the first widget is the loading icon (then transformed to a Container)

    for (var i = 0; i < visibilityRules.length; i++) {
      bool checked = true;
      visibilityRules[i].forEach((key, value) {
        //TODO: in case visibility rule is a List ??
        if (answers.value[key] != value) checked = false;
      });
      DocumentSnapshot question = await survey.reference
          .collection('questions')
          .doc(survey.data()['order'][i])
          .get()
          .then((question) {
        return question;
      });
      if (checked &&
          surveyQuestionList.value[i + 1].widgetType == 'Container') {
        setState(() => surveyQuestionList.value[i + 1] =
            getSurveyWidget(question, answers));
      } else if (!checked) {
        setState(() => surveyQuestionList.value[i + 1] = SurveyQuestion(
              widgetType: 'Container',
              question: question.data()['text'],
            ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          currentFocus.unfocus();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
        body: ValueListenableBuilder(
            // listens to changes in the variable surveyQuestionList
            valueListenable: surveyQuestionList,
            builder: (BuildContext context, List questions, Widget child) {
              return SingleChildScrollView(
                physics: ScrollPhysics(),
                child:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
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
                      for (var i = 1; i < questions.length; i++) {
                        // NOTE: starts on 1 because the first widget is the loading icon (then transformed to a Container)
                        // if not answered (or not question not visible) the answer will be null
                        print('question: ${questions[i].question}');
                        print('answer: ${questions[i].answer}');
                        //TODO: FALTA ENVIAR AS RESPOSTAS PARA O FIRESTORE
                      }
                    },
                  )
                ]),
              );
            }),
      ),
    );
  }
}
