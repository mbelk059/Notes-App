import 'package:flutter/material.dart';
import 'package:notes_app/models/note.dart';
import 'package:notes_app/models/note_database.dart';
import 'package:provider/provider.dart';

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  // text controller to access what user typed
  final textController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // On app startup, fetch existing notes
    readNotes();
  }

  // Create a note
  void createNote() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: TextField(
          controller: textController,
        ),
        actions: [
          // Create button
          MaterialButton(
            onPressed: () {
              // Add to db
              context.read<NoteDatabase>().addNote(textController.text);

              // Clear controller
              textController.clear();

              // Pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Create"),
          ),
        ],
      ),
    );
  }

  // Read notes
  void readNotes() {
    context.read<NoteDatabase>().fetchNotes();
  }

  // Update note
  void updateNote(Note note) {
    // Prefill current note text
    textController.text = note.text;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Note"),
        content: TextField(
          controller: textController,
        ),
        actions: [
          // Update button
          MaterialButton(
            onPressed: () {
              // Update note in db
              context
                  .read<NoteDatabase>()
                  .updateNote(note.id, textController.text);

              // Clear controller
              textController.clear();

              // Pop dialog box
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
        ],
      ),
    );
  }

  // delete a note
  void deleteNote(int id) {
    context.read<NoteDatabase>().deleteNote(id);
  }

  @override
  Widget build(BuildContext context) {
    // Note db
    final noteDatabase = context.watch<NoteDatabase>();

    // Current notes
    List<Note> currentNotes = noteDatabase.currentNotes;

    return Scaffold(
      appBar: AppBar(title: const Text('Notes')),
      floatingActionButton: FloatingActionButton(
        onPressed: createNote,
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: currentNotes.length,
        itemBuilder: (context, index) {
          // Get individual note
          final note = currentNotes[index];

          // List tile UI
          return ListTile(
            title: Text(note.text),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Edit button
                IconButton(
                  onPressed: () => updateNote(note),
                  icon: const Icon(Icons.edit),
                ),

                // Delete button
                IconButton(
                  onPressed: () => deleteNote(note.id),
                  icon: const Icon(Icons.delete),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
