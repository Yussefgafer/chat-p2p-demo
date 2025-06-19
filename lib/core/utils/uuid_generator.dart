import 'package:uuid/uuid.dart';

/// Utility class for generating UUIDs throughout the application
class UuidGenerator {
  static const Uuid _uuid = Uuid();
  
  /// Generate a new UUID v4 (random)
  static String generateV4() {
    return _uuid.v4();
  }
  
  /// Generate a new UUID v1 (time-based)
  static String generateV1() {
    return _uuid.v1();
  }
  
  /// Generate a UUID for a user
  static String generateUserId() {
    return 'user_${_uuid.v4()}';
  }
  
  /// Generate a UUID for a session
  static String generateSessionId() {
    return 'session_${_uuid.v4()}';
  }
  
  /// Generate a UUID for a message
  static String generateMessageId() {
    return 'msg_${_uuid.v4()}';
  }
  
  /// Generate a UUID for a file transfer
  static String generateFileTransferId() {
    return 'file_${_uuid.v4()}';
  }
  
  /// Generate a UUID for a peer connection
  static String generatePeerConnectionId() {
    return 'peer_${_uuid.v4()}';
  }
  
  /// Generate a UUID for a chat room
  static String generateChatRoomId() {
    return 'room_${_uuid.v4()}';
  }
  
  /// Validate if a string is a valid UUID
  static bool isValidUuid(String uuid) {
    try {
      Uuid.parse(uuid);
      return true;
    } catch (e) {
      return false;
    }
  }
  
  /// Extract the timestamp from a UUID v1
  static DateTime? getTimestampFromV1(String uuid) {
    try {
      return _uuid.v1ToTime(uuid);
    } catch (e) {
      return null;
    }
  }
}
