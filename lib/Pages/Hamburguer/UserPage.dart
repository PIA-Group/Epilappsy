import 'package:casia/Pages/Calendar/seizure_dialog.dart';
import 'package:casia/Pages/Hamburguer/profile_drawer.dart';
import 'package:casia/Widgets/dailytip.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

//for the dictionaries
import '../../app_localizations.dart';

class UserPage extends StatefulWidget {
  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  TabController _tabController;
  bool _isLoading = true;
  List<List<String>> _seizures = [];

  @override
  void initState() {
    super.initState();
    _isLoading = false;
  }

  Widget userBox(BuildContext context, Color backColor, String imagePath,
      String message, dynamic screenShown) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: ElevatedButton(
            onPressed: () {
              pushDynamicScreen(
                context,
                screen: screenShown,
                withNavBar: false,
              );
            },
            style: ElevatedButton.styleFrom(
                elevation: 5,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                primary: backColor,
                textStyle: Theme.of(context).textTheme.bodyText1),
            child: Column(children: [
              Padding(
                padding: EdgeInsets.only(top: 15, left: 30),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.height * 0.2,
                  decoration: BoxDecoration(
                    //shape: BoxShape.circle,
                    image: DecorationImage(
                        fit: BoxFit.scaleDown,
                        image: AssetImage(imagePath),
                        alignment: Alignment.topRight),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height *
                        0.1), //top: 10, left: 10),
                child: Expanded(
                  child: Text(
                    message,
                    style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width * 0.05,
                        color: DefaultColors.backgroundColor),
                  ),
                ),
              ),
            ])));
  }

  GlobalKey<ScaffoldState> _scaffoldState = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldState,
      body: Stack(
        children: [
          AppBarAll(
            context: context,
            titleH: 'user page',
          ),
          Positioned(
            left: 10,
            top: AppBarHome.appBarHeight * 1 / 2,
            child: IconButton(
                icon: Icon(Icons.arrow_back,
                    color: DefaultColors.backgroundColor),
                onPressed: () => Navigator.pop(context)),
          ),
          Stack(
            children: [
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: userBox(
                                      context,
                                      DefaultColors.boxHomeRed,
                                      'assets/images/alimentação.png',
                                      AppLocalizations.of(context)
                                          .translate('information')
                                          .capitalizeFirstofEach,
                                      SeizureInfoDialog()),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: userBox(
                                      context,
                                      DefaultColors.boxHomePurple,
                                      'assets/images/car female.png',
                                      AppLocalizations.of(context)
                                          .translate('color scheme')
                                          .capitalizeFirstofEach,
                                      SeizureInfoDialog()),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: userBox(
                                      context,
                                      DefaultColors.boxHomePurple,
                                      'assets/images/sleeping.png',
                                      AppLocalizations.of(context)
                                          .translate('user seizure types')
                                          .capitalizeFirstofEach,
                                      SeizureInfoDialog()),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.height * 0.22,
                                  child: userBox(
                                      context,
                                      DefaultColors.boxHomeRed,
                                      'assets/images/qrcode.png',
                                      AppLocalizations.of(context)
                                          .translate('access qr code')
                                          .capitalizeFirstofEach,
                                      SeizureInfoDialog()),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )))
            ],
          ),
        ],
      ),
    );
  }
}
/*
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
        //length: 3,
        length: 1,
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
*/
