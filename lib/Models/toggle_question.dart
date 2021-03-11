import 'package:flutter/material.dart';

class ToggleQuestion extends StatelessWidget {
  
  ToggleQuestion({
    this.selections,
    this.question,
    this.options,
    this.answers,
    this.onPressed,
  });

  final List<bool> selections;
  final String question;
  final List options;
  final ValueNotifier<Map> answers;
  final Function onPressed;

  /* @override
  _ToggleQuestionState createState() => _ToggleQuestionState();
}

class _ToggleQuestionState extends State<ToggleQuestion> { */
  @override
  Widget build(BuildContext context) {
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
            onPressed: (int index) => onPressed(index), 
            isSelected: selections,
          ),
        ],
      ),
    );
  }
}