import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';
import 'package:casia/Utils/appBar.dart';
import 'package:flutter/material.dart';
//for the dictionaries
import '../../Utils/app_localizations.dart';

class UserPage extends StatefulWidget {
  final ValueNotifier<bool> logout;
  UserPage({this.logout});

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: DefaultColors.backgroundColor,
        body: Stack(children: [
          AppBarAll(
            context: context,
            titleH: 'user page',
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
          right: 8,
          top: AppBarHome.appBarHeight * 0.4,
          child: IconButton(
            icon: Icon(
              Icons.logout,
              color: DefaultColors.backgroundColor,
              size: 30,
            ),
            onPressed: () => setState(() => widget.logout.value = true),
          ),
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
