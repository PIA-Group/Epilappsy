import 'package:epilappsy/Pages/AddSeizure/symptom_slider.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class QuestionsPage4 extends StatefulWidget {
  List<String> postSymptomLabels;

  final ValueNotifier<List<SymptomSlider>> postSymptomSliders;

  final ValueNotifier<List<double>> postSymptomValues;

  QuestionsPage4(
      {this.postSymptomLabels,
      this.postSymptomSliders,
      this.postSymptomValues});

  @override
  _QuestionsPage4State createState() => _QuestionsPage4State();
}

class _QuestionsPage4State extends State<QuestionsPage4> {
  @override
  Widget build(BuildContext context) {
    return ListView(shrinkWrap: true, children: [
      SizedBox(height: 20),
      Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.1),
        child: Text('Post-Seizure Symptoms',
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
            valueListenable: widget.postSymptomSliders,
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
