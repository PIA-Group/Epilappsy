import 'package:casia/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';

class CheckboxDialog extends StatefulWidget {
  final List<String> listOfCheckboxes;
  final ValueNotifier<List<dynamic>> answers;
  final int index;
  final String title;
  final IconData icon;

  const CheckboxDialog({
    Key key,
    this.listOfCheckboxes,
    this.answers,
    this.title,
    this.index,
    this.icon,
  }) : super(key: key);

  @override
  _CheckboxDialogState createState() => _CheckboxDialogState();
}

class _CheckboxDialogState extends State<CheckboxDialog> {
  Function doAfterDone;

  Widget getListTiles() {
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return ListView(
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,
        children: widget.listOfCheckboxes.asMap().entries.map((e) {
          return new CheckboxListTile(
            title: new Text(e.value),
            value: widget.answers.value[widget.index][e.key],
            onChanged: (bool value) {
              setState(() {
                widget.answers.value[widget.index][e.key] = value;
              });
              setState(() {
                setState(() => widget.answers.value = List.from(widget.answers.value));
              });
            },
          );
        }).toList(),
      );
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