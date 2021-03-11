import 'package:flutter/material.dart';

class RadioQuestion extends StatefulWidget {
  RadioQuestion({
    this.question,
    this.options,
    this.answers,
    this.controller,
    this.radioValue,
    this.otherFocusNode,
    this.onChangedRadio,
    this.onChangedOtherText,
    this.onChangedOtherRadio,
  });

  final String question;
  final List options;
  final ValueNotifier<Map> answers;
  final TextEditingController controller;
  final String radioValue;
  final FocusNode otherFocusNode;
  final Function onChangedRadio;
  final Function onChangedOtherText;
  final Function onChangedOtherRadio;

  @override
  _RadioQuestionState createState() => _RadioQuestionState();
}

class _RadioQuestionState extends State<RadioQuestion> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            widget.question,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Column(children: _getRadioOptions()),
        ],
      ),
    );
  }

  List<RadioListTile<String>> _getRadioOptions() {
    List<RadioListTile<String>> listRadio;
    listRadio = List<RadioListTile<String>>.from(widget.options.map((option) {
      return RadioListTile<String>(
        title: Text(option),
        value: option,
        groupValue: widget.radioValue,
        onChanged: (value) => widget.onChangedRadio(value),
      );
    }).toList());
    listRadio.add(RadioListTile<String>(
        title: Row(children: [
          Text('Other:'),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              focusNode: widget.otherFocusNode,
              onChanged: (text) => widget.onChangedOtherText(text),
              controller: widget.controller,
            ),
          ))
        ]),
        value: 'Other',
        groupValue: widget.radioValue,
        onChanged: (value) => widget.onChangedOtherRadio(value)));
    return listRadio;
  }
}
