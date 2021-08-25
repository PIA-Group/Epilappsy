import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:epilappsy/Database/database.dart';
import '../app_localizations.dart';
import 'package:epilappsy/Pages/Education/WebPageCasia.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:flutter/material.dart';
import '../app_localizations.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/my_flutter_app_icons.dart';

Widget rowEdu(
    BuildContext context, Color backColor, String imagePath, IconData icon) {
  String tip_of_day = 'tip' + DateTime.now().day.toString();
  String ReadMore = '\n Carregue para ler mais';

  return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: FutureBuilder<dynamic>(
          future: getDailyTip(tip_of_day),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            ElevatedButton daily_tip;
            if (snapshot.hasData) {
              daily_tip = ElevatedButton(
                  onPressed: () {
                    print(snapshot.data['key_pt']);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => WebViewContainer(
                            snapshot.data['url_pt'], snapshot.data['key_pt']),
                      ),
                    );
                    print('YES');
                  },
                  style: ElevatedButton.styleFrom(
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      primary: DefaultColors.boxHomePurple,
                      textStyle: Theme.of(context).textTheme.bodyText1),
                  child: Column(children: [
                    Padding(
                      padding: EdgeInsets.only(top: 10, left: 30),
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
                        padding: EdgeInsets.only(top: 70), //top: 10, left: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Icon(icon,
                                color: DefaultColors.backgroundColor, size: 20),
                            Text(
                              'Daily Tip',
                              style: TextStyle(
                                  fontSize: 15,
                                  color: DefaultColors.backgroundColor),
                            ),
                          ],
                        ))
                  ]));

              return daily_tip;
            } else {
              return CircularProgressIndicator();
            }
          }));
}

Widget homeBox(BuildContext context, Color backColor, String imagePath,
    IconData icon, String message) {
  return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: ElevatedButton(
          onPressed: () {
            print('Nothing');
          },
          style: ElevatedButton.styleFrom(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              primary: backColor,
              textStyle: Theme.of(context).textTheme.bodyText1),
          child: Column(children: [
            Padding(
              padding: EdgeInsets.only(top: 10, left: 30),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(icon, color: DefaultColors.backgroundColor, size: 20),
                    Text(
                      message,
                      style: TextStyle(
                          fontSize: 14, color: DefaultColors.backgroundColor),
                    ),
                  ],
                ))
          ])));
}
