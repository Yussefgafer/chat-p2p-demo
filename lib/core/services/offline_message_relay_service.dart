import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import '../utils/uuid_generator.dart';
import '../utils/encryption_helper.dart';
import '../errors/exceptions.dart';
import '../../shared/models/message_model.dart';
import '../../shared/models/user_model.dart';

/// Service for handling offline message relay functionality
class OfflineMessageRelayService {
  final Database database;
  bool _isRelayEnabled = false;
  final Duration _messageExpiryDuration = const Duration(days: 7);

  Timer? _cleanupTimer;
  final StreamController<RelayMessage> _relayMessageController =
      StreamController<RelayMessage>.broadcast();

  OfflineMessageRelayService({required this.database}) {
    _startCleanupTimer();
  }

  /// Enable offline message relay
  Future<void> enableRelay() async {
    _isRelayEnabled = true;
    await _saveRelayPreference(true);
  }

  /// Disable offline message relay
  Future<void> disableRelay() async {
    _isRelayEnabled = false;
    await _saveRelayPreference(false);
    await _clearAllRelayMessages();
  }

  /// Check if relay is enabled
  bool get isRelayEnabled => _isRelayEnabled;

  /// Store message for offline relay
  Future<void> storeMessageForRelay({
    required MessageModel message,
    required String targetUserId,
    required String relayUserId,
  }) async {
    if (!_isRelayEnabled) return;

    try {
      // Encrypt message content for relay
      final encryptedContent = await _encryptMessageForRelay(message);

      final relayMessage = RelayMessage(
        id: UuidGenerator.generateV4(),
        originalMessageId: message.id,
        targetUserId: targetUserId,
        relayUserId: relayUserId,
        encryptedContent: encryptedContent,
        timestamp: DateTime.now(),
        expiryTimestamp: DateTime.now().add(_messageExpiryDuration),
      );

      await _saveRelayMessage(relayMessage);
      _relayMessageController.add(relayMessage);
    } catch (e) {
      throw StorageException(message: 'Failed to store relay message: $e');
    }
  }

