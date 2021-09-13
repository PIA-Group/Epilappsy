import 'package:casia/Pages/Medication/historic_medication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Utils/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:casia/main.dart';
import 'package:intl/intl.dart';

class HistoricMedicationDialog extends StatefulWidget {
  final HistoricMedication historicMedication;
  final String type;
  final String dosage;
  final DateTime startingDate;
  final DateTime endingDate;
  final String hours;
  final DocumentSnapshot medDoc;

  const HistoricMedicationDialog({
    Key key,
    this.historicMedication,
    this.type,
    this.dosage,
    this.startingDate,
    this.endingDate,
    this.hours,
    this.medDoc,
  }) : super(key: key);

  @override
  _HistoricMedicationDialogState createState() =>
      _HistoricMedicationDialogState();
}

class _HistoricMedicationDialogState extends State<HistoricMedicationDialog> {
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
                    AppLocalizations.of(context)
                        .translate('medicine type')
                        .inCaps,
                    style: MyTextStyle(),
                  ),
                  subtitle: Text(AppLocalizations.of(context)
                      .translate(widget.type)
                      .inCaps)),
            ),
            IconButton(
                icon:
                    Icon(Icons.delete_outline, color: DefaultColors.logoColor),
                onPressed: () {
                  deleteMedication(widget.medDoc, true);
                  Navigator.of(context).pop();
                })
          ]),
          ListTile(
              title: Text(
                AppLocalizations.of(context).translate('dosage').inCaps,
                style: MyTextStyle(),
              ),
              subtitle: Text(widget.dosage)),
          if (widget.historicMedication.intakeDate == null)
            ListTile(
                title: Text(
                  AppLocalizations.of(context)
                      .translate('starting date')
                      .inCaps,
                  style: MyTextStyle(),
                ),
                subtitle:
                    Text(DateFormat('dd-MM-yyyy').format(widget.startingDate))),
          if (widget.historicMedication.intakeDate == null)
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate('ending date').inCaps,
                  style: MyTextStyle(),
                ),
                subtitle:
                    Text(DateFormat('dd-MM-yyyy').format(widget.endingDate))),
          if (widget.historicMedication.intakeDate != null)
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate('intake date').inCaps,
                  style: MyTextStyle(),
                ),
                subtitle: Text(DateFormat('dd-MM-yyyy')
                    .format(widget.historicMedication.intakeDate))),
          if (widget.historicMedication.intakeDate == null)
            ListTile(
                title: Text(
                  AppLocalizations.of(context).translate('hours').inCaps,
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
            SizedBox(height: 20),
            getListTiles(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text(
                    AppLocalizations.of(context).translate('done').inCaps,
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