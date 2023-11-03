import 'package:crud/providers.dart/actual_option_provider.dart';
import 'package:crud/screens/create_course_screen.dart';
//import 'package:crud/screens/create_note_screen.dart';
import 'package:crud/screens/create_student_screen.dart';
import 'package:crud/screens/list_course_screen.dart';
//import 'package:crud/screens/list_note_screen.dart';
import 'package:crud/screens/list_student_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_navigatorbar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        /*appBar: AppBar(
          leading: const Icon(Icons.local_fire_department, color: Colors.red,),
          title: const Center(child: Text("Entregable")),
        ),*/
        body: _HomeScreenBody(),
        bottomNavigationBar: const CustomNavigatorBar());
  }
}

class _HomeScreenBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ActualOptionProvider actualOptionProvider = Provider.of<ActualOptionProvider>(context);

    int selectedOption = actualOptionProvider.selectedOption;

    switch (selectedOption) {
      case 0:
        return const ListStudentsScreen();
      case 1:
        return const CreateStudentScreen();
      /*case 2:
        return const ListCoursesScreen();
      case 3:
        return const CreateCourseScreen();*/
      default:
        return const ListStudentsScreen();
    }
  }
}