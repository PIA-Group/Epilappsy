import 'package:casia/Widgets/appBar.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:casia/Database/database.dart';

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
    Map<String, dynamic> docData = doc.data() as Map<String, dynamic>;
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: appBarAll(
            context,
            [
              IconButton(
                  onPressed: () {
                    //JOANA
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return Center(
                            child: Column(
                              children: <Widget>[
                                Container(
                                  alignment: Alignment.center,
                                  margin: EdgeInsets.only(
                                      left: 10.0,
                                      top: 10.0,
                                      bottom: 10.0,
                                      right: 0.0),
                                  child: Material(
                                      child: ListTile(
                                    title: Row(
                                      children: <Widget>[
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {
                                              deleteMedication(doc);
                                            },
                                            child: Text("Delete"),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                                onPrimary: Colors.white),
                                          ),
                                        ),
                                        Expanded(
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text("Move to History"),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.grey,
                                                onPrimary: Colors.white),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )),
                                ),
                              ],
                            ),
                          );
                        });
                  },
                  icon: Icon(Icons.delete, size: 30)),
              Padding(
                padding: EdgeInsets.only(left: 20.0),
              ),
            ],
            Text(docData['Medication name']).data),
        body: Center(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
                  child: ListTile(
                    title: Text('Type'),
                    subtitle: Text(docData['Medicine type']),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
                  child: ListTile(
                    title: Text('Dosage'),
                    subtitle: Text(docData['Dosage']),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
                  child: ListTile(
                    title: Text('Starting date'),
                    subtitle: Text(docData['Starting date']),
                  ),
                ),
                Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.only(
                      left: 10.0, top: 10.0, bottom: 10.0, right: 0.0),
                  child: ListTile(
                    title: Text('Hours'),
                    subtitle: Text(docData['Hours']),
                  ),
                ),
              ],
            ))));
  }

  _MedicationDetailsState(this.doc);
}
