import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:epilappsy/Widgets/appBar.dart';

import 'medicine.dart';


class MedicineDetails extends StatelessWidget {
  final Medicine medicine;

  MedicineDetails(this.medicine);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
        ),
        );
  
}
  }

