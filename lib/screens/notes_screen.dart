import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../models/note_model.dart';
import '../providers/notes_provider.dart';
import '../screens/note_detail_screen.dart';
import '../widgets/note_card.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> with SingleTickerProviderStateMixin {
  late TextEditingController _searchController;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  bool _isSearching = false;
  
  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchController.addListener(_onSearchChanged);
    
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    
    _fabAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _fabController,
        curve: Curves.easeInOut,
      ),
    );
    
    _fabController.forward();
  }
  
  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    _fabController.dispose();
    super.dispose();
  }
  
  void _onSearchChanged() {
    Provider.of<NotesProvider>(context, listen: false)
        .setSearchQuery(_searchController.text);
  }
  
  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      if (!_isSearching) {
        _searchController.clear();
      }
    });
  }

  void _createNewNote() async {
    final result = await Navigator.of(context).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => NoteDetailScreen(
          isNewNote: true, 
          noteId: '',
        ),
        transitionDuration: const Duration(milliseconds: 300),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var curve = Curves.easeInOut;
          var tween = Tween(begin: 0.0, end: 1.0).chain(CurveTween(curve: curve));
          return FadeTransition(
            opacity: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
    
    // Refresh the animation when returning to the screen
    if (result == true && mounted) {
      _fabController.reset();
      _fabController.forward();
    }
  }

  void _showSortOptions() {
    final notesProvider = Provider.of<NotesProvider>(context, listen: false);
    
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setState) {
          return Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(CupertinoIcons.calendar),
                  title: const Text('Modified Date'),
                  trailing: notesProvider.sortOption == SortOption.modifiedDate
                      ? const Icon(CupertinoIcons.check_mark, color: Colors.blue)
                      : null,
                  onTap: () {
                    notesProvider.setSortOption(SortOption.modifiedDate);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.calendar_badge_plus),
                  title: const Text('Created Date'),
                  trailing: notesProvider.sortOption == SortOption.createdDate
                      ? const Icon(CupertinoIcons.check_mark, color: Colors.blue)
                      : null,
                  onTap: () {
                    notesProvider.setSortOption(SortOption.createdDate);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.textformat),
                  title: const Text('Title'),
                  trailing: notesProvider.sortOption == SortOption.title
                      ? const Icon(CupertinoIcons.check_mark, color: Colors.blue)
                      : null,
                  onTap: () {
                    notesProvider.setSortOption(SortOption.title);
                    Navigator.pop(context);
                  },
                ),
                const Divider(),
                const SizedBox(height: 8),
                const Text(
                  'Show',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  leading: const Icon(CupertinoIcons.doc_text),
                  title: const Text('All Notes'),
                  trailing: notesProvider.filterOption == FilterOption.all
                      ? const Icon(CupertinoIcons.check_mark, color: Colors.blue)
                      : null,
                  onTap: () {
                    notesProvider.setFilterOption(FilterOption.all);
                    Navigator.pop(context);
                  },
                ),
                ListTile(
                  leading: const Icon(CupertinoIcons.pin_fill),
                  title: const Text('Pinned Only'),
                  trailing: notesProvider.filterOption == FilterOption.pinned
                      ? const Icon(CupertinoIcons.check_mark, color: Colors.blue)
                      : null,
                  onTap: () {
                    notesProvider.setFilterOption(FilterOption.pinned);
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: _isSearching 
            ? TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search notes...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey[400]),
                ),
                style: const TextStyle(fontSize: 18),
                autofocus: true,
              )
            : const Text('Notes', style: TextStyle(color: Colors.black)),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(
              _isSearching ? CupertinoIcons.clear_circled : CupertinoIcons.search,
              color: Colors.black,
            ),
            onPressed: _toggleSearch,
          ),
          if (!_isSearching)
            IconButton(
              icon: const Icon(CupertinoIcons.sort_down, color: Colors.black),
              onPressed: _showSortOptions,
            ),
        ],
      ),
      body: Consumer<NotesProvider>(
        builder: (context, notesProvider, child) {
          final pinnedNotes = notesProvider.pinnedNotes;
          final unpinnedNotes = notesProvider.unpinnedNotes;
          final hasSearchQuery = notesProvider.searchQuery.isNotEmpty;
          
          if (pinnedNotes.isEmpty && unpinnedNotes.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.doc_text,
                    size: 70,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    hasSearchQuery 
                        ? 'No results found' 
                        : 'No notes yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  if (!hasSearchQuery) ...[
                    const SizedBox(height: 12),
                    Text(
                      'Tap the + button to create a note',
                      style: TextStyle(
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }
          
          return ListView(
            padding: const EdgeInsets.all(12.0),
            children: [
              if (pinnedNotes.isNotEmpty && !hasSearchQuery) ...[
                const Padding(
                  padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                  child: Text(
                    'PINNED',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1,
                  ),
                  itemCount: pinnedNotes.length,
                  itemBuilder: (context, index) {
                    return NoteCard(note: pinnedNotes[index]);
                  },
                ),
                const SizedBox(height: 20),
                if (unpinnedNotes.isNotEmpty)
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0, bottom: 8.0),
                    child: Text(
                      'OTHERS',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ),
              ],
              
              GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                  childAspectRatio: 1,
                ),
                itemCount: hasSearchQuery ? notesProvider.notes.length : unpinnedNotes.length,
                itemBuilder: (context, index) {
                  final note = hasSearchQuery 
                      ? notesProvider.notes[index] 
                      : unpinnedNotes[index];
                  return NoteCard(note: note);
                },
              ),
            ],
          );
        },
      ),
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton(
          onPressed: _createNewNote,
          backgroundColor: Colors.amber,
          child: const Icon(CupertinoIcons.plus),
        ),
      ),
    );
  }
}
