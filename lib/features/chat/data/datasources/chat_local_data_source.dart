import 'dart:async';
import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../../core/utils/encryption_helper.dart';
import '../../../../shared/models/message_model.dart';
import '../../../../shared/models/user_model.dart';
import '../models/chat_room_model.dart';

/// Abstract class for chat local data operations
abstract class ChatLocalDataSource {
  Future<List<ChatRoomModel>> getChatRooms();
  Future<ChatRoomModel?> getChatRoomById(String roomId);
  Future<ChatRoomModel> createChatRoom({
    required String name,
    required List<String> participantIds,
    bool isGroup = false,
    String? avatar,
    Map<String, dynamic>? metadata,
  });
  Future<ChatRoomModel> updateChatRoom(ChatRoomModel chatRoom);
  Future<void> deleteChatRoom(String roomId);

  Future<List<MessageModel>> getMessages({
    required String roomId,
    int limit = 50,
    String? beforeMessageId,
  });
  Future<MessageModel> saveMessage(MessageModel message);
  Future<void> updateMessageStatus(String messageId, String status);
  Future<void> deleteMessage(String messageId);

  Future<String> encryptMessage(String content, String roomId);
  Future<String> decryptMessage(String encryptedContent, String roomId);
  Future<String> generateEncryptionKey();

  Stream<List<ChatRoomModel>> watchChatRooms();
  Stream<List<MessageModel>> watchMessages(String roomId);
}

/// Implementation of chat local data source
class ChatLocalDataSourceImpl implements ChatLocalDataSource {
  final Database database;
  late Box<ChatRoomModel> chatRoomBox;
  late Box<MessageModel> messageBox;
  late Box<String> encryptionKeyBox;

  final StreamController<List<ChatRoomModel>> _chatRoomsController =
      StreamController<List<ChatRoomModel>>.broadcast();
  final Map<String, StreamController<List<MessageModel>>> _messagesControllers =
      {};

  ChatLocalDataSourceImpl({required this.database});

  /// Initialize Hive boxes (demo version - disabled)
  Future<void> _initializeHiveBoxes() async {
    // TODO: Initialize Hive boxes when dependencies are added
    // For demo purposes, we'll use in-memory storage
    print('Hive boxes initialization skipped for demo');
  }

  @override
  Future<List<ChatRoomModel>> getChatRooms() async {
    try {
      await _initializeHiveBoxes();

      // Get from database
      final List<Map<String, dynamic>> maps = await database.query(
        'chat_rooms',
        orderBy: 'updated_at DESC',
      );

      final chatRooms = maps
          .map((map) => ChatRoomModel.fromDatabase(map))
          .toList();

      // Update Hive cache
      for (final chatRoom in chatRooms) {
        await chatRoomBox.put(chatRoom.id, chatRoom);
      }

      return chatRooms;
    } catch (e) {
      throw DatabaseException(message: 'Failed to get chat rooms: $e');
    }
  }

  @override
  Future<ChatRoomModel?> getChatRoomById(String roomId) async {
    try {
      await _initializeHiveBoxes();

      // Try Hive first (faster)
      final cachedRoom = chatRoomBox.get(roomId);
      if (cachedRoom != null) return cachedRoom;

      // Then try database
      final List<Map<String, dynamic>> maps = await database.query(
        'chat_rooms',
        where: 'id = ?',
        whereArgs: [roomId],
      );

      if (maps.isNotEmpty) {
        final chatRoom = ChatRoomModel.fromDatabase(maps.first);
        await chatRoomBox.put(roomId, chatRoom);
        return chatRoom;
      }

      return null;
    } catch (e) {
      throw DatabaseException(message: 'Failed to get chat room by ID: $e');
    }
  }

  @override
  Future<ChatRoomModel> createChatRoom({
    required String name,
    required List<String> participantIds,
    bool isGroup = false,
    String? avatar,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      await _initializeHiveBoxes();

      final now = DateTime.now();
      final encryptionKey = await generateEncryptionKey();

      final chatRoom = ChatRoomModel(
        id: UuidGenerator.generateChatRoomId(),
        name: name,
        participantIds: participantIds,
        participants: [], // Will be populated when needed
        createdAt: now,
        updatedAt: now,
        isGroup: isGroup,
        avatar: avatar,
        metadata: metadata,
        encryptionKey: encryptionKey,
      );

      // Save to database
      await database.insert('chat_rooms', chatRoom.toDatabase());

      // Save to Hive
      await chatRoomBox.put(chatRoom.id, chatRoom);

      // Save encryption key
      await encryptionKeyBox.put(chatRoom.id, encryptionKey);

      // Notify listeners
      _notifyChatRoomsChanged();

      return chatRoom;
    } catch (e) {
      throw DatabaseException(message: 'Failed to create chat room: $e');
    }
  }

