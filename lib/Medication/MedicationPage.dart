import 'package:epilappsy/Medication/MedicineDetails.dart';
import 'package:flutter/material.dart';
import 'package:epilappsy/Medication/NewReminder.dart';
import 'package:epilappsy/Widgets/appBar.dart';

class MedicationPage extends StatefulWidget {
  @override
  _MedicationPageState createState() => _MedicationPageState();
}

class _MedicationPageState extends State<MedicationPage> {
  
  void initState() {
    super.initState();    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
        body: Container(
        color: Color(0xFFF6F8FC),
        child: Column(
          children: <Widget>[
            Flexible(
              flex: 3,
              child: Header(),
            ),
            Flexible(
              flex: 7,
              //child: Provider<GlobalBloc>.value(
                child: ReminderList(),              
                //value: _globalBloc,
              //),
            ),
        
          ])),
          floatingActionButton: RaisedButton(
                  elevation: 4,
                  color: Colors.grey,
                  child: Text("Add new reminder"),
                  onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => NewReminder(),
                    ),
                  );
                },
                ),     
          floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}



class Header extends StatelessWidget{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(71, 123, 117, 1),
          ),
          width: double.infinity,
          child: Column(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(
                  top: 10,
                  bottom: 10,
                ),
                child: Text(
                  "Medication Reminders",
                  style: TextStyle(
                    fontFamily: "Neu",
                    fontSize:30,
                    color: Colors.white,
                  ),
                ),
              ),
              Divider(
                color: Color(0xFFB0F3CB),
              ),
              Padding(
                padding: EdgeInsets.only(top: 2.0),
                child: Center(
                  child: Text(
                    "Active reminders",
                    style: TextStyle(
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),

              // streambuilder thing to connect to firestore
              // PRINT THE NUMBER OF ACTIVE REMINDERS (count the ones in the database)

              ])));
              
              
  }
}


class ReminderList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    
    /* return StreamBuilder<List<Medicine>>(
      stream: _globalBloc.medicineList$,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else if (snapshot.data.length == 0) { */
        
          return Scaffold(
            body: Container(
            color: Color(0xFFF6F8FC),
            child: Center(
              child: 
                
                //if there are no active reminders, print this
                Text("No active reminders",
                textAlign: TextAlign.center,
                style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFC9C9C9),
                    fontWeight: FontWeight.normal),
                ),


                //if there are active reminders, print them
                /* return Container(
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
                  ); */
                  


                )

            ));          
        } 
        }



/* class MedicineCard extends StatelessWidget {
  final Medicine medicine;

  MedicineCard(this.medicine);

  Hero makeIcon(double size) {
    if (medicine.medicineType == "Bottle") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: Icon(
          IconData(0xe900, fontFamily: "Ic"),
          color: Color(0xFF3EB16F),
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Pill") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: Icon(
          IconData(0xe901, fontFamily: "Ic"),
          color: Color(0xFF3EB16F),
          size: size,
        ),
      );
    } else if (medicine.medicineType == "Syringe") {
      return Hero(
        tag: medicine.medicineName + medicine.medicineType,
        child: Icon(
          IconData(0xe902, fontFamily: "Ic"),
          color: Color(0xFF3EB16F),
          size: size,
        ),
      );
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: InkWell(
        highlightColor: Colors.white,
        splashColor: Colors.grey,
        onTap: () {
          Navigator.of(context).push(
            PageRouteBuilder<Null>(
              pageBuilder: (BuildContext context, Animation<double> animation,
                  Animation<double> secondaryAnimation) {
                return AnimatedBuilder(
                    animation: animation,
                    builder: (BuildContext context, Widget child) {
                      return Opacity(
                        opacity: animation.value,
                        child: MedicineDetails(medicine),
                      );
                    });
              },
              transitionDuration: Duration(milliseconds: 500),
            ),
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                makeIcon(50.0),
                Hero(
                  tag: medicine.medicineName,
                  child: Material(
                    color: Colors.transparent,
                    child: Text(
                      medicine.medicineName,
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0xFF3EB16F),
                          fontWeight: FontWeight.w500),
                    ),
                  ),
                ),
                Text(
                  medicine.interval == 1
                      ? "Every " + medicine.interval.toString() + " hour"
                      : "Every " + medicine.interval.toString() + " hours",
                  style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC9C9C9),
                      fontWeight: FontWeight.w400),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
} */
 



