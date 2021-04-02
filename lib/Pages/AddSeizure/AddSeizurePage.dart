import 'package:epilappsy/Pages/AddSeizure/QuestionsPage1.dart';
import 'package:epilappsy/Pages/AddSeizure/QuestionsPage2.dart';
import 'package:epilappsy/Pages/AddSeizure/QuestionsPage4.dart';
import 'package:epilappsy/Pages/AddSeizure/circle_list.dart';
import 'package:epilappsy/Pages/AddSeizure/QuestionsPage3.dart';
import 'package:epilappsy/Pages/AddSeizure/symptom_slider.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:flutter/material.dart';

class AddSeizurePage extends StatefulWidget {
  ValueNotifier<String> duration;
  AddSeizurePage({this.duration});

  @override
  _AddSeizurePageState createState() => _AddSeizurePageState();
}

class _AddSeizurePageState extends State<AddSeizurePage> {
  // QuestionsPage1
  ValueNotifier<List<DateTime>> datePicker = ValueNotifier([]);
  ValueNotifier<int> timeOfSeizureIndex = ValueNotifier(0);
  ValueNotifier<List<String>> triggerChoices = ValueNotifier([]);
  ValueNotifier<List<String>> triggerOptions =
      ValueNotifier(['Stress', 'Lack of sleep', 'Missed medication', 'Light']);
  ValueNotifier<String> seizureType = ValueNotifier('');
  ValueNotifier<String> seizureItem = ValueNotifier('');
  //ValueNotifier<int> timeOfSeizureIndex = ValueNotifier(0);
  List<String> seizureTypes = <String>[
    'Clonic',
    'Myoclonic',
    'Tonic-clonic',
    'Absence',
  ];
  List<String> seizureTypesItems = [''];

  // QuestionsPage2
  ValueNotifier<List<SymptomSlider>> preSymptomSliders = ValueNotifier([
    SymptomSlider(
      label: '',
      sliderIndex: 0,
      onChanged: (value) {},
      sliderValues: ValueNotifier([0, 0, 0]),
    ),
    SymptomSlider(
      label: '',
      sliderIndex: 0,
      onChanged: (value) {},
      sliderValues: ValueNotifier([0, 0, 0]),
    ),
    SymptomSlider(
      label: '',
      sliderIndex: 0,
      onChanged: (value) {},
      sliderValues: ValueNotifier([0, 0, 0]),
    )
  ]);
  List<String> preSymptomLabels = ['Anxiety', 'Numbness', 'Feeling hot'];
  List<String> duringSymptomLabels = ['Anxiety', 'Numbness', 'Feeling hot'];
  List<String> postSymptomLabels = ['Anxiety', 'Numbness', 'Feeling hot'];
  ValueNotifier<List<double>> preSymptomValues =
      ValueNotifier(List.generate(3, (index) => 0));
  ValueNotifier<List<double>> duringSymptomValues =
      ValueNotifier(List.generate(3, (index) => 0));
  ValueNotifier<List<double>> postSymptomValues =
      ValueNotifier(List.generate(3, (index) => 0));

  //
  PageController _pageController = PageController();
  int intCurrentPageValue = 0;
  var currentPageValue = 0.0;
  int nPages = 4;

  ValueNotifier<List<Widget>> circleList = ValueNotifier([]);

  void _updateCircleList(int intCurrentPageValue) {
    List<Widget> auxList = [];
    for (var i = 0; i < nPages; i++) {
      auxList.add(QuestionnaireCircle(
          color: i == intCurrentPageValue
              ? DefaultColors.accentColor
              : DefaultColors.backgroundColor));
      if (i != circleList.value.length - 1) auxList.add(SizedBox(width: 5));
    }
    setState(() => circleList.value = auxList);
  }