  @override
  Future<ChatRoomModel> updateChatRoom(ChatRoomModel chatRoom) async {
    try {
      await _initializeHiveBoxes();

      final updatedChatRoom = chatRoom.copyWith(updatedAt: DateTime.now());

      // Update in database
      await database.update(
        'chat_rooms',
        updatedChatRoom.toDatabase(),
        where: 'id = ?',
        whereArgs: [updatedChatRoom.id],
      );

      // Update in Hive
      await chatRoomBox.put(updatedChatRoom.id, updatedChatRoom);

      // Notify listeners
      _notifyChatRoomsChanged();

      return updatedChatRoom;
    } catch (e) {
      throw DatabaseException(message: 'Failed to update chat room: $e');
    }
  }

  @override
  Future<void> deleteChatRoom(String roomId) async {
    try {
      await _initializeHiveBoxes();

      // Delete from database
      await database.delete('chat_rooms', where: 'id = ?', whereArgs: [roomId]);
      await database.delete(
        'messages',
        where: 'receiver_id = ? OR sender_id = ?',
        whereArgs: [roomId, roomId],
      );

      // Delete from Hive
      await chatRoomBox.delete(roomId);
      await encryptionKeyBox.delete(roomId);

      // Remove messages from cache
      final messagesToRemove = messageBox.values
          .where((msg) => msg.receiverId == roomId || msg.senderId == roomId)
          .toList();
      for (final message in messagesToRemove) {
        await messageBox.delete(message.id);
      }

      // Notify listeners
      _notifyChatRoomsChanged();
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete chat room: $e');
    }
  }

  @override
  Future<List<MessageModel>> getMessages({
    required String roomId,
    int limit = 50,
    String? beforeMessageId,
  }) async {
    try {
      await _initializeHiveBoxes();

      String whereClause = '(sender_id = ? OR receiver_id = ?)';
      List<dynamic> whereArgs = [roomId, roomId];

      if (beforeMessageId != null) {
        // Get timestamp of the before message
        final beforeMessage = await database.query(
          'messages',
          where: 'id = ?',
          whereArgs: [beforeMessageId],
        );

        if (beforeMessage.isNotEmpty) {
          whereClause += ' AND timestamp < ?';
          whereArgs.add(beforeMessage.first['timestamp']);
        }
      }

      final List<Map<String, dynamic>> maps = await database.query(
        'messages',
        where: whereClause,
        whereArgs: whereArgs,
        orderBy: 'timestamp DESC',
        limit: limit,
      );

      final messages = maps
          .map((map) => MessageModel.fromDatabase(map))
          .toList();

      // Decrypt messages
      final decryptedMessages = <MessageModel>[];
      for (final message in messages) {
        if (message.isEncrypted) {
          try {
            final decryptedContent = await decryptMessage(
              message.content,
              roomId,
            );
            decryptedMessages.add(message.copyWith(content: decryptedContent));
          } catch (e) {
            // If decryption fails, keep original message
            decryptedMessages.add(message);
          }
        } else {
          decryptedMessages.add(message);
        }
      }

      return decryptedMessages.reversed
          .toList(); // Return in chronological order
    } catch (e) {
      throw DatabaseException(message: 'Failed to get messages: $e');
    }
  }

  @override
  Future<MessageModel> saveMessage(MessageModel message) async {
    try {
      await _initializeHiveBoxes();

      // Encrypt message content if needed
      String content = message.content;
      if (message.isEncrypted) {
        content = await encryptMessage(message.content, message.receiverId);
      }

      final encryptedMessage = message.copyWith(content: content);

      // Save to database
      await database.insert('messages', encryptedMessage.toDatabase());

      // Save to Hive
      await messageBox.put(encryptedMessage.id, encryptedMessage);

      // Notify listeners
      _notifyMessagesChanged(message.receiverId);

      return message; // Return original unencrypted message
    } catch (e) {
      throw DatabaseException(message: 'Failed to save message: $e');
    }
  }

