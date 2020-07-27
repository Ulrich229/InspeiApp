import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/student.dart';
import '../providers/lessons.dart';
import '../models/note.dart';
import '../providers/students.dart';
import '../dummy_data.dart' as dm;

class PerformanceScreen extends StatefulWidget {
  Student student;
  PerformanceScreen(this.student);

  @override
  _PerformanceScreenState createState() => _PerformanceScreenState();
}

class _PerformanceScreenState extends State<PerformanceScreen> {
  @override
  Widget build(BuildContext context) {
    Future<void> _refreshData(BuildContext context) async {
      try {
        await Provider.of<Students>(context, listen: false)
            .fetchAndSetStudent(widget.student.email);
        setState(() {
          widget.student = dm.student;
        });
      } catch (e) {
        Scaffold.of(context).hideCurrentSnackBar();
        Scaffold.of(context).showSnackBar(SnackBar(
          content: Text('Echec de la mise a jour des notes'),
          duration: Duration(seconds: 2),
        ));
      }
    }

    void bottomShit(Note notes, String lessonId, BuildContext ctx) {
      List<double> note = [
        notes.devoir1,
        notes.devoir2,
        notes.devoir3,
        notes.rattrapage
      ];
      double moyenne = note[3] == 0
          ? (note[2] == 0
              ? (note[0] + note[1]) / 2
              : (note[0] + note[1] + note[2]) / 3)
          : (note[3] >= 12 ? 12 : note[3]);
      showModalBottomSheet(
        context: ctx,
        builder: (_) => FractionallySizedBox(
          heightFactor: 0.43,
          child: Column(
            children: <Widget>[
              Container(
                child: Text(
                  '${Provider.of<Lessons>(ctx).lessonById(lessonId).name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                color: Theme.of(context).secondaryHeaderColor,
                width: double.infinity,
                height: 30,
                padding: EdgeInsets.only(top: 5, bottom: 4),
              ),
              Container(
                height: 125,
                child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (ctx, i) {
                    return Column(children: [
                      SizedBox(
                        height: 5,
                      ),
                      Row(
                        children: <Widget>[
                          i == 3
                              ? Text('Rattrapage')
                              : Text('Devoir N°${i + 1}'),
                          note[i] == 0
                              ? Text("--")
                              : Text(
                                  '${note[i]}',
                                  style: TextStyle(
                                      color: note[i] < 12
                                          ? Colors.red
                                          : Colors.greenAccent,
                                      fontSize: 14),
                                )
                        ],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                      Divider(),
                    ]);
                  },
                ),
              ),
              SizedBox(),
              Text(
                note[1] == 0 ? '' : '${moyenne.toStringAsFixed(2)}',
                style:
                    TextStyle(color: moyenne < 12 ? Colors.red : Colors.green),
              ),
              Divider(),
              SizedBox(),
              Container(
                width: MediaQuery.of(context).size.width / 2,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: note[1] == 0
                      ? Colors.indigo[200]
                      : (moyenne < 12 ? Colors.red : Colors.green),
                ),
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: FittedBox(
                    child: note[1] == 0
                        ? Text("En attente d'un second devoir")
                        : (moyenne < 12
                            ? Text(
                                'Non validée',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18),
                              )
                            : Text('Validée',
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))),
                  ),
                ),
              )
            ],
          ),
        ),
        isScrollControlled: true,
      );
    }

    return RefreshIndicator(
      onRefresh: () => _refreshData(context),
      child: ListView.builder(
          itemCount: widget.student.notes.length,
          itemBuilder: (ctx, i) {
            return InkWell(
                key: ValueKey(widget.student.notes[i].lessonId),
                child: Container(
                  height: 30,
                  decoration: BoxDecoration(
                    color: Colors.black87,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: EdgeInsets.only(top: 5, bottom: 5),
                  padding: EdgeInsets.only(top: 6, bottom: 4),
                  child: Column(
                    children: [
                      Text(
                        '${Provider.of<Lessons>(context).lessonById(widget.student.notes[i].lessonId).name}',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Lato',
                            color: Colors.white70),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  if (widget.student.notes[i].devoir1 == 0) {
                    Scaffold.of(context).hideCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(SnackBar(
                      duration: Duration(seconds: 2),
                      content: Text(
                          'Les notes de cette matière ne sont pas encore disponibles'),
                    ));
                  } else {
                    bottomShit(widget.student.notes[i],
                        widget.student.notes[i].lessonId, context);
                  }
                });
          }),
    );
  }
}
