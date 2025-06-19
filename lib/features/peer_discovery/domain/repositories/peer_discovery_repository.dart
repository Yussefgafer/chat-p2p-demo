import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../entities/discovery_data_entity.dart';

/// Abstract repository for peer discovery operations
abstract class PeerDiscoveryRepository {
  /// Generate QR code data for current user
  Future<Either<Failure, DiscoveryDataEntity>> generateQRCodeData({
    Duration? expirationDuration,
    Map<String, dynamic>? metadata,
  });
  
  /// Parse QR code data
  Future<Either<Failure, DiscoveryDataEntity>> parseQRCodeData(String qrData);
  
  /// Generate shareable link
  Future<Either<Failure, String>> generateShareableLink({
    Duration? expirationDuration,
    Map<String, dynamic>? metadata,
  });
  
  /// Parse shareable link
  Future<Either<Failure, DiscoveryDataEntity>> parseShareableLink(String link);
  
  /// Start LAN discovery
  Future<Either<Failure, void>> startLANDiscovery();
  
  /// Stop LAN discovery
  Future<Either<Failure, void>> stopLANDiscovery();
  
  /// Broadcast presence on LAN
  Future<Either<Failure, void>> broadcastPresence();
  
  /// Listen for LAN peers
  Stream<DiscoveryDataEntity> watchLANPeers();
  
  /// Start Bluetooth discovery
  Future<Either<Failure, void>> startBluetoothDiscovery();
  
  /// Stop Bluetooth discovery
  Future<Either<Failure, void>> stopBluetoothDiscovery();
  
  /// Get available Bluetooth devices
  Future<Either<Failure, List<DiscoveryDataEntity>>> getBluetoothDevices();
  
  /// Listen for Bluetooth peers
  Stream<DiscoveryDataEntity> watchBluetoothPeers();
  
  /// Connect to discovered peer
  Future<Either<Failure, void>> connectToPeer(DiscoveryDataEntity discoveryData);
  
  /// Get discovery history
  Future<Either<Failure, List<DiscoveryDataEntity>>> getDiscoveryHistory();
  
  /// Save discovery data
  Future<Either<Failure, void>> saveDiscoveryData(DiscoveryDataEntity data);
  
  /// Delete discovery data
  Future<Either<Failure, void>> deleteDiscoveryData(String id);
  
  /// Check if discovery method is available
  Future<Either<Failure, bool>> isDiscoveryMethodAvailable(DiscoveryMethod method);
  
  /// Get network information
  Future<Either<Failure, Map<String, dynamic>>> getNetworkInfo();
  
  /// Validate discovery data
  Future<Either<Failure, bool>> validateDiscoveryData(DiscoveryDataEntity data);
  
  /// Get nearby peers (all methods)
  Stream<List<DiscoveryDataEntity>> watchNearbyPeers();
  
  /// Start comprehensive discovery (all available methods)
  Future<Either<Failure, void>> startComprehensiveDiscovery();
  
  /// Stop all discovery methods
  Future<Either<Failure, void>> stopAllDiscovery();
  
  /// Get discovery status
  Future<Either<Failure, Map<DiscoveryMethod, bool>>> getDiscoveryStatus();
  
  /// Set discovery preferences
  Future<Either<Failure, void>> setDiscoveryPreferences({
    bool enableLAN = true,
    bool enableBluetooth = true,
    bool enableQRCode = true,
    bool enableLinks = true,
    Duration defaultExpiration = const Duration(hours: 24),
  });
  
  /// Get discovery preferences
  Future<Either<Failure, Map<String, dynamic>>> getDiscoveryPreferences();
}