  @override
  Future<void> updateMessageStatus(String messageId, String status) async {
    try {
      await _initializeHiveBoxes();

      // Update in database
      await database.update(
        'messages',
        {
          'is_sent': status == 'sent' ? 1 : 0,
          'is_delivered': status == 'delivered' ? 1 : 0,
          'is_read': status == 'read' ? 1 : 0,
        },
        where: 'id = ?',
        whereArgs: [messageId],
      );

      // Update in Hive
      final message = messageBox.get(messageId);
      if (message != null) {
        MessageStatus messageStatus;
        switch (status) {
          case 'sent':
            messageStatus = MessageStatus.sent;
            break;
          case 'delivered':
            messageStatus = MessageStatus.delivered;
            break;
          case 'read':
            messageStatus = MessageStatus.read;
            break;
          default:
            messageStatus = MessageStatus.sending;
        }

        final updatedMessage = message.copyWith(status: messageStatus);
        await messageBox.put(messageId, updatedMessage);

        // Notify listeners
        _notifyMessagesChanged(message.receiverId);
      }
    } catch (e) {
      throw DatabaseException(message: 'Failed to update message status: $e');
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await _initializeHiveBoxes();

      final message = messageBox.get(messageId);

      // Delete from database
      await database.delete(
        'messages',
        where: 'id = ?',
        whereArgs: [messageId],
      );

      // Delete from Hive
      await messageBox.delete(messageId);

      // Notify listeners
      if (message != null) {
        _notifyMessagesChanged(message.receiverId);
      }
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete message: $e');
    }
  }

  @override
  Future<String> encryptMessage(String content, String roomId) async {
    try {
      await _initializeHiveBoxes();

      final encryptionKey = encryptionKeyBox.get(roomId);
      if (encryptionKey == null) {
        throw CryptographyException(
          message: 'Encryption key not found for room',
        );
      }

      // encryptionKey is already a string in our demo implementation
      final encryptedData = EncryptionHelper.encryptText(
        content,
        encryptionKey,
      );

      return json.encode(encryptedData.toJson());
    } catch (e) {
      throw CryptographyException(message: 'Failed to encrypt message: $e');
    }
  }

  @override
  Future<String> decryptMessage(String encryptedContent, String roomId) async {
    try {
      await _initializeHiveBoxes();

      final encryptionKey = encryptionKeyBox.get(roomId);
      if (encryptionKey == null) {
        throw CryptographyException(
          message: 'Encryption key not found for room',
        );
      }

      final encryptedData = EncryptedData.fromJson(
        json.decode(encryptedContent),
      );
      return EncryptionHelper.decryptText(encryptedData);
    } catch (e) {
      throw CryptographyException(message: 'Failed to decrypt message: $e');
    }
  }

  @override
  Future<String> generateEncryptionKey() async {
    try {
      final key = EncryptionHelper.generateKey();
      return key; // key is already a string in our demo implementation
    } catch (e) {
      throw CryptographyException(
        message: 'Failed to generate encryption key: $e',
      );
    }
  }

  @override
  Stream<List<ChatRoomModel>> watchChatRooms() {
    return _chatRoomsController.stream;
  }

  @override
  Stream<List<MessageModel>> watchMessages(String roomId) {
    if (!_messagesControllers.containsKey(roomId)) {
      _messagesControllers[roomId] =
          StreamController<List<MessageModel>>.broadcast();
    }
    return _messagesControllers[roomId]!.stream;
  }

  void _notifyChatRoomsChanged() async {
    try {
      final chatRooms = await getChatRooms();
      _chatRoomsController.add(chatRooms);
    } catch (e) {
      // Handle error
    }
  }

  void _notifyMessagesChanged(String roomId) async {
    try {
      final messages = await getMessages(roomId: roomId);
      if (_messagesControllers.containsKey(roomId)) {
        _messagesControllers[roomId]!.add(messages);
      }
    } catch (e) {
      // Handle error
    }
  }

  void dispose() {
    _chatRoomsController.close();
    for (final controller in _messagesControllers.values) {
      controller.close();
    }
    _messagesControllers.clear();
  }
}
