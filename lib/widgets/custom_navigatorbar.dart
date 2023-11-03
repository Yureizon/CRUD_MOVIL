import 'package:crud/providers.dart/actual_option_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomNavigatorBar extends StatelessWidget {
  const CustomNavigatorBar({super.key});

  @override
  Widget build(BuildContext context) {
    final ActualOptionProvider actualOptionProvider = Provider.of<ActualOptionProvider>(context);

    final currentIndex = actualOptionProvider.selectedOption;

    return BottomNavigationBar(
      //backgroundColor: Colors.green,
      selectedItemColor: Colors.blue,
      unselectedItemColor: Colors.black,
      //Current Index, para determinar el botón que debe marcarse
      currentIndex: currentIndex,
      onTap: (int i) {
        actualOptionProvider.selectedOption = i;
      },
      //Items
      items: const <BottomNavigationBarItem>[
        //BottomNavigationBarItem(icon: Icon(Icons.list), label: "Listar Notas"),
        //BottomNavigationBarItem(icon: Icon(Icons.post_add_rounded), label: "Crear Nota"),
        BottomNavigationBarItem(icon: Icon(Icons.group), label: "Students"),
        BottomNavigationBarItem(icon: Icon(Icons.person_add), label: "New Student"),
        //BottomNavigationBarItem(icon: Icon(Icons.shield), label: "Courses"),
        //BottomNavigationBarItem(icon: Icon(Icons.add_moderator), label: "New Course"),
      ],
    );
  }
}