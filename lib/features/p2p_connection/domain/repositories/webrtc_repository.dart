import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/peer_connection_entity.dart';

/// Abstract repository for WebRTC operations
abstract class WebRTCRepository {
  /// Initialize WebRTC configuration
  Future<Either<Failure, void>> initialize();
  
  /// Create a new peer connection
  Future<Either<Failure, PeerConnectionEntity>> createPeerConnection({
    required String peerId,
    required String peerName,
    required ConnectionType connectionType,
  });
  
  /// Close a peer connection
  Future<Either<Failure, void>> closePeerConnection(String connectionId);
  
  /// Create an offer for establishing connection
  Future<Either<Failure, String>> createOffer(String connectionId);
  
  /// Create an answer for an incoming offer
  Future<Either<Failure, String>> createAnswer(String connectionId, String offer);
  
  /// Set remote description (offer/answer)
  Future<Either<Failure, void>> setRemoteDescription(
    String connectionId,
    String description,
  );
  
  /// Set local description
  Future<Either<Failure, void>> setLocalDescription(
    String connectionId,
    String description,
  );
  
  /// Add ICE candidate
  Future<Either<Failure, void>> addIceCandidate(
    String connectionId,
    String candidate,
  );
  
  /// Get all active connections
  Future<Either<Failure, List<PeerConnectionEntity>>> getActiveConnections();
  
  /// Get connection by ID
  Future<Either<Failure, PeerConnectionEntity?>> getConnectionById(String connectionId);
  
  /// Get connections by peer ID
  Future<Either<Failure, List<PeerConnectionEntity>>> getConnectionsByPeerId(String peerId);
  
  /// Send data through data channel
  Future<Either<Failure, void>> sendData(String connectionId, String data);
  
  /// Listen to connection state changes
  Stream<PeerConnectionEntity> watchConnectionState(String connectionId);
  
  /// Listen to all connection changes
  Stream<List<PeerConnectionEntity>> watchAllConnections();
  
  /// Listen to incoming data
  Stream<Map<String, dynamic>> watchIncomingData();
  
  /// Get connection statistics
  Future<Either<Failure, Map<String, dynamic>>> getConnectionStats(String connectionId);
  
  /// Update connection quality metrics
  Future<Either<Failure, void>> updateConnectionMetrics(
    String connectionId,
    double? signalStrength,
    int? latency,
    double? bandwidth,
  );
  
  /// Restart ICE for a connection
  Future<Either<Failure, void>> restartIce(String connectionId);
  
  /// Check if WebRTC is supported
  Future<Either<Failure, bool>> isWebRTCSupported();
  
  /// Get available STUN/TURN servers
  Future<Either<Failure, List<Map<String, dynamic>>>> getIceServers();
  
  /// Test connection to STUN/TURN servers
  Future<Either<Failure, bool>> testIceServers();
  
  /// Enable/disable audio
  Future<Either<Failure, void>> setAudioEnabled(String connectionId, bool enabled);
  
  /// Enable/disable video
  Future<Either<Failure, void>> setVideoEnabled(String connectionId, bool enabled);
  
  /// Get media stream
  Future<Either<Failure, dynamic>> getMediaStream({
    bool audio = false,
    bool video = false,
  });
  
  /// Add media stream to connection
  Future<Either<Failure, void>> addMediaStream(String connectionId, dynamic stream);
  
  /// Remove media stream from connection
  Future<Either<Failure, void>> removeMediaStream(String connectionId, dynamic stream);
  
  /// Dispose all resources
  Future<Either<Failure, void>> dispose();
}
