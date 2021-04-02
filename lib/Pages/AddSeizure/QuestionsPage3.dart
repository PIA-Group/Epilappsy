import 'package:epilappsy/Pages/AddSeizure/symptom_slider.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionsPage3 extends StatefulWidget {
  List<String> duringSymptomLabels;

  final ValueNotifier<List<SymptomSlider>> duringSymptomSliders;

  final ValueNotifier<List<double>> duringSymptomValues;

  QuestionsPage3({
    this.duringSymptomLabels,
    this.duringSymptomSliders,
    this.duringSymptomValues,
  });

  @override
  _QuestionsPage3State createState() => _QuestionsPage3State();
}

class _QuestionsPage3State extends State<QuestionsPage3> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Text('During-Seizure Symptoms',
            style: MyTextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
      ),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Text('(optional)', style: MyTextStyle(color: Colors.grey[600])),
      ),
      SizedBox(height: 10),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: ValueListenableBuilder(
            valueListenable: widget.duringSymptomSliders,
            builder: (BuildContext context, List<SymptomSlider> listSliders,
                Widget child) {
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: listSliders.length,
                itemBuilder: (context, index) {
                  return listSliders[index];
                },
              );
            }),
      ),
      SizedBox(height: 20),
    ]);
  }
}
