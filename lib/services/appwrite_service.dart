import 'package:appwrite/appwrite.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/server_ui_config.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  
  factory AppwriteService() => _instance;
  
  AppwriteService._internal();
  
  late Client client;
  late Databases databases;
  late Realtime realtime;
  late Account account;
  bool _isInitialized = false;

  // Local cache key
  static const String _configCacheKey = 'cached_ui_config';

  // Initialize Appwrite clients
  Future<void> initialize() async {
    if (_isInitialized) return;
    
    try {
      client = Client();
      client
        .setEndpoint('https://appwrite.iasys.me/v1')
        .setProject('67d3180b00227563b2dc')
        .setSelfSigned(status: true);
      
      databases = Databases(client);
      realtime = Realtime(client);
      account = Account(client);
      
      // Create an anonymous session for authentication if needed
      try {
        await account.createAnonymousSession();
        print('Anonymous session created successfully');
      } catch (e) {
        print('Error creating anonymous session: $e');
      }
      
      _isInitialized = true;
      print('Appwrite successfully initialized');
    } catch (e) {
      print('Error initializing Appwrite client: $e');
      throw Exception('Failed to initialize Appwrite: $e');
    }
  }

  // Check if device has internet connection
  Future<bool> _hasInternetConnection() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }
  
  // Verify Appwrite connectivity
  Future<bool> verifyConnectivity() async {
    if (!await _hasInternetConnection()) {
      print('No internet connection available');
      return false;
    }
    
    try {
      // Try to ping the Appwrite server
      await account.get();  // Fixed: using account object directly
      print('Appwrite connection successful');
      return true;
    } catch (e) {
      print('Appwrite connection failed: $e');
      return false;
    }
  }

  // Save config to local storage
  Future<void> _saveConfigToCache(ServerUIConfig config) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = json.encode(config.toMap());
      await prefs.setString(_configCacheKey, jsonString);
      print('Config saved to cache');
    } catch (e) {
      print('Error saving config to cache: $e');
    }
  }

  // Load config from local storage
  Future<ServerUIConfig?> _loadConfigFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(_configCacheKey);
      
      if (jsonString == null) return null;
      
      final configMap = json.decode(jsonString) as Map<String, dynamic>;
      return ServerUIConfig.fromMap(configMap);
    } catch (e) {
      print('Error loading config from cache: $e');
      return null;
    }
  }
  
  // Fetch UI configuration from Appwrite
  Future<ServerUIConfig> fetchUIConfig() async {
    if (!_isInitialized) await initialize();
    
    try {
      // Check internet connection
      final hasConnection = await _hasInternetConnection();
      if (!hasConnection) {
        print('No internet connection, loading from cache');
        final cachedConfig = await _loadConfigFromCache();
        if (cachedConfig != null) return cachedConfig;
        throw Exception('No internet connection and no cached config available');
      }
      
      print('Fetching UI config from Appwrite...');
      
      // Assuming you have a database with ID 'ui_config' and collection 'configurations'
      final document = await databases.getDocument(
        databaseId: 'ui_config',
        collectionId: 'configurations',
        documentId: 'current_config',
      );
      
      print('Document retrieved: ${document.toMap()}');
      
      // Process the document data to handle potential string-based JSON
      Map<String, dynamic> processedData = {...document.data};
      
      // If secretAppConfig is a string (JSON string from Appwrite), parse it
      if (processedData['secretAppConfig'] != null && 
          processedData['secretAppConfig'] is String) {
        try {
          processedData['secretAppConfig'] = 
              json.decode(processedData['secretAppConfig'] as String);
        } catch (e) {
          print('Error parsing secretAppConfig: $e');
          processedData['secretAppConfig'] = {};
        }
      }
      
      final config = ServerUIConfig.fromMap(processedData);
      
      // Cache the config
      await _saveConfigToCache(config);
      
      return config;
    } catch (e) {
      print('Error fetching UI config: $e');
      
      // Try to load from cache if available
      final cachedConfig = await _loadConfigFromCache();
      if (cachedConfig != null) {
        print('Loaded config from cache');
        return cachedConfig;
      }
      
      // Return default config if fetch fails and no cache
      return ServerUIConfig(
        version: '1.0',
        enabledFeatures: [],
        secretAppEnabled: false,
        secretAppConfig: {},
      );
    }
  }
  
  // Subscribe to real-time updates for UI configuration changes
  Stream<ServerUIConfig> listenToConfigChanges() {
    if (!_isInitialized) {
      // Return an empty stream if not initialized
      print('Realtime not initialized');
      return Stream.empty();
    }
    
    print('Setting up realtime subscription');
    
    return realtime.subscribe(['databases.ui_config.collections.configurations.documents']).stream
      .where((event) {
        // Fixed: using the events property of RealtimeMessage
        print('Received realtime event type: ${event.events}');
        return event.payload.containsKey('_id') && event.payload['_id'] == 'current_config';
      })
      .map((event) {
        print('Processing realtime event: ${event.payload}');
        
        // Process the payload to handle string-based JSON
        Map<String, dynamic> processedPayload = {...event.payload};
        
        // If secretAppConfig is a string (JSON string from Appwrite), parse it
        if (processedPayload['secretAppConfig'] != null && 
            processedPayload['secretAppConfig'] is String) {
          try {
            processedPayload['secretAppConfig'] = 
                json.decode(processedPayload['secretAppConfig'] as String);
          } catch (e) {
            print('Error parsing secretAppConfig in stream: $e');
            processedPayload['secretAppConfig'] = {};
          }
        }
        
        final config = ServerUIConfig.fromMap(processedPayload);
        
        // Cache the updated config
        _saveConfigToCache(config);
        
        return config;
      });
  }
}
