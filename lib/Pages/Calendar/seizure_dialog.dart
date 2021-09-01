import 'package:casia/Database/database.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';

class SeizureInfoDialog extends StatefulWidget {
  final DateTime date;

  //final String startingDate;
  //final String hours;
  //final DocumentSnapshot medDoc;

  const SeizureInfoDialog({
    Key key,
    this.date,
  }) : super(key: key);

  @override
  _SeizureInfoDialogState createState() => _SeizureInfoDialogState();
}

class _SeizureInfoDialogState extends State<SeizureInfoDialog> {
  Function doAfterDone;
  final keys = [];

  Widget getListTiles(DateTime date) {
    Map<String, dynamic> seizure;
    List keys = [];
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return FutureBuilder(
        future: getSeizuresOfDay(date),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data != null) {
              seizure = snapshot.data;

              print('There $seizure');

              if (seizure.isNotEmpty) {
                keys = seizure.keys.toList();
                print('List this $seizure');
                if (keys.contains('Date')) {
                  seizure['Date'] = seizure['Date'].toDate();
                }
              } else {
                seizure = {};
              }
            }
          }
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: new List.generate(
              keys.length,
              (index) => new ListTile(
                title: Text(
                  AppLocalizations.of(context).translate(keys[index]),
                  style: MyTextStyle(),
                ),
                subtitle: Text(seizure[keys[index]].toString()),
              ),
            ),
          );
        });
  }
  /*[
          Row(children: [
            Expanded(
              child: ListTile(
                  title: Text(
                    AppLocalizations.of(context).translate('Type'),
                    style: MyTextStyle(),
                  ),
                  subtitle: Text(widget.type)),
            ),
            IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  deleteMedication(widget.medDoc);
                  Navigator.of(context).pop();
                })
          ]),
          */

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return Stack(
      children: <Widget>[
        Container(
          padding: EdgeInsets.only(left: 20, right: 20, bottom: 20),
          margin: EdgeInsets.only(top: 60),
          decoration: BoxDecoration(
              shape: BoxShape.rectangle,
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                    color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
              ]),
          child: ListView(shrinkWrap: true, children: <Widget>[
            /* Text(
              widget.title,
              textAlign: TextAlign.center,
              style: MyTextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ), */
            SizedBox(height: 20),
            getListTiles(widget.date),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text(AppLocalizations.of(context).translate('Done'),
                    style: MyTextStyle()))
          ]),
        ),
        Positioned(
          left: 20,
          right: 20,
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 60,
            child: ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(60)),
              child: CircleAvatar(
                backgroundColor: Colors.white,
                child:
                    Icon(Icons.bolt, size: 30, color: DefaultColors.logoColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
