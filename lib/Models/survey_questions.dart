import 'package:flutter/material.dart';

class SurveyQuestion extends StatefulWidget {
  String question;
  String type;
  List options;
  int questionIndex;
  ValueNotifier<Map> answers;

  SurveyQuestion({
    this.question,
    this.type,
    this.options,
    this.questionIndex,
    this.answers,
  });

  @override
  _SurveyQuestionState createState() => _SurveyQuestionState();
}

class _SurveyQuestionState extends State<SurveyQuestion> {
  List<bool> _toggleSelections;
  Map<String, bool> _checkboxSelections = {};

  @override
  void initState() {
    if (widget.type == 'toggle')
      setState(() => _toggleSelections = [true, false]);
    if (widget.type == 'checkbox')
      setState(() =>
          _checkboxSelections = {for (var opt in widget.options) opt: false});
    print("checkbox selections: $_checkboxSelections");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(top: 20),
        child: widget.type == 'toggle'
            ? Container(
                width: MediaQuery.of(context).size.width - 20,
                child: Column(
                  children: [
                    Text(
                      widget.question,
                      style: TextStyle(fontSize: 16),
                    ),
                    SizedBox(height: 10),
                    ToggleButtons(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.options[0],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            widget.options[1],
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int i = 0; i < _toggleSelections.length; i++) {
                            _toggleSelections[i] = i == index;
                          }
                        });
                        setState(() {
                          widget.answers.value[widget.question] = widget
                                  .options[
                              _toggleSelections.indexWhere((value) => value)];
                        });
                        print('answers: ${widget.answers.value}');
                      },
                      isSelected: _toggleSelections,
                    ),
                  ],
                ),
              )
            : widget.type == 'checkbox'
                ? Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Column(
                      children: [
                        Text(
                          widget.question,
                          style: TextStyle(fontSize: 16),
                        ),
                        SizedBox(height: 10),
                        Column(
                          children: _checkboxSelections.keys.map((String key) {
                            return new CheckboxListTile(
                              title: new Text(key),
                              value: _checkboxSelections[key],
                              onChanged: (bool value) {
                                setState(() {
                                  _checkboxSelections[key] = value;
                                });
                                setState(() {
                                  widget.answers.value[widget.question] =
                                      _checkboxSelections.keys
                                          .where((element) => _checkboxSelections[element]);
                                });
                                print('answers: ${widget.answers.value}');
                              },
                            );
                          }).toList(),
                        ),
                      ],
                    ),
                  )
                : Container(child: Text(widget.type)));
  }
}
