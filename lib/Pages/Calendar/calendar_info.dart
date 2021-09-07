import 'package:casia/Pages/Calendar/calendar_utils.dart';
import 'package:property_change_notifier/property_change_notifier.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarInfo extends PropertyChangeNotifier<String> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay;
  List<Event> _selectedEvents = [];
  DateTime _rangeStart;
  DateTime _rangeEnd;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  int _selectedMonth = DateTime.now().month;
  

  DateTime get focusedDay => _focusedDay;
  DateTime get selectedDay => _selectedDay;
  List<Event> get selectedEvents => _selectedEvents;
  DateTime get rangeStart => _rangeStart;
  DateTime get rangeEnd => _rangeEnd;
  RangeSelectionMode get rangeSelectionMode => _rangeSelectionMode;
  CalendarFormat get calendarFormat => _calendarFormat;
  int get selectedMonth => _selectedMonth;

  dynamic get(String key) => <String, dynamic>{
        'focusedDay': _focusedDay,
        'selectedDay': _selectedDay,
        'selectedEvents': _selectedEvents,
        'rangeStart': _rangeStart,
        'rangeEnd': _rangeEnd,
        'rangeSelectionMode': _rangeSelectionMode,
        'calendarFormat': _calendarFormat,
        'selectedMonth':_selectedMonth,
      }[key];

  set focusedDay(DateTime value) {
    _focusedDay = value;
    notifyListeners('focusedDay');
  }
  set selectedDay(DateTime value) {
    _selectedDay = value;
    notifyListeners('selectedDay');
  }
  set selectedEvents(List<Event> value) {
    _selectedEvents = value;
    notifyListeners('selectedEvents');
  }
  set rangeStart(DateTime value) {
    _rangeStart = value;
    notifyListeners('rangeStart');
  }
  set rangeEnd(DateTime value) {
    _rangeEnd = value;
    notifyListeners('rangeEnd');
  }
  set rangeSelectionMode(RangeSelectionMode value) {
    _rangeSelectionMode = value;
    notifyListeners('rangeSelectionMode');
  }
  set calendarFormat(CalendarFormat value) {
    _calendarFormat = value;
    notifyListeners('calendarFormat');
  }
  set selectedMonth(int value) {
    _selectedMonth = value;
    notifyListeners('selectedMonth');
  }
}
