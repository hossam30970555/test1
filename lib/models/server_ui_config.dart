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
    return ServerUIConfig(
      version: map['version'] ?? '1.0',
      enabledFeatures: List<String>.from(map['enabledFeatures'] ?? []),
      secretAppEnabled: map['secretAppEnabled'] ?? false,
      secretAppConfig: Map<String, dynamic>.from(map['secretAppConfig'] ?? {}),
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
