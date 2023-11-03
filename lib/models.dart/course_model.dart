// To parse this JSON data, do
//
//     final course = courseFromJson(jsonString);

import 'dart:convert';
//course
Course courseFromJson(String str) => Course.fromJson(json.decode(str));

String courseToJson(Course data) => json.encode(data.toJson());

class Course {
  int? id;
  String courseName;
  int credits;
  String docente;

  Course({
    this.id,
    required this.courseName,
    required this.credits,
    required this.docente,
  });

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        courseName: json["courseName"],
        credits: json["credits"],
        docente: json["docente"],
      );

  Map<String, dynamic> toJson() => {
      "id": id,
      "courseName": courseName,
      "credits": credits,
      "docente": docente,
    };
}