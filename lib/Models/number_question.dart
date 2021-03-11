import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberQuestion extends StatefulWidget {
  NumberQuestion({
    this.controller,
    this.question,
    this.options,
    this.answers,
    this.onPressedRemove,
    this.onPressedAdd,
    this.onChanged,
    this.minValue,
    this.maxValue,
  });

  final TextEditingController controller;
  final String question;
  final List options;
  final ValueNotifier<Map> answers;
  final Function onPressedRemove;
  final Function onPressedAdd;
  final Function onChanged;
  final int minValue;
  final int maxValue;

  @override
  _NumberQuestionState createState() => _NumberQuestionState();
}

class _NumberQuestionState extends State<NumberQuestion> {
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
          Padding(
            padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
            child: Center(child: numberPicker()),
          ),
        ],
      ),
    );
  }

  Widget numberPicker() {
    return Container(
      padding: EdgeInsets.only(left: 5, right: 5),
      decoration: BoxDecoration(border: Border.all(color: Colors.grey[300])),
      width: 200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
              icon: Icon(Icons.remove, size: 30),
              onPressed: () => widget.onPressedRemove()),
          Expanded(
            child: Container(
              width: _textSize(TextStyle(fontSize: 20)).width,
              child: TextField(
                  textAlign: TextAlign.center,
                  controller: widget.controller,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(border: InputBorder.none),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  onChanged: (text) => widget.onChanged()),
            ),
          ),
          IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () => widget.onPressedAdd()),
        ],
      ),
    );
  }

  Size _textSize(style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: widget.maxValue.toString(), style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(
          minWidth: 0, maxWidth: widget.maxValue.toString().length * style.fontSize);
    return textPainter.size;
  }
}