  /// Retrieve messages for a user
  Future<List<RelayMessage>> getMessagesForUser(String userId) async {
    try {
      final List<Map<String, dynamic>> maps = await database.query(
        'offline_messages',
        where:
            'target_user_id = ? AND is_delivered = 0 AND expiry_timestamp > ?',
        whereArgs: [userId, DateTime.now().millisecondsSinceEpoch],
        orderBy: 'timestamp ASC',
      );

      return maps.map((map) => RelayMessage.fromDatabase(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get relay messages: $e');
    }
  }

  /// Mark message as delivered
  Future<void> markMessageAsDelivered(String relayMessageId) async {
    try {
      await database.update(
        'offline_messages',
        {'is_delivered': 1},
        where: 'id = ?',
        whereArgs: [relayMessageId],
      );
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to mark message as delivered: $e',
      );
    }
  }

  /// Decrypt relay message
  Future<MessageModel> decryptRelayMessage(RelayMessage relayMessage) async {
    try {
      final decryptedContent = await _decryptMessageFromRelay(
        relayMessage.encryptedContent,
      );
      return MessageModel.fromJson(json.decode(decryptedContent));
    } catch (e) {
      throw CryptographyException(
        message: 'Failed to decrypt relay message: $e',
      );
    }
  }

  /// Get relay statistics
  Future<Map<String, dynamic>> getRelayStatistics() async {
    try {
      final totalMessages = await database.rawQuery(
        'SELECT COUNT(*) as count FROM offline_messages',
      );

      final deliveredMessages = await database.rawQuery(
        'SELECT COUNT(*) as count FROM offline_messages WHERE is_delivered = 1',
      );

      final expiredMessages = await database.rawQuery(
        'SELECT COUNT(*) as count FROM offline_messages WHERE expiry_timestamp < ?',
        [DateTime.now().millisecondsSinceEpoch],
      );

      return {
        'totalMessages': totalMessages.first['count'],
        'deliveredMessages': deliveredMessages.first['count'],
        'expiredMessages': expiredMessages.first['count'],
        'pendingMessages':
            (totalMessages.first['count'] as int) -
            (deliveredMessages.first['count'] as int) -
            (expiredMessages.first['count'] as int),
      };
    } catch (e) {
      throw DatabaseException(message: 'Failed to get relay statistics: $e');
    }
  }

  /// Listen to new relay messages
  Stream<RelayMessage> watchRelayMessages() {
    return _relayMessageController.stream;
  }

  /// Clean up expired messages
  Future<void> cleanupExpiredMessages() async {
    try {
      final expiredCount = await database.delete(
        'offline_messages',
        where: 'expiry_timestamp < ?',
        whereArgs: [DateTime.now().millisecondsSinceEpoch],
      );

      if (expiredCount > 0) {
        print('Cleaned up $expiredCount expired relay messages');
      }
    } catch (e) {
      throw DatabaseException(
        message: 'Failed to cleanup expired messages: $e',
      );
    }
  }

  /// Process incoming relay request
  Future<bool> processRelayRequest({
    required String fromUserId,
    required String targetUserId,
    required String encryptedMessage,
  }) async {
    if (!_isRelayEnabled) return false;

    try {
      // Verify the request is legitimate
      if (!await _verifyRelayRequest(fromUserId, targetUserId)) {
        return false;
      }

      final relayMessage = RelayMessage(
        id: UuidGenerator.generateV4(),
        originalMessageId: UuidGenerator.generateV4(),
        targetUserId: targetUserId,
        relayUserId: fromUserId,
        encryptedContent: encryptedMessage,
        timestamp: DateTime.now(),
        expiryTimestamp: DateTime.now().add(_messageExpiryDuration),
      );

      await _saveRelayMessage(relayMessage);
      _relayMessageController.add(relayMessage);

      return true;
    } catch (e) {
      return false;
    }
  }

  /// Get pending relay count for user
  Future<int> getPendingRelayCount(String userId) async {
    try {
      final result = await database.rawQuery(
        'SELECT COUNT(*) as count FROM offline_messages WHERE target_user_id = ? AND is_delivered = 0 AND expiry_timestamp > ?',
        [userId, DateTime.now().millisecondsSinceEpoch],
      );

      return result.first['count'] as int;
    } catch (e) {
      return 0;
    }
  }

  Future<String> _encryptMessageForRelay(MessageModel message) async {
    try {
      final messageJson = json.encode(message.toJson());
      final key = EncryptionHelper.generateKey();
      final encryptedData = EncryptionHelper.encryptText(messageJson, key);

      return json.encode({
        'data': encryptedData.toJson(),
        'key': key, // key is already a string in our demo implementation
      });
    } catch (e) {
      throw CryptographyException(
        message: 'Failed to encrypt message for relay: $e',
      );
    }
  }

  Future<String> _decryptMessageFromRelay(String encryptedContent) async {
    try {
      final contentData = json.decode(encryptedContent);
      final encryptedData = EncryptedData.fromJson(contentData['data']);

      return EncryptionHelper.decryptText(encryptedData);
    } catch (e) {
      throw CryptographyException(
        message: 'Failed to decrypt message from relay: $e',
      );
    }
  }

  Future<void> _saveRelayMessage(RelayMessage relayMessage) async {
    await database.insert('offline_messages', relayMessage.toDatabase());
  }

  Future<void> _saveRelayPreference(bool enabled) async {
    await database.insert('settings', {
      'key': 'offline_relay_enabled',
      'value': enabled.toString(),
      'updated_at': DateTime.now().millisecondsSinceEpoch,
    }); // conflictAlgorithm removed for demo
  }

  Future<void> _clearAllRelayMessages() async {
    await database.delete('offline_messages');
  }

  Future<bool> _verifyRelayRequest(
    String fromUserId,
    String targetUserId,
  ) async {
    // Implement verification logic
    // Check if users are known, not blocked, etc.
    return true;
  }

  void _startCleanupTimer() {
    _cleanupTimer = Timer.periodic(const Duration(hours: 6), (timer) {
      cleanupExpiredMessages();
    });
  }

  void dispose() {
    _cleanupTimer?.cancel();
    _relayMessageController.close();
  }
}

/// Model for relay messages
class RelayMessage {
  final String id;
  final String originalMessageId;
  final String targetUserId;
  final String relayUserId;
  final String encryptedContent;
  final DateTime timestamp;
  final DateTime expiryTimestamp;
  final bool isDelivered;

  const RelayMessage({
    required this.id,
    required this.originalMessageId,
    required this.targetUserId,
    required this.relayUserId,
    required this.encryptedContent,
    required this.timestamp,
    required this.expiryTimestamp,
    this.isDelivered = false,
  });

  factory RelayMessage.fromDatabase(Map<String, dynamic> map) {
    return RelayMessage(
      id: map['id'],
      originalMessageId: map['original_message_id'],
      targetUserId: map['target_user_id'],
      relayUserId: map['relay_user_id'],
      encryptedContent: map['encrypted_content'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      expiryTimestamp: DateTime.fromMillisecondsSinceEpoch(
        map['expiry_timestamp'],
      ),
      isDelivered: map['is_delivered'] == 1,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'original_message_id': originalMessageId,
      'target_user_id': targetUserId,
      'relay_user_id': relayUserId,
      'encrypted_content': encryptedContent,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'expiry_timestamp': expiryTimestamp.millisecondsSinceEpoch,
      'is_delivered': isDelivered ? 1 : 0,
    };
  }

  bool get isExpired => DateTime.now().isAfter(expiryTimestamp);

  Duration get timeUntilExpiry => expiryTimestamp.difference(DateTime.now());
}
