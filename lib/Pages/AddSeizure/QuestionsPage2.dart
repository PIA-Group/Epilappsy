import 'package:epilappsy/Pages/AddSeizure/symptom_slider.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionsPage2 extends StatefulWidget {
  List<String> preSymptomLabels;
  final ValueNotifier<List<SymptomSlider>> preSymptomSliders;
  final ValueNotifier<List<double>> preSymptomValues;

  QuestionsPage2({
    this.preSymptomLabels,
    this.preSymptomSliders,
    this.preSymptomValues,
  });

  @override
  _QuestionsPage2State createState() => _QuestionsPage2State();
}

class _QuestionsPage2State extends State<QuestionsPage2> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Text('Pre-Seizure Symptoms',
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
            valueListenable: widget.preSymptomSliders,
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
