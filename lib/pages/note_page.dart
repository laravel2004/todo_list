import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:todo_list/databases/note_database.dart';
import 'package:todo_list/models/note.dart';
import 'package:todo_list/pages/add_edit_note_page.dart';
import 'package:todo_list/widgets/note_card_widget.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {

  late List<Note> _notes;
  var _isLoading = false;
  
  Future<void> _refreshNotes() async {
    setState(() {
      _isLoading = true;
    });

    _notes = await NoteDatabase.instance.getAllNote();
    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes"),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => const AddEditNotePage(),));
          _refreshNotes();
        },
      ),
      body: _isLoading ? const Center(
        child: CircularProgressIndicator(),
      ) : _notes.isEmpty ? const Text('Notes Kosong') :
      MasonryGridView.count(
        crossAxisCount: 2,
        mainAxisSpacing: 4,
        crossAxisSpacing: 4,
        itemCount: _notes.length,
        itemBuilder: (context, index) {
          final note = _notes[index];
          return GestureDetector(
            child: NoteCardWidget(note: note, index: index)
          );
        },
        )
    );
  }
}