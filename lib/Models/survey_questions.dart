import 'package:flutter/material.dart';

class SurveyQuestion extends StatefulWidget {
  final String question;
  final String widgetType;
  final String type;
  final List options;
  final ValueNotifier<Map> answers;
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
  List<bool> _radioSelections = List.filled(3, false);
  Map<String, bool> _checkboxSelections;
  final TextEditingController _textController = TextEditingController();

  @override
  void initState() {
    // initiates the variables according to the type of question
    print('type: ${widget.widgetType}');
    print(widget.type);
    if (widget.widgetType == 'Widget') {
      if (widget.type == 'radio') {
        setState(() => _radioSelections = List.filled(widget.options.length, false));
        print("radio selections: $_radioSelections");
      }
      else if (widget.type == 'checkbox') {
        setState(() =>
            _checkboxSelections = {for (var opt in widget.options) opt: false});
        print("checkbox selections: $_checkboxSelections");
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
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
                : widget.type == 'radio'
                    ? radioQuestion(_radioSelections, widget.question,
                        widget.options, widget.answers)
                : widget.type == 'checkbox'
                        ? checkboxQuestion(_checkboxSelections, widget.question,
                            widget.options, widget.answers)
                : widget.type == 'text'
                    ? textQuestion(_textController, widget.question,
                        widget.options, widget.answers)
                    // more types of questions can be added here in the same manner
                    : Container(child: Text(widget.type)));
  }

  Widget radioQuestion(List<bool> _selections, String question, List options,
      ValueNotifier<Map> answers) {
    List<Widget> _radioButtons = [];
    options.forEach((opt) {
      _radioButtons.add(Padding(
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
            children: _radioButtons,
            onPressed: (int index) {
              setState(() {
                for (int i = 0; i < _selections.length; i++) {
                  _selections[i] = i == index;
                }
              });
              setState(() => widget.answer =
                  options[_selections.indexWhere((value) => value)]);
              print('answer: ${widget.answer}');
              setState(() {
                answers.value[question] =
                    options[_selections.indexWhere((value) => value)];
                answers.notifyListeners();
              });
              print('answers: ${answers.value}');
            },
            isSelected: _selections,
          ),
        ],
      ),
    );
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
}
