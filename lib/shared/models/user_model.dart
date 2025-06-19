import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel extends Equatable {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String name;
  
  @HiveField(2)
  final String? avatar;
  
  @HiveField(3)
  final String? publicKey;
  
  @HiveField(4)
  final DateTime createdAt;
  
  @HiveField(5)
  final DateTime updatedAt;
  
  @HiveField(6)
  final int? age;
  
  @HiveField(7)
  final String? phoneNumber;
  
  @HiveField(8)
  final bool isOnline;
  
  @HiveField(9)
  final DateTime? lastSeen;

  const UserModel({
    required this.id,
    required this.name,
    this.avatar,
    this.publicKey,
    required this.createdAt,
    required this.updatedAt,
    this.age,
    this.phoneNumber,
    this.isOnline = false,
    this.lastSeen,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        avatar,
        publicKey,
        createdAt,
        updatedAt,
        age,
        phoneNumber,
        isOnline,
        lastSeen,
      ];

  UserModel copyWith({
    String? id,
    String? name,
    String? avatar,
    String? publicKey,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? age,
    String? phoneNumber,
    bool? isOnline,
    DateTime? lastSeen,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      avatar: avatar ?? this.avatar,
      publicKey: publicKey ?? this.publicKey,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      age: age ?? this.age,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isOnline: isOnline ?? this.isOnline,
      lastSeen: lastSeen ?? this.lastSeen,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'publicKey': publicKey,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
      'age': age,
      'phoneNumber': phoneNumber,
      'isOnline': isOnline,
      'lastSeen': lastSeen?.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      avatar: json['avatar'],
      publicKey: json['publicKey'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(json['updatedAt']),
      age: json['age'],
      phoneNumber: json['phoneNumber'],
      isOnline: json['isOnline'] ?? false,
      lastSeen: json['lastSeen'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['lastSeen'])
          : null,
    );
  }

  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'name': name,
      'avatar': avatar,
      'public_key': publicKey,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  factory UserModel.fromDatabase(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      name: map['name'],
      avatar: map['avatar'],
      publicKey: map['public_key'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }
}
