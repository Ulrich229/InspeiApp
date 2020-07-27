import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widget/calendarItem.dart';
import '../providers/calendars.dart';
import '../dummy_data.dart';

class CalendarScreen extends StatefulWidget {
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  int i = 0;
  bool _fetched;
  bool _isLoading;
  Future<void> _fetch(BuildContext context) async {
    try {
      print('start fetching');
      await Provider.of<Calendars>(context).fetchCalendars(student.classe);
      setState(() {
        _fetched = true;
      });
    } catch (e) {
      setState(() {
        _fetched = false;
      });
    }
  }

  @override
  void initState() {
    setState(() {
      _isLoading = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading == true) {
      _fetch(context).then((value) {
        setState(() {
          _isLoading = false;
        });
      });
      i = 1;
    }
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : RefreshIndicator(
            onRefresh: () {
              setState(() {
                _isLoading = true;
              });
            },
            child: ListView(
              children: <Widget>[
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    CalendarItem(
                      imageLink:
                          _fetched ? Provider.of<Calendars>(context).url1 : '_',
                      text: 'Semaine en cours',
                    ),
                    CalendarItem(
                        text: 'Semaine prochaine',
                        imageLink: _fetched
                            ? Provider.of<Calendars>(context).url2
                            : '_'),
                  ],
                )
              ],
            ),
          );
  }
}
