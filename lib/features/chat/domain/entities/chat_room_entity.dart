import 'package:equatable/equatable.dart';
import '../../../../shared/models/message_model.dart';
import '../../../../shared/models/user_model.dart';

/// Entity representing a chat room
class ChatRoomEntity extends Equatable {
  final String id;
  final String name;
  final List<String> participantIds;
  final List<UserModel> participants;
  final MessageModel? lastMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isGroup;
  final String? avatar;
  final Map<String, dynamic>? metadata;
  final bool isEncrypted;
  final String? encryptionKey;
  final int unreadCount;
  final bool isMuted;
  final bool isPinned;
  final ChatRoomStatus status;

  const ChatRoomEntity({
    required this.id,
    required this.name,
    required this.participantIds,
    this.participants = const [],
    this.lastMessage,
    required this.createdAt,
    required this.updatedAt,
    this.isGroup = false,
    this.avatar,
    this.metadata,
    this.isEncrypted = true,
    this.encryptionKey,
    this.unreadCount = 0,
    this.isMuted = false,
    this.isPinned = false,
    this.status = ChatRoomStatus.active,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    participantIds,
    participants,
    lastMessage,
    createdAt,
    updatedAt,
    isGroup,
    avatar,
    metadata,
    isEncrypted,
    encryptionKey,
    unreadCount,
    isMuted,
    isPinned,
    status,
  ];

  ChatRoomEntity copyWith({
    String? id,
    String? name,
    List<String>? participantIds,
    List<UserModel>? participants,
    MessageModel? lastMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isGroup,
    String? avatar,
    Map<String, dynamic>? metadata,
    bool? isEncrypted,
    String? encryptionKey,
    int? unreadCount,
    bool? isMuted,
    bool? isPinned,
    ChatRoomStatus? status,
  }) {
    return ChatRoomEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      participantIds: participantIds ?? this.participantIds,
      participants: participants ?? this.participants,
      lastMessage: lastMessage ?? this.lastMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isGroup: isGroup ?? this.isGroup,
      avatar: avatar ?? this.avatar,
      metadata: metadata ?? this.metadata,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      unreadCount: unreadCount ?? this.unreadCount,
      isMuted: isMuted ?? this.isMuted,
      isPinned: isPinned ?? this.isPinned,
      status: status ?? this.status,
    );
  }

  /// Get display name for the chat room
  String getDisplayName(String currentUserId) {
    if (isGroup) {
      return name;
    } else {
      // For direct chats, show the other participant's name
      final otherParticipant = participants.firstWhere(
        (p) => p.id != currentUserId,
        orElse: () => UserModel(
          id: '',
          name: 'Unknown User',
          publicKey: '',
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      return otherParticipant.name;
    }
  }

  /// Get display avatar for the chat room
  String? getDisplayAvatar(String currentUserId) {
    if (isGroup) {
      return avatar;
    } else {
      // For direct chats, show the other participant's avatar
      final otherParticipant = participants.firstWhere(
        (p) => p.id != currentUserId,
        orElse: () => UserModel(
          id: '',
          name: 'Unknown User',
          publicKey: '',
          lastSeen: DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      return otherParticipant.avatar;
    }
  }

  /// Check if user is online (for direct chats)
  bool isOtherUserOnline(String currentUserId) {
    if (isGroup) return false;

    final otherParticipant = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => UserModel(
        id: '',
        name: 'Unknown User',
        publicKey: '',
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return otherParticipant.isOnline;
  }

  /// Get last seen time for other user (for direct chats)
  DateTime? getOtherUserLastSeen(String currentUserId) {
    if (isGroup) return null;

    final otherParticipant = participants.firstWhere(
      (p) => p.id != currentUserId,
      orElse: () => UserModel(
        id: '',
        name: 'Unknown User',
        publicKey: '',
        lastSeen: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    return otherParticipant.lastSeen;
  }

  /// Check if chat room has unread messages
  bool get hasUnreadMessages => unreadCount > 0;

  /// Get formatted unread count
  String get formattedUnreadCount {
    if (unreadCount == 0) return '';
    if (unreadCount > 99) return '99+';
    return unreadCount.toString();
  }

  /// Check if chat room is active
  bool get isActive => status == ChatRoomStatus.active;

  /// Check if current user can send messages
  bool canSendMessages(String currentUserId) {
    return isActive && participantIds.contains(currentUserId);
  }
}

/// Enum for chat room status
enum ChatRoomStatus { active, archived, blocked, deleted }
