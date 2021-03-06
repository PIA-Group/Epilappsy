import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/app_localizations.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/material.dart';

class MedicationDialog extends StatefulWidget {
  final String type;
  final String dosage;
  final String startingDate;
  final String hours;
  final DocumentSnapshot medDoc;

  const MedicationDialog({
    Key key,
    this.type,
    this.dosage,
    this.startingDate,
    this.hours,
    this.medDoc,
  }) : super(key: key);

  @override
  _MedicationDialogState createState() => _MedicationDialogState();
}

class _MedicationDialogState extends State<MedicationDialog> {
  Function doAfterDone;

  Widget getListTiles() {
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return ListView(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        children: [
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
                icon: Icon(Icons.delete_outline),
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
        ]);
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
            getListTiles(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text(AppLocalizations.of(context)
                                      .translate('Done'), style: MyTextStyle()))
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
                child: ImageIcon(
                    AssetImage("assets/" + widget.type.toLowerCase() + ".png"),
                    size: 30,
                    color: DefaultColors.logoColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
