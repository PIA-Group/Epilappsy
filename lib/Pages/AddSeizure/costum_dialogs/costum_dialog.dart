import 'dart:ui';
import 'package:epilappsy/Pages/AddSeizure/questionnaire_tiles.dart';
import 'package:epilappsy/design/colors.dart';
import 'package:epilappsy/design/text_style.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';

class CustomDialogBox extends StatefulWidget {
  final ValueNotifier<String> textNotifier;
  final List<IconTile> listOfTiles;
  final ValueNotifier<int> selectedIndex;
  final ValueNotifier<String> duration;
  final String title;
  final IconData icon;
  final String type;
  final ValueNotifier<List<DateTime>> datePicker;

  const CustomDialogBox({
    Key key,
    this.listOfTiles,
    this.selectedIndex,
    this.duration,
    this.title,
    this.icon,
    this.type,
    this.datePicker,
    this.textNotifier,
  }) : super(key: key);

  @override
  _CustomDialogBoxState createState() => _CustomDialogBoxState();
}

class _CustomDialogBoxState extends State<CustomDialogBox> {
  DateRangePickerController datePickerController = DateRangePickerController();
  TextEditingController textFieldController = TextEditingController();
  Function doAfterDone;

  @override
  void initState() {
    if (widget.type == 'date')
      datePickerController.selectedDates = widget.datePicker.value;
    else if (widget.type == 'duration') super.initState();
  }

  @override
  void dispose() {
    datePickerController.dispose();
    textFieldController.dispose();
    super.dispose();
  }

  Widget getTextField() {
    setState(() {
      doAfterDone = () {
        widget.textNotifier.value = textFieldController.text;
        Navigator.pop(context);
      };
    });
    return TextField(
      cursorColor: DefaultColors.textColorOnLight,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultColors.mainColor),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultColors.mainColor),
        ),
        border: UnderlineInputBorder(
          borderSide: BorderSide(color: DefaultColors.mainColor),
        ),
      ),
      style: MyTextStyle(),
      autofocus: true,
      controller: textFieldController,
    );
  }

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
              leading: Icon(
                widget.listOfTiles[index].icon,
                size: 30,
              ),
              title: Text(widget.listOfTiles[index].label),
              selected: index == widget.selectedIndex.value,
              onTap: () {
                setState(() {
                  widget.selectedIndex.value = index;
                });
              },
            ),
          );
        });
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    final List<DateTime> selectedDates = args.value;
    setState(() => widget.datePicker.value = selectedDates);
  }

  Widget getDurationPicker() {
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return Container(
        height: MediaQuery.of(context).copyWith().size.height / 3,
        child: CupertinoTimerPicker(
            initialTimerDuration: Duration(
                minutes: int.parse(widget.duration.value.split(':')[1]),
                seconds:
                    double.parse(widget.duration.value.split(':')[2]).round()),
            mode: CupertinoTimerPickerMode.ms,
            onTimerDurationChanged: (value) {
              setState(() {
                widget.duration.value = value.toString();
                print(widget.duration.value);
              });
            }));
  }

  Widget getDatePicker() {
    setState(() {
      doAfterDone = () {
        Navigator.pop(context);
      };
    });
    return Container(
      child: SfDateRangePicker(
        selectionColor: DefaultColors.mainColor,
        onSelectionChanged: _onSelectionChanged,
        controller: datePickerController,
        view: DateRangePickerView.month,
        selectionMode: DateRangePickerSelectionMode.multiple,
        monthViewSettings: DateRangePickerMonthViewSettings(
            viewHeaderHeight: 0, showTrailingAndLeadingDates: true),
      ),
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
            if (widget.type == 'listTile')
              getListTiles()
            else if (widget.type == 'date')
              getDatePicker()
            else if (widget.type == 'duration')
              getDurationPicker()
            else if (widget.type == 'textfield')
              getTextField(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text('Done', style: MyTextStyle()))
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
