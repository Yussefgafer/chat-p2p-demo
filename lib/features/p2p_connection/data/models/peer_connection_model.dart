import '../../domain/entities/peer_connection_entity.dart';

/// Model class for peer connection data
class PeerConnectionModel extends PeerConnectionEntity {
  const PeerConnectionModel({
    required super.id,
    required super.peerId,
    required super.peerName,
    required super.connectionType,
    required super.status,
    required super.createdAt,
    super.connectedAt,
    super.lastSeen,
    super.connectionData,
    super.localDescription,
    super.remoteDescription,
    super.iceCandidates = const [],
    super.signalStrength,
    super.latency,
    super.bandwidth,
  });

  /// Create model from entity
  factory PeerConnectionModel.fromEntity(PeerConnectionEntity entity) {
    return PeerConnectionModel(
      id: entity.id,
      peerId: entity.peerId,
      peerName: entity.peerName,
      connectionType: entity.connectionType,
      status: entity.status,
      createdAt: entity.createdAt,
      connectedAt: entity.connectedAt,
      lastSeen: entity.lastSeen,
      connectionData: entity.connectionData,
      localDescription: entity.localDescription,
      remoteDescription: entity.remoteDescription,
      iceCandidates: entity.iceCandidates,
      signalStrength: entity.signalStrength,
      latency: entity.latency,
      bandwidth: entity.bandwidth,
    );
  }

  /// Create model from JSON
  factory PeerConnectionModel.fromJson(Map<String, dynamic> json) {
    return PeerConnectionModel(
      id: json['id'],
      peerId: json['peerId'],
      peerName: json['peerName'],
      connectionType: _parseConnectionType(json['connectionType']),
      status: _parseConnectionStatus(json['status']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      connectedAt: json['connectedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['connectedAt'])
          : null,
      lastSeen: json['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSeen'])
          : null,
      connectionData: json['connectionData'],
      localDescription: json['localDescription'],
      remoteDescription: json['remoteDescription'],
      iceCandidates: List<String>.from(json['iceCandidates'] ?? []),
      signalStrength: json['signalStrength']?.toDouble(),
      latency: json['latency'],
      bandwidth: json['bandwidth']?.toDouble(),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'peerId': peerId,
      'peerName': peerName,
      'connectionType': connectionType.name,
      'status': status.name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'connectedAt': connectedAt?.millisecondsSinceEpoch,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
      'connectionData': connectionData,
      'localDescription': localDescription,
      'remoteDescription': remoteDescription,
      'iceCandidates': iceCandidates,
      'signalStrength': signalStrength,
      'latency': latency,
      'bandwidth': bandwidth,
    };
  }

  /// Create model from database map
  factory PeerConnectionModel.fromDatabase(Map<String, dynamic> map) {
    return PeerConnectionModel(
      id: map['id'],
      peerId: map['peer_id'],
      peerName: map['peer_name'] ?? 'Unknown',
      connectionType: _parseConnectionType(map['connection_type']),
      status: _parseConnectionStatus(map['status']),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      connectedAt: map['connected_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['connected_at'])
          : null,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['last_seen']),
      connectionData: map['connection_data'] != null
          ? Map<String, dynamic>.from(map['connection_data'])
          : null,
    );
  }

  /// Convert model to database map
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'peer_id': peerId,
      'connection_type': connectionType.name,
      'status': status.name,
      'last_seen': (lastSeen ?? DateTime.now()).millisecondsSinceEpoch,
      'connection_data': connectionData,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  /// Copy with new values
  @override
  PeerConnectionModel copyWith({
    String? id,
    String? peerId,
    String? peerName,
    ConnectionType? connectionType,
    PeerConnectionStatus? status,
    DateTime? createdAt,
    DateTime? connectedAt,
    DateTime? lastSeen,
    Map<String, dynamic>? connectionData,
    String? localDescription,
    String? remoteDescription,
    List<String>? iceCandidates,
    double? signalStrength,
    int? latency,
    double? bandwidth,
  }) {
    return PeerConnectionModel(
      id: id ?? this.id,
      peerId: peerId ?? this.peerId,
      peerName: peerName ?? this.peerName,
      connectionType: connectionType ?? this.connectionType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSeen: lastSeen ?? this.lastSeen,
      connectionData: connectionData ?? this.connectionData,
      localDescription: localDescription ?? this.localDescription,
      remoteDescription: remoteDescription ?? this.remoteDescription,
      iceCandidates: iceCandidates ?? this.iceCandidates,
      signalStrength: signalStrength ?? this.signalStrength,
      latency: latency ?? this.latency,
      bandwidth: bandwidth ?? this.bandwidth,
    );
  }

  /// Parse connection type from string
  static ConnectionType _parseConnectionType(String? type) {
    switch (type?.toLowerCase()) {
      case 'webrtc':
        return ConnectionType.webrtc;
      case 'lan':
        return ConnectionType.lan;
      case 'bluetooth':
        return ConnectionType.bluetooth;
      default:
        return ConnectionType.webrtc;
    }
  }

  /// Parse connection status from string
  static PeerConnectionStatus _parseConnectionStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'connected':
        return PeerConnectionStatus.connected;
      case 'connecting':
        return PeerConnectionStatus.connecting;
      case 'disconnected':
        return PeerConnectionStatus.disconnected;
      case 'reconnecting':
        return PeerConnectionStatus.reconnecting;
      case 'failed':
        return PeerConnectionStatus.failed;
      case 'closed':
        return PeerConnectionStatus.closed;
      default:
        return PeerConnectionStatus.disconnected;
    }
  }
}
