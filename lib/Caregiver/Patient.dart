import 'package:firebase_auth/firebase_auth.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Pages/SeizureDiaryPage.dart';
import 'package:epilappsy/Caregiver/Patientinfo.dart';
import 'package:epilappsy/Pages/StatisticsPage.dart';

import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
import '../app_localizations.dart';


class Patient extends StatefulWidget {
  @override
  _PatientState createState() => _PatientState();
}

class _PatientState extends State<Patient> {
  TabController _tabController;
  bool _isLoading = true;
  List<List<String>> _seizures = [];
  String uid = FirebaseAuth.instance.currentUser.uid;

  void updateAllSeizures() {
    getAllSeizureDetails(uid).then((surveys) => {
          this.setState(() {
            this._seizures = surveys;
          })
        });
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
              backgroundColor: Colors.teal,
              title: Text('Health Check'),
              actions: [
                IconButton(
                  icon: Icon(Icons.settings, color: Colors.white),
                  onPressed: () {
                    pushNewScreen(
                      context,
                      screen: Patientinfo(),
                      withNavBar: true,
                    );
                  },
                )
              ],
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
                                child: Text(AppLocalizations.of(context).translate('Patient Info'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0))),
                          ),
                          Tab(
                            child: Container(
                                child: Text(AppLocalizations.of(context).translate('Statistics'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0))),
                          ),
                          Tab(
                            child: Container(
                                child: Text(AppLocalizations.of(context).translate('Seizures'),
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0))),
                          ),
                        ]),
            ),
            body: TabBarView(controller: _tabController, children: [
              Patientinfo(),
              StatisticsPage(seizures: _seizures),
              SeizureDiary(),
            ])));
  }
}