  @override
  void initState() {
    super.initState();
    for (var i = 0; i < nPages; i++) {
      // initiate the circles on the appBar according to the number of pages
      circleList.value.add(QuestionnaireCircle(
          color: i == 0
              ? DefaultColors.accentColor
              : DefaultColors.backgroundColor));
      if (i != nPages - 1) circleList.value.add(SizedBox(width: 5));
    }

    _pageController.addListener(() {
      setState(() {
        currentPageValue = _pageController.page;
        intCurrentPageValue = currentPageValue.round();
      });
      _updateCircleList(intCurrentPageValue);
    });

    // initState for QuestionsPage1
    seizureTypesItems = List.from(seizureTypes)..add('Other');
    seizureItem.value = seizureTypesItems[0];
    datePicker = ValueNotifier(<DateTime>[DateTime.now()]);
    if (widget.duration == null) widget.duration = ValueNotifier('00:00:00.0');
    var hour = DateTime.now().hour;
    if ((hour > 5) && (hour <= 12)) {
      timeOfSeizureIndex = ValueNotifier(1);
    } else if ((hour > 12) && (hour <= 20)) {
      timeOfSeizureIndex = ValueNotifier(2);
    } else {
      timeOfSeizureIndex = ValueNotifier(3);
    }
  }

  Future<List> _initiatePages() async {
    ValueNotifier<List<SymptomSlider>> preSymptomSliders = ValueNotifier(
        await _initiateSliders(preSymptomValues, preSymptomLabels));
    ValueNotifier<List<SymptomSlider>> duringSymptomSliders = ValueNotifier(
        await _initiateSliders(duringSymptomValues, duringSymptomLabels));
    ValueNotifier<List<SymptomSlider>> postSymptomSliders = ValueNotifier(
        await _initiateSliders(postSymptomValues, postSymptomLabels));

    return [
      QuestionsPage1(
          datePicker: datePicker,
          duration: widget.duration,
          seizureType: seizureType,
          seizureItem: seizureItem,
          timeOfSeizureIndex: timeOfSeizureIndex,
          seizureTypes: seizureTypes,
          seizureTypesItems: seizureTypesItems,
          triggerOptions: triggerOptions,
          triggerChoices: triggerChoices),
      QuestionsPage2(
        preSymptomLabels: preSymptomLabels,
        preSymptomSliders: preSymptomSliders,
        preSymptomValues: preSymptomValues,
      ),
      QuestionsPage3(
        duringSymptomLabels: duringSymptomLabels,
        duringSymptomSliders: duringSymptomSliders,
        duringSymptomValues: duringSymptomValues,
      ),
      QuestionsPage4(
          postSymptomLabels: postSymptomLabels,
          postSymptomSliders: postSymptomSliders,
          postSymptomValues: postSymptomValues)
    ];
  }

  Future<List<SymptomSlider>> _initiateSliders(
      ValueNotifier<List<double>> symptomValues,
      List<String> symptomLabels) async {
    List<SymptomSlider> sliderList = [];
    for (var i = 0; i < symptomValues.value.length; i++) {
      sliderList.add(
        SymptomSlider(
          label: symptomLabels[i],
          onChanged: (value) {
            setState(() => symptomValues.value[i] = value);
          },
          sliderIndex: i,
          sliderValues: symptomValues,
        ),
      );
    }
    return sliderList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarAddSeizure(
        title: 'New Seizure',
        circleList: circleList,
      ),
      body: FutureBuilder(
        future: _initiatePages(),
        builder: (BuildContext context, snapshot) {
          if (ConnectionState.active != null && !snapshot.hasData) {
            return Container();
          } else {
            return PageView.builder(
              controller: _pageController,
              itemBuilder: (context, position) {
                return snapshot.data[position];
              },
              itemCount: snapshot.data.length,
            );
          }
        },
      ),
      floatingActionButton: Stack(children: [
        Align(
          alignment: Alignment(-0.8, 1.0),
          child: FloatingActionButton(
            heroTag: null,
            child: Icon(
              Icons.arrow_back_ios_rounded,
              color: DefaultColors.mainColor,
              size: 40,
            ),
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              _pageController.previousPage(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: FloatingActionButton(
            child: Icon(
              Icons.arrow_forward_ios_rounded,
              color: DefaultColors.mainColor,
              size: 40,
            ),
            foregroundColor: Colors.transparent,
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: () {
              _pageController.nextPage(
                  duration: Duration(milliseconds: 400),
                  curve: Curves.easeInOut);
            },
          ),
        ),
      ]),

      /* floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.arrow_forward_ios_rounded,
          color: DefaultColors.mainColor,
          size: 40,
        ),
        foregroundColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        elevation: 0,
        onPressed: () {_pageController.nextPage(duration: Duration(milliseconds: 400), curve: Curves.easeInOut);},
      ), */
    );
  }
}
