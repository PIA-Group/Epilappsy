import 'package:casia/Database/Survey.dart';
import 'package:casia/Widgets/appBar.dart';
import 'package:casia/main.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import '../app_localizations.dart';

class EventsPage extends StatefulWidget {
  final List<List<String>> seizure;

  const EventsPage({Key key, this.seizure}) : super(key: key);

  @override
  _EventsPageState createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  Survey _survey;
  bool _isLoading = true;

  void updateAllSurveys() {
    /* getDefaultSurvey().then((dSurvey) => {
          this.setState(() {
            this._survey = dSurvey;
            this._isLoading = false;
          })
        }); */
  }

  @override
  void initState() {
    super.initState();
    updateAllSurveys();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0.0,
          title: appBarTitle(context, 'Events'),
          backgroundColor: mycolor,
        ),
        body: _isLoading
            ? Container(
                child: Center(child: CircularProgressIndicator()),
              )
            : ListView(
                children: _listView(context, widget.seizure[1] != []),
              ));
  }

  List<ListTile> _listView(BuildContext context, bool hasAnswers) {
    List<String> answers = widget.seizure[1];
    List<ListTile> _tiles = [
      ListTile(
        title: Text(AppLocalizations.of(context).translate('date').inCaps),
        subtitle: Text(
            AppLocalizations.of(context).translate(widget.seizure[0][0]) ??
                widget.seizure[0][0]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('time').inCaps),
        subtitle: Text(
            AppLocalizations.of(context).translate(widget.seizure[0][1]) ??
                widget.seizure[0][1]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('duration').inCaps),
        subtitle: Text(AppLocalizations.of(context)
                .translate(widget.seizure[0][2] ?? "unknown").inCaps ??
            widget.seizure[0][2]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('type').inCaps),
        subtitle: Text(AppLocalizations.of(context)
                .translate(widget.seizure[0][3] ?? "unknown").inCaps ??
            widget.seizure[0][3]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('mood').inCaps),
        subtitle: Text(AppLocalizations.of(context)
                .translate(widget.seizure[0][4] ?? "unknown").inCaps ??
            widget.seizure[0][4]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('possible trigger').capitalizeFirstofEach +
                ': ' +
                AppLocalizations.of(context)
                    .translate(widget.seizure[0][5] ?? "unknown").inCaps ??
            widget.seizure[0][5]),
        subtitle: Text(AppLocalizations.of(context).translate('notes').inCaps +
                ': ' +
                AppLocalizations.of(context)
                    .translate(widget.seizure[0][6] ?? "unknown").inCaps ??
            widget.seizure[0][6]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('description').inCaps +
                ': ' +
                AppLocalizations.of(context)
                    .translate(widget.seizure[0][7] ?? "--") ??
            widget.seizure[0][7]),
        subtitle: Text(AppLocalizations.of(context).translate('notes').inCaps +
                ': ' +
                AppLocalizations.of(context)
                    .translate(widget.seizure[0][8] ?? "--") ??
            widget.seizure[0][8]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('post events').capitalizeFirstofEach +
                ': ' +
                AppLocalizations.of(context)
                    .translate(widget.seizure[0][9] ?? "--") ??
            widget.seizure[0][9]),
        subtitle: Text(AppLocalizations.of(context).translate('notes').inCaps +
                ': ' +
                AppLocalizations.of(context)
                    .translate(widget.seizure[0][10] ?? "--") ??
            widget.seizure[0][10]),
      ),
    ];
    if (hasAnswers) {
      for (var i = 0; i < answers.length; i++) {
        _tiles.add(ListTile(
          title: Text(_survey.questionList[i]),
          subtitle: Text(AppLocalizations.of(context).translate('answer').inCaps +
                  ': ' +
                  AppLocalizations.of(context)
                      .translate(widget.seizure[1][i]) ??
              widget.seizure[1][i]),
        ));
      }
    }
    return _tiles;
  }
}
