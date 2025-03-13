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
      
      return ServerUIConfig.fromMap(document.data);
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
      .map((event) => ServerUIConfig.fromMap(event.payload));
  }
}
