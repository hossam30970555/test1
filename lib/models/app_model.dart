import 'package:flutter/material.dart';
import '../screens/calculator_screen.dart';

class AppModel {
  final String name;
  final IconData icon;
  final Color color;
  final Function()? onTap;
  final Widget? screen;

  const AppModel({
    required this.name,
    required this.icon,
    required this.color,
    this.onTap,
    this.screen,
  });
}

// Sample app data
final List<List<AppModel>> allApps = [
  // First page
  [
    AppModel(name: 'Messages', icon: Icons.message, color: Colors.green),
    AppModel(name: 'Calendar', icon: Icons.calendar_today, color: Colors.blue),
    AppModel(name: 'Photos', icon: Icons.photo_library, color: Colors.purple),
    AppModel(name: 'Camera', icon: Icons.camera_alt, color: Colors.grey),
    AppModel(name: 'Mail', icon: Icons.mail, color: Colors.blue),
    AppModel(name: 'Clock', icon: Icons.access_time, color: Colors.black),
    AppModel(name: 'Maps', icon: Icons.map, color: Colors.green),
    AppModel(name: 'Videos', icon: Icons.video_library, color: Colors.pink),
    AppModel(name: 'Notes', icon: Icons.note, color: Colors.yellow),
    AppModel(name: 'Reminders', icon: Icons.checklist, color: Colors.orange),
    AppModel(name: 'App Store', icon: Icons.shop, color: Colors.blue),
    AppModel(name: 'Health', icon: Icons.favorite, color: Colors.red),
  ],
  // Second page
  [
    AppModel(name: 'Settings', icon: Icons.settings, color: Colors.grey),
    AppModel(
      name: 'Calculator', 
      icon: Icons.calculate, 
      color: Colors.orange,
      screen: const CalculatorScreen(),
    ),
    AppModel(name: 'Weather', icon: Icons.cloud, color: Colors.lightBlue),
    AppModel(name: 'Wallet', icon: Icons.account_balance_wallet, color: Colors.black),
    AppModel(name: 'Music', icon: Icons.music_note, color: Colors.red),
  ],
  // Third page
  [
    AppModel(name: 'Books', icon: Icons.book, color: Colors.orange),
    AppModel(name: 'Stocks', icon: Icons.show_chart, color: Colors.black),
  ],
];

// Apps in dock
final List<AppModel> dockApps = [
  AppModel(name: 'Phone', icon: Icons.phone, color: Colors.green),
  AppModel(name: 'Safari', icon: Icons.public, color: Colors.blue),
  AppModel(name: 'Messages', icon: Icons.message, color: Colors.green),
  AppModel(name: 'Music', icon: Icons.music_note, color: Colors.red),
];
