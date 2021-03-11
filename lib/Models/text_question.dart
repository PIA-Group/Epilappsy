import 'package:flutter/material.dart';

class TextQuestion extends StatelessWidget {

  TextQuestion({
    this.controller,
    this.question,
    this.options,
    this.answers,
    this.onChanged,
  });

  final TextEditingController controller;
  final String question;
  final List options;
  final ValueNotifier<Map> answers;
  final Function onChanged;

  /* @override
  _TextQuestionState createState() => _TextQuestionState();
}

class _TextQuestionState extends State<TextQuestion> { */
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
                        hintText: question),
                    onChanged: (text) {
                      onChanged(text);
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