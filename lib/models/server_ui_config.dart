import 'dart:convert';

class ServerUIConfig {
  final String version;
  final List<String> enabledFeatures;
  final bool secretAppEnabled;
  final Map<String, dynamic> secretAppConfig;

  ServerUIConfig({
    required this.version,
    required this.enabledFeatures,
    required this.secretAppEnabled,
    required this.secretAppConfig,
  });

  factory ServerUIConfig.fromMap(Map<String, dynamic> map) {
    // Handle enabledFeatures which might be a String or List
    List<String> features = [];
    if (map['enabledFeatures'] != null) {
      if (map['enabledFeatures'] is List) {
        features = List<String>.from(map['enabledFeatures']);
      } else if (map['enabledFeatures'] is String) {
        try {
          features = List<String>.from(json.decode(map['enabledFeatures'] as String));
        } catch (e) {
          print('Error parsing enabledFeatures: $e');
        }
      }
    }

    // Handle secretAppConfig which might be a String or Map
    Map<String, dynamic> configMap = {};
    if (map['secretAppConfig'] != null) {
      if (map['secretAppConfig'] is Map) {
        configMap = Map<String, dynamic>.from(map['secretAppConfig']);
      } else if (map['secretAppConfig'] is String) {
        try {
          configMap = Map<String, dynamic>.from(json.decode(map['secretAppConfig'] as String));
        } catch (e) {
          print('Error parsing secretAppConfig in model: $e');
        }
      }
    }

    return ServerUIConfig(
      version: map['version'] ?? '1.0',
      enabledFeatures: features,
      secretAppEnabled: map['secretAppEnabled'] ?? false,
      secretAppConfig: configMap,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'version': version,
      'enabledFeatures': enabledFeatures,
      'secretAppEnabled': secretAppEnabled,
      'secretAppConfig': secretAppConfig,
    };
  }

  String toJson() => json.encode(toMap());

  factory ServerUIConfig.fromJson(String source) => 
      ServerUIConfig.fromMap(json.decode(source));
  
  ServerUIConfig copyWith({
    String? version,
    List<String>? enabledFeatures,
    bool? secretAppEnabled,
    Map<String, dynamic>? secretAppConfig,
  }) {
    return ServerUIConfig(
      version: version ?? this.version,
      enabledFeatures: enabledFeatures ?? this.enabledFeatures,
      secretAppEnabled: secretAppEnabled ?? this.secretAppEnabled,
      secretAppConfig: secretAppConfig ?? this.secretAppConfig,
    );
  }
}
