import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';

class NoteDetailScreen extends StatefulWidget {
  final bool isNewNote;
  final String noteId;

  const NoteDetailScreen({
    super.key,
    required this.isNewNote,
    required this.noteId,
  });

  @override
  State<NoteDetailScreen> createState() => _NoteDetailScreenState();
}

class _NoteDetailScreenState extends State<NoteDetailScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  late Color _noteColor;
  bool _isNoteChanged = false;
  bool _isPinned = false;
  String _currentNoteId = '';
  
  final List<Color> _colors = [
    Colors.white,
    Colors.amber.shade100,
    Colors.lightBlue.shade100,
    Colors.greenAccent.shade100,
    Colors.purple.shade100,
    Colors.orange.shade100,
    Colors.pink.shade100,
    Colors.teal.shade100,
  ];

  @override
  void initState() {
    super.initState();
    
    _titleController = TextEditingController();
    _contentController = TextEditingController();
    
    if (widget.isNewNote) {
      _noteColor = _colors[0];
      _currentNoteId = DateTime.now().millisecondsSinceEpoch.toString();
    } else {
      // Load existing note data
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final note = Provider.of<NotesProvider>(context, listen: false)
            .getNoteById(widget.noteId);
        
        if (note != null) {
          _titleController.text = note.title;
          _contentController.text = note.content;
          setState(() {
            _noteColor = note.color;
            _isPinned = note.isPinned;
            _currentNoteId = note.id;
          });
        }
      });
    }
    
    // Add listeners to detect changes
    _titleController.addListener(_onTextChanged);
    _contentController.addListener(_onTextChanged);
  }
  
  void _onTextChanged() {
    setState(() {
      _isNoteChanged = true;
    });
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }
  
  void _saveNote() {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    
    if (title.isEmpty && content.isEmpty) {
      Navigator.pop(context);
      return;
    }
    
    final now = DateTime.now();
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    
    if (widget.isNewNote) {
      final newNote = Note(
        id: _currentNoteId,
        title: title,
        content: content,
        color: _noteColor,
        createdAt: now,
        modifiedAt: now,
        isPinned: _isPinned,
      );
      notesProvider.addNote(newNote);
    } else {
      final existingNote = notesProvider.getNoteById(widget.noteId);
      if (existingNote != null) {
        final updatedNote = existingNote.copyWith(
          title: title,
          content: content,
          color: _noteColor,
          modifiedAt: now,
          isPinned: _isPinned,
        );
        notesProvider.updateNote(updatedNote);
      }
    }
    
    Navigator.pop(context, true);
  }
  
  void _togglePin() {
    setState(() {
      _isPinned = !_isPinned;
      _isNoteChanged = true;
    });
  }

  void _showColorPicker() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Note Color',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 10,
              children: _colors.map((color) {
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _noteColor = color;
                      _isNoteChanged = true;
                    });
                    Navigator.pop(context);
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      color: color,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: _noteColor == color 
                            ? Colors.blue 
                            : Colors.grey.shade300,
                        width: _noteColor == color ? 2 : 1,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (_isNoteChanged) {
          _saveNote();
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: _noteColor,
        appBar: AppBar(
          backgroundColor: _noteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back, color: Colors.black),
            onPressed: () {
              if (_isNoteChanged) {
                _saveNote();
              } else {
                Navigator.pop(context);
              }
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isPinned 
                    ? CupertinoIcons.pin_fill 
                    : CupertinoIcons.pin,
                color: Colors.black,
              ),
              onPressed: _togglePin,
            ),
            IconButton(
              icon: const Icon(
                CupertinoIcons.square_on_circle,
                color: Colors.black,
              ),
              onPressed: _showColorPicker,
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                decoration: const InputDecoration(
                  hintText: 'Title',
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              const SizedBox(height: 8),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  decoration: const InputDecoration(
                    hintText: 'Note',
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  textCapitalization: TextCapitalization.sentences,
                ),
              ),
            ],
          ),
        ),
        floatingActionButton: _isNoteChanged 
            ? FloatingActionButton(
                onPressed: _saveNote,
                backgroundColor: Colors.amber,
                child: const Icon(Icons.save),
              )
            : null,
      ),
    );
  }
}
