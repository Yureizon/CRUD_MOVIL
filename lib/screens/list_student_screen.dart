import 'package:crud/models.dart/student_model.dart';
import 'package:crud/providers.dart/actual_option_provider.dart';
import 'package:crud/providers.dart/students_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListStudentsScreen extends StatelessWidget {
  const ListStudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    StudentsProvider studentsProvider = Provider.of<StudentsProvider>(context);
    //studentsProvider.loadStudents();
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.group),
        title: const Text("Students List", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      ),
      body: _ListStudents(),
      floatingActionButton: IconButton(
        onPressed: () async {
          studentsProvider.loadStudents();
        }, 
        icon: const Icon(Icons.restart_alt),
        iconSize: 40,
        tooltip: "Refresh List",
        splashColor: Colors.green,
      ),
    );
  }
}

class _ListStudents extends StatelessWidget {

  void displayDialog(BuildContext context, StudentsProvider studentsProvider, int id) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return AlertDialog(
          elevation: 5,
          title: const Text("WARNING"),
          shape: RoundedRectangleBorder( borderRadius: BorderRadiusDirectional.circular(10)),
          content: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Do you want to permanently delete the registry?"),
              SizedBox(height: 10,)
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancerl"),
            ),
            TextButton(
              onPressed: () {
                studentsProvider.deleteStudentById(id);
                Navigator.pop(context);
              },
              child: const Text("Yes!"),
            ),
          ],
        );
      }
    );
  }

  void detail (BuildContext context, StudentsProvider studentsProvider, int index) {
    final students = studentsProvider.students; 
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Student Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blue),),
              const SizedBox(height: 15,),
              Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 15),
                  children: <TextSpan> [
                    const TextSpan(text: "Student Identification Document: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${students[index].identificationDocument}\n"),
                    const TextSpan(text: "Student name: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${students[index].name}\n"),
                    const TextSpan(text: "Student age: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${students[index].age}\n"),
                  ]
                )
              ),
              TextButton(
                onPressed:() => Navigator.of(context).pop(), child: const Text("Okay", style: TextStyle(color: Colors.white),),
                style: TextButton.styleFrom(
                  backgroundColor: Colors.blue,
                ),
                )
            ],
          ),
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    StudentsProvider studentsProvider = Provider.of<StudentsProvider>(context);
    //studentsProvider.loadStudents();
    final students = studentsProvider.students;

    return ListView.builder(

      itemCount: students.length,
      itemBuilder: (_, index) => ListTile(
        onTap: () => detail(context, studentsProvider, (index)),
        leading: const Icon(Icons.person),
        title: Text(students[index].name),
        subtitle: Text(students[index].identificationDocument.toString()),
        trailing: PopupMenuButton(
          onSelected: (int i){
            if (i==0) {
              studentsProvider.createOrUpdate = "update";
              studentsProvider.assignDataWithStudent(students[index]);
              Provider.of<ActualOptionProvider>(context, listen: false).selectedOption = 1; // este num debe cambiar para cursos
              return;
            }
            displayDialog(context, studentsProvider, students[index].id!);
          },
          itemBuilder: (context) => const [
            PopupMenuItem(value: 0, child: Text("Update"),),
            PopupMenuItem(value: 1, child: Text("Delete"),),
          ],
        ),
      ),
    );
  }
}