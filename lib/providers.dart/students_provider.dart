import 'package:crud/models.dart/student_model.dart';
import 'package:flutter/material.dart';
//import 'package:crud/models.dart/note_model.dart';
//import 'db_provider.dart';
import 'db_provider2.dart';

class StudentsProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String createOrUpdate = "create";
  int? id;
  int identificationDocument = 0;
  String name= '';
  int age = 0;

  bool _isLoading = false;
  List<Student> students = [];

  bool get isLoading => _isLoading;

  set isLoading(bool opc) {
    _isLoading = opc;
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }

  Future<Student> addStudent() async {
    final Student student = Student(identificationDocument: identificationDocument, name: name, age: age);

    final id = await DBProvider.db.newStudent(student);

    student.id = id;

    students.add(student);

    notifyListeners();

    return student;
  }

  deleteStudentById(int id) async {
    final res = await DBProvider.db.deleteStudent(id);
    loadStudents();
  }

  updateStudent() async {
    final student = Student(id: id, identificationDocument: identificationDocument, name: name, age: age);
    final res = await DBProvider.db.updateStudent(student);
    print("Updated ID: $res");
    loadStudents();
  }

  assignDataWithStudent(Student student) {
    id = student.id;
    identificationDocument = student.identificationDocument;
    name = student.name;
    age = student.age;
  }

  resetStudentData() {
    id = 0;
    identificationDocument = 0;
    name = "";
    age = 0;
    createOrUpdate = "create";
  }

  loadStudents() async {
    final List<Student> students = await DBProvider.db.getAllStudents();
    //operador Spreed
    this.students = [...students];
    notifyListeners();
  }
}