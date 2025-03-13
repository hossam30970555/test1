import 'package:flutter/material.dart';
import '../models/note_model.dart';

class NotesProvider with ChangeNotifier {
  final List<Note> _notes = [];
  String _searchQuery = '';
  SortOption _sortOption = SortOption.modifiedDate;
  FilterOption _filterOption = FilterOption.all;

  NotesProvider() {
    // Add some sample notes
    _addSample();
  }

  // Getters
  List<Note> get notes {
    List<Note> filteredNotes = _notes;
    
    // Apply filtering
    if (_filterOption == FilterOption.pinned) {
      filteredNotes = filteredNotes.where((note) => note.isPinned).toList();
    }
    
    // Apply search query
    if (_searchQuery.isNotEmpty) {
      filteredNotes = filteredNotes.where((note) {
        return note.title.toLowerCase().contains(_searchQuery.toLowerCase()) ||
               note.content.toLowerCase().contains(_searchQuery.toLowerCase());
      }).toList();
    }
    
    // Apply sorting
    switch (_sortOption) {
      case SortOption.modifiedDate:
        filteredNotes.sort((a, b) => b.modifiedAt.compareTo(a.modifiedAt));
        break;
      case SortOption.createdDate:
        filteredNotes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
        break;
      case SortOption.title:
        filteredNotes.sort((a, b) => a.title.compareTo(b.title));
        break;
    }
    
    return filteredNotes;
  }

  List<Note> get pinnedNotes => notes.where((note) => note.isPinned).toList();
  List<Note> get unpinnedNotes => notes.where((note) => !note.isPinned).toList();
  
  String get searchQuery => _searchQuery;
  SortOption get sortOption => _sortOption;
  FilterOption get filterOption => _filterOption;
  
  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }
  
  void setSortOption(SortOption option) {
    _sortOption = option;
    notifyListeners();
  }
  
  void setFilterOption(FilterOption option) {
    _filterOption = option;
    notifyListeners();
  }

  void addNote(Note note) {
    _notes.add(note);
    notifyListeners();
  }

  Note? getNoteById(String id) {
    try {
      return _notes.firstWhere((note) => note.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateNote(Note updatedNote) {
    final index = _notes.indexWhere((note) => note.id == updatedNote.id);
    if (index >= 0) {
      _notes[index] = updatedNote;
      notifyListeners();
    }
  }

  void deleteNote(String id) {
    _notes.removeWhere((note) => note.id == id);
    notifyListeners();
  }

  void togglePin(String id) {
    final index = _notes.indexWhere((note) => note.id == id);
    if (index >= 0) {
      _notes[index] = _notes[index].copyWith(
        isPinned: !_notes[index].isPinned,
        modifiedAt: DateTime.now(),
      );
      notifyListeners();
    }
  }
  
  void deleteAllNotes() {
    _notes.clear();
    notifyListeners();
  }
  
  void exportNotes() {
    // This would be implemented to export notes to a file in a real app
    // For demo purposes, we'll just return the count of notes
    print('Exporting ${_notes.length} notes');
  }

  void _addSample() {
    final now = DateTime.now();
    
    addNote(Note(
      id: '1',
      title: 'Welcome to Notes',
      content: 'This is your new notes app! You can create, edit, and manage your notes here.\n\n• Tap the "+" button to create a new note\n• Swipe left on a note to delete it\n• Tap and hold to pin important notes',
      color: Colors.amber.shade200,
      createdAt: now.subtract(const Duration(days: 2)),
      modifiedAt: now.subtract(const Duration(days: 2)),
      isPinned: true,
    ));
    
    addNote(Note(
      id: '2',
      title: 'Shopping List',
      content: '1. Milk\n2. Eggs\n3. Bread\n4. Coffee\n5. Apples\n6. Pasta',
      color: Colors.greenAccent.shade100,
      createdAt: now.subtract(const Duration(days: 1)),
      modifiedAt: now.subtract(const Duration(days: 1)),
      isPinned: false,
    ));
    
    addNote(Note(
      id: '3',
      title: 'Project Ideas',
      content: '- Mobile app for plant identification\n- Recipe organization system\n- Daily productivity tracker',
      color: Colors.lightBlue.shade100,
      createdAt: now.subtract(const Duration(hours: 5)),
      modifiedAt: now.subtract(const Duration(hours: 5)),
      isPinned: false,
    ));
    
    // Add one more note for variety
    addNote(Note(
      id: '4',
      title: 'Meeting Notes',
      content: 'Meeting with design team on Thursday at 2pm\n\nAgenda:\n- Review new UI mockups\n- Discuss user feedback from beta testing\n- Plan next iteration of features',
      color: Colors.purple.shade100,
      createdAt: now.subtract(const Duration(hours: 2)),
      modifiedAt: now.subtract(const Duration(hours: 2)),
      isPinned: false,
    ));
  }
}

enum SortOption {
  modifiedDate,
  createdDate,
  title,
}

enum FilterOption {
  all,
  pinned,
}
