import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';


class SeizureDetailSeries {
  final String detail;
  final int number;
  final charts.Color barColor;

  SeizureDetailSeries(
      {@required this.detail, @required this.number, @required this.barColor});
}

List<SeizureDetailSeries> convertTypeToData(List<List<String>> _list) {
  int _numAbsence = 0;
  int _numAtonic = 0;
  int _numClonic = 0;
  int _numMyoclonic = 0;
  int _numTonic = 0;
  int _numTonicClonic = 0;
  for (var i = 0; i < _list.length; i++) {
    switch (_list[i][3]) {
      case 'Absence':
        {
          _numAbsence++;
        }
        break;

      case 'Atonic':
        {
          _numAtonic++;
        }
        break;

      case 'Clonic':
        {
          _numClonic++;
        }
        break;

      case 'Myoclonic':
        {
          _numMyoclonic++;
        }
        break;

      case 'Tonic':
        {
          _numTonic++;
        }
        break;

      case 'Tonic Clonic':
        {
          _numTonicClonic++;
        }
        break;
    }
  }
  final List<SeizureDetailSeries> data = [
    SeizureDetailSeries(
      detail: "Absence",
      number: _numAbsence,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Atonic",
      number: _numAtonic,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Clonic",
      number: _numClonic,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Myoclonic",
      number: _numMyoclonic,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Tonic",
      number: _numTonic,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Tonic Clonic",
      number: _numTonicClonic,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
  ];
  return data;
}

List<SeizureDetailSeries> convertMoodToData(List<List<String>> _list) {
  int _numNormal = 0;
  int _numGood = 0;
  int _numBad = 0;
  for (var i = 0; i < _list.length; i++) {
    switch (_list[i][4]) {
      case 'Normal':
        {
          _numNormal++;
        }
        break;

      case 'Good':
        {
          _numGood++;
        }
        break;

      case 'Bad':
        {
          _numBad++;
        }
        break;
    }
  }
  final List<SeizureDetailSeries> data = [
    SeizureDetailSeries(
      detail: "Normal",
      number: _numNormal,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Good",
      number: _numGood,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Bad",
      number: _numBad,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
  ];
  return data;
}

List<SeizureDetailSeries> convertTriggersToData(List<List<String>> _list) {
  int _numMedication = 0;
  int _numSleep = 0;
  int _numDiet = 0;
  int _numAlcoholDrugs = 0;
  int _numLights = 0;
  int _numStress = 0;
  int _numHeat = 0;
  int _numHormonal = 0;
  int _numSick = 0;
  int _numOther = 0;
  for (var i = 0; i < _list.length; i++) {
    switch (_list[i][5]) {
      case 'Changes in Medication':
        {
          _numMedication++;
        }
        break;

      case 'Overtired or irregular sleep':
        {
          _numSleep++;
        }
        break;

      case 'Irregular Diet':
        {
          _numDiet++;
        }
        break;

      case 'Alcohol or Drug Abuse':
        {
          _numAlcoholDrugs++;
        }
        break;

      case 'Bright or flashing lights':
        {
          _numLights++;
        }
        break;

      case 'Emotional Stress':
        {
          _numStress++;
        }
        break;

      case 'Fever or Overheated':
        {
          _numHeat++;
        }
        break;

      case 'Hormonal Fluctuations':
        {
          _numHormonal++;
        }
        break;

      case 'Sick':
        {
          _numSick++;
        }
        break;

      case 'Other':
        {
          _numOther++;
        }
        break;
    }
  }
  final List<SeizureDetailSeries> data = [
    SeizureDetailSeries(
      detail: "Medication",
      number: _numMedication,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Sleep",
      number: _numSleep,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Diet",
      number: _numDiet,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Alcohol/Drugs",
      number: _numAlcoholDrugs,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Lights",
      number: _numLights,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Stress",
      number: _numStress,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Heat",
      number: _numHeat,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Hormonal",
      number: _numHormonal,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Sick",
      number: _numSick,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
    SeizureDetailSeries(
      detail: "Others",
      number: _numOther,
      barColor:
          charts.ColorUtil.fromDartColor(Color.fromRGBO(219, 213, 110, 1)),
    ),
  ];
  return data;
}
