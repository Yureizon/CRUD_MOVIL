import 'package:crud/models.dart/course_model.dart';
import 'package:flutter/material.dart';
//import 'package:crud/models.dart/note_model.dart';
//import 'db_provider.dart';
import 'db_provider2.dart';

class CoursesProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String createOrUpdate = "create";
  int? id ;
  String courseName= '';
  int credits = 0;
  String docente= '';

  bool _isLoading = false;
  List<Course> courses = [];

  bool get isLoading => _isLoading;

  set isLoading(bool opc) {
    _isLoading = opc;
  }

  bool isValidForm() {
    print(formKey.currentState?.validate());

    return formKey.currentState?.validate() ?? false;
  }

  Future<Course> addCourse() async {
    final Course course = Course(id: this.id, courseName: courseName, credits: credits, docente: docente);

    final id = await DBProvider.db.newCourse(course);

    course.id = id;

    courses.add(course);

    notifyListeners();

    return course;
  }

  deleteCourseById(int id) async {
    final res = DBProvider.db.deleteCourse(id);
    loadCourses();
  }

  updateCourse() async {
    final course = Course(id: id, courseName: courseName, credits: credits, docente: docente);
    final res = await DBProvider.db.updateCourse(course);
    print("Updated ID: $res");
    loadCourses();
  }

  assignDataWithCourse(Course course) {
    id = course.id;
    courseName = course.courseName;
    credits = course.credits;
    docente = course.docente;
  }

  resetCourseData() {
    id = null;
    courseName = "";
    credits = 0;
    docente = "";
    createOrUpdate = "create";
  }

  loadCourses() async {
    final List<Course> courses = await DBProvider.db.getAllCourses();
    //operador Spreed
    this.courses = [...courses];
    notifyListeners();
  }
}