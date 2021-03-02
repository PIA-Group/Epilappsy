import 'package:firebase_database/firebase_database.dart';
import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Pages/HomePage.dart';
import 'package:epilappsy/Pages/SeizureLog.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:transformer_page_view/transformer_page_view.dart';
import 'package:flutter_circular_slider/flutter_circular_slider.dart';


//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';


class QuestionsPage extends StatefulWidget {
  final String duration;
  final String route;
  final String surveyId;
  final List<String> questionList;
  const QuestionsPage(
      {this.questionList, this.surveyId, this.route, this.duration});

  @override
  _QuestionsPageState createState() => _QuestionsPageState();
}

class _QuestionsPageState extends State<QuestionsPage> {
  final IndexController _pageController = IndexController();
  final List<int> _answerList = [];
  final Answers _answers = Answers();
  int initAnswer = 0;

  void _updateLabel(int init, int newAnswer, int laps) {
    setState(() {
      initAnswer = newAnswer;
    });
  }

  Color getColor() {
    if (initAnswer > 80) {
      return Colors.red;
    } else if (initAnswer > 60) {
      return Colors.orange;
    } else if (initAnswer > 40) {
      return Colors.yellow;
    } else if (initAnswer > 20) {
      return Colors.lightGreen;
    } else {
      return Colors.green[800];
    }
  }

  Widget getButton(int index, int length) {
    if (index < (length - 1)) {
      return FlatButton(
        color: Color.fromRGBO(71, 123, 117, 1),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(AppLocalizations.of(context).translate('Next')),
        onPressed: () {
          _answerList.add(initAnswer);
          initAnswer = 0;
          _pageController.move(index + 1);
        },
      );
    } else {
      return FlatButton(
        color: Color.fromRGBO(71, 123, 117, 1),
        textColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50.0),
        ),
        child: Text(AppLocalizations.of(context).translate('Finish')),
        onPressed: () async {
          _answerList.add(initAnswer);
          _answers.setAnswers(_answerList);
          //_answers.setSurveyId(widget.surveyId);
          String surveyID = await saveAnswers(_answers);
          _answers.setSurveyId(surveyID);
          if (widget.route == 'SurveyPage') {
            //_answers.setId(saveAnswers(_answers));
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => HomePage()),
            );
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SeizureLog(
                        answers: _answers,
                        duration: widget.duration,
                      )),
            );
            ;
          }
        },
      );
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
        body: TransformerPageView(
          physics: NeverScrollableScrollPhysics(),
          controller: _pageController,
          itemCount: widget.questionList.length,
          itemBuilder: (BuildContext ctxt, int index) {
            return Center(
                child: new Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                  Text(
                    widget.questionList[index],
                    style: TextStyle(
                        fontSize: 30.0, color: Color.fromRGBO(71, 123, 117, 1)),
                  ),
                  SingleCircularSlider(100, initAnswer,
                      height: 220.0,
                      width: 220.0,
                      primarySectors: 6,
                      baseColor: getColor(),
                      handlerColor: Colors.grey[350],
                      handlerOutterRadius: 12.0,
                      onSelectionChange: _updateLabel,
                      showRoundedCapInSelection: true,
                      showHandlerOutter: true,
                      child: Padding(
                          padding: const EdgeInsets.all(42.0),
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 10),
                                Text('$initAnswer',
                                    style: TextStyle(
                                        fontSize: 40.0, color: Colors.black))
                              ]))),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        getButton(index, widget.questionList.length),
                      ],
                    ),
                  ),
                ]));
          },
        ));
  }
}
