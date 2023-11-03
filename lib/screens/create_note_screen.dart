import 'package:crud/providers.dart/notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateNoteScreen extends StatelessWidget {
  const CreateNoteScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _CreateForm();
  }
}

class _CreateForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final notesProvider = Provider.of<NotesProvider>(context);
    return Container(
        child: Form(
      key: notesProvider.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        children: [
          TextFormField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Construir Apps',
              labelText: 'Titulo',
              contentPadding: EdgeInsets.symmetric(vertical: 8, horizontal: 8)
            ),
            onChanged: (value) => notesProvider.title = value,
            validator: (value) {
              return value != '' ? null : 'El campo no debe estar vacío';
            },
          ),
          const SizedBox(height: 30),
          TextFormField(
            maxLines: 10,
            autocorrect: false,
            // keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: 'Aprender sobre Dart...',
              labelText: 'Descripción',
            ),
            onChanged: (value) => notesProvider.description = value,
            validator: (value) {
              return (value != null) ? null : 'El campo no puede estar vacío';
            },
          ),
          const SizedBox(height: 30),
          MaterialButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            disabledColor: Colors.grey,
            elevation: 0,
            color: Colors.deepPurple,
            onPressed: notesProvider.isLoading
                  ? null
                  : () async {
                      //Quitar teclado al terminar
                      FocusScope.of(context).unfocus();

                      if (!notesProvider.isValidForm()) return;

                      notesProvider.addNote();

                      notesProvider.isLoading = false;
                    },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 15),
              child: Text(notesProvider.isLoading ? 'Espere' : 'Ingresar', style: const TextStyle(color: Colors.white),)
            )
          )
        ],
      ),
    ));
  }
}