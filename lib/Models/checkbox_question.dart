import 'package:flutter/material.dart';

class CheckboxQuestion extends StatefulWidget {
  
  CheckboxQuestion({
    this.selections,
    this.question,
    this.options,
    this.answers,
    this.onChanged,
  });
  
  final Map<String, bool> selections;
  final String question;
  final List options;
  final ValueNotifier<Map> answers;
  final Function onChanged;

  @override
  _CheckboxQuestionState createState() => _CheckboxQuestionState();
}

class _CheckboxQuestionState extends State<CheckboxQuestion> {
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
          Column(
            children: widget.selections.keys.map((String key) {
              return new CheckboxListTile(
                title: new Text(key),
                value: widget.selections[key],
                onChanged: (bool value) {
                  setState(() {
                    widget.selections[key] = value;
                  });
                  widget.onChanged(value);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
