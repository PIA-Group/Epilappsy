import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class TimeQuestion extends StatelessWidget {
  TimeQuestion({
    this.controller,
    this.question,
    this.options,
    this.answers,
    this.onPressedRemove,
    this.onPressedAdd,
    this.focusNode,
  });

  final TextEditingController controller;
  final String question;
  final List options;
  final ValueNotifier<Map> answers;
  final Function onPressedRemove;
  final Function onPressedAdd;
  final FocusNode focusNode;

  /* @override
  _NumberQuestionState createState() => _NumberQuestionState();
}

class _NumberQuestionState extends State<NumberQuestion> { */
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
              onPressed: () => onPressedRemove()),
          Expanded(
            child: Container(
              width: _textSize(TextStyle(fontSize: 20)).width,
              child: TextField( 
                focusNode: focusNode,
                  textAlign: TextAlign.center,
                  controller: controller,
                  style: TextStyle(fontSize: 20),
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(border: InputBorder.none),
                  inputFormatters: <TextInputFormatter>[
                    //FilteringTextInputFormatter.digitsOnly,
                    MaskTextInputFormatter(mask: '##:##:##', initialText: '00:00:00'),
                  ],
                  ),
            ),
          ),
          IconButton(
              icon: Icon(Icons.add, size: 30),
              onPressed: () => onPressedAdd()),
        ],
      ),
    );
  }

  Size _textSize(style) {
    final TextPainter textPainter = TextPainter(
        text: TextSpan(text: '##:##:##', style: style),
        maxLines: 1,
        textDirection: TextDirection.ltr)
      ..layout(
          minWidth: '##:##:##'.length * style.fontSize, maxWidth: '##:##:##'.length * style.fontSize);
    return textPainter.size;
  }
}

