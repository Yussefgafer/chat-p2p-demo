import 'dart:async';
import 'dart:convert';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../models/peer_connection_model.dart';

/// Abstract class for WebRTC data operations
abstract class WebRTCDataSource {
  Future<void> initialize();
  Future<PeerConnectionModel> createPeerConnection({
    required String peerId,
    required String peerName,
    required String connectionType,
  });
  Future<void> closePeerConnection(String connectionId);
  Future<String> createOffer(String connectionId);
  Future<String> createAnswer(String connectionId, String offer);
  Future<void> setRemoteDescription(String connectionId, String description);
  Future<void> setLocalDescription(String connectionId, String description);
  Future<void> addIceCandidate(String connectionId, String candidate);
  Future<void> sendData(String connectionId, String data);
  Future<Map<String, dynamic>> getConnectionStats(String connectionId);
  Future<void> dispose();
  
  // Streams
  Stream<PeerConnectionModel> watchConnectionState(String connectionId);
  Stream<Map<String, dynamic>> watchIncomingData();
}

/// Implementation of WebRTC data source
class WebRTCDataSourceImpl implements WebRTCDataSource {
  final Map<String, RTCPeerConnection> _peerConnections = {};
  final Map<String, RTCDataChannel> _dataChannels = {};
  final Map<String, PeerConnectionModel> _connectionModels = {};
  
  final StreamController<PeerConnectionModel> _connectionStateController =
      StreamController<PeerConnectionModel>.broadcast();
  final StreamController<Map<String, dynamic>> _incomingDataController =
      StreamController<Map<String, dynamic>>.broadcast();

  bool _isInitialized = false;

  @override
  Future<void> initialize() async {
    try {
      if (_isInitialized) return;
      
      // Initialize WebRTC
      await WebRTC.initialize();
      _isInitialized = true;
    } catch (e) {
      throw WebRTCException(message: 'Failed to initialize WebRTC: $e');
    }
  }

  @override
  Future<PeerConnectionModel> createPeerConnection({
    required String peerId,
    required String peerName,
    required String connectionType,
  }) async {
    try {
      if (!_isInitialized) {
        throw WebRTCException(message: 'WebRTC not initialized');
      }

      final connectionId = UuidGenerator.generatePeerConnectionId();
      
      // Create RTCPeerConnection
      final peerConnection = await createPeerConnectionWithConfig();
      
      // Create data channel
      final dataChannel = await peerConnection.createDataChannel(
        'chat',
        RTCDataChannelInit()..ordered = true,
      );

      // Set up event listeners
      _setupPeerConnectionListeners(connectionId, peerConnection);
      _setupDataChannelListeners(connectionId, dataChannel);

      // Store connections
      _peerConnections[connectionId] = peerConnection;
      _dataChannels[connectionId] = dataChannel;

      // Create model
      final model = PeerConnectionModel(
        id: connectionId,
        peerId: peerId,
        peerName: peerName,
        connectionType: connectionType,
        status: 'connecting',
        createdAt: DateTime.now(),
        iceCandidates: [],
      );

      _connectionModels[connectionId] = model;
      
      return model;
    } catch (e) {
      throw WebRTCException(message: 'Failed to create peer connection: $e');
    }
  }

  Future<RTCPeerConnection> createPeerConnectionWithConfig() async {
    final configuration = RTCConfiguration()
      ..iceServers = AppConstants.rtcConfiguration['iceServers']
          .map<RTCIceServer>((server) => RTCIceServer(
                urls: server['urls'],
                username: server['username'],
                credential: server['credential'],
              ))
          .toList()
      ..iceCandidatePoolSize = AppConstants.rtcConfiguration['iceCandidatePoolSize'];

    return await createPeerConnection(configuration.toMap());
  }

  void _setupPeerConnectionListeners(String connectionId, RTCPeerConnection pc) {
    pc.onIceCandidate = (candidate) {
      _handleIceCandidate(connectionId, candidate);
    };

    pc.onConnectionState = (state) {
      _handleConnectionStateChange(connectionId, state);
    };

    pc.onDataChannel = (channel) {
      _setupDataChannelListeners(connectionId, channel);
    };
  }

  void _setupDataChannelListeners(String connectionId, RTCDataChannel channel) {
    channel.onMessage = (message) {
      _handleIncomingData(connectionId, message.text);
    };

    channel.onDataChannelState = (state) {
      _handleDataChannelStateChange(connectionId, state);
    };
  }

  void _handleIceCandidate(String connectionId, RTCIceCandidate candidate) {
    final model = _connectionModels[connectionId];
    if (model != null) {
      final updatedModel = model.copyWith(
        iceCandidates: [...model.iceCandidates, candidate.candidate ?? ''],
      );
      _connectionModels[connectionId] = updatedModel;
      _connectionStateController.add(updatedModel);
    }
  }

