// To parse this JSON data, do
//
//     final student = studentFromJson(jsonString);

import 'dart:convert';
//student
Student studentFromJson(String str) => Student.fromJson(json.decode(str));

String studentToJson(Student data) => json.encode(data.toJson());

class Student {
  int? id;
  int identificationDocument;
  String name;
  int age;

  Student({
    this.id,
    required this.identificationDocument,
    required this.name,
    required this.age,
  });

  factory Student.fromJson(Map<String, dynamic> json) => Student(
        id: json["id"],
        identificationDocument: json["identificationDocument"],
        name: json["name"],
        age: json["age"],
      );

  Map<String, dynamic> toJson() => {
      "id": id,
      "identificationDocument": identificationDocument,
      "name": name,
      "age": age,
    };
}