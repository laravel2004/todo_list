// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:todo_list/databases/note_database.dart';
import 'package:todo_list/models/note.dart';
import 'package:todo_list/widgets/note_form_widget.dart';

class AddEditNotePage extends StatefulWidget {
  const AddEditNotePage({super.key, this.note});
  final Note? note;

  @override
  State<AddEditNotePage> createState() => _AddEditNotePageState();
}

class _AddEditNotePageState extends State<AddEditNotePage> {

  late bool _isImportant;
  late int _number;
  late String _title;
  late String _description;
  final _formKey = GlobalKey<FormState>();
  var _isUpdatedForm = false;

  @override
  void initState() {
    super.initState();
    _isImportant = widget.note?.isImportant ?? false;
    _number = widget.note?.number ?? 0;
    _title = widget.note?.title ?? '';
    _description = widget.note?.description ?? '';
    _isUpdatedForm = widget.note != null;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add'),
        actions: [
          _buildButtonSave(),
        ],
      ),
      body: Form(
        key: _formKey,
        child: NoteFormWidget(
          description: _description,
          title: _title,
          number: _number,
          isImportant: _isImportant,
          onChangeDescription: (value) {
            setState(() {
              _description = value;
            });
          },
          onChangeIsImportant: (value) {
            setState(() {
              _isImportant = value;
            });
          },
          onChangeNumber: (value) {
            setState(() {
              _number = value;
            });
          },
          onChangeTitle: (value) {
            setState(() {
              _title = value;
            });
          },
        ),
      ),
    );
  }

  Widget _buildButtonSave() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      child: ElevatedButton(
        onPressed: () async {
          final isValid = _formKey.currentState!.validate();
          if(isValid) {
            await _addNote();
            Navigator.pop(context);
          }
        },
        child: const Text('Save'),
      ),
    );
  }

  Future<void> _addNote() async {
    final note = Note(
      isImportant: _isImportant,
      number: _number,
      title: _title,
      description: _description,
      createdTime: DateTime.now(),
    );
    await NoteDatabase.instance.create(note);
  }
}