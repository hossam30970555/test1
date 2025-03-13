import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:test1/screens/wallpaper_screen.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    
    return Scaffold(
      backgroundColor: settingsProvider.darkMode ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: settingsProvider.darkMode ? Colors.black : Colors.white,
        leading: IconButton(
          icon: Icon(
            CupertinoIcons.back, 
            color: settingsProvider.darkMode ? Colors.white : Colors.black,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Settings',
          style: TextStyle(
            color: settingsProvider.darkMode ? Colors.white : Colors.black, 
            fontWeight: FontWeight.w400
          ),
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 20),
          _buildUserSection(context, settingsProvider),
          const SizedBox(height: 20),
          _buildSettingsSection(context, settingsProvider),
          const SizedBox(height: 20),
          _buildAppSection(context, settingsProvider),
          const SizedBox(height: 20),
          Center(
            child: Text(
              'iOS Launcher v0.0.1.beta',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUserSection(BuildContext context, SettingsProvider settingsProvider) {
    return Container(
      color: settingsProvider.darkMode ? Colors.grey.shade900 : Colors.white,
      child: ListTile(
        leading: const CircleAvatar(
          backgroundColor: Colors.blue,
          child: Icon(
            CupertinoIcons.person_fill,
            color: Colors.white,
          ),
        ),
        title: Text(
          'User Name',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: settingsProvider.darkMode ? Colors.white : Colors.black,
          ),
        ),
        subtitle: Text(
          'Apple ID, iCloud, App Store & More',
          style: TextStyle(
            color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade600,
          ),
        ),
        trailing: Icon(
          CupertinoIcons.chevron_forward,
          color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade400,
        ),
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context, SettingsProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: settingsProvider.darkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            title: Text(
              'Dark Mode',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.white : Colors.black,
              ),
            ),
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
            title: Text(
              'Edit Mode',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.white : Colors.black,
              ),
            ),
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
            title: Text(
              'Notifications',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.white : Colors.black,
              ),
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade400,
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
                CupertinoIcons.photo,
                color: Colors.white,
                size: 20,
              ),
            ),
            title: Text(
              'Wallpaper',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.white : Colors.black,
              ),
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade400,
            ),
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

  Widget _buildAppSection(BuildContext context, SettingsProvider settingsProvider) {
    return Container(
      decoration: BoxDecoration(
        color: settingsProvider.darkMode ? Colors.grey.shade900 : Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 16),
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
            title: Text(
              'Calculator',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Scientific mode, history options',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade600,
              ),
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade400,
            ),
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
            title: Text(
              'Notes',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.white : Colors.black,
              ),
            ),
            subtitle: Text(
              'Backup notes, default color, sorting',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade600,
              ),
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade400,
            ),
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
            title: Text(
              'About',
              style: TextStyle(
                color: settingsProvider.darkMode ? Colors.white : Colors.black,
              ),
            ),
            trailing: Icon(
              CupertinoIcons.chevron_forward,
              color: settingsProvider.darkMode ? Colors.grey : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}