import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class WallpaperScreen extends StatefulWidget {
  const WallpaperScreen({super.key});

  @override
  State<WallpaperScreen> createState() => _WallpaperScreenState();
}

class _WallpaperScreenState extends State<WallpaperScreen> {
  final List<String> _defaultWallpapers = [
    'assets/images/ios_wallpaper.jpg',
    'assets/images/wallpaper1.jpg',
    'assets/images/wallpaper2.jpg',
    'assets/images/wallpaper3.jpg',
  ];
  
  String? _customWallpaperPath;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadCurrentWallpaper();
  }

  void _loadCurrentWallpaper() {
    final wallpaper = Provider.of<SettingsProvider>(context, listen: false).wallpaper;
    if (wallpaper.startsWith('file://')) {
      setState(() {
        _customWallpaperPath = wallpaper.replaceFirst('file://', '');
      });
    }
  }

  Future<void> _pickImage() async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 90,
      );
      
      if (pickedFile != null) {
        setState(() {
          _customWallpaperPath = pickedFile.path;
        });
        // Set the wallpaper path
        Provider.of<SettingsProvider>(context, listen: false)
            .wallpaper = 'file://${pickedFile.path}';
        
        // Return to previous screen
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Wallpaper changed successfully'))
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to select image: $e'))
        );
      }
    }
  }

  void _selectDefaultWallpaper(String path) {
    Provider.of<SettingsProvider>(context, listen: false).wallpaper = path;
    setState(() {
      _customWallpaperPath = null;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Default wallpaper applied'))
    );
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final currentWallpaper = settingsProvider.wallpaper;
    final theme = Theme.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Choose Wallpaper'),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Custom Wallpaper',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Custom wallpaper section
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                // Custom wallpaper display or placeholder
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100,
                    height: 120,
                    decoration: BoxDecoration(
                      color: theme.brightness == Brightness.dark 
                          ? Colors.grey.shade800 
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(12),
                      border: _customWallpaperPath != null && currentWallpaper == 'file://${_customWallpaperPath}'
                          ? Border.all(color: theme.colorScheme.primary, width: 3)
                          : null,
                    ),
                    child: _customWallpaperPath != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.file(
                              File(_customWallpaperPath!),
                              fit: BoxFit.cover,
                            ),
                          )
                        : Icon(
                            CupertinoIcons.photo,
                            size: 40,
                            color: settingsProvider.darkMode ? Colors.white : Colors.grey,
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                // Choose new wallpaper button
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _pickImage,
                    icon: const Icon(CupertinoIcons.photo_camera),
                    label: const Text('Select from Gallery'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Default Wallpapers',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          // Default wallpapers grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.75,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemCount: _defaultWallpapers.length,
              itemBuilder: (context, index) {
                final wallpaperPath = _defaultWallpapers[index];
                final isSelected = currentWallpaper == wallpaperPath;
                
                return GestureDetector(
                  onTap: () => _selectDefaultWallpaper(wallpaperPath),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: isSelected
                          ? Border.all(color: theme.colorScheme.primary, width: 3)
                          : null,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        fit: StackFit.expand,
                        children: [
                          Image.asset(
                            wallpaperPath,
                            fit: BoxFit.cover,
                          ),
                          if (isSelected)
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.primary,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.check,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
