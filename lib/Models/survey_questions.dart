import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
  String _radioValue = 'Tonic';
  Map<String, bool> _checkboxSelections;
  final TextEditingController _otherController = TextEditingController();
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();
  FocusNode _otherFocusNode;

  @override
  void initState() {
    super.initState();
    _otherFocusNode = FocusNode();
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
        setState(() => _radioValue = widget.options[0]);
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
    _otherFocusNode.dispose();
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
                                        widget.answers)
                                    // more types of questions can be added here in the same manner
                                    : Container(child: Text(widget.type)));
  }

  Widget toggleQuestion(List<bool> _selections, String question, List options,
      ValueNotifier<Map> answers) {
    List<Widget> _toggleButtons = [];
    options.forEach((opt) {
      _toggleButtons.add(Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          opt,
          style: TextStyle(fontSize: 16),
        ),
      ));
    });
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          ToggleButtons(
            children: _toggleButtons,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selections.length; i++) {
                  _selections[i] = i == index;
                }
              });
              _setToggleAnswer(_selections, question, options, answers);
            },
            isSelected: _selections,
          ),
        ],
      ),
    );
  }

  Widget radioQuestion(String question, List options,
      ValueNotifier<Map> answers, TextEditingController controller) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Column(
              children:
                  _getRadioOptions(options, question, answers, controller)),
        ],
      ),
    );
  }

  List<RadioListTile<String>> _getRadioOptions(
      options, question, answers, controller) {
    List<RadioListTile<String>> listRadio;
    listRadio = List<RadioListTile<String>>.from(options.map((option) {
      return RadioListTile<String>(
        title: Text(option),
        value: option,
        groupValue: _radioValue,
        onChanged: (value) {
          setState(() {
            _radioValue = value;
            _setRadioAnswer(question, answers, false, null);
          });
        },
      );
    }).toList());
    listRadio.add(RadioListTile<String>(
      title: Row(children: [
        Text('Other:'),
        Expanded(
            child: Padding(
          padding: EdgeInsets.only(left: 10),
          child: TextField(
            focusNode: _otherFocusNode,
            onChanged: (text) {
              setState(() => widget.answer = text);
              setState(() {
                answers.value[question] = text;
                answers.notifyListeners();
                print('answers: ${answers.value}');
              });
            },
            controller: controller,
          ),
        ))
      ]),
      value: 'Other',
      groupValue: _radioValue,
      onChanged: (value) {
        setState(() {
          _radioValue = value;
          _otherFocusNode.requestFocus();
          _setRadioAnswer(question, answers, true, controller);
        });
      },
    ));
    return listRadio;
  }

  Widget checkboxQuestion(Map<String, bool> _selections, String question,
      List options, ValueNotifier<Map> answers) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Column(
            children: _selections.keys.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: _selections[key],
                onChanged: (bool value) {
                  setState(() {
                    _selections[key] = value;
                  });
                  setState(() => widget.answer = _selections.keys
                      .where((element) => _selections[element])
                      .toString());
                  print('answer: ${widget.answer}');
                  setState(() {
                    answers.value[question] = _selections.keys
                        .where((element) => _selections[element]);
                    answers.notifyListeners();
                  });
                  print('answers: ${answers.value}');
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget textQuestion(TextEditingController controller, String question,
      List options, ValueNotifier<Map> answers) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Card(
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(8.0),
                  child: TextField(
                    controller: controller,
                    maxLines: 8,
                    decoration: InputDecoration.collapsed(
                        hintText: "Enter your text here"),
                    onChanged: (text) {
                      setState(() => widget.answer = controller.text);
                      print('answer: ${widget.answer}');
                    },
                    // open text answers are not added to the variable 'answers' as they are not used
                    // to validate visibility rules
                  ),
                )),
          ),
        ],
      ),
    );
  }

  Widget numberQuestion(TextEditingController controller, String question,
      List options, ValueNotifier<Map> answers) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            question,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Center(
                child: numberPicker(answers, question, controller, 1, 50)),
          ),
        ],
      ),
    );
  }

  Widget numberPicker(ValueNotifier<Map> answers, String question,
      TextEditingController controller, int _minValue, int _maxValue) {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300])),
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.remove, size: 30),
            onPressed: () {
              if (int.parse(controller.text) > _minValue) {
                setState(() => controller.text =
                    (int.parse(controller.text) - 1).toString());
                _setNumberAnswer(controller.text, answers, question);
              }
            },
          ),
          Expanded(
              child: Container(
            width: _textSize(TextStyle(fontSize: 20), _maxValue).width,
            child: TextField(
                textAlign: TextAlign.center,
                controller: controller,
                style: TextStyle(fontSize: 20),
                keyboardType: TextInputType.number,
                decoration: InputDecoration(border: InputBorder.none),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                onChanged: (text) => _setNumberAnswer(text, answers, question)),
          )),
          IconButton(
            icon: Icon(Icons.add, size: 30),
            onPressed: () {
              if (int.parse(controller.text) < _maxValue) {
                setState(() => controller.text =
                    (int.parse(controller.text) + 1).toString());
                _setNumberAnswer(controller.text, answers, question);
              }
            },
          ),
        ],
      ),
    );
  }

  Size _textSize(TextStyle style, int _maxValue) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: _maxValue.toString(), style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(
          minWidth: 0, maxWidth: _maxValue.toString().length * style.fontSize);
    return textPainter.size;
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

  void _setRadioAnswer(String question, ValueNotifier<Map> answers, bool other,
      TextEditingController controller) {
    if (!other) {
      setState(() => widget.answer = _radioValue);
      setState(() {
        answers.value[question] = _radioValue;
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
