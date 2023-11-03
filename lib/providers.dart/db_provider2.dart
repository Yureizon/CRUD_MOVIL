import 'dart:io';
import 'package:crud/models.dart/course_model.dart';
import 'package:crud/models.dart/student_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';


class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database> get database async {
    if (_database != null) return _database!;

    _database = await initDB();

    return _database!;
  }

  Future<Database> initDB() async {
    //Obteniendo direccion base donde se guardará la base de datos
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    //Armamos la url donde quedará la base de datos
    final path = join(documentsDirectory.path, 'Entregable2DB.db');

    //Imprimos ruta
    print(path);

    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) => {},
      onCreate: (db, version) async {
        await db.execute('''

        CREATE TABLE students(
          id INTEGER PRIMARY KEY,
          identificationDocument INTEGER,
          name TEXT,
          age INTEGER
        );

        ''');

        await db.execute(''' 
          CREATE TABLE courses(
            id INTEGER PRIMARY KEY,
            courseName TEXT,
            credits INTEGER,
            docente TEXT
          );
        ''');
      },
    );
  }

  Future<int> newStudentRaw(Student student) async {
    final int? id = student.id;
    final int identificationDocument = student.identificationDocument;
    final String name = student.name;
    final int age = student.age;

    final db = await database; //Recibimos instancia de base de datos para trabajar con ella

    final int res = await db.rawInsert('''

      INSERT INTO students (id, identificationDocument, name, age) VALUES ($id, $identificationDocument, "$name", $age)

''');
    print(res);
    return res;
  }

  Future<int> newCourseRaw(Course course) async {
    final int? id = course.id;
    final String courseName = course.courseName;
    final int credits = course.credits;
    final String docente = course.docente;

    final db = await database; //Recibimos instancia de base de datos para trabajar con ella

    final int res = await db.rawInsert('''

      INSERT INTO courses (id, courseName, credits, docente) VALUES ($id, "$courseName", $credits, "$docente")

''');
    print(res);
    return res;
  }

  Future<int> newStudent(Student student) async {
    final db = await database;

    final int res = await db.insert("students", student.toJson());

    return res;
  }

  Future<int> newCourse(Course course) async {
    final db = await database;
    
    final int res = await db.insert("courses", course.toJson());

    return res;
  }

  //Obtener un registro de students por id
  Future<Student?> getStudentById(int id) async {
    final Database? db = await database;

    //usando Query para construir la consulta, con where y argumentos posicionales (whereArgs)
    final res = await db!.query('students', where: 'identificationDocument = ?', whereArgs: [id]);
    print(res);
    //Preguntamos si trae algun dato. Si lo hace
    return res.isNotEmpty ? Student.fromJson(res.first) : null;
  }

  //Obtener un registro de students por id
  Future<Course?> getCoursetById(int id) async {
    final Database? db = await database;

    //usando Query para construir la consulta, con where y argumentos posicionales (whereArgs)
    final res = await db!.query('courses', where: 'id = ?', whereArgs: [id]);
    print(res);
    //Preguntamos si trae algun dato. Si lo hace
    return res.isNotEmpty ? Course.fromJson(res.first) : null;
  }

  Future<List<Student>> getAllStudents() async {
    final Database? db = await database;
    final res = await db!.query('students');
    //Transformamos con la funcion map instancias de nuestro modelo. Si no existen registros, devolvemos una lista vacia
    return res.isNotEmpty ? res.map((n) => Student.fromJson(n)).toList() : [];
  }

  Future<List<Course>> getAllCourses() async {
    final Database? db = await database;
    final res = await db!.query('courses');
    //Transformamos con la funcion map instancias de nuestro modelo. Si no existen registros, devolvemos una lista vacia
    return res.isNotEmpty ? res.map((n) => Course.fromJson(n)).toList() : [];
  }

  Future<int> updateStudent(Student student) async {
    final Database db = await database;
    //con updates, se usa el nombre de la tabla, seguido de los valores en formato de Mapa, seguido del where con parametros posicionales y los argumentos finales
    final res = await db.update('students', student.toJson(), where: 'id = ?', whereArgs: [student.id]);
    return res;
  }

  Future<int> updateCourse(Course course) async {
    final Database db = await database;
    //con updates, se usa el nombre de la tabla, seguido de los valores en formato de Mapa, seguido del where con parametros posicionales y los argumentos finales
    final res = await db.update('courses', course.toJson(), where: 'id = ?', whereArgs: [course.id]);
    return res;
  }

  Future<int> deleteStudent(int id) async {
    final Database? db = await database;
    final int res = await db!.delete('students', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteCourse(int id) async {
    final Database? db = await database;
    final int res = await db!.delete('courses', where: 'id = ?', whereArgs: [id]);
    return res;
  }

  Future<int> deleteAllStudents() async {
    final Database? db = await database;
    final res = await db!.rawDelete('''
      DELETE FROM students    
    ''');
    return res;
  }

  Future<int> deleteAllCourses() async {
    final Database? db = await database;
    final res = await db!.rawDelete('''
      DELETE FROM courses    
    ''');
    return res;
  }
}