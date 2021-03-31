

import 'package:epilappsy/Pages/AddSeizure/circle_list.dart';
import 'package:epilappsy/Pages/AddSeizure/questions.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:flutter/material.dart';


class AddSeizurePage extends StatefulWidget {
  @override
  _AddSeizurePageState createState() => _AddSeizurePageState();
}

class _AddSeizurePageState extends State<AddSeizurePage> {
  PageController _pageController = PageController();
  int intCurrentPageValue = 0;
  var currentPageValue = 0.0;

  List<Widget> listPages = [
    QuestionsPage1(),
    QuestionsPage2(),
    QuestionsPage3()
  ];

  ValueNotifier<List<Widget>> circleList = ValueNotifier([]);

  void _updateCircleList(int intCurrentPageValue) {
    List<Widget> auxList = [];
    for (var i = 0; i < 3; i++) {
      auxList.add(QuestionnaireCircle(
          color: i == intCurrentPageValue ? DefaultColors.accentColor : DefaultColors.backgroundColor));
      if (i != circleList.value.length - 1) auxList.add(SizedBox(width: 5));
    }
    setState(() => circleList.value = auxList);
  }

  @override
  void initState() {
    for (var i = 0; i < listPages.length; i++) {
      // initiate the circles on the appBar according to the number of pages
      circleList.value.add(
          QuestionnaireCircle(color: i == 0 ? DefaultColors.accentColor : DefaultColors.backgroundColor));
      if (i != listPages.length - 1) circleList.value.add(SizedBox(width: 5));
    }

    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page;
        intCurrentPageValue = currentPageValue.round();
      });
      _updateCircleList(intCurrentPageValue);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAddSeizure(
        title: 'New Seizure',
        circleList: circleList,
      ),
      body: PageView.builder(
        controller: _pageController,
        itemBuilder: (context, position) {
          return listPages[position];
        },
        itemCount: listPages.length,
      ),
    );
  }
}
