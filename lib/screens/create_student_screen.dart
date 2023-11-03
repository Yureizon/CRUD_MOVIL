import 'package:crud/providers.dart/actual_option_provider.dart';
import 'package:crud/providers.dart/students_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateStudentScreen extends StatelessWidget {
  const CreateStudentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.person_add),
        title: const Text("New Student", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
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
    final StudentsProvider studentsProvider = Provider.of<StudentsProvider>(context);
    final ActualOptionProvider actualOptionProvider = Provider.of<ActualOptionProvider>(context, listen: false);
    return Form(
      key: studentsProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            initialValue: studentsProvider.identificationDocument.toString(),
            decoration: const InputDecoration(
              //border: OutlineInputBorder(),
              hintText: "example: 7832154690",
              labelText: "Identification Document",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                studentsProvider.identificationDocument = int.parse(value);
              } else {
                studentsProvider.identificationDocument = 0;
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
            initialValue: studentsProvider.name,
            decoration: const InputDecoration(
              //border: OutlineInputBorder(),
              hintText: "example: Carlos",
              labelText: "Student's name",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            ),
            onChanged: (value) => studentsProvider.name = value,
            validator: (value) {
              return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            initialValue: studentsProvider.age.toString(),
            decoration: const InputDecoration(
              //border: OutlineInputBorder(),
              hintText: "example: 1900 Before of Christ",
              labelText: "Age",
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            ),
            onChanged: (value) {
              if (value.isNotEmpty) {
                studentsProvider.age = int.parse(value);
              } else {
                studentsProvider.age = 0;
              }
            },
            validator: (value) {
              return value != '' ? null : 'The field must not be empty';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.green,
            splashColor: Colors.pink,
            onPressed: studentsProvider.isLoading? null: () async {
              //Quitar teclado al terminar
              FocusScope.of(context).unfocus();

              if (!studentsProvider.isValidForm()) return;

              if (studentsProvider.createOrUpdate == "create") {
                studentsProvider.addStudent();
              } else {
                studentsProvider.updateStudent();
              }
              
              studentsProvider.resetStudentData();

              studentsProvider.isLoading = false;

              actualOptionProvider.selectedOption = 0;
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(studentsProvider.isLoading ? 'Espere' : 'Ingresar', style: const TextStyle(color: Colors.white),),
            ),
          )
        ],
      )
    );
  }
}