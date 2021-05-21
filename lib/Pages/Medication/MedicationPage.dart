import 'package:epilappsy/Caregiver/Patients.dart';
import 'package:epilappsy/Pages/Medication/NewMedicationEntry.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class MedicationPage extends StatefulWidget {
  
  @override
  _MedicationPageState createState() => _MedicationPageState();
}



class MedicationPatients extends StatelessWidget{
@override


Widget build(BuildContext context) {
  String uid = FirebaseAuth.instance.currentUser.uid;
  return StreamBuilder<QuerySnapshot>(
    
    stream: FirebaseFirestore.instance.collection('medication-patients').doc(uid).collection('current').orderBy('Medication name').snapshots(),
    builder: ( context, snapshot){
      if (snapshot.hasData) {
        print(snapshot.data.docs);
        final List<DocumentSnapshot> documents = snapshot.data.docs;
        return Container(
          height: 400,
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:Column(
              children: [ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: documents.map((doc) => Card(
                  child: ListTile(
                    tileColor: Colors.grey.shade100,
                    title: Text(doc['Medication name']),
                    subtitle: Text(doc['Starting time']),
                    trailing: Icon(Icons.alarm_on_outlined),
                    onTap: null,
                    ),
                ))
              .toList()),
              ])
          ));
        } else {print('something went wrong');
          return Text("Something went wrong!");
                }
    });
    }
}

class MedicationHistoric extends StatelessWidget{
@override


Widget build(BuildContext context) {
  String uid = FirebaseAuth.instance.currentUser.uid;
  return StreamBuilder<QuerySnapshot>(
    
    stream: FirebaseFirestore.instance.collection('medication-patients').doc(uid).collection('current').orderBy('Medication name').snapshots(),
    builder: ( context, snapshot){
      if (snapshot.hasData) {
        print(snapshot.data.docs);
        final List<DocumentSnapshot> documents = snapshot.data.docs;
        return Container(
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child:Column(
              children: [ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: documents.map((doc) => Card(
                  child: ListTile(
                    tileColor: Colors.grey.shade100,
                    title: Text(doc['Medication name']),
                    subtitle: Text(doc['Starting time']),
                    onTap: null,
                    ),
                ))
              .toList()),
              ])
          ));
        } else {print('something went wrong');
          return Text("Something went wrong!");
                }
    });
    }
}
class _MedicationPageState extends State<MedicationPage> {


  @override
  Widget build(BuildContext context) {
    //reference to the firebase reminders list -  Provider.of....(context) ?;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarAll(
          context,
          [
            IconButton(
                onPressed: () {
                  pushNewScreen(context, screen: NewMedicationEntry(), withNavBar: false);
                },
                icon: Icon(Icons.add_circle_outline_rounded, size: 30)),
            Padding(
              padding: EdgeInsets.only(left: 20.0),
            ),
          ],
          'Medication'),
      body:  TopContainer(),
               
        );
    }
}



class TopContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //final GlobalBloc globalBloc = Provider.of<GlobalBloc>(context);
    return Column(
      children: [Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.elliptical(50, 10),
          bottomRight: Radius.elliptical(50, 10),
        ),
        boxShadow: [
          BoxShadow(
            blurRadius: 5,
            color: DefaultColors.backgroundColor,
            offset: Offset(0, 3.5),
          )
        ],
        color: DefaultColors.mainColor,
      ),
      width: double.infinity,
      height: 60,
      child: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 20.0),
            child: Center(
              child: Text(
                "Active medications",
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),],),),
        Container(
           color: Colors.grey.shade50,
           height: 350,
           padding: EdgeInsets.all(8.0),
           child: MedicationPatients(),),
        Container(
          height: 100,
        ),

        Container(
          child: ElevatedButton(
            
            onPressed:   () {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(
                    child: 
                      Container(
                          color: Colors.grey.shade50,
                          height: 200,
                          padding: EdgeInsets.all(8.0),
                          child:MedicationHistoric(),),
                          );
                });
          },
            child: Text('Historic medication')),
        )
          
        ],
      );
  }
}

class Dialog extends StatelessWidget{

  createAlertDialog(BuildContext context){
  return Container(
                          color: Colors.grey.shade50,
                          height: 350,
                          padding: EdgeInsets.all(8.0),
                          child: MedicationHistoric() ,);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
class BottomContainer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /* final GlobalBloc _globalBloc = Provider.of<GlobalBloc>(context);
    return StreamBuilder<List<Medicine>>(
      stream: _globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data.length == 0) { */
          return Container(
            color: Color(0xFFF6F8FC),
            child: Center(
              child: Text(
                "Press + to add a reminder",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFC9C9C9),
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        } /* else {
          return Container(
            color: Color(0xFFF6F8FC),
            child: GridView.builder(
              padding: EdgeInsets.only(top: 12),
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return MedicineCard(snapshot.data[index]);
              },
            ),
          );
        }
      }, 
    );
  }*/
}
