import 'package:casia/Database/database.dart';
import 'package:casia/Pages/Education/EduDefaultPage.dart';
import 'package:casia/Pages/Education/EduMyPage.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:casia/Utils/app_localizations.dart';
import 'package:casia/main.dart';
import 'package:flutter/material.dart';
import 'package:casia/Pages/Education/WebPage.dart';
import 'package:casia/design/colors.dart';

Widget questionButton(
    {Color bckgColor,
    Color textColor,
    IconData icon,
    String text,
    GestureTapCallback onTap}) {
  return ListTile(
    selectedTileColor: mycolor,
    dense: true,
    contentPadding: EdgeInsets.only(left: 20.0, right: 12.0),
    leading: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: textColor),
      ],
    ),
    title: Text(
      text.inCaps,
      style: TextStyle(color: textColor, fontSize: 18),
    ),
    trailing: Icon(Icons.keyboard_arrow_right, color: textColor, size: 30.0),
    onTap: onTap,
  );
}

class EducationalPage extends StatefulWidget {
  @override
  _EducationalPageState createState() => _EducationalPageState();
}

class _EducationalPageState extends State<EducationalPage> {
  ValueNotifier<List<RecordObject>> records = ValueNotifier([]);

  void _getQuestions() {
    List listRecords = [];
    getQuestions().then((val) {
      records.value = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getQuestions();
    return Scaffold(
      backgroundColor: DefaultColors.backgroundColor,
      body: Stack(children: [
        AppBarAll(
          context: context,
          titleH: 'education',
        ),
        Positioned(
          left: 8,
          top: AppBarHome.appBarHeight * 0.4,
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: DefaultColors.backgroundColor,
              size: 30,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        Positioned(
          top: AppBarAll.appBarHeight,
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            decoration: BoxDecoration(
                color: DefaultColors.backgroundColor,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(30.0),
                  topRight: const Radius.circular(30.0),
                )),
            child: DefaultTabController(
              length: 2,
              child: Column(children: [
                TabBar(
                    indicatorColor: DefaultColors.purpleLogo,
                    indicatorWeight: 6.0,
                    tabs: <Widget>[
                      Tab(
                        child: Container(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("general")
                                    .inCaps,
                                style: Theme.of(context).textTheme.bodyText2)),
                      ),
                      Tab(
                        child: Container(
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate("my questions")
                                  .capitalizeFirstofEach,
                              style: Theme.of(context).textTheme.bodyText2),
                        ),
                      ),
                    ]),
                Expanded(
                  child: TabBarView(children: [
                    EduDefaultPage(),
                    EduMyPage(records: records),
                  ]),
                ),
              ]),
            ),
          ),
        ),
      ]),
    );
  }
}
