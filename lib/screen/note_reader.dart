import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:notes_app/style/app_style.dart';

class NoteReaderScreen extends StatefulWidget {
  NoteReaderScreen(this.doc, {super.key});
  QueryDocumentSnapshot doc;
  @override
  State<NoteReaderScreen> createState() => _NoteReaderScreenState();
}

class _NoteReaderScreenState extends State<NoteReaderScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _mainController = TextEditingController();

  @override
  void initState() {
    super.initState();

    _titleController.text = widget.doc["note_title"];
    _mainController.text = widget.doc["note_content"];
  }

  void saveNote() {
    FirebaseFirestore.instance.collection('notes').doc(widget.doc.id).update({
      'note_title': _titleController.text,
      'note_content': _mainController.text,
    });
    Navigator.pop(context);
  }

  void deleteNote() {
    FirebaseFirestore.instance.collection('notes').doc(widget.doc.id).delete();
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _mainController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    int color_id = widget.doc['color_id'];
    return Scaffold(
      backgroundColor: AppStyle.cardsColor[color_id],
      appBar: AppBar(
        backgroundColor: AppStyle.cardsColor[color_id],
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _titleController,
              style: AppStyle.mainTitle,
              decoration: InputDecoration(
                hintText: "Note Title",
                border: InputBorder.none,
              ),
            ),
            SizedBox(
              height: 4.0,
            ),
            Text(widget.doc["creation_date"], style: AppStyle.dateTitle),
            SizedBox(
              height: 28.0,
            ),
            Expanded(
              child: TextField(
                controller: _mainController,
                style: AppStyle.mainContent,
                maxLines: null,
                decoration: InputDecoration(
                  hintText: "Note Content",
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: "fab1",
            onPressed: () {
              saveNote();
            },
            child: Icon(Icons.save),
          ),
          SizedBox(height: 16.0),
          FloatingActionButton(
            heroTag: "fab2",
            onPressed: () {
              deleteNote();
            },
            child: Icon(Icons.delete),
          ),
        ],
      ),
    );
  }
}
