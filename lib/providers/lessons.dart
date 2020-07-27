import 'package:flutter/material.dart';

import '../models/lesson.dart';

class Lessons with ChangeNotifier {
  List<Lesson> _lessons = [
    Lesson(
        id: '-MBx7Zd6OhsKR5AoafXN',
        name: 'Résistance des matériaux',
        classes: ['CP1']),
    Lesson(
        id: '-MBx7ZdAxxh4P0MKjhDp',
        name: "Statique de l'ingénieur",
        classes: ['CP1']),
    Lesson(
        id: '-MBx7ZdNzr04MdMjByFH',
        name: 'Probabilité et Statistique',
        classes: ['CP1']),
    Lesson(
        id: '-MBx7ZeWTN8VdsRKo4vV',
        name: 'Graphe et Optimisation',
        classes: ['CP1']),
    Lesson(
        id: '-MBx7Zk8Fd2PDYyL2KIk', name: 'Anglais', classes: ['CP1', 'CP2']),
    Lesson(
        id: '-MBx7aWb2fJILAI3d4K0',
        name: 'Cinématique et dynamique',
        classes: ['CP1']),
    Lesson(
        id: '-MBx7dKZoP4FDgSmzddL',
        name: 'Analyse Numérique',
        classes: ['CP1']),
    Lesson(id: '-MBx7ZdNzr04MdMjByFI', name: 'Maths I', classes: ['CP1']),
    Lesson(id: '-MBx7_502WIU2XsM95', name: 'Maths II', classes: ['CP1']),
    Lesson(id: '-MBx7ZhK8c2ldvYS26Bc', name: 'Algorithmique', classes: ['CP1']),
    Lesson(
        id: '-MBx7Zjfi1kHRTXXd4Cw',
        name: 'Langage et Programmation',
        classes: ['CP1']),
    Lesson(
        id: '-MBx7Zd8y7MInx16eJUh', name: 'Thermodynamique', classes: ['CP1']),
    Lesson(
        id: '-MBx7ZdI1_og3K0EaApp', name: 'Sport I', classes: ['CP1', 'CP2']),
    Lesson(
        id: '-MBx7ZdKoRUWSGvjiC-J', name: 'Sport II', classes: ['CP1', 'CP2']),
    Lesson(
        id: '-MBx7chQrR2tAjKxwxnv',
        name: 'Mécanique des fluides',
        classes: ['CP2']),
    Lesson(
        id: '-MBx7lTqOLXxunbwnY7C',
        name: "Biologie de l'ingénieur",
        classes: ['CP2']),
    Lesson(
        id: '-MBx7ZdLT5wwnfF1W3X5',
        name: 'Modélisation des phénomènes aléatoires',
        classes: ['CP2']),
    Lesson(id: '-MBx7gLurtLqVprCIwuq', name: 'TEMC', classes: ['CP2', 'CP1']),
    Lesson(
        id: '-MBx7chQrR2tAjKxwxnu',
        name: 'Recherche Opérationnelle',
        classes: ['CP2']),
    Lesson(
        id: '-MBx7ZdNzr04MdMjByFG',
        name: "Physique des Matériaux",
        classes: ['CP2']),
    Lesson(
        id: '-MBx7_DV5YWjpm8BzImu',
        name: 'Transfert thermique',
        classes: ['CP2']),
    Lesson(
        id: '-MBx7_BlnUst20d8TSsy',
        name: 'Dessin Technique/Assisté par Ordinateur',
        classes: ['CP2']),
    Lesson(id: '-MBx7_6aBRWKQUmQLvkb', name: 'Maths III', classes: ['CP2']),
    Lesson(id: '-MBx7Zk0X3g3WZKvdKL2', name: 'Maths IV', classes: ['CP2']),
    Lesson(
        id: '-MBx7_8KZWsii6ZLCFqo',
        name: 'Méthode numérique de Calcul',
        classes: ['CP2']),
    Lesson(id: '-MBx7frU0y8DsnLSxVO5', name: 'Electricité', classes: ['CP2']),
    Lesson(
        id: '-MBx7ae2XkIixe5pd7sQ',
        name: 'Onde et Electromagnétisme',
        classes: ['CP2']),
  ];

  List<Lesson> lessons(String classe) {
    return _lessons
        .where((element) => element.classes.contains(classe))
        .toList();
  }

  Lesson lessonById(String id) {
    return _lessons.firstWhere((element) => element.id == id);
  }
}
