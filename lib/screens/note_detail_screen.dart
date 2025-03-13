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
                    margin: const EdgeInsets.all(4),
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
                    child: _noteColor == color
                        ? const Center(
                            child: Icon(
                              Icons.check,
                              color: Colors.blue,
                            ),
                          )
                        : null,
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
    final theme = Theme.of(context);
    
    return PopScope(
      canPop: !_isNoteChanged,
      onPopInvoked: (didPop) async {
        if (didPop) return;
        
        final title = _titleController.text.trim();
        final content = _contentController.text.trim();
        
        if (title.isEmpty && content.isEmpty) {
          // If note is empty, just allow the pop
          Navigator.of(context).pop();
          return;
        }
        
        if (_isNoteChanged) {
          final result = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Save changes?'),
              content: const Text('Your note has unsaved changes. Would you like to save them?'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text('DISCARD'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: const Text('SAVE'),
                ),
              ],
            ),
          );
          
          if (result == true) {
            _saveNote();
          } else {
            Navigator.of(context).pop();
          }
        }
      },
      child: Scaffold(
        backgroundColor: _noteColor,
        appBar: AppBar(
          backgroundColor: _noteColor,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(CupertinoIcons.back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              icon: Icon(
                _isPinned ? CupertinoIcons.pin_fill : CupertinoIcons.pin,
              ),
              onPressed: _togglePin,
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.paintbrush),
              onPressed: _showColorPicker,
            ),
            IconButton(
              icon: const Icon(CupertinoIcons.check_mark),
              onPressed: _saveNote,
            ),
          ],
        ),
        body: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              TextField(
                controller: _titleController,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.black87,
                ),
                decoration: InputDecoration(
                  hintText: 'Title',
                  hintStyle: TextStyle(
                    color: theme.brightness == Brightness.dark
                        ? Colors.white60
                        : Colors.grey[600],
                  ),
                  border: InputBorder.none,
                ),
                maxLines: 1,
              ),
              const Divider(height: 20),
              Expanded(
                child: TextField(
                  controller: _contentController,
                  style: TextStyle(
                    fontSize: 18,
                    color: theme.brightness == Brightness.dark
                        ? Colors.white
                        : Colors.black87,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Note content',
                    hintStyle: TextStyle(
                      color: theme.brightness == Brightness.dark
                          ? Colors.white60
                          : Colors.grey[600],
                    ),
                    border: InputBorder.none,
                  ),
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