  void _handleConnectionStateChange(String connectionId, RTCPeerConnectionState state) {
    final model = _connectionModels[connectionId];
    if (model != null) {
      String status;
      DateTime? connectedAt;
      
      switch (state) {
        case RTCPeerConnectionState.RTCPeerConnectionStateConnected:
          status = 'connected';
          connectedAt = DateTime.now();
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateConnecting:
          status = 'connecting';
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateDisconnected:
          status = 'disconnected';
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateFailed:
          status = 'failed';
          break;
        case RTCPeerConnectionState.RTCPeerConnectionStateClosed:
          status = 'closed';
          break;
        default:
          status = 'unknown';
      }

      final updatedModel = model.copyWith(
        status: status,
        connectedAt: connectedAt,
        lastSeen: DateTime.now(),
      );
      
      _connectionModels[connectionId] = updatedModel;
      _connectionStateController.add(updatedModel);
    }
  }

  void _handleDataChannelStateChange(String connectionId, RTCDataChannelState state) {
    // Handle data channel state changes if needed
  }

  void _handleIncomingData(String connectionId, String data) {
    try {
      final decodedData = json.decode(data);
      _incomingDataController.add({
        'connectionId': connectionId,
        'data': decodedData,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    } catch (e) {
      // Handle non-JSON data
      _incomingDataController.add({
        'connectionId': connectionId,
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      });
    }
  }

  @override
  Future<void> closePeerConnection(String connectionId) async {
    try {
      final peerConnection = _peerConnections[connectionId];
      final dataChannel = _dataChannels[connectionId];

      await dataChannel?.close();
      await peerConnection?.close();

      _peerConnections.remove(connectionId);
      _dataChannels.remove(connectionId);
      _connectionModels.remove(connectionId);
    } catch (e) {
      throw WebRTCException(message: 'Failed to close peer connection: $e');
    }
  }

  @override
  Future<String> createOffer(String connectionId) async {
    try {
      final peerConnection = _peerConnections[connectionId];
      if (peerConnection == null) {
        throw WebRTCException(message: 'Peer connection not found');
      }

      final offer = await peerConnection.createOffer();
      await peerConnection.setLocalDescription(offer);
      
      return offer.sdp ?? '';
    } catch (e) {
      throw WebRTCException(message: 'Failed to create offer: $e');
    }
  }

  @override
  Future<String> createAnswer(String connectionId, String offer) async {
    try {
      final peerConnection = _peerConnections[connectionId];
      if (peerConnection == null) {
        throw WebRTCException(message: 'Peer connection not found');
      }

      await peerConnection.setRemoteDescription(
        RTCSessionDescription(offer, 'offer'),
      );
      
      final answer = await peerConnection.createAnswer();
      await peerConnection.setLocalDescription(answer);
      
      return answer.sdp ?? '';
    } catch (e) {
      throw WebRTCException(message: 'Failed to create answer: $e');
    }
  }

  @override
  Future<void> setRemoteDescription(String connectionId, String description) async {
    try {
      final peerConnection = _peerConnections[connectionId];
      if (peerConnection == null) {
        throw WebRTCException(message: 'Peer connection not found');
      }

      await peerConnection.setRemoteDescription(
        RTCSessionDescription(description, 'answer'),
      );
    } catch (e) {
      throw WebRTCException(message: 'Failed to set remote description: $e');
    }
  }

  @override
  Future<void> setLocalDescription(String connectionId, String description) async {
    try {
      final peerConnection = _peerConnections[connectionId];
      if (peerConnection == null) {
        throw WebRTCException(message: 'Peer connection not found');
      }

      await peerConnection.setLocalDescription(
        RTCSessionDescription(description, 'offer'),
      );
    } catch (e) {
      throw WebRTCException(message: 'Failed to set local description: $e');
    }
  }

  @override
  Future<void> addIceCandidate(String connectionId, String candidate) async {
    try {
      final peerConnection = _peerConnections[connectionId];
      if (peerConnection == null) {
        throw WebRTCException(message: 'Peer connection not found');
      }

      await peerConnection.addCandidate(RTCIceCandidate(candidate, '', 0));
    } catch (e) {
      throw WebRTCException(message: 'Failed to add ICE candidate: $e');
    }
  }

  @override
  Future<void> sendData(String connectionId, String data) async {
    try {
      final dataChannel = _dataChannels[connectionId];
      if (dataChannel == null) {
        throw WebRTCException(message: 'Data channel not found');
      }

      await dataChannel.send(RTCDataChannelMessage(data));
    } catch (e) {
      throw WebRTCException(message: 'Failed to send data: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getConnectionStats(String connectionId) async {
    try {
      final peerConnection = _peerConnections[connectionId];
      if (peerConnection == null) {
        throw WebRTCException(message: 'Peer connection not found');
      }

      final stats = await peerConnection.getStats();
      return stats;
    } catch (e) {
      throw WebRTCException(message: 'Failed to get connection stats: $e');
    }
  }

  @override
  Stream<PeerConnectionModel> watchConnectionState(String connectionId) {
    return _connectionStateController.stream
        .where((model) => model.id == connectionId);
  }

  @override
  Stream<Map<String, dynamic>> watchIncomingData() {
    return _incomingDataController.stream;
  }

  @override
  Future<void> dispose() async {
    try {
      // Close all connections
      for (final connectionId in _peerConnections.keys.toList()) {
        await closePeerConnection(connectionId);
      }

      // Close stream controllers
      await _connectionStateController.close();
      await _incomingDataController.close();

      _isInitialized = false;
    } catch (e) {
      throw WebRTCException(message: 'Failed to dispose WebRTC: $e');
    }
  }
}
