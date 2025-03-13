import 'package:flutter/material.dart';
import '../models/server_ui_config.dart';
import '../services/appwrite_service.dart';
import 'dart:async';

class ServerConfigProvider with ChangeNotifier {
  AppwriteService _appwriteService = AppwriteService();
  ServerUIConfig _config = ServerUIConfig(
    version: '1.0',
    enabledFeatures: [],
    secretAppEnabled: false,
    secretAppConfig: {},
  );
  bool _isLoading = true;
  StreamSubscription? _configSubscription;

  ServerConfigProvider() {
    _initialize();
  }

  ServerUIConfig get config => _config;
  bool get isLoading => _isLoading;
  bool get isSecretAppEnabled => _config.secretAppEnabled;
  
  Future<void> _initialize() async {
    try {
      _appwriteService.initialize();
      
      // Get initial config
      _config = await _appwriteService.fetchUIConfig();
      _isLoading = false;
      notifyListeners();
      
      // Listen for real-time updates
      _configSubscription = _appwriteService.listenToConfigChanges().listen((updatedConfig) {
        _config = updatedConfig;
        notifyListeners();
      });
    } catch (e) {
      print('Error initializing server config: $e');
      _isLoading = false;
      notifyListeners();
    }
  }

  // Manually refresh config from server
  Future<void> refreshConfig() async {
    _isLoading = true;
    notifyListeners();
    
    try {
      _config = await _appwriteService.fetchUIConfig();
    } catch (e) {
      print('Error refreshing config: $e');
    }
    
    _isLoading = false;
    notifyListeners();
  }

  @override
  void dispose() {
    _configSubscription?.cancel();
    super.dispose();
  }
}
