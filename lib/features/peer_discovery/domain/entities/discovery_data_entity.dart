import 'package:equatable/equatable.dart';

/// Enum for discovery methods
enum DiscoveryMethod {
  qrCode,
  link,
  lan,
  bluetooth,
  manual,
}

/// Entity representing peer discovery data
class DiscoveryDataEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String? userAvatar;
  final DiscoveryMethod method;
  final Map<String, dynamic> connectionData;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool isActive;
  final String? publicKey;
  final List<String> supportedProtocols;
  final Map<String, dynamic>? metadata;

  const DiscoveryDataEntity({
    required this.id,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.method,
    required this.connectionData,
    required this.createdAt,
    required this.expiresAt,
    this.isActive = true,
    this.publicKey,
    this.supportedProtocols = const ['webrtc'],
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        method,
        connectionData,
        createdAt,
        expiresAt,
        isActive,
        publicKey,
        supportedProtocols,
        metadata,
      ];

  DiscoveryDataEntity copyWith({
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
    return DiscoveryDataEntity(
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

  /// Check if discovery data is expired
  bool get isExpired => DateTime.now().isAfter(expiresAt);

  /// Check if discovery data is valid
  bool get isValid => isActive && !isExpired;

  /// Get time remaining until expiration
  Duration get timeUntilExpiration {
    if (isExpired) return Duration.zero;
    return expiresAt.difference(DateTime.now());
  }

  /// Generate QR code data string
  String toQRCodeData() {
    final data = {
      'id': id,
      'userId': userId,
      'userName': userName,
      'userAvatar': userAvatar,
      'method': method.name,
      'connectionData': connectionData,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'expiresAt': expiresAt.millisecondsSinceEpoch,
      'publicKey': publicKey,
      'supportedProtocols': supportedProtocols,
      'metadata': metadata,
    };
    
    // Convert to JSON string for QR code
    return Uri.encodeComponent(data.toString());
  }

  /// Generate shareable link
  String toShareableLink({String baseUrl = 'https://chatp2p.app/connect'}) {
    final params = {
      'id': id,
      'userId': userId,
      'userName': userName,
      'data': Uri.encodeComponent(connectionData.toString()),
      'expires': expiresAt.millisecondsSinceEpoch.toString(),
    };
    
    final queryString = params.entries
        .map((e) => '${e.key}=${e.value}')
        .join('&');
    
    return '$baseUrl?$queryString';
  }

  /// Get connection priority based on method
  int get connectionPriority {
    switch (method) {
      case DiscoveryMethod.lan:
        return 1; // Highest priority - local network
      case DiscoveryMethod.bluetooth:
        return 2; // Second priority - direct connection
      case DiscoveryMethod.qrCode:
        return 3; // Third priority - manual but secure
      case DiscoveryMethod.link:
        return 4; // Fourth priority - convenient but less secure
      case DiscoveryMethod.manual:
        return 5; // Lowest priority - manual entry
    }
  }
}
