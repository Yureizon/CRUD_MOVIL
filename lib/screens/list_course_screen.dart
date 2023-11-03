//import 'package:crud/models.dart/course_model.dart';
import 'package:crud/providers.dart/actual_option_provider.dart';
import 'package:crud/providers.dart/courses_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListCoursesScreen extends StatelessWidget {
  const ListCoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    CoursesProvider coursesProvider = Provider.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.shield),
        title: const Text("Course List", style: TextStyle(fontWeight: FontWeight.bold),textAlign: TextAlign.center),
      ),
      body: _ListCourses(),
      floatingActionButton: IconButton(
        onPressed: () async {
          coursesProvider.loadCourses();
        }, 
        icon: const Icon(Icons.restart_alt),
        iconSize: 40,
        tooltip: "Refresh List",
        splashColor: Colors.red,
      ),
    );
  }
}

class _ListCourses extends StatelessWidget {

  void displayDialog(BuildContext context, CoursesProvider coursesProvider, int id) {
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
                coursesProvider.deleteCourseById(id);
                Navigator.pop(context);
              },
              child: const Text("Yes!"),
            ),
          ],
        );
      }
    );
  }

  void detail (BuildContext context, CoursesProvider coursesProvider, int index) {
    final courses = coursesProvider.courses; 
    showModalBottomSheet(
      showDragHandle: true,
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Course Detail", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blue),),
              const SizedBox(height: 15,),
              Text.rich(
                TextSpan(
                  style: const TextStyle(fontSize: 15),
                  children: <TextSpan> [
                    const TextSpan(text: "Course Name: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${courses[index].courseName}\n"),
                    const TextSpan(text: "Course credits: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${courses[index].credits}\n"),
                    const TextSpan(text: "Course teacher: ", style: TextStyle(fontStyle: FontStyle.italic, fontWeight: FontWeight.bold)),
                    TextSpan(text: "${courses[index].docente}\n"),
                  ]
                )
              ),
              const Text("Course Students", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17, color: Colors.blue),),
              const SizedBox(height: 15,),
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
    CoursesProvider coursesProvider = Provider.of<CoursesProvider>(context);
    //coursesProvider.loadCourses();
    final courses = coursesProvider.courses;

    return ListView.builder(

      itemCount: courses.length,
      itemBuilder: (_, index) => ListTile(
        onTap: () => detail(context, coursesProvider, (index)),
        leading: const Icon(Icons.shield),
        title: Text(courses[index].courseName),
        subtitle: Text(courses[index].credits.toString()),
        trailing: PopupMenuButton(
          onSelected: (int i){
            if (i==0) {
              coursesProvider.createOrUpdate = "update";
              coursesProvider.assignDataWithCourse(courses[index]);
              Provider.of<ActualOptionProvider>(context, listen: false).selectedOption = 3;
              return;
            }
            displayDialog(context, coursesProvider, courses[index].id!);
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