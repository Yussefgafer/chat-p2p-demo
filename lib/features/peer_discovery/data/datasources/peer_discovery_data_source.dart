import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../../shared/models/user_model.dart';
import '../models/discovery_data_model.dart';

/// Abstract class for peer discovery data operations
abstract class PeerDiscoveryDataSource {
  Future<DiscoveryDataModel> generateQRCodeData(
    UserModel user, {
    Duration? expirationDuration,
    Map<String, dynamic>? metadata,
  });
  
  Future<DiscoveryDataModel> parseQRCodeData(String qrData);
  
  Future<String> generateShareableLink(
    UserModel user, {
    Duration? expirationDuration,
    Map<String, dynamic>? metadata,
  });
  
  Future<DiscoveryDataModel> parseShareableLink(String link);
  
  Future<void> startLANDiscovery();
  Future<void> stopLANDiscovery();
  Future<void> broadcastPresence(UserModel user);
  Stream<DiscoveryDataModel> watchLANPeers();
  
  Future<void> startBluetoothDiscovery();
  Future<void> stopBluetoothDiscovery();
  Future<List<DiscoveryDataModel>> getBluetoothDevices();
  Stream<DiscoveryDataModel> watchBluetoothPeers();
  
  Future<Map<String, dynamic>> getNetworkInfo();
  Future<bool> isDiscoveryMethodAvailable(String method);
}

/// Implementation of peer discovery data source
class PeerDiscoveryDataSourceImpl implements PeerDiscoveryDataSource {
  final NetworkInfo _networkInfo = NetworkInfo();
  final Connectivity _connectivity = Connectivity();
  
  // LAN Discovery
  RawDatagramSocket? _udpSocket;
  Timer? _broadcastTimer;
  final StreamController<DiscoveryDataModel> _lanPeersController =
      StreamController<DiscoveryDataModel>.broadcast();
  
  // Bluetooth Discovery
  final StreamController<DiscoveryDataModel> _bluetoothPeersController =
      StreamController<DiscoveryDataModel>.broadcast();
  
  bool _isLANDiscoveryActive = false;
  bool _isBluetoothDiscoveryActive = false;
  
  static const int _discoveryPort = 8888;
  static const String _discoveryMessage = 'CHAT_P2P_DISCOVERY';

  @override
  Future<DiscoveryDataModel> generateQRCodeData(
    UserModel user, {
    Duration? expirationDuration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final networkInfo = await getNetworkInfo();
      
      final connectionData = {
        'userId': user.id,
        'userName': user.name,
        'userAvatar': user.avatar,
        'publicKey': user.publicKey,
        'networkInfo': networkInfo,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      final discoveryData = DiscoveryDataModel(
        id: UuidGenerator.generateV4(),
        userId: user.id,
        userName: user.name,
        userAvatar: user.avatar,
        method: 'qrCode',
        connectionData: connectionData,
        createdAt: DateTime.now(),
        expiresAt: DateTime.now().add(
          expirationDuration ?? const Duration(hours: 1),
        ),
        publicKey: user.publicKey,
        supportedProtocols: ['webrtc', 'lan'],
        metadata: metadata,
      );

      return discoveryData;
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to generate QR code data: $e');
    }
  }

  @override
  Future<DiscoveryDataModel> parseQRCodeData(String qrData) async {
    try {
      final decodedData = Uri.decodeComponent(qrData);
      final jsonData = json.decode(decodedData);
      
      return DiscoveryDataModel.fromJson(jsonData);
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to parse QR code data: $e');
    }
  }

  @override
  Future<String> generateShareableLink(
    UserModel user, {
    Duration? expirationDuration,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final discoveryData = await generateQRCodeData(
        user,
        expirationDuration: expirationDuration,
        metadata: metadata,
      );
      
      return discoveryData.toShareableLink();
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to generate shareable link: $e');
    }
  }

  @override
  Future<DiscoveryDataModel> parseShareableLink(String link) async {
    try {
      final uri = Uri.parse(link);
      final params = uri.queryParameters;
      
      final connectionData = {
        'userId': params['userId'],
        'userName': params['userName'],
        'data': Uri.decodeComponent(params['data'] ?? ''),
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };

      return DiscoveryDataModel(
        id: params['id'] ?? UuidGenerator.generateV4(),
        userId: params['userId'] ?? '',
        userName: params['userName'] ?? 'Unknown',
        method: 'link',
        connectionData: connectionData,
        createdAt: DateTime.now(),
        expiresAt: DateTime.fromMillisecondsSinceEpoch(
          int.tryParse(params['expires'] ?? '0') ?? 0,
        ),
        supportedProtocols: ['webrtc'],
      );
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to parse shareable link: $e');
    }
  }

  @override
  Future<void> startLANDiscovery() async {
    try {
      if (_isLANDiscoveryActive) return;

      // Create UDP socket for discovery
      _udpSocket = await RawDatagramSocket.bind(InternetAddress.anyIPv4, _discoveryPort);
      _udpSocket!.broadcastEnabled = true;
      
      // Listen for incoming discovery messages
      _udpSocket!.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          final datagram = _udpSocket!.receive();
          if (datagram != null) {
            _handleIncomingDiscoveryMessage(datagram);
          }
        }
      });

