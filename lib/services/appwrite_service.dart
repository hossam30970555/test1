import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'dart:convert';
import '../models/server_ui_config.dart';

class AppwriteService {
  static final AppwriteService _instance = AppwriteService._internal();
  
  factory AppwriteService() => _instance;
  
  AppwriteService._internal();
  
  late Client client;
  late Databases databases;
  late Realtime realtime;
  
  // Initialize Appwrite clients
  void initialize() {
    client = Client();
    client
      .setEndpoint('https://appwrite.iasys.me/v1')
      .setProject('67d3180b00227563b2dc')
      .setSelfSigned(status: true); // Only use for development
    
    databases = Databases(client);
    realtime = Realtime(client);
  }
  
  // Fetch UI configuration from Appwrite
  Future<ServerUIConfig> fetchUIConfig() async {
    try {
      // Assuming you have a database with ID 'ui_config' and collection 'configurations'
      final document = await databases.getDocument(
        databaseId: 'ui_config',
        collectionId: 'configurations',
        documentId: 'current_config',
      );
      
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
      
      return ServerUIConfig.fromMap(processedData);
    } catch (e) {
      print('Error fetching UI config: $e');
      // Return default config if fetch fails
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
    return realtime.subscribe(['databases.ui_config.collections.configurations.documents']).stream
      .where((event) => event.payload['_id'] == 'current_config')
      .map((event) {
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
        
        return ServerUIConfig.fromMap(processedPayload);
      });
  }
}
