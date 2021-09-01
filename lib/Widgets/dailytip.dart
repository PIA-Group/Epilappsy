import 'package:casia/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Pages/Education/WebPageCasia.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/main.dart';


Widget rowEdu(BuildContext context, Color backColor, String imagePath) {
  String tipOfDay = 'tip' + DateTime.now().day.toString();
  //String ReadMore = '\n Carregue para ler mais';

  return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      child: FutureBuilder<dynamic>(
          future: getDailyTip(tipOfDay),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            ElevatedButton dailyTip;
            if (snapshot.hasData) {
              dailyTip = ElevatedButton(
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
                            Expanded(flex: 3, child: Text(
                              AppLocalizations.of(context).translate('daily tip').capitalizeFirstofEach,
                              style: TextStyle(
                                  fontSize: 14,
                                  color: DefaultColors.backgroundColor),
                            ),),
                          ],
                        ))
                  ]));

              return dailyTip;
            } else {
              return CircularProgressIndicator();
            }
          }));
}

Widget homeBox(
    BuildContext context, Color backColor, String imagePath, String message) {
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
                    Expanded(
                      flex: 3,
                      child: Text(
                      message,
                      style: TextStyle(
                          fontSize: 14, color: DefaultColors.backgroundColor),
                    ),),
                  ],
                ))
          ])));
}
