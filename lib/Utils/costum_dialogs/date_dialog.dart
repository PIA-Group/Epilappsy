import 'package:casia/Utils/app_localizations.dart';
import 'package:casia/design/colors.dart';
import 'package:casia/design/text_style.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import 'package:casia/main.dart';

class DateDialog extends StatefulWidget {
  final String title;
  final IconData icon;
  final ValueNotifier<dynamic> datePicker;
  final bool allowMultiple;

  const DateDialog({
    Key key,
    this.title,
    this.icon,
    this.datePicker,
    this.allowMultiple = true,
  }) : super(key: key);

  @override
  _DateDialogState createState() => _DateDialogState();
}

class _DateDialogState extends State<DateDialog> {
  DateRangePickerController datePickerController = DateRangePickerController();
  Function doAfterDone;

  @override
  void initState() {
    widget.allowMultiple
        ? datePickerController.selectedDates = widget.datePicker.value
        : datePickerController.selectedDate = widget.datePicker.value;
    super.initState();
  }

  @override
  void dispose() {
    datePickerController.dispose();
    super.dispose();
  }

  void _onSelectionChanged(DateRangePickerSelectionChangedArgs args) {
    if (widget.allowMultiple) {
      final List<DateTime> selectedDates = args.value;
      setState(() => widget.datePicker.value = selectedDates);
    } else {
      final DateTime selectedDates = args.value;
      setState(() => widget.datePicker.value = selectedDates);
    }
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
        selectionMode: widget.allowMultiple
            ? DateRangePickerSelectionMode.multiple
            : DateRangePickerSelectionMode.single,
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
            getDatePicker(),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: doAfterDone,
                child: Text(AppLocalizations.of(context)
                                      .translate('save').inCaps, style: MyTextStyle()))
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
