import 'package:flutter/material.dart';
import 'package:epilappsy/Models/checkbox_question.dart';
import 'package:epilappsy/Models/text_question.dart';
import 'package:epilappsy/Models/number_question.dart';
import 'package:epilappsy/Models/toggle_question.dart';
import 'package:epilappsy/Models/radio_question.dart';

class SurveyQuestion extends StatefulWidget {
  String question;
  String widgetType;
  String type;
  List options;
  ValueNotifier<Map> answers;
  String answer;

  SurveyQuestion({
    this.question,
    this.type,
    this.options,
    this.answers,
    this.widgetType = 'Widget',
  });

  @override
  _SurveyQuestionState createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  List<bool> _toggleSelections;
  String radioValue;
  Map<String, bool> _checkboxSelections;
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  FocusNode otherFocusNode;

  @override
  void initState() {
    super.initState();
    otherFocusNode = FocusNode();
    // initiates the variables according to the type of question
    if (widget.widgetType == 'Widget') {
      if (widget.type == 'toggle') {
        setState(() {
          _toggleSelections = List.filled(widget.options.length, false);
          _toggleSelections[0] = true;
        });
        print("toggle selections: $_toggleSelections");
        _setToggleAnswer(
            _toggleSelections,
            widget.question,
            widget.options,
            widget
                .answers); //initiate answer with default value in case the user doesn't change it
      } else if (widget.type == 'radio') {
        setState(() => radioValue = widget.options[0]);
        setState(() =>
            _setRadioAnswer(widget.question, widget.answers, false, null));
      } else if (widget.type == 'checkbox') {
        setState(() =>
            _checkboxSelections = {for (var opt in widget.options) opt: false});
        print("checkbox selections: $_checkboxSelections");
      } else if (widget.type == 'number') {
        setState(() => _numberController.text = '2');
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _numberController.dispose();
    otherFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: widget.widgetType == 'Container'
            ? Container()
            : widget.widgetType == 'Processing'
                ? Padding(
                    padding: EdgeInsets.only(top: 20.0),
                    child: Center(child: CircularProgressIndicator()))
                : widget.type == 'toggle'
                    ? toggleQuestion(_toggleSelections, widget.question,
                        widget.options, widget.answers)
                    : widget.type == 'radio'
                        ? radioQuestion(widget.question, widget.options,
                            widget.answers, _otherController)
                        : widget.type == 'checkbox'
                            ? checkboxQuestion(_checkboxSelections,
                                widget.question, widget.options, widget.answers)
                            : widget.type == 'text'
                                ? textQuestion(_textController, widget.question,
                                    widget.options, widget.answers)
                                : widget.type == 'number'
                                    ? numberQuestion(
                                        _numberController,
                                        widget.question,
                                        widget.options,
                                        widget.answers,
                                        1,
                                        50)
                                    // more types of questions can be added here in the same manner
                                    : Container(child: Text(widget.type)));
  }

  Widget toggleQuestion(List<bool> selections, String question, List options,
      ValueNotifier<Map> answers) {
    return ToggleQuestion(
      selections: selections,
      question: question,
      options: options,
      answers: answers,
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < selections.length; i++) {
            selections[i] = i == index;
          }
        });
        _setToggleAnswer(selections, question, options, answers);
      },
    );
  }

  void _setToggleAnswer(List<bool> _selections, String question, List options,
      ValueNotifier<Map> answers) {
    setState(() =>
        widget.answer = options[_selections.indexWhere((value) => value)]);
    print('answer: ${widget.answer}');
    setState(() {
      answers.value[question] =
          options[_selections.indexWhere((value) => value)];
      answers.notifyListeners();
    });
    print('answers: ${answers.value}');
  }

  Widget radioQuestion(String question, List options,
      ValueNotifier<Map> answers, TextEditingController controller) {
    return RadioQuestion(
      question: question,
      options: options,
      answers: answers,
      controller: controller,
      radioValue: radioValue,
      otherFocusNode: otherFocusNode,
      onChangedRadio: (value) {
        setState(() {
          radioValue = value;
          _setRadioAnswer(question, answers, false, null);
        });
      },
      onChangedOtherText: (text) {
        setState(() => widget.answer = text);
        setState(() {
          answers.value[question] = text;
          answers.notifyListeners();
          print('answers: ${answers.value}');
        });
      },
      onChangedOtherRadio: (value) {
        setState(() {
          radioValue = value;
          otherFocusNode.requestFocus();
          _setRadioAnswer(question, answers, true, controller);
        });
      },
    );
  }

  void _setRadioAnswer(String question, ValueNotifier<Map> answers, bool other,
      TextEditingController controller) {
    if (!other) {
      setState(() => widget.answer = radioValue);
      setState(() {
        answers.value[question] = radioValue;
        answers.notifyListeners();
      });
    } else {
      setState(() => widget.answer = controller.text);
      setState(() {
        answers.value[question] = controller.text;
        answers.notifyListeners();
      });
    }
    print('answer: ${widget.answer}');
    print('answers: ${answers.value}');
  }

  Widget checkboxQuestion(Map<String, bool> selections, String question,
      List options, ValueNotifier<Map> answers) {
    return CheckboxQuestion(
      selections: selections,
      question: question,
      options: options,
      answers: answers,
      onChanged: (bool value) {
        setState(() => widget.answer =
            selections.keys.where((element) => selections[element]).toString());
        print('answer: ${widget.answer}');
        setState(() {
          answers.value[question] =
              selections.keys.where((element) => selections[element]);
          answers.notifyListeners();
        });
        print('answers: ${answers.value}');
      },
    );
  }

  Widget textQuestion(TextEditingController controller, String question,
      List options, ValueNotifier<Map> answers) {
    return TextQuestion(
      controller: controller,
      question: question,
      options: options,
      answers: answers,
      onChanged: (text) {
        setState(() => widget.answer = controller.text);
        print('answer: ${widget.answer}');
      },
    );
  }

  Widget numberQuestion(TextEditingController controller, String question,
      List options, ValueNotifier<Map> answers, int minValue, int maxValue) {
    return NumberQuestion(
      controller: controller,
      question: question,
      options: options,
      answers: answers,
      onPressedRemove: () {
        if (int.parse(controller.text) > minValue) {
          setState(() =>
              controller.text = (int.parse(controller.text) - 1).toString());
          _setNumberAnswer(controller.text, answers, question);
        }
      },
      onPressedAdd: () {
        if (int.parse(controller.text) < maxValue) {
          setState(() =>
              controller.text = (int.parse(controller.text) + 1).toString());
          _setNumberAnswer(controller.text, answers, question);
        }
      },
      minValue: minValue,
      maxValue: maxValue,
    );
  }

  void _setNumberAnswer(
    String text,
    ValueNotifier<Map> answers,
    String question,
  ) {
    setState(() => widget.answer = text);
    setState(() {
      answers.value[question] = int.parse(text);
      answers.notifyListeners();
      print('answers: ${answers.value}');
    });
  }
}
