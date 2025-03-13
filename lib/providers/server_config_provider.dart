import 'package:flutter/material.dart';
import '../models/server_ui_config.dart';
import '../services/appwrite_service.dart';
import 'dart:async';

class ServerConfigProvider with ChangeNotifier {
  final AppwriteService _appwriteService = AppwriteService();
  ServerUIConfig _config = ServerUIConfig(
    version: '1.0',
    enabledFeatures: [],
    secretAppEnabled: false,
    secretAppConfig: {},
  );
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  bool _isConnected = false;
  StreamSubscription? _configSubscription;

  ServerConfigProvider() {
    _initialize();
  }

  ServerUIConfig get config => _config;
  bool get isLoading => _isLoading;
  bool get hasError => _hasError;
  String get errorMessage => _errorMessage;
  bool get isConnected => _isConnected;
  bool get isSecretAppEnabled => _config.secretAppEnabled;
  
  Future<void> _initialize() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    
    try {
      // Initialize Appwrite
      await _appwriteService.initialize();
      
      // Check connectivity
      _isConnected = await _appwriteService.verifyConnectivity();
      if (!_isConnected) {
        _hasError = true;
        _errorMessage = 'Unable to connect to Appwrite server';
        print('Appwrite connectivity check failed');
      } else {
        print('Appwrite connectivity verified');
      }
      
      // Get initial config (will try to fetch from server or use cache)
      _config = await _appwriteService.fetchUIConfig();
      print('Loaded config: ${_config.toMap()}');
      
      // Only setup realtime if connected
      if (_isConnected) {
        // Listen for real-time updates
        _configSubscription = _appwriteService.listenToConfigChanges().listen(
          (updatedConfig) {
            print('Received config update: ${updatedConfig.toMap()}');
            _config = updatedConfig;
            notifyListeners();
          },
          onError: (error) {
            print('Error in realtime subscription: $error');
          }
        );
      }
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error initializing server config: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Manually refresh config from server
  Future<void> refreshConfig() async {
    _isLoading = true;
    _hasError = false;
    notifyListeners();
    
    try {
      // Re-check connectivity
      _isConnected = await _appwriteService.verifyConnectivity();
      
      if (!_isConnected) {
        _hasError = true;
        _errorMessage = 'No connection to server. Using cached data if available.';
      }
      
      _config = await _appwriteService.fetchUIConfig();
      print('Config refreshed: ${_config.toMap()}');
    } catch (e) {
      _hasError = true;
      _errorMessage = 'Error refreshing config: $e';
      print(_errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _configSubscription?.cancel();
    super.dispose();
  }
}
