import 'package:crud/providers.dart/actual_option_provider.dart';
import 'package:crud/providers.dart/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateCourseScreen extends StatelessWidget {
  const CreateCourseScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.add_moderator),
        title: const Text("New Course", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 5),
        child: _CreateForm(),
      )
    );
  }
}

class _CreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    final ActualOptionProvider actualOptionProvider = Provider.of<ActualOptionProvider>(context, listen: false);
    return Form(
      key: coursesProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            initialValue: coursesProvider.courseName,
            decoration: const InputDecoration(
              hintText: "example: Terrorist Course",
              labelText: "Course name",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            ),
            onChanged: (value) => coursesProvider.courseName = value,
            validator: (value) {
              return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            initialValue: coursesProvider.credits.toString(),
            decoration: const InputDecoration(
              hintText: "example: 16",
              labelText: "Credits",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                coursesProvider.credits = int.parse(value);
              } else {
                coursesProvider.credits = 0;
              }
            },
            validator: (value) {
              return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            initialValue: coursesProvider.docente,
            decoration: const InputDecoration(
              hintText: "example: Tri-line, julioprofe, Skrillex, Doja Cat, キュートなカノジョ, 【syudou】爆笑",
              labelText: "Teacher's name",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            ),
            onChanged: (value) => coursesProvider.docente = value,
            validator: (value) {
              return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.red,
            splashColor: Colors.purple,
            onPressed: coursesProvider.isLoading? null: () async {
              //Quitar teclado al terminar
              FocusScope.of(context).unfocus();

              if (!coursesProvider.isValidForm()) return;

              if (coursesProvider.createOrUpdate == "create") {
                coursesProvider.addCourse();
              } else {
                coursesProvider.updateCourse();
              }

              coursesProvider.resetCourseData();

              coursesProvider.isLoading = false;

              actualOptionProvider.selectedOption = 2;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(coursesProvider.isLoading ? 'Espere' : 'Ingresar', style: const TextStyle(color: Colors.white),),
            ),
          )
        ],
      ),
    );
  }
}