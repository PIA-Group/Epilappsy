import 'package:firebase_database/firebase_database.dart';

class Survey {
  String name;
  List questionList;
  String _id;

  Survey() {
    this.questionList = List<String>();
  }

  void setName(String name) {
    this.name = name;
  }

  void setQuestions(List<String> list) {
    this.questionList = list;
  }

  void addQuestion(String question) {
    this.questionList.add(question);
  }

  void setId(String id) {
    this._id = id;
  }

  String getId() {
    return this._id;
  }

  Survey.fromJson(Map<String, dynamic> json) {
    this.name = json['name'];
    this.questionList = json['questionList'];
  }

  Map<String, dynamic> toJson() {
    return {
      'name': this.name,
      'questionList': this.questionList,
    };
  }
}

Survey createSurvey(record) {
  Map<String, dynamic> attributes = {
    'name': '',
    'questionList': [],
  };
  record.forEach((key, value) => {attributes[key] = value});

  Survey survey = new Survey();
  survey.setName(attributes['name']);
  survey.setQuestions(attributes['questionList'].cast<String>());
  return survey;
}

class Answers {
  List<int> values;
  String _surveyId;
  DatabaseReference _id;

  Answers();

  void setAnswers(List<int> answers) {
    this.values = answers;
  }

  void setSurveyId(String id) {
    this._surveyId = id;
  }

  String getSurveyId() {
    return this._surveyId;
  }

  void setId(DatabaseReference id) {
    this._id = id;
  }

  Map<String, dynamic> toJson() {
    return {
      'Values': this.values,
    };
  }

  Answers.fromJson(Map<String, dynamic> json) {
    this.values = json['Values'];
  }
}
