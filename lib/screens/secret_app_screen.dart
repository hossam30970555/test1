import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../providers/server_config_provider.dart';

class SecretAppScreen extends StatefulWidget {
  const SecretAppScreen({super.key});

  @override
  State<SecretAppScreen> createState() => _SecretAppScreenState();
}

class _SecretAppScreenState extends State<SecretAppScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final serverConfig = Provider.of<ServerConfigProvider>(context);
    final config = serverConfig.config.secretAppConfig;
    
    // Safely access config values with fallbacks
    final String title = config['title']?.toString() ?? 'Secret App';
    final String message = config['message']?.toString() ?? 'This is a server-controlled secret feature!';
    final String colorHex = config['colorHex']?.toString() ?? '#FF9800';
    
    // Parse color with error handling
    Color themeColor;
    try {
      themeColor = Color(int.parse(colorHex.replaceAll('#', '0xFF')));
    } catch (e) {
      print('Error parsing color: $e');
      themeColor = Colors.orange; // Fallback color
    }

    return Scaffold(
      backgroundColor: themeColor.withOpacity(0.1),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: themeColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FadeTransition(
            opacity: _animation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(
                  CupertinoIcons.lock_shield,
                  size: 100,
                  color: themeColor,
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: themeColor,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 48),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 32,
                      vertical: 16,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  onPressed: () {
                    serverConfig.refreshConfig();
                  },
                  child: const Text(
                    'Refresh Configuration',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
