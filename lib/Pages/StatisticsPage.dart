import 'package:casia/Charts/seizure_series.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;
//for the dictionaries
import '../app_localizations.dart';
import '../main.dart';

class StatisticsPage extends StatefulWidget {
  final Widget child;
  final List<List<String>> seizures;

  StatisticsPage({Key key, this.child, @required this.seizures})
      : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    List<charts.Series<SeizureDetailSeries, String>> typeSeries = [
      charts.Series(
          id: "number",
          data: convertTypeToData(widget.seizures),
          domainFn: (SeizureDetailSeries series, _) => series.detail,
          measureFn: (SeizureDetailSeries series, _) => series.number,
          colorFn: (SeizureDetailSeries series, _) => series.barColor)
    ];
    List<charts.Series<SeizureDetailSeries, String>> moodSeries = [
      charts.Series(
          id: "number",
          data: convertMoodToData(widget.seizures),
          domainFn: (SeizureDetailSeries series, _) => series.detail,
          measureFn: (SeizureDetailSeries series, _) => series.number,
          colorFn: (SeizureDetailSeries series, _) => series.barColor)
    ];
    List<charts.Series<SeizureDetailSeries, String>> triggerSeries = [
      charts.Series(
          id: "number",
          data: convertTriggersToData(widget.seizures),
          domainFn: (SeizureDetailSeries series, _) => series.detail,
          measureFn: (SeizureDetailSeries series, _) => series.number,
          colorFn: (SeizureDetailSeries series, _) => series.barColor)
    ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        title: appBarTitle(context, 'casia - Statistics'),
        backgroundColor: mycolor,
      ),
      body: ListView(
        padding: const EdgeInsets.all(10),
        children: [
          Container(
            height: 400,
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context).translate("Type of Seizure"),
                    ),
                    Expanded(
                      child: charts.BarChart(
                        typeSeries,
                        animate: true,
                        domainAxis: new charts.OrdinalAxisSpec(
                            renderSpec: new charts.SmallTickRendererSpec(

                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 10, // size in Pts.
                                    color: charts.MaterialPalette.black),

                                // Change the line colors to match text color.
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.black))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 400,
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)
                          .translate("Mood after Seizure"),
                    ),
                    Expanded(
                      child: charts.BarChart(moodSeries, animate: true),
                    )
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: 400,
            padding: EdgeInsets.all(20),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)
                          .translate("Possible Triggers"),
                    ),
                    Expanded(
                      child: charts.BarChart(
                        triggerSeries,
                        animate: true,
                        domainAxis: new charts.OrdinalAxisSpec(
                            renderSpec: new charts.SmallTickRendererSpec(

                                // Tick and Label styling here.
                                labelStyle: new charts.TextStyleSpec(
                                    fontSize: 8, // size in Pts.
                                    color: charts.MaterialPalette.black),

                                // Change the line colors to match text color.
                                lineStyle: new charts.LineStyleSpec(
                                    color: charts.MaterialPalette.black))),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
