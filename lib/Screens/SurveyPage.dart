import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Screens/QuestionsPage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class SurveyPage extends StatefulWidget {
  @override
  _SurveyPageState createState() => _SurveyPageState();
}

class _SurveyPageState extends State<SurveyPage> {
  List<Survey> surveys = [];
  bool _isLoading = true;

  void updateAllSurveys() {
    getAllSurveys().then((surveys) => {
          this.setState(() {
            this.surveys = surveys;
          })
        });
  }

  @override
  void initState() {
    updateAllSurveys();
    _isLoading = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: appBarTitle(context, 'Survey'),
        backgroundColor: Color.fromRGBO(71, 123, 117, 1),
      ),
      body: _isLoading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : ListView.builder(
              itemCount: surveys.length,
              itemBuilder: (BuildContext ctxt, int index) {
                return Container(
                    margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    padding: EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: Color.fromRGBO(252, 164, 83, 1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    height: 50,
                    width: MediaQuery.of(context).size.width - 48,
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Row(
                          children: [
                            Text(surveys[index].name,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                        SizedBox(width: 70),
                        ClipOval(
                          child: Material(
                            color: Colors.white,
                            child: InkWell(
                              splashColor: Colors.teal[50],
                              child: SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: Icon(Icons.arrow_forward_ios,
                                      color: Colors.teal)),
                              onTap: () {
                                pushNewScreen(
                                  context,
                                  screen: QuestionsPage(
                                    questionList: surveys[index].questionList,
                                    surveyId: surveys[index].getId(),
                                    route: 'SurveyPage',
                                  ),
                                  withNavBar: true,
                                  pageTransitionAnimation:
                                      PageTransitionAnimation.cupertino,
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ));
              }),
    );
  }
}
