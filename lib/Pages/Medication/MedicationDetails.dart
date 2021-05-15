import 'package:epilappsy/Caregiver/Patients.dart';
import 'package:epilappsy/Pages/Medication/NewMedicationEntry.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MedicationDetails extends StatefulWidget {
  //@override
  DocumentSnapshot doc;

  _MedicationDetailsState createState() => _MedicationDetailsState(doc);

  MedicationDetails(this.doc);
}

class _MedicationDetailsState extends State<MedicationDetails> {
  //@override
  DocumentSnapshot doc;
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarAll(
            context,
            [
              IconButton(
                  onPressed: () {
                    //pushNewScreen(context,
                    //screen: NewMedicationEntry(),
                    //withNavBar: false); //botão add new medication
                  },
                  icon: Icon(Icons.delete, size: 30)),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
            ],
            Text(doc['Name']).data),
        body: Center(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Type'),
                subtitle: Text(doc['type']),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Dosage'),
                subtitle: Text(doc['dosage']),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Interval Time'),
                subtitle: Text(doc['intervaltime']),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Staring Time'),
                subtitle: Text(doc['startingtime']),
              ),
            ),
          ],
        )));
  }

  _MedicationDetailsState(this.doc);
}
