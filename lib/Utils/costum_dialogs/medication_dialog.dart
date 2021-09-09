import 'package:casia/Pages/Medication/NewMedicationEntry.dart';
import 'package:casia/Pages/Medication/historic_medication.dart';
import 'package:casia/Pages/Medication/medication.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/Database/database.dart';
import 'package:casia/Utils/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:casia/main.dart';
import 'package:intl/intl.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class MedicationDialog extends StatefulWidget {
  final Medication medication;
  final String hours;
  final DocumentSnapshot medDoc;

  const MedicationDialog({
    Key key,
    this.medication,
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
                    AppLocalizations.of(context)
                        .translate('medicine type')
                        .inCaps,
                    style: MyTextStyle(),
                  ),
                  subtitle: Text(AppLocalizations.of(context)
                      .translate(widget.medication.type)
                      .inCaps)),
            ),
            IconButton(
                icon:
                    Icon(Icons.delete_outline, color: DefaultColors.logoColor),
                onPressed: () {
                  deleteMedication(widget.medDoc, false);
                  Navigator.of(context).pop();
                }),
          ]),
          Row(children: [
            Expanded(
              child: ListTile(
                  title: Text(
                    AppLocalizations.of(context).translate('dosage').inCaps,
                    style: MyTextStyle(),
                  ),
                  subtitle: Text(
                      '${widget.medication.dosage['dose']} ${AppLocalizations.of(context).translate(widget.medication.dosage['unit'])}')),
            ),
            IconButton(
                icon: Icon(Icons.edit, color: DefaultColors.logoColor),
                onPressed: () {
                  Navigator.of(context).pop();
                  pushNewScreen(context,
                      screen: MedicationEntry(
                        answers: widget.medication,
                        medDoc: widget.medDoc,
                      ),
                      withNavBar: false);
                }),
          ]),
          Row(children: [
            Expanded(
              child: ListTile(
                  title: Text(
                    widget.medication.once
                        ? AppLocalizations.of(context)
                            .translate('intake date')
                            .inCaps
                        : AppLocalizations.of(context)
                            .translate('starting date')
                            .inCaps,
                    style: MyTextStyle(),
                  ),
                  subtitle: Text(
                      (widget.medication.spontaneous || widget.medication.once)
                          ? DateFormat('dd-MM-yyyy')
                              .format(widget.medication.intakeDate)
                          : DateFormat('dd-MM-yyyy')
                              .format(widget.medication.startDate))),
            ),
            IconButton(
                icon: Icon(Icons.save_alt_rounded,
                    color: DefaultColors.logoColor),
                onPressed: () {
                  HistoricMedication historicMedication =
                      HistoricMedication.fromMedication(widget.medication);
                  saveHistoricMedication(historicMedication, context);
                  deleteMedication(widget.medDoc, false);
                  Navigator.of(context).pop();
                }),
          ]),
          ListTile(
              title: Text(
                AppLocalizations.of(context).translate('intake time(s)').inCaps,
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
                    AssetImage("assets/" +
                        widget.medication.type.toLowerCase() +
                        ".png"),
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
