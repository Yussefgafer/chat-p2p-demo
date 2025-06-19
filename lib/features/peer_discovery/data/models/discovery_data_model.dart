import '../../domain/entities/discovery_data_entity.dart';

/// Model class for discovery data
class DiscoveryDataModel extends DiscoveryDataEntity {
  const DiscoveryDataModel({
    required super.id,
    required super.userId,
    required super.userName,
    super.userAvatar,
    required super.method,
    required super.connectionData,
    required super.createdAt,
    required super.expiresAt,
    super.isActive = true,
    super.publicKey,
    super.supportedProtocols = const ['webrtc'],
    super.metadata,
  });

  /// Create model from entity
  factory DiscoveryDataModel.fromEntity(DiscoveryDataEntity entity) {
    return DiscoveryDataModel(
      id: entity.id,
      userId: entity.userId,
      userName: entity.userName,
      userAvatar: entity.userAvatar,
      method: entity.method,
      connectionData: entity.connectionData,
      createdAt: entity.createdAt,
      expiresAt: entity.expiresAt,
      isActive: entity.isActive,
      publicKey: entity.publicKey,
      supportedProtocols: entity.supportedProtocols,
      metadata: entity.metadata,
    );
  }

  /// Create model from JSON
  factory DiscoveryDataModel.fromJson(Map<String, dynamic> json) {
    return DiscoveryDataModel(
      id: json['id'],
      userId: json['userId'],
      userName: json['userName'],
      userAvatar: json['userAvatar'],
      method: _parseDiscoveryMethod(json['method']),
      connectionData: Map<String, dynamic>.from(json['connectionData']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(json['expiresAt']),
      isActive: json['isActive'] ?? true,
      publicKey: json['publicKey'],
      supportedProtocols: List<String>.from(json['supportedProtocols'] ?? ['webrtc']),
      metadata: json['metadata'] != null 
          ? Map<String, dynamic>.from(json['metadata'])
          : null,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'method': method.name,
      'connectionData': connectionData,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'isActive': isActive,
      'publicKey': publicKey,
      'supportedProtocols': supportedProtocols,
      'metadata': metadata,
    };
  }

  /// Create model from database map
  factory DiscoveryDataModel.fromDatabase(Map<String, dynamic> map) {
    return DiscoveryDataModel(
      id: map['id'],
      userId: map['user_id'],
      userName: map['user_name'],
      userAvatar: map['user_avatar'],
      method: _parseDiscoveryMethod(map['method']),
      connectionData: map['connection_data'] != null
          ? Map<String, dynamic>.from(map['connection_data'])
          : {},
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      expiresAt: DateTime.fromMillisecondsSinceEpoch(map['expires_at']),
      isActive: map['is_active'] == 1,
      publicKey: map['public_key'],
      supportedProtocols: map['supported_protocols'] != null
          ? List<String>.from(map['supported_protocols'])
          : ['webrtc'],
      metadata: map['metadata'] != null
          ? Map<String, dynamic>.from(map['metadata'])
          : null,
    );
  }

  /// Convert model to database map
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'method': method.name,
      'connection_data': connectionData,
      'created_at': createdAt.millisecondsSinceEpoch,
      'expires_at': expiresAt.millisecondsSinceEpoch,
      'is_active': isActive ? 1 : 0,
      'public_key': publicKey,
      'supported_protocols': supportedProtocols,
      'metadata': metadata,
    };
  }

  /// Copy with new values
  @override
  DiscoveryDataModel copyWith({
    String? id,
    String? userId,
    String? userName,
    String? userAvatar,
    DiscoveryMethod? method,
    Map<String, dynamic>? connectionData,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? isActive,
    String? publicKey,
    List<String>? supportedProtocols,
    Map<String, dynamic>? metadata,
  }) {
    return DiscoveryDataModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      userName: userName ?? this.userName,
      userAvatar: userAvatar ?? this.userAvatar,
      method: method ?? this.method,
      connectionData: connectionData ?? this.connectionData,
      createdAt: createdAt ?? this.createdAt,
      expiresAt: expiresAt ?? this.expiresAt,
      isActive: isActive ?? this.isActive,
      publicKey: publicKey ?? this.publicKey,
      supportedProtocols: supportedProtocols ?? this.supportedProtocols,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Parse discovery method from string
  static DiscoveryMethod _parseDiscoveryMethod(String? method) {
    switch (method?.toLowerCase()) {
      case 'qrcode':
        return DiscoveryMethod.qrCode;
      case 'link':
        return DiscoveryMethod.link;
      case 'lan':
        return DiscoveryMethod.lan;
      case 'bluetooth':
        return DiscoveryMethod.bluetooth;
      case 'manual':
        return DiscoveryMethod.manual;
      default:
        return DiscoveryMethod.qrCode;
    }
  }

  /// Generate QR code data string
  @override
  String toQRCodeData() {
    final data = toJson();
    return Uri.encodeComponent(data.toString());
  }

  /// Generate shareable link
  @override
  String toShareableLink({String baseUrl = 'https://chatp2p.app/connect'}) {
    final params = {
      'id': id,
      'userId': userId,
      'userName': userName,
      'data': Uri.encodeComponent(connectionData.toString()),
      'expires': expiresAt.millisecondsSinceEpoch.toString(),
      'publicKey': publicKey ?? '',
    };
    
    final queryString = params.entries
        .where((e) => e.value.isNotEmpty)
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return '$baseUrl?$queryString';
  }
}
