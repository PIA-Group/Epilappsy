import 'package:casia/Utils/appBar.dart';
import 'package:casia/design/colors.dart';
import 'package:flutter/material.dart';
//for the dictionaries
import '../Utils/app_localizations.dart';
import '../main.dart';

class StatisticsPage extends StatefulWidget {
  final Widget child;
  final List<List<String>> seizures;

  StatisticsPage({Key key, this.child, this.seizures}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DefaultColors.backgroundColor,
        body: Stack(children: [
          AppBarAll(
            context: context,
            titleH: 'statistics',
          ),
          Positioned(
            top: AppBarAll.appBarHeight,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
                alignment: Alignment.center,
                decoration: BoxDecoration(
                    color: DefaultColors.backgroundColor,
                    borderRadius: new BorderRadius.only(
                      topLeft: const Radius.circular(30.0),
                      topRight: const Radius.circular(30.0),
                    )),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'assets/images/exercicios.gif',
                      height: MediaQuery.of(context).size.width * 0.8,
                      width: MediaQuery.of(context).size.width * 0.8,
                    ),
                    Text(
                      AppLocalizations.of(context)
                          .translate('comming soon')
                          .capitalizeFirstofEach,
                      style: TextStyle(
                          fontFamily: 'canter',
                          color: DefaultColors.purpleLogo,
                          fontSize: MediaQuery.of(context).size.width * 0.12),
                    )
                  ],
                )),
          ),
        ]));
  }
}
