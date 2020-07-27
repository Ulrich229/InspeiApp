import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/student.dart';
import '../models/note.dart';
import '../models/lesson.dart';
import '../dummy_data.dart';
import '../models/login_exception.dart';

class Students with ChangeNotifier {
  List<Student> _students = [];
  Students(this._students);

  get studentt {
    return _students;
  }

  Future<void> addStudent(String nom, String prenom, String classe,
      List<Lesson> lessons, String email) async {
    List<Note> notes = [];
    lessons.forEach((element) {
      notes.add(Note(lessonId: element.id));
    });
    student = Student(
        email: email,
        id: null,
        nom: nom,
        prenom: prenom,
        classe: classe,
        notes: notes);
    final url = 'https://inspeiapp.firebaseio.com/Students.json';
    try {
      final response = await http.post(url,
          body: json.encode({
            'nom': nom,
            'prenom': prenom,
            'classe': classe,
            'notes': lessons
                .map((e) => {
                      'id': e.id,
                      'devoir1': 0,
                      'devoir2': 0,
                      'devoir3': 0,
                      'rattrapage': 0,
                    })
                .toList(),
            'email': email,
          }));
      final Map<String, dynamic> responseData = json.decode(response.body);
      if (responseData["error"] != null) {
        print('Enfin_');
        throw LoginException('${responseData['error']['message']}');
      }
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<String> fetchAndSetStudent(String email) async {
    final url = 'https://inspeiapp.firebaseio.com/Students.json';
    try {
      final response = await http.get(url);
      final extratedData = json.decode(response.body) as Map<String, dynamic>;
      if (extratedData == null) {
        print('Enfin');
        throw LoginException('EMAIL_NOT_FOUND');
      } else {
        final List<Student> loaded = [];
        extratedData.forEach((studentId, studentData) {
          loaded.add(Student(
            id: studentId,
            nom: studentData['nom'],
            prenom: studentData['prenom'],
            classe: studentData['classe'],
            notes: (studentData['notes'] as List<dynamic>).map((item) {
              return Note(
                lessonId: item['id'],
                devoir1: item['devoir1'].toDouble(),
                devoir2: item['devoir2'].toDouble(),
                devoir3: item['devoir3'].toDouble(),
                rattrapage: item['rattrapage'].toDouble(),
              );
            }).toList(),
            email: studentData['email'],
          ));
        });
        _students = loaded;
        student = null;
        _students.forEach((element) {
          if (element.email == email) {
            student = element;
          }
        });
        student == null ? throw LoginException('EMAIL_NOT_FOUND') : print('');
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }
}
