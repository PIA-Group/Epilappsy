import 'package:epilappsy/Database/Survey.dart';
import 'package:epilappsy/Database/database.dart';
import 'package:epilappsy/Widgets/appBar.dart';
import 'package:flutter/material.dart';

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
        title: Text('Date'),
        subtitle: Text(widget.seizure[0][0]),
      ),
      ListTile(
        title: Text('Time'),
        subtitle: Text(widget.seizure[0][1]),
      ),
      ListTile(
        title: Text('Duration'),
        subtitle: Text(widget.seizure[0][2]),
      ),
      ListTile(
        title: Text('Type'),
        subtitle: Text(widget.seizure[0][2]),
      ),
      ListTile(
        title: Text('Mood'),
        subtitle: Text(widget.seizure[0][3]),
      ),
      ListTile(
        title: Text('Possible Trigger: ${widget.seizure[0][4]}'),
        subtitle: Text('Notes: ${widget.seizure[0][5]}'),
      ),
      ListTile(
        title: Text('Description: ${widget.seizure[0][4]}'),
        subtitle: Text('Notes: ${widget.seizure[0][5]}'),
      ),
      ListTile(
        title: Text('Post Events: ${widget.seizure[0][4]}'),
        subtitle: Text('Notes: ${widget.seizure[0][5]}'),
      ),
    ];
    if (hasAnswers) {
      for (var i = 0; i < answers.length; i++) {
        _tiles.add(ListTile(
          title: Text(_survey.questionList[i]),
          subtitle: Text('Answer: ${widget.seizure[1][i]}'),
        ));
      }
    }
    return _tiles;
  }
}
