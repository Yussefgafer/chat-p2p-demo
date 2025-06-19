/// Demo User Model - simplified version for demo purposes
/// In production, use proper packages like equatable and hive
class UserModel {
  final String id;
  final String name;
  final String? avatar;
  final String publicKey;
  final String? status;
  final bool isOnline;
  final DateTime lastSeen;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Map<String, dynamic>? metadata;

  const UserModel({
    required this.id,
    required this.name,
    this.avatar,
    required this.publicKey,
    this.status,
    this.isOnline = false,
    required this.lastSeen,
    required this.createdAt,
    required this.updatedAt,
    this.metadata,
  });

  /// Demo equality check (simplified)
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserModel &&
        other.id == id &&
        other.name == name &&
        other.avatar == avatar &&
        other.publicKey == publicKey &&
        other.status == status &&
        other.isOnline == isOnline &&
        other.lastSeen == lastSeen &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        avatar.hashCode ^
        publicKey.hashCode ^
        status.hashCode ^
        isOnline.hashCode ^
        lastSeen.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode;
  }

  /// Convert to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'publicKey': publicKey,
      'status': status,
      'isOnline': isOnline,
      'lastSeen': lastSeen.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  /// Create from JSON
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] as String,
      name: json['name'] as String,
      avatar: json['avatar'] as String?,
      publicKey: json['publicKey'] as String,
      status: json['status'] as String?,
      isOnline: json['isOnline'] as bool? ?? false,
      lastSeen: DateTime.parse(json['lastSeen'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  /// Copy with new values
  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? publicKey,
    String? status,
    bool? isOnline,
    DateTime? lastSeen,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? metadata,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      publicKey: publicKey ?? this.publicKey,
      status: status ?? this.status,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      metadata: metadata ?? this.metadata,
    );
  }

  /// Convert to database format
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'publicKey': publicKey,
      'status': status,
      'isOnline': isOnline ? 1 : 0,
      'lastSeen': lastSeen.millisecondsSinceEpoch,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'metadata': metadata != null ? metadata.toString() : null,
    };
  }

  /// Create from database format
  factory UserModel.fromDatabase(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] as String,
      name: map['name'] as String,
      avatar: map['avatar'] as String?,
      publicKey: map['publicKey'] as String,
      status: map['status'] as String?,
      isOnline: (map['isOnline'] as int) == 1,
      lastSeen: DateTime.fromMillisecondsSinceEpoch(map['lastSeen'] as int),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updatedAt'] as int),
      metadata: map['metadata'] != null ? {'raw': map['metadata']} : null,
    );
  }

  @override
  String toString() {
    return 'UserModel(id: $id, name: $name, isOnline: $isOnline)';
  }
}
