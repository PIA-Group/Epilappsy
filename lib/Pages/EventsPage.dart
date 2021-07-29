import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';

//for the dictionaries
import 'package:flutter_localizations/flutter_localizations.dart';
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
        title: Text(AppLocalizations.of(context).translate('date'.inCaps)),
        subtitle: Text(widget.seizure[0][0]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('time'.inCaps)),
        subtitle: Text(widget.seizure[0][1]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('duration'.inCaps)),
        subtitle: Text(widget.seizure[0][2]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('type'.inCaps)),
        subtitle: Text(widget.seizure[0][2]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('mood'.inCaps)),
        subtitle: Text(widget.seizure[0][3]),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('possible Trigger${widget.seizure[0][4]}'.inCaps)+": "),
        subtitle: Text(AppLocalizations.of(context).translate('notes${widget.seizure[0][5]}'.inCaps)+": "),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('description${widget.seizure[0][4]}'.inCaps)+": "),
        subtitle: Text(AppLocalizations.of(context).translate('notes${widget.seizure[0][5]}'.inCaps)+": "),
      ),
      ListTile(
        title: Text(AppLocalizations.of(context).translate('post events${widget.seizure[0][4]}'.inCaps)+": "),
        subtitle: Text(AppLocalizations.of(context).translate('notes${widget.seizure[0][5]}'.inCaps)+": "),
      ),
    ];
    if (hasAnswers) {
      for (var i = 0; i < answers.length; i++) {
        _tiles.add(ListTile(
          title: Text(_survey.questionList[i]),
          subtitle: Text(AppLocalizations.of(context).translate('answer${widget.seizure[1][i]}'.inCaps)+": "),
        ));
      }
    }
    return _tiles;
  }
}
