import 'dart:ui';

import 'package:casia/main.dart';
import 'package:flutter/material.dart';
import 'package:casia/Pages/Education/WebPage.dart';
import 'package:casia/Pages/Education/WebPageCasia.dart';
//for the dictionaries
import '../../app_localizations.dart';

Widget questionButton(
    {BuildContext context,
    Color bckgColor,
    IconData icon,
    String text,
    GestureTapCallback onTap}) {
  return Container(
    child: ListTile(
      selectedTileColor: mycolor,
      dense: true,
      contentPadding: EdgeInsets.only(left: 16.0, right: 12.0),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Theme.of(context).unselectedWidgetColor),
        ],
      ),
      title: Text(
        text,
        style: Theme.of(context)
            .textTheme
            .bodyText1, //TextStyle(color: textColor, fontSize: 18),
      ),
      trailing: Icon(Icons.keyboard_arrow_right,
          color: Theme.of(context).unselectedWidgetColor, size: 30.0),
      onTap: onTap,
    ),
  );
}

class EduDefaultPage extends StatelessWidget {
  EduDefaultPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(scrollDirection: Axis.vertical, children: <Widget>[
      Padding(
          padding: const EdgeInsets.all(12.0),
          child: questionButton(
              context: context,
              icon: Icons.bolt,
              text:
                  AppLocalizations.of(context).translate('what is a seizure').inCaps+'?',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPage(
                          question: AppLocalizations.of(context)
                              .translate('what is a seizure').inCaps+'?',
                          url:
                              'https://www.epilepsy.com/learn/about-epilepsy-basics/what-seizure')),
                );
              })),
      Padding(
          padding: const EdgeInsets.all(12.0),
          child: questionButton(
              context: context,
              icon: Icons.workspaces_filled,
              text:
                  AppLocalizations.of(context).translate('Types of seizures?'),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => WebViewContainer(
                            'https://www.epilepsy.com/learn/types-seizures',
                            'There Are Many Different Types Of Seizures')));
                //WebPage(
                //  question: AppLocalizations.of(context)
                //    .translate('Types of Seizures?'),
                // )),
                //);
              })),
      Padding(
          padding: const EdgeInsets.all(12.0),
          child: questionButton(
              context: context,
              icon: Icons.error_sharp,
              text:
                  AppLocalizations.of(context).translate('possible triggers').inCaps+'?',
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebPage(
                          question: AppLocalizations.of(context)
                              .translate('possible trigers').inCaps+'?',
                          url:
                              'https://www.epilepsy.com/learn/triggers-seizures')),
                );
              })),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: questionButton(
            context: context,
            icon: Icons.medical_services,
            text: AppLocalizations.of(context).translate('treating seizures').capitalizeFirstofEach,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebPage(
                        question: AppLocalizations.of(context)
                            .translate('treating seizures').capitalizeFirstofEach,
                        url:
                            'https://epilepsysociety.org.uk/about-epilepsy/treatment')),
              );
            }),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: questionButton(
            context: context,
            icon: Icons.self_improvement,
            text: AppLocalizations.of(context).translate('managing epilepsy').capitalizeFirstofEach,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebPage(
                        question: AppLocalizations.of(context)
                            .translate('managing epilepsy').capitalizeFirstofEach,
                        url:
                            'https://www.cdc.gov/epilepsy/managing-epilepsy/checklist.htm')),
              );
            }),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: questionButton(
            context: context,
            icon: Icons.dangerous,
            text: AppLocalizations.of(context).translate('what is SUDEP').inCaps+'?',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebPage(
                        question: AppLocalizations.of(context)
                            .translate('what is SUDEP').inCaps+'?',
                        url:
                            'https://www.epilepsy.com/learn/early-death-and-sudep/sudep')),
              );
            }),
      ),
      Padding(
        padding: const EdgeInsets.all(12.0),
        child: questionButton(
            context: context,
            icon: Icons.lightbulb,
            text:
                AppLocalizations.of(context).translate('challenges').inCaps,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebPage(
                        question: AppLocalizations.of(context)
                            .translate('challenges in epilepsy').capitalizeFirstofEach,
                        url:
                            'https://www.epilepsy.com/learn/challenges-epilepsy')),
              );
            }),
      ),
      Container(
        height: 100.0,
      )
    ]));
  }
}
