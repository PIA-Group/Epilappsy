import 'package:flutter/material.dart';

class RadioQuestion extends StatelessWidget {
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

 /*  @override
  _RadioQuestionState createState() => _RadioQuestionState();
}

class _RadioQuestionState extends State<RadioQuestion> { */
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 20,
      child: Column(
        children: [
          Text(
            question,
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
    listRadio = List<RadioListTile<String>>.from(options.map((option) {
      return RadioListTile<String>(
        title: Text(option),
        value: option,
        groupValue: radioValue,
        onChanged: (value) => onChangedRadio(value),
      );
    }).toList());
    listRadio.add(RadioListTile<String>(
        title: Row(children: [
          Text('Other:'),
          Expanded(
              child: Padding(
            padding: EdgeInsets.only(left: 10),
            child: TextField(
              focusNode: otherFocusNode,
              onChanged: (text) => onChangedOtherText(text),
              controller: controller,
            ),
          ))
        ]),
        value: 'Other',
        groupValue: radioValue,
        onChanged: (value) => onChangedOtherRadio(value)));
    return listRadio;
  }
}