      _isLANDiscoveryActive = true;
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to start LAN discovery: $e');
    }
  }

  @override
  Future<void> stopLANDiscovery() async {
    try {
      _broadcastTimer?.cancel();
      _udpSocket?.close();
      _isLANDiscoveryActive = false;
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to stop LAN discovery: $e');
    }
  }

  @override
  Future<void> broadcastPresence(UserModel user) async {
    try {
      if (!_isLANDiscoveryActive || _udpSocket == null) return;

      final discoveryMessage = {
        'type': _discoveryMessage,
        'userId': user.id,
        'userName': user.name,
        'userAvatar': user.avatar,
        'publicKey': user.publicKey,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'supportedProtocols': ['webrtc', 'lan'],
      };

      final messageBytes = utf8.encode(json.encode(discoveryMessage));
      
      // Broadcast to local network
      final broadcastAddress = await _getBroadcastAddress();
      _udpSocket!.send(
        messageBytes,
        InternetAddress(broadcastAddress),
        _discoveryPort,
      );

      // Start periodic broadcasting
      _broadcastTimer?.cancel();
      _broadcastTimer = Timer.periodic(const Duration(seconds: 30), (_) {
        _udpSocket!.send(
          messageBytes,
          InternetAddress(broadcastAddress),
          _discoveryPort,
        );
      });
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to broadcast presence: $e');
    }
  }

  void _handleIncomingDiscoveryMessage(Datagram datagram) {
    try {
      final message = utf8.decode(datagram.data);
      final messageData = json.decode(message);
      
      if (messageData['type'] == _discoveryMessage) {
        final discoveryData = DiscoveryDataModel(
          id: UuidGenerator.generateV4(),
          userId: messageData['userId'],
          userName: messageData['userName'],
          userAvatar: messageData['userAvatar'],
          method: 'lan',
          connectionData: {
            ...messageData,
            'ipAddress': datagram.address.address,
            'port': datagram.port,
          },
          createdAt: DateTime.now(),
          expiresAt: DateTime.now().add(const Duration(minutes: 5)),
          publicKey: messageData['publicKey'],
          supportedProtocols: List<String>.from(
            messageData['supportedProtocols'] ?? ['webrtc'],
          ),
        );
        
        _lanPeersController.add(discoveryData);
      }
    } catch (e) {
      // Ignore malformed messages
    }
  }

  @override
  Stream<DiscoveryDataModel> watchLANPeers() {
    return _lanPeersController.stream;
  }

  @override
  Future<void> startBluetoothDiscovery() async {
    try {
      // TODO: Implement Bluetooth discovery using flutter_bluetooth_serial
      // This is a placeholder implementation
      _isBluetoothDiscoveryActive = true;
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to start Bluetooth discovery: $e');
    }
  }

  @override
  Future<void> stopBluetoothDiscovery() async {
    try {
      _isBluetoothDiscoveryActive = false;
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to stop Bluetooth discovery: $e');
    }
  }

  @override
  Future<List<DiscoveryDataModel>> getBluetoothDevices() async {
    try {
      // TODO: Implement Bluetooth device discovery
      return [];
    } catch (e) {
      throw PeerDiscoveryException(message: 'Failed to get Bluetooth devices: $e');
    }
  }

  @override
  Stream<DiscoveryDataModel> watchBluetoothPeers() {
    return _bluetoothPeersController.stream;
  }

  @override
  Future<Map<String, dynamic>> getNetworkInfo() async {
    try {
      final wifiName = await _networkInfo.getWifiName();
      final wifiIP = await _networkInfo.getWifiIP();
      final wifiBSSID = await _networkInfo.getWifiBSSID();
      final connectivityResult = await _connectivity.checkConnectivity();

      return {
        'wifiName': wifiName,
        'wifiIP': wifiIP,
        'wifiBSSID': wifiBSSID,
        'connectivity': connectivityResult.name,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
      };
    } catch (e) {
      throw NetworkException(message: 'Failed to get network info: $e');
    }
  }

  @override
  Future<bool> isDiscoveryMethodAvailable(String method) async {
    try {
      switch (method.toLowerCase()) {
        case 'lan':
          final connectivity = await _connectivity.checkConnectivity();
          return connectivity.contains(ConnectivityResult.wifi);
        case 'bluetooth':
          // TODO: Check Bluetooth availability
          return false;
        case 'qrcode':
        case 'link':
          return true;
        default:
          return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<String> _getBroadcastAddress() async {
    try {
      final wifiIP = await _networkInfo.getWifiIP();
      if (wifiIP != null) {
        final parts = wifiIP.split('.');
        if (parts.length == 4) {
          return '${parts[0]}.${parts[1]}.${parts[2]}.255';
        }
      }
      return '255.255.255.255';
    } catch (e) {
      return '255.255.255.255';
    }
  }

  void dispose() {
    stopLANDiscovery();
    stopBluetoothDiscovery();
    _lanPeersController.close();
    _bluetoothPeersController.close();
  }
}
