import 'package:casia/Pages/Education/EduDefaultPage.dart';
import 'package:casia/Pages/Education/EduMyPage.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/app_localizations.dart';
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
  return Container(
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(20),
    ),
    child: ListTile(
      selectedTileColor: mycolor,
      dense: true,
      contentPadding: EdgeInsets.only(left: 20.0, right: 12.0),
      leading: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor),
          Padding(
            padding: EdgeInsets.only(left: 10.0),
            child: VerticalDivider(
              indent: 5,
              endIndent: 5,
              thickness: 1.0,
              color: textColor,
            ),
          ),
        ],
      ),
      title: Text(
        text,
        style: TextStyle(color: textColor, fontSize: 18),
      ),
      trailing: Icon(Icons.keyboard_arrow_right, color: textColor, size: 30.0),
      onTap: onTap,
    ),
  );
}

class EducationalPage extends StatefulWidget {
  @override
  _EducationalPageState createState() => _EducationalPageState();
}

class _EducationalPageState extends State<EducationalPage> {
  ValueNotifier<List<RecordObject>> records = ValueNotifier([]);

  //List<List<String>> _seizures = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: mycolor,
      /* appBar: AppBar(
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.white),
        title: appBarTitle(context, 'Education'),
        backgroundColor: Theme.of(context).unselectedWidgetColor,
        bottom: _isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : TabBar(
                controller: _tabController,
                indicatorColor: DefaultColors.purpleLogo,
                indicatorWeight: 6.0,
                tabs: <Widget>[
                    Tab(
                      child: Container(
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate("general")
                                  .inCaps,
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  color: mycolor,
                                  fontSize: 18.0))),
                    ),
                    Tab(
                      child: Container(
                          child: Text(
                              AppLocalizations.of(context)
                                  .translate("my questions")
                                  .capitalizeFirstofEach,
                              style: TextStyle(
                                  letterSpacing: 1.5,
                                  color: mycolor,
                                  fontSize: 18.0))),
                    ),
                  ]),
      ), */
      body: Stack(children: [
        AppBarAll(
          context: context,
          titleH: 'education',
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
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    color: DefaultColors.textColorOnLight,
                                    fontSize: 18.0))),
                      ),
                      Tab(
                        child: Container(
                            child: Text(
                                AppLocalizations.of(context)
                                    .translate("my questions")
                                    .capitalizeFirstofEach,
                                style: TextStyle(
                                    letterSpacing: 1.5,
                                    color: DefaultColors.textColorOnLight,
                                    fontSize: 18.0))),
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
