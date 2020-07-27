import 'package:flutter/material.dart';

class Note {
  String lessonId;
  double devoir1;
  double devoir2;
  double devoir3;
  double rattrapage;
  Note(
      {this.devoir1 = 0,
      this.devoir2 = 0,
      this.devoir3 = 0,
      this.rattrapage = 0,
      @required this.lessonId});
}
