import 'package:hive/hive.dart';
import '../../../../shared/models/message_model.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/entities/chat_room_entity.dart';

part 'chat_room_model.g.dart';

@HiveType(typeId: 4)
class ChatRoomModel extends ChatRoomEntity {
  const ChatRoomModel({
    required super.id,
    required super.name,
    required super.participantIds,
    super.participants = const [],
    super.lastMessage,
    required super.createdAt,
    required super.updatedAt,
    super.isGroup = false,
    super.avatar,
    super.metadata,
    super.isEncrypted = true,
    super.encryptionKey,
    super.unreadCount = 0,
    super.isMuted = false,
    super.isPinned = false,
    super.status = ChatRoomStatus.active,
  });

  /// Create model from entity
  factory ChatRoomModel.fromEntity(ChatRoomEntity entity) {
    return ChatRoomModel(
      id: entity.id,
      name: entity.name,
      participantIds: entity.participantIds,
      participants: entity.participants,
      lastMessage: entity.lastMessage,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
      isGroup: entity.isGroup,
      avatar: entity.avatar,
      metadata: entity.metadata,
      isEncrypted: entity.isEncrypted,
      encryptionKey: entity.encryptionKey,
      unreadCount: entity.unreadCount,
      isMuted: entity.isMuted,
      isPinned: entity.isPinned,
      status: entity.status,
    );
  }

  /// Create model from JSON
  factory ChatRoomModel.fromJson(Map<String, dynamic> json) {
    return ChatRoomModel(
      id: json['id'],
      name: json['name'],
      participantIds: List<String>.from(json['participantIds']),
      participants: json['participants'] != null
          ? (json['participants'] as List)
              .map((p) => UserModel.fromJson(p))
              .toList()
          : [],
      lastMessage: json['lastMessage'] != null
          ? MessageModel.fromJson(json['lastMessage'])
          : null,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      isGroup: json['isGroup'] ?? false,
      avatar: json['avatar'],
      metadata: json['metadata'],
      isEncrypted: json['isEncrypted'] ?? true,
      encryptionKey: json['encryptionKey'],
      unreadCount: json['unreadCount'] ?? 0,
      isMuted: json['isMuted'] ?? false,
      isPinned: json['isPinned'] ?? false,
      status: _parseChatRoomStatus(json['status']),
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'participantIds': participantIds,
      'participants': participants.map((p) => p.toJson()).toList(),
      'lastMessage': lastMessage?.toJson(),
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'isGroup': isGroup,
      'avatar': avatar,
      'metadata': metadata,
      'isEncrypted': isEncrypted,
      'encryptionKey': encryptionKey,
      'unreadCount': unreadCount,
      'isMuted': isMuted,
      'isPinned': isPinned,
      'status': status.name,
    };
  }

  /// Create model from database map
  factory ChatRoomModel.fromDatabase(Map<String, dynamic> map) {
    return ChatRoomModel(
      id: map['id'],
      name: map['name'],
      participantIds: map['participant_ids'] != null
          ? List<String>.from(map['participant_ids'])
          : [],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
      isGroup: map['is_group'] == 1,
      avatar: map['avatar'],
      metadata: map['metadata'],
      isEncrypted: map['is_encrypted'] == 1,
      encryptionKey: map['encryption_key'],
      unreadCount: map['unread_count'] ?? 0,
      isMuted: map['is_muted'] == 1,
      isPinned: map['is_pinned'] == 1,
      status: _parseChatRoomStatus(map['status']),
    );
  }

  /// Convert model to database map
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'participant_ids': participantIds,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
      'is_group': isGroup ? 1 : 0,
      'avatar': avatar,
      'metadata': metadata,
      'is_encrypted': isEncrypted ? 1 : 0,
      'encryption_key': encryptionKey,
      'unread_count': unreadCount,
      'is_muted': isMuted ? 1 : 0,
      'is_pinned': isPinned ? 1 : 0,
      'status': status.name,
    };
  }

  /// Copy with new values
  @override
  ChatRoomModel copyWith({
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
    return ChatRoomModel(
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

  /// Parse chat room status from string
  static ChatRoomStatus _parseChatRoomStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'active':
        return ChatRoomStatus.active;
      case 'archived':
        return ChatRoomStatus.archived;
      case 'blocked':
        return ChatRoomStatus.blocked;
      case 'deleted':
        return ChatRoomStatus.deleted;
      default:
        return ChatRoomStatus.active;
    }
  }
}
