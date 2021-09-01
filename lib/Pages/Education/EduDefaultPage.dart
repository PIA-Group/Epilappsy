import 'dart:ui';

import 'package:casia/app_localizations.dart';
import 'package:casia/main.dart';
import 'package:flutter/material.dart';
import 'package:casia/Pages/Education/WebPage.dart';

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
            .bodyText2, //TextStyle(color: textColor, fontSize: 18),
      ),
      trailing: Icon(Icons.keyboard_arrow_right,
          color: Theme.of(context).unselectedWidgetColor, size: 30.0),
      onTap: onTap,
    ),
  );
}

List defaultQuestions = [
  {
    'question': 'what is a seizure',
    'icon': Icons.bolt,
    'url': 'https://www.epilepsy.com/learn/about-epilepsy-basics/what-seizure'
  },
  {
    'question': 'types of seizures',
    'icon': Icons.workspaces_filled,
    'url': 'https://www.epilepsy.com/learn/types-seizures',
  },
  {
    'question': 'possible triggers',
    'icon': Icons.error_sharp,
    'url': 'https://www.epilepsy.com/learn/triggers-seizures',
  },
  {
    'question': 'treating seizures',
    'icon': Icons.medical_services,
    'url': 'https://epilepsysociety.org.uk/about-epilepsy/treatment',
  },
  {
    'question': 'managing epilepsy',
    'icon': Icons.self_improvement,
    'url': 'https://www.cdc.gov/epilepsy/managing-epilepsy/checklist.htm',
  },
  {
    'question': 'what is SUDEP',
    'icon': Icons.dangerous,
    'url': 'https://www.epilepsy.com/learn/early-death-and-sudep/sudep',
  },
  {
    'question': 'challenges in epilepsy',
    'icon': Icons.lightbulb,
    'url': 'https://www.epilepsy.com/learn/challenges-epilepsy',
  },
];

class EduDefaultPage extends StatelessWidget {
  EduDefaultPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: defaultQuestions.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.all(12.0),
              child: questionButton(
                  context: context,
                  icon: defaultQuestions[index]['icon'],
                  text: AppLocalizations.of(context)
                          .translate(
                            defaultQuestions[index]['question'],
                          )
                          .inCaps +
                      '?',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebPage(
                            question: AppLocalizations.of(context)
                                    .translate(
                                      defaultQuestions[index]['question'],
                                    )
                                    .inCaps +
                                '?',
                            url: defaultQuestions[index]['url']),
                      ),
                    );
                  }),
            );
          }),
    );
  }
}
