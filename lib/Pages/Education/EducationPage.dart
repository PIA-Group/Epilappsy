import 'package:epilappsy/Pages/Education/EduDefaultPage.dart';
import 'package:epilappsy/Pages/Education/EduMyPage.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:epilappsy/Pages/SeizureDiaryPage.dart';
import 'package:epilappsy/Pages/Education/WebMyPage.dart';
//for the dictionaries
import '../../app_localizations.dart';

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
  TabController _tabController;
  bool _isLoading = true;
  List<List<String>> _seizures = [];
  String uid = FirebaseAuth.instance.currentUser.uid;

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            backgroundColor: mycolor,
            appBar: AppBar(
              elevation: 0.0,
              title: appBarTitle(context, 'Education'),
              backgroundColor: Theme.of(context).unselectedWidgetColor,
              bottom: _isLoading
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : TabBar(
                      controller: _tabController,
                      indicatorColor: Theme.of(context).accentColor,
                      indicatorWeight: 6.0,
                      tabs: <Widget>[
                          Tab(
                            child: Container(
                                child: Text(
                                    "General"
                                        .toUpperCase(), //AppLocalizations.of(context).translate('STATISTICS'),
                                    style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: mycolor,
                                        fontSize: 18.0))),
                          ),
                          Tab(
                            child: Container(
                                child: Text(
                                    "My Questions"
                                        .toUpperCase(), //AppLocalizations.of(context).translate('MODULES'),
                                    style: TextStyle(
                                        letterSpacing: 1.5,
                                        color: mycolor,
                                        fontSize: 18.0))),
                          ),
                        ]),
            ),
            body: TabBarView(controller: _tabController, children: [
              EduDefaultPage(),
              EduMyPage(records: records),
            ])));
  }
}
