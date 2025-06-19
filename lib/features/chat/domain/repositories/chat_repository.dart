import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/message_model.dart';
import '../entities/chat_room_entity.dart';

/// Abstract repository for chat operations
abstract class ChatRepository {
  /// Get all chat rooms for current user
  Future<Either<Failure, List<ChatRoomEntity>>> getChatRooms();
  
  /// Get chat room by ID
  Future<Either<Failure, ChatRoomEntity?>> getChatRoomById(String roomId);
  
  /// Create a new chat room
  Future<Either<Failure, ChatRoomEntity>> createChatRoom({
    required String name,
    required List<String> participantIds,
    bool isGroup = false,
    String? avatar,
    Map<String, dynamic>? metadata,
  });
  
  /// Update chat room
  Future<Either<Failure, ChatRoomEntity>> updateChatRoom(ChatRoomEntity chatRoom);
  
  /// Delete chat room
  Future<Either<Failure, void>> deleteChatRoom(String roomId);
  
  /// Get messages for a chat room
  Future<Either<Failure, List<MessageModel>>> getMessages({
    required String roomId,
    int limit = 50,
    String? beforeMessageId,
  });
  
  /// Send a message
  Future<Either<Failure, MessageModel>> sendMessage({
    required String roomId,
    required String content,
    required MessageType type,
    String? filePath,
    int? fileSize,
    String? fileType,
    Map<String, dynamic>? metadata,
  });
  
  /// Update message status
  Future<Either<Failure, void>> updateMessageStatus({
    required String messageId,
    required MessageStatus status,
  });
  
  /// Mark messages as read
  Future<Either<Failure, void>> markMessagesAsRead({
    required String roomId,
    required List<String> messageIds,
  });
  
  /// Delete message
  Future<Either<Failure, void>> deleteMessage(String messageId);
  
  /// Search messages
  Future<Either<Failure, List<MessageModel>>> searchMessages({
    required String query,
    String? roomId,
    MessageType? type,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Get unread message count
  Future<Either<Failure, int>> getUnreadMessageCount(String roomId);
  
  /// Listen to chat room changes
  Stream<List<ChatRoomEntity>> watchChatRooms();
  
  /// Listen to messages in a chat room
  Stream<List<MessageModel>> watchMessages(String roomId);
  
  /// Listen to message status updates
  Stream<MessageModel> watchMessageUpdates();
  
  /// Encrypt message content
  Future<Either<Failure, String>> encryptMessage({
    required String content,
    required String roomId,
  });
  
  /// Decrypt message content
  Future<Either<Failure, String>> decryptMessage({
    required String encryptedContent,
    required String roomId,
  });
  
  /// Generate encryption key for chat room
  Future<Either<Failure, String>> generateEncryptionKey();
  
  /// Share encryption key with participants
  Future<Either<Failure, void>> shareEncryptionKey({
    required String roomId,
    required String encryptionKey,
    required List<String> participantIds,
  });
  
  /// Archive chat room
  Future<Either<Failure, void>> archiveChatRoom(String roomId);
  
  /// Unarchive chat room
  Future<Either<Failure, void>> unarchiveChatRoom(String roomId);
  
  /// Mute chat room
  Future<Either<Failure, void>> muteChatRoom(String roomId);
  
  /// Unmute chat room
  Future<Either<Failure, void>> unmuteChatRoom(String roomId);
  
  /// Pin chat room
  Future<Either<Failure, void>> pinChatRoom(String roomId);
  
  /// Unpin chat room
  Future<Either<Failure, void>> unpinChatRoom(String roomId);
  
  /// Block user
  Future<Either<Failure, void>> blockUser(String userId);
  
  /// Unblock user
  Future<Either<Failure, void>> unblockUser(String userId);
  
  /// Get blocked users
  Future<Either<Failure, List<String>>> getBlockedUsers();
  
  /// Export chat history
  Future<Either<Failure, String>> exportChatHistory({
    required String roomId,
    DateTime? startDate,
    DateTime? endDate,
  });
  
  /// Import chat history
  Future<Either<Failure, void>> importChatHistory({
    required String roomId,
    required String data,
  });
  
  /// Clear chat history
  Future<Either<Failure, void>> clearChatHistory(String roomId);
  
  /// Get chat statistics
  Future<Either<Failure, Map<String, dynamic>>> getChatStatistics(String roomId);
}
