import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../screens/calculator_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/notes_screen.dart';

class AppModel {
  final String name;
  final IconData icon;
  final Color color;
  final Function()? onTap;
  final Widget? screen;
  final String? badge;

  const AppModel({
    required this.name,
    required this.icon,
    required this.color,
    this.onTap,
    this.screen,
    this.badge,
  });
}

// Simplified app data - just one page with Settings, Calculator, and Notes
final List<List<AppModel>> allApps = [
  // First page - Main apps
  [
    const AppModel(
      name: 'Settings',
      icon: CupertinoIcons.settings,
      color: Color(0xFF757575),
      screen: SettingsScreen(),
    ),
    const AppModel(
      name: 'Calculator', 
      icon: Icons.calculate,
      color: Color(0xFFFF9500),
      screen: CalculatorScreen(),
    ),
    const AppModel(
      name: 'Notes', 
      icon: CupertinoIcons.doc_text,
      color: Colors.amber,
      screen: NotesScreen(),
    ),
  ],
];

// Apps in dock
final List<AppModel> dockApps = [
  const AppModel(
    name: 'Settings',
    icon: CupertinoIcons.settings,
    color: Color(0xFF757575),
    screen: SettingsScreen(),
  ),
  const AppModel(
    name: 'Calculator', 
    icon: Icons.calculate,
    color: Color(0xFFFF9500),
    screen: CalculatorScreen(),
  ),
  const AppModel(
    name: 'Notes', 
    icon: CupertinoIcons.doc_text,
    color: Colors.amber,
    screen: NotesScreen(),
  ),
];
