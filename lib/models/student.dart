import 'package:flutter/material.dart';

import '../models/note.dart';

class Student {
  String id;
  String nom;
  String prenom;
  String classe;
  String email;
  List<Note> notes;
  Student(
      {@required this.id,
      @required this.nom,
      @required this.prenom,
      @required this.classe,
      @required this.notes,
      @required this.email});
}
