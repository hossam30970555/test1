import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/app_model.dart';
import '../providers/settings_provider.dart';
import '../providers/server_config_provider.dart';
import '../widgets/app_grid.dart';
import '../widgets/dock.dart';
import '../widgets/search_bar.dart';
import 'secret_app_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  double _previousPageValue = 0;
  late AnimationController _timeAnimController;
  late Animation<double> _timeScaleAnimation;
  // Secret code for activation
  final List<String> _secretCodeSequence = ['double_tap', 'double_tap', 'long_press'];
  List<String> _currentSequence = [];
  bool _secretCodeActivated = false;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(_pageListener);
    
    // Animation for time widget
    _timeAnimController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    
    _timeScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: 1.05)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.05, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50.0,
      ),
    ]).animate(_timeAnimController);
    
    // Start with a subtle animation
    Future.delayed(const Duration(milliseconds: 500), () {
      _timeAnimController.forward(from: 0.0);
    });
  }
  
  void _pageListener() {
    if (_pageController.page == null) return;
    
    // Trigger time animation only when changing pages
    if ((_previousPageValue - _pageController.page!).abs() >= 0.5) {
      _timeAnimController.forward(from: 0.0);
      _previousPageValue = _pageController.page!;
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_pageListener);
    _pageController.dispose();
    _timeAnimController.dispose();
    super.dispose();
  }
  
  // Add to secret sequence and check if activated
  void _addToSecretSequence(String gesture) {
    setState(() {
      _currentSequence.add(gesture);
      
      // Keep only the last 3 gestures
      if (_currentSequence.length > 3) {
        _currentSequence.removeAt(0);
      }
      
      // Check if secret sequence matches
      if (_currentSequence.length == 3 && 
          _secretCodeSequence[0] == _currentSequence[0] &&
          _secretCodeSequence[1] == _currentSequence[1] &&
          _secretCodeSequence[2] == _currentSequence[2]) {
        // Secret code activated
        _checkSecretApp();
      }
    });
  }
  
  void _checkSecretApp() {
    final serverConfig = Provider.of<ServerConfigProvider>(context, listen: false);
    if (serverConfig.isSecretAppEnabled) {
      _secretCodeActivated = true;
      
      // Show activation success and navigate to secret app
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Secret Feature Activated'),
          content: const Text('You have discovered a hidden feature!'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const SecretAppScreen()),
                );
              },
              child: const Text('CONTINUE'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final serverConfig = Provider.of<ServerConfigProvider>(context);
    
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: settingsProvider.wallpaper.startsWith('file://') 
                ? FileImage(File(settingsProvider.wallpaper.replaceFirst('file://', '')))
                : AssetImage(settingsProvider.wallpaper) as ImageProvider,
            fit: BoxFit.cover,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: IOSSearchBar(),
              ),
              // Time widget with animation
              GestureDetector(
                onDoubleTap: () => _addToSecretSequence('double_tap'),
                onLongPress: () => _addToSecretSequence('long_press'),
                child: AnimatedBuilder(
                  animation: _timeScaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _timeScaleAnimation.value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Text(
                          _formatTime(),
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.w300,
                            color: Colors.white,
                            shadows: [
                              Shadow(
                                blurRadius: 4.0,
                                color: Color.fromARGB(100, 0, 0, 0),
                                offset: Offset(1.0, 1.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              // Status indicator for server config
              if (serverConfig.isLoading)
                Container(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: const SizedBox(
                    width: 12,
                    height: 12,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  ),
                ),
              Expanded(
                child: GestureDetector(
                  onLongPress: () {
                    settingsProvider.editMode = !settingsProvider.editMode;
                    // Adding secret code tracking
                    _addToSecretSequence('long_press');
                  },
                  onDoubleTap: () {
                    // Add to secret sequence
                    _addToSecretSequence('double_tap');
                  },
                  child: PageView.builder(
                    controller: _pageController,
                    onPageChanged: (page) {
                      setState(() {
                        _currentPage = page;
                      });
                    },
                    itemCount: allApps.length,
                    itemBuilder: (context, index) {
                      return AppGrid(
                        pageIndex: index,
                        isEditMode: settingsProvider.editMode,
                      );
                    },
                  ),
                ),
              ),
              // Page indicator with animation
              if (allApps.length > 1)
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      allApps.length,
                      (index) => AnimatedContainer(
                        margin: const EdgeInsets.symmetric(horizontal: 3.0),
                        width: _currentPage == index ? 10.0 : 8.0,
                        height: _currentPage == index ? 10.0 : 8.0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _currentPage == index
                              ? Colors.white
                              : Colors.white.withAlpha(128),
                        ),
                      ),
                    ),
                  ),
                ),
              const Dock(),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour == 0 ? 12 : now.hour;
    final minute = now.minute.toString().padLeft(2, '0');
    return "$hour:$minute";
  }
}