import 'package:casia/main.dart';
import 'package:casia/Pages/StatisticsPage.dart';
import 'package:casia/Widgets/appBar.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//for the dictionaries
import '../app_localizations.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TabController _tabController;
  bool _isLoading = true;
  List<List<String>> _seizures = [];

  void updateAllSeizures() {
    /* getAllSeizureDetails(uid).then((surveys) => {
          this.setState(() {
            this._seizures = surveys;
          })
        }); */
  }

  @override
  void initState() {
    super.initState();
    updateAllSeizures();
    _isLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        length: 3,
        child: Scaffold(
            appBar: AppBar(
              elevation: 0.0,
              title: appBarTitle(context, 'User Page'),
              backgroundColor: mycolor,
              bottom: _isLoading
                  ? Container(
                      child: Center(child: CircularProgressIndicator()),
                    )
                  : TabBar(
                      controller: _tabController,
                      indicatorColor: Colors.white,
                      indicatorWeight: 6.0,
                      tabs: <Widget>[
                          Tab(
                            child: Container(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('STATISTICS'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0))),
                          ),
                          Tab(
                            child: Container(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('MODULES'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0))),
                          ),
                          Tab(
                            child: Container(
                                child: Text(
                                    AppLocalizations.of(context)
                                        .translate('CONNECT'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0))),
                          ),
                        ]),
            ),
            body: TabBarView(controller: _tabController, children: [
              StatisticsPage(seizures: _seizures),
            ])));
  }
}
