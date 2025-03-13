import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:test1/screens/wallpaper_screen.dart';
import 'package:test1/screens/calculator_screen.dart'; // Add this import
import 'package:test1/screens/notes_screen.dart'; // Add this import
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildUserSection(context),
          const SizedBox(height: 20),
          _buildSettingsSection(context),
          const SizedBox(height: 20),
          _buildAppSection(context),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'iOS Launcher v0.0.1.beta',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.brightness == Brightness.dark 
                    ? Colors.grey 
                    : Colors.grey.shade600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            CupertinoIcons.person_fill,
            color: Colors.white,
          ),
        ),
        title: const Text(
          'User Name',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: const Text('Apple ID, iCloud, App Store & More'),
        trailing: const Icon(CupertinoIcons.chevron_forward),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                CupertinoIcons.moon_fill,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text('Dark Mode'),
            trailing: CupertinoSwitch(
              value: settingsProvider.darkMode,
              onChanged: (value) {
                settingsProvider.darkMode = value;
              },
              activeColor: Colors.green,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                CupertinoIcons.hammer_fill,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text('Edit Mode'),
            trailing: CupertinoSwitch(
              value: settingsProvider.editMode,
              onChanged: (value) {
                settingsProvider.editMode = value;
              },
              activeColor: Colors.green,
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                CupertinoIcons.bell_fill,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text('Notifications'),
            trailing: const Icon(CupertinoIcons.chevron_forward),
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.purple,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                CupertinoIcons.photo,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text('Wallpaper'),
            trailing: const Icon(CupertinoIcons.chevron_forward),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WallpaperScreen()),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildAppSection(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                Icons.calculate,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text('Calculator'),
            subtitle: const Text('Scientific mode, history options'),
            trailing: const Icon(CupertinoIcons.chevron_forward),
            onTap: () {
              // Navigate to Calculator screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CalculatorScreen()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.amber,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                CupertinoIcons.doc_text,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text('Notes'),
            subtitle: const Text('Backup notes, default color, sorting'),
            trailing: const Icon(CupertinoIcons.chevron_forward),
            onTap: () {
              // Navigate to Notes screen
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const NotesScreen()),
              );
            },
          ),
          const Divider(height: 1),
          ListTile(
            leading: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(
                CupertinoIcons.info,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: const Text('About'),
            trailing: const Icon(CupertinoIcons.chevron_forward),
            onTap: () {
              // Show about dialog
              showAboutDialog(
                context: context,
                applicationName: "Islam",
                applicationVersion: "0.0.5-beta+1",
                applicationIcon: const FlutterLogo(size: 40),
                children: [
                  const Text("A lightweight Islamic app built with Flutter"),
                  const SizedBox(height: 10),
                  const Text("Created for demonstration purposes"),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}