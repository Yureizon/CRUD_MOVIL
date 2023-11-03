import 'package:crud/providers.dart/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ListNotesScreen extends StatelessWidget {
  const ListNotesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _ListNotes();
  }
}

class _ListNotes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    NotesProvider notesProvider = Provider.of<NotesProvider>(context);

    final notes = notesProvider.notes;

    return ListView.builder(
      itemCount: notes.length,
      itemBuilder: (_, index) => ListTile(
        leading: const Icon(Icons.note),
        title: Text(notes[index].title),
        subtitle: Text(notes[index].id.toString()),
        trailing: const Icon(Icons.arrow_forward_ios_sharp),
      ),
    );
  }
}