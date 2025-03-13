import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../screens/calculator_screen.dart';

class AppModel {
  final String name;
  final IconData icon;
  final Color color;
  final Function()? onTap;
  final Widget? screen;
  final String? badge; // For notification badges

  const AppModel({
    required this.name,
    required this.icon,
    required this.color,
    this.onTap,
    this.screen,
    this.badge,
  });
}

// Sample app data
final List<List<AppModel>> allApps = [
  // First page - Main apps
  [
    AppModel(
      name: 'Messages',
      icon: CupertinoIcons.chat_bubble_2_fill,
      color: const Color(0xFF4CD964),
      badge: '3',
    ),
    AppModel(name: 'Calendar', icon: CupertinoIcons.calendar, color: Colors.blue),
    AppModel(name: 'Photos', icon: CupertinoIcons.photo, color: Colors.purple),
    AppModel(name: 'Camera', icon: CupertinoIcons.camera_fill, color: Colors.grey.shade800),
    AppModel(name: 'Mail', icon: CupertinoIcons.mail_solid, color: Colors.blueAccent, badge: '5'),
    AppModel(name: 'Clock', icon: CupertinoIcons.clock_fill, color: Colors.black87),
    AppModel(name: 'Maps', icon: CupertinoIcons.map_fill, color: const Color(0xFF46C01C)),
    AppModel(name: 'Videos', icon: CupertinoIcons.play_rectangle_fill, color: Colors.pink),
    AppModel(name: 'Notes', icon: CupertinoIcons.square_list, color: const Color(0xFFFFCC00)),
    AppModel(name: 'Reminders', icon: CupertinoIcons.list_bullet, color: Colors.orangeAccent),
    AppModel(name: 'App Store', icon: CupertinoIcons.app_fill, color: Colors.blue),
    AppModel(name: 'Health', icon: CupertinoIcons.heart_fill, color: Colors.redAccent),
  ],
  // Second page - Utilities
  [
    AppModel(name: 'Settings', icon: CupertinoIcons.settings, color: Colors.grey.shade700),
    AppModel(
      name: 'Calculator', 
      icon: Icons.calculate, // Changed to Material icon as CupertinoIcons doesn't have calculator_fill
      color: const Color(0xFFFF9500),
      screen: const CalculatorScreen(),
    ),
    AppModel(name: 'Weather', icon: CupertinoIcons.cloud_sun_fill, color: const Color(0xFF54C7FC)),
    AppModel(name: 'Wallet', icon: CupertinoIcons.creditcard, color: Colors.black87),
    AppModel(name: 'Music', icon: CupertinoIcons.music_note, color: const Color(0xFFFC3C44)),
    AppModel(name: 'Files', icon: CupertinoIcons.folder_fill, color: const Color(0xFF5AC8FA)),
    AppModel(name: 'Contacts', icon: CupertinoIcons.person_crop_circle_fill, color: const Color(0xFF4CD964)),
    AppModel(name: 'FaceTime', icon: CupertinoIcons.video_camera, color: const Color(0xFF4CD964)),
  ],
  // Third page - More apps
  [
    AppModel(name: 'Books', icon: CupertinoIcons.book_fill, color: const Color(0xFFFF9500)),
    AppModel(name: 'Stocks', icon: CupertinoIcons.graph_square_fill, color: Colors.black87),
    AppModel(name: 'News', icon: CupertinoIcons.news, color: const Color(0xFFFC3C44)),
    AppModel(name: 'TV', icon: CupertinoIcons.tv, color: Colors.indigo),
    AppModel(name: 'Podcasts', icon: CupertinoIcons.mic_fill, color: const Color(0xFF9B59B6)),
    AppModel(name: 'Translate', icon: CupertinoIcons.globe, color: const Color(0xFF4CD964)),
    AppModel(name: 'Voice Memos', icon: CupertinoIcons.waveform, color: const Color(0xFFFC3C44)),
    AppModel(name: 'Compass', icon: CupertinoIcons.compass, color: Colors.grey.shade800),
  ],
];

// Apps in dock
final List<AppModel> dockApps = [
  AppModel(name: 'Phone', icon: CupertinoIcons.phone_fill, color: const Color(0xFF4CD964)),
  AppModel(name: 'Safari', icon: CupertinoIcons.compass, color: const Color(0xFF1C7CF0)),
  AppModel(name: 'Messages', icon: CupertinoIcons.chat_bubble_2_fill, color: const Color(0xFF4CD964)),
  AppModel(name: 'Music', icon: CupertinoIcons.music_note, color: const Color(0xFFFC3C44)),
];
