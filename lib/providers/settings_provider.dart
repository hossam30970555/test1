import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  bool _darkMode = false;
  bool _editMode = false;
  String _wallpaper = 'assets/images/ios_wallpaper.jpg';
  
  // Constructor that loads settings
  SettingsProvider() {
    _loadSettings();
  }

  bool get darkMode => _darkMode;
  bool get editMode => _editMode;
  String get wallpaper => _wallpaper;

  set darkMode(bool value) {
    _darkMode = value;
    _saveSettings();
    notifyListeners();
  }

  set editMode(bool value) {
    _editMode = value;
    notifyListeners();
  }

  set wallpaper(String path) {
    _wallpaper = path;
    _saveSettings();
    notifyListeners();
  }
  
  // Load settings from SharedPreferences
  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    _darkMode = prefs.getBool('darkMode') ?? false;
    _wallpaper = prefs.getString('wallpaper') ?? 'assets/images/ios_wallpaper.jpg';
    notifyListeners();
  }
  
  // Save settings to SharedPreferences
  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('darkMode', _darkMode);
    prefs.setString('wallpaper', _wallpaper);
  }
}
