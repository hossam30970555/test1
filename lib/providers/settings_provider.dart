import 'package:flutter/foundation.dart';

class SettingsProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _editMode = false;
  String _wallpaper = 'assets/images/ios_wallpaper.jpg';

  bool get darkMode => _darkMode;
  bool get editMode => _editMode;
  String get wallpaper => _wallpaper;

  set darkMode(bool value) {
    _darkMode = value;
    notifyListeners();
  }

  set editMode(bool value) {
    _editMode = value;
    notifyListeners();
  }

  set wallpaper(String path) {
    _wallpaper = path;
    notifyListeners();
  }
}
