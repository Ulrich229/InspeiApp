import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/lessons.dart';
import './providers/students.dart';
import './providers/auth.dart';
import './screens/main_screen.dart';
import './screens/auth_screen.dart';
import './dummy_data.dart';

void main() => runApp(MyApp());
enum IsConnected { Yes, No }

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Lessons()),
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Students>(
          create: null,
          update: (ctx, auth, previousStudents) => Students(
              previousStudents == null ? [] : previousStudents.studentt),
        ),
      ],
      child: MaterialApp(
          theme: ThemeData(
              primaryColor: Colors.blueGrey, secondaryHeaderColor: Colors.grey),
          home: StartScreen(),
          routes: {
            AuthScreen.routeName: (ctx) => AuthScreen(),
          }),
    );
  }
}

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            theme: ThemeData(
                primaryColor: Colors.blueGrey,
                secondaryHeaderColor: Colors.grey),
            home: (!(auth.token == null) && !(student == null))
                ? MainScreen()
                : AuthScreen()));
  }
}
