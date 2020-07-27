import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './calendar_screen.dart';
import './perf_screen.dart';
import '../providers/students.dart';
import '../providers/auth.dart';
import '../dummy_data.dart';
import '../providers/calendars.dart';

enum IsConnected { No, Yes }

class MainScreen extends StatefulWidget {
  /* static String routeName = "/mainScreen"; */
  @override
  void initState() {}
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedPageIndex = 0;
  void _selectPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Map<String, Object>> _pages = [
      {
        'page': CalendarScreen(),
        'title': 'Emploi du temps',
      },
      {
        'page': PerformanceScreen(student),
        'title': 'Mes performances',
      },
    ];
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProvider.value(value: Calendars()),
        ChangeNotifierProvider.value(value: Students([]))
      ],
      child: Consumer<Auth>(
          builder: (ctx, auth, _) => Scaffold(
                appBar: AppBar(
                  title: Text(
                    _pages[_selectedPageIndex]['title'],
                    style: TextStyle(
                        fontSize: 15,
                        fontStyle: FontStyle.italic,
                        fontFamily: 'Anto'),
                  ),
                  actions: <Widget>[
                    Row(
                      children: <Widget>[
                        Text('${student.nom} ${student.prenom}'),
                        PopupMenuButton(
                            onSelected: (_) {
                              Navigator.of(context).pushReplacementNamed('/');
                              student = null;
                              Provider.of<Auth>(context, listen: false)
                                  .disconnect();
                            },
                            icon: Icon(Icons.contacts),
                            itemBuilder: (_) => [
                                  PopupMenuItem(
                                    child: Text("Deconnexion"),
                                    value: IsConnected.No,
                                  ),
                                ]),
                      ],
                    ),
                  ],
                ),
                body: _pages[_selectedPageIndex]['page'],
                bottomNavigationBar: BottomNavigationBar(
                  selectedIconTheme: IconThemeData(color: Colors.black87),
                  unselectedIconTheme: IconThemeData(color: Colors.grey),

                  onTap: _selectPage,
                  backgroundColor: Theme.of(context).primaryColor,
                  unselectedItemColor: Colors.grey,
                  selectedItemColor: Colors.black87,
                  currentIndex: _selectedPageIndex,
                  // type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.calendar_today),
                      title: Text('Programmes'),
                    ),
                    BottomNavigationBarItem(
                      backgroundColor: Theme.of(context).primaryColor,
                      icon: Icon(Icons.library_books),
                      title: Text('Performences'),
                    ),
                  ],
                ),
              )),
    );
  }
}
