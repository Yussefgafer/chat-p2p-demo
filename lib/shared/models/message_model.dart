import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 1)
enum MessageType {
  @HiveField(0)
  text,
  @HiveField(1)
  image,
  @HiveField(2)
  video,
  @HiveField(3)
  audio,
  @HiveField(4)
  file,
  @HiveField(5)
  location,
  @HiveField(6)
  contact,
  @HiveField(7)
  system,
}

@HiveType(typeId: 2)
enum MessageStatus {
  @HiveField(0)
  sending,
  @HiveField(1)
  sent,
  @HiveField(2)
  delivered,
  @HiveField(3)
  read,
  @HiveField(4)
  failed,
}

@HiveType(typeId: 3)
class MessageModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String senderId;
  
  @HiveField(2)
  final String receiverId;
  
  @HiveField(3)
  final String content;
  
  @HiveField(4)
  final MessageType type;
  
  @HiveField(5)
  final DateTime timestamp;
  
  @HiveField(6)
  final MessageStatus status;
  
  @HiveField(7)
  final bool isEncrypted;
  
  @HiveField(8)
  final String? filePath;
  
  @HiveField(9)
  final int? fileSize;
  
  @HiveField(10)
  final String? fileType;
  
  @HiveField(11)
  final String? thumbnailPath;
  
  @HiveField(12)
  final Duration? duration; // For audio/video messages
  
  @HiveField(13)
  final Map<String, dynamic>? metadata;

  const MessageModel({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.type,
    required this.timestamp,
    this.status = MessageStatus.sending,
    this.isEncrypted = true,
    this.filePath,
    this.fileSize,
    this.fileType,
    this.thumbnailPath,
    this.duration,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        senderId,
        receiverId,
        content,
        type,
        timestamp,
        status,
        isEncrypted,
        filePath,
        fileSize,
        fileType,
        thumbnailPath,
        duration,
        metadata,
      ];

  MessageModel copyWith({
    String? id,
    String? senderId,
    String? receiverId,
    String? content,
    MessageType? type,
    DateTime? timestamp,
    MessageStatus? status,
    bool? isEncrypted,
    String? filePath,
    int? fileSize,
    String? fileType,
    String? thumbnailPath,
    Duration? duration,
    Map<String, dynamic>? metadata,
  }) {
    return MessageModel(
      id: id ?? this.id,
      senderId: senderId ?? this.senderId,
      receiverId: receiverId ?? this.receiverId,
      content: content ?? this.content,
      type: type ?? this.type,
      timestamp: timestamp ?? this.timestamp,
      status: status ?? this.status,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      duration: duration ?? this.duration,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'type': type.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'status': status.name,
      'isEncrypted': isEncrypted,
      'filePath': filePath,
      'fileSize': fileSize,
      'fileType': fileType,
      'thumbnailPath': thumbnailPath,
      'duration': duration?.inMilliseconds,
      'metadata': metadata,
    };
  }

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'],
      senderId: json['senderId'],
      receiverId: json['receiverId'],
      content: json['content'],
      type: MessageType.values.firstWhere((e) => e.name == json['type']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      status: MessageStatus.values.firstWhere((e) => e.name == json['status']),
      isEncrypted: json['isEncrypted'] ?? true,
      filePath: json['filePath'],
      fileSize: json['fileSize'],
      fileType: json['fileType'],
      thumbnailPath: json['thumbnailPath'],
      duration: json['duration'] != null 
          ? Duration(milliseconds: json['duration']) 
          : null,
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'sender_id': senderId,
      'receiver_id': receiverId,
      'content': content,
      'message_type': type.name,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'is_sent': status == MessageStatus.sent ? 1 : 0,
      'is_delivered': status == MessageStatus.delivered ? 1 : 0,
      'is_read': status == MessageStatus.read ? 1 : 0,
      'is_encrypted': isEncrypted ? 1 : 0,
      'file_path': filePath,
      'file_size': fileSize,
      'file_type': fileType,
    };
  }

  factory MessageModel.fromDatabase(Map<String, dynamic> map) {
    MessageStatus getStatus() {
      if (map['is_read'] == 1) return MessageStatus.read;
      if (map['is_delivered'] == 1) return MessageStatus.delivered;
      if (map['is_sent'] == 1) return MessageStatus.sent;
      return MessageStatus.sending;
    }

    return MessageModel(
      id: map['id'],
      senderId: map['sender_id'],
      receiverId: map['receiver_id'],
      content: map['content'],
      type: MessageType.values.firstWhere((e) => e.name == map['message_type']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(map['timestamp']),
      status: getStatus(),
      isEncrypted: map['is_encrypted'] == 1,
      filePath: map['file_path'],
      fileSize: map['file_size'],
      fileType: map['file_type'],
    );
  }
}
