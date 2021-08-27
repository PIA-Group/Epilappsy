import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';

class SeizureInfoDialog extends StatefulWidget {
  final List<dynamic> seizure;
  final List<String> keys;
  //final String startingDate;
  //final String hours;
  //final DocumentSnapshot medDoc;

  const SeizureInfoDialog({
    Key key,
    this.seizure,
    this.keys,
  }) : super(key: key);

  @override
  _SeizureInfoDialogState createState() => _SeizureInfoDialogState();
}

class _SeizureInfoDialogState extends State<SeizureInfoDialog> {
  Function doAfterDone;

  Widget getListTiles(_seizure, _keys) {
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: new List.generate(
            _seizure.length,
            (index) => new ListTile(
                  title: Text(_seizure[index].toString()),
                ))
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
          ListTile(
              title: Text(
                AppLocalizations.of(context).translate('Dosage'),
                style: MyTextStyle(),
              ),
              subtitle: Text(widget.dosage)),
          ListTile(
              title: Text(
                AppLocalizations.of(context).translate('Starting date'),
                style: MyTextStyle(),
              ),
              subtitle: Text(widget.startingDate)),
          ListTile(
              title: Text(
                AppLocalizations.of(context).translate('Hours'),
                style: MyTextStyle(),
              ),
              subtitle: Text(widget.hours)),
        ]);*/
        );
  }

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
            getListTiles(widget.seizure, widget.keys),
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
