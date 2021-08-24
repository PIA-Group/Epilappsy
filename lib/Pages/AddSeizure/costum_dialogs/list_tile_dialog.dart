import 'package:casia/Pages/Medication/medication_answers.dart';
import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';

class ListTileDialog extends StatefulWidget {
  final List listOfTiles;
  final ValueNotifier<int> selectedIndex;
  final ValueNotifier<MedicationAnswers> medicineAnswers;
  final String title;
  final dynamic icon;

  const ListTileDialog({
    Key key,
    this.listOfTiles,
    this.selectedIndex,
    this.medicineAnswers,
    this.title,
    this.icon,
  }) : super(key: key);

  @override
  _ListTileDialogState createState() => _ListTileDialogState();
}

class _ListTileDialogState extends State<ListTileDialog> {
  Function doAfterDone;

  Widget getListTiles() {
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return ListView.builder(
        shrinkWrap: true,
        itemCount: widget.listOfTiles.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
            color: index == widget.selectedIndex.value
                ? DefaultColors.mainColor
                : Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
            child: ListTile(
              leading: widget.listOfTiles[index].icon.runtimeType != ImageIcon ? Icon(
                widget.listOfTiles[index].icon,
                size: 30,
              ) : widget.listOfTiles[index].icon,
              title: Text(widget.listOfTiles[index].label),
              selected: index == widget.selectedIndex.value,
              onTap: () {
                setState(() {
                  widget.selectedIndex.value = index;
                  //widget.selectedIndex.notifyListeners();
                });
              },
            ),
          );
        });
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
          padding: EdgeInsets.only(left: 20, top: 60, right: 20, bottom: 20),
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
            Text(
              widget.title,
              textAlign: TextAlign.center,
              style: MyTextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
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
                child: Icon(widget.icon,
                    size: 30, color: DefaultColors.accentColor),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
