import 'package:equatable/equatable.dart';

/// Enum for peer connection status
enum PeerConnectionStatus {
  disconnected,
  connecting,
  connected,
  reconnecting,
  failed,
  closed,
}

/// Enum for connection type
enum ConnectionType {
  webrtc,
  lan,
  bluetooth,
}

/// Entity representing a peer connection
class PeerConnectionEntity extends Equatable {
  final String id;
  final String peerId;
  final String peerName;
  final ConnectionType connectionType;
  final PeerConnectionStatus status;
  final DateTime createdAt;
  final DateTime? connectedAt;
  final DateTime? lastSeen;
  final Map<String, dynamic>? connectionData;
  final String? localDescription;
  final String? remoteDescription;
  final List<String> iceCandidates;
  final double? signalStrength;
  final int? latency; // in milliseconds
  final double? bandwidth; // in Mbps

  const PeerConnectionEntity({
    required this.id,
    required this.peerId,
    required this.peerName,
    required this.connectionType,
    required this.status,
    required this.createdAt,
    this.connectedAt,
    this.lastSeen,
    this.connectionData,
    this.localDescription,
    this.remoteDescription,
    this.iceCandidates = const [],
    this.signalStrength,
    this.latency,
    this.bandwidth,
  });

  @override
  List<Object?> get props => [
        id,
        peerId,
        peerName,
        connectionType,
        status,
        createdAt,
        connectedAt,
        lastSeen,
        connectionData,
        localDescription,
        remoteDescription,
        iceCandidates,
        signalStrength,
        latency,
        bandwidth,
      ];

  PeerConnectionEntity copyWith({
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
    return PeerConnectionEntity(
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

  /// Check if connection is active
  bool get isActive => status == PeerConnectionStatus.connected;

  /// Check if connection is in progress
  bool get isConnecting => status == PeerConnectionStatus.connecting ||
      status == PeerConnectionStatus.reconnecting;

  /// Check if connection has failed
  bool get hasFailed => status == PeerConnectionStatus.failed;

  /// Get connection duration
  Duration? get connectionDuration {
    if (connectedAt != null) {
      return DateTime.now().difference(connectedAt!);
    }
    return null;
  }

  /// Get time since last seen
  Duration? get timeSinceLastSeen {
    if (lastSeen != null) {
      return DateTime.now().difference(lastSeen!);
    }
    return null;
  }

  /// Get connection quality based on latency and signal strength
  ConnectionQuality get connectionQuality {
    if (!isActive) return ConnectionQuality.none;
    
    if (latency != null && signalStrength != null) {
      if (latency! < 50 && signalStrength! > 0.8) {
        return ConnectionQuality.excellent;
      } else if (latency! < 100 && signalStrength! > 0.6) {
        return ConnectionQuality.good;
      } else if (latency! < 200 && signalStrength! > 0.4) {
        return ConnectionQuality.fair;
      } else {
        return ConnectionQuality.poor;
      }
    }
    
    return ConnectionQuality.unknown;
  }
}

/// Enum for connection quality
enum ConnectionQuality {
  none,
  poor,
  fair,
  good,
  excellent,
  unknown,
}
