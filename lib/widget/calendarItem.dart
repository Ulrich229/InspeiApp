import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class CalendarItem extends StatefulWidget {
  final String text;
  final String imageLink;
  CalendarItem({@required this.text, @required this.imageLink});

  @override
  _CalendarItemState createState() => _CalendarItemState();
}

class _CalendarItemState extends State<CalendarItem> {
  bool _expand = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      color: Colors.white,
      duration: Duration(milliseconds: 300),
      height: _expand ? MediaQuery.of(context).size.height / 2 : 57,
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text(
              '${widget.text}',
              style: TextStyle(
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                  fontFamily: 'Lato'),
            ),
            trailing: IconButton(
                icon: Icon(_expand ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expand = !_expand;
                  });
                }),
          ),
          AnimatedContainer(
            color: Colors.white,
            width: double.infinity,
            duration: Duration(milliseconds: 300),
            height: _expand ? MediaQuery.of(context).size.height / 3 : 0,
            child: Container(
              child: _expand
                  ? (widget.imageLink == '_'
                      ? Center(
                          child: Text(
                            '❗🤔Erreur de chargement de l\'emploi du temps.\n- Vérifiez votre connexion internet. Et faites glisser votre doigt du haut vers le bas',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontStyle: FontStyle.italic),
                          ),
                        )
                      : PhotoView(
                          imageProvider: NetworkImage(widget.imageLink),
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                        ))
                  : null,
              width: double.infinity,
            ),
          )
        ],
      ),
    );
  }
}
