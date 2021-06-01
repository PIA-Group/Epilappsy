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

  _MedicationDetailsState createState() => _MedicationDetailsState(this.doc);

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
            Text(doc.data()['Medication name']).data),
        body: Center(
            child: Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Type'),
                subtitle: Text(doc.data()['Medicine type']),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Dosage'),
                subtitle: Text(doc.data()['Dosage']),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Interval Time'),
                subtitle: Text(doc.data()['Interval']),
              ),
            ),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
              child: ListTile(
                title: Text('Starting Time'),
                subtitle: Text(doc.data()['Starting time']),
              ),
            ),
          ],
        )));
  }

  _MedicationDetailsState(this.doc);
}
