import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Widgets/appBar.dart';
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
    getDefaultSurvey().then((dSurvey) => {
          this.setState(() {
            this._survey = dSurvey;
            this._isLoading = false;
          })
        });
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
          title: appBarTitle(context),
          backgroundColor: Color.fromRGBO(71, 123, 117, 1),
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
        title: Text(AppLocalizations.of(context).translate('Date')),
        subtitle: Text(AppLocalizations.of(context).translate(widget.seizure[0][0])??widget.seizure[0][0]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('Time')),
        subtitle: Text(AppLocalizations.of(context).translate(widget.seizure[0][1])??widget.seizure[0][1]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('Duration')),
        subtitle: Text(AppLocalizations.of(context).translate(widget.seizure[0][2]??'Unknown')??widget.seizure[0][2]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('Type')),
        subtitle: Text(AppLocalizations.of(context).translate(widget.seizure[0][3]??'Unknown')??widget.seizure[0][3]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('Mood')),
        subtitle: Text(AppLocalizations.of(context).translate(widget.seizure[0][4]??'Unknown')??widget.seizure[0][4]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('Possible Trigger') + ': ' + AppLocalizations.of(context).translate(widget.seizure[0][5]??"Unknown")??widget.seizure[0][5]),
        subtitle: Text(AppLocalizations.of(context).translate('Notes') + ': ' + AppLocalizations.of(context).translate(widget.seizure[0][6]??"Unknown")??widget.seizure[0][6]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('Description') + ': ' + AppLocalizations.of(context).translate(widget.seizure[0][7]??"--")??widget.seizure[0][7]),
        subtitle: Text(AppLocalizations.of(context).translate('Notes') + ': ' + AppLocalizations.of(context).translate(widget.seizure[0][8]??"--")??widget.seizure[0][8]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('Post Events') + ': ' + AppLocalizations.of(context).translate(widget.seizure[0][9]??"--")??widget.seizure[0][9]),
        subtitle: Text(AppLocalizations.of(context).translate('Notes') + ': ' + AppLocalizations.of(context).translate(widget.seizure[0][10]??"--")??widget.seizure[0][10]),
      ),
    ];
    if (hasAnswers) {
      for (var i = 0; i < answers.length; i++) {
        _tiles.add(ListTile(
          title: Text(_survey.questionList[i]),
          subtitle: Text(AppLocalizations.of(context).translate('Answer') + ': ' + AppLocalizations.of(context).translate(widget.seizure[1][i])??widget.seizure[1][i]),
        ));
      }
    }
    return _tiles;
  }
}
