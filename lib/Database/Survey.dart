
class Survey {
  String name;
  List questionList;
  String _id;

  Survey() {
    this.questionList = [];
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

Survey createSurvey(questions) {
  /* Map<String, dynamic> attributes = {
    //'name': '',
    'questionList': [],
  }; */
  //questions.forEach((key, value) => {attributes[key] = value}); 

  Survey survey = new Survey();
  //survey.setName(attributes['name']);
  survey.setQuestions(questions);
  return survey;
}

class Answers {
  List<int> values;
  String _surveyId;

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

  Map<String, dynamic> toJson() {
    return {
      'Values': this.values,
    };
  }

  Answers.fromJson(Map<String, dynamic> json) {
    this.values = json['Values'];
  }
}
