import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import 'package:hive/hive.dart';
import 'dart:convert';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../../shared/models/user_model.dart';

/// Abstract class for user local data operations
abstract class UserLocalDataSource {
  Future<UserModel?> getCurrentUser();
  Future<UserModel> createUser({
    required String name,
    String? avatar,
    int? age,
    String? phoneNumber,
  });
  Future<UserModel> updateUser(UserModel user);
  Future<void> deleteUser(String userId);
  Future<bool> userExists();
  Future<UserModel?> getUserById(String userId);
  Future<void> saveUserToPreferences(UserModel user);
  Future<UserModel?> loadUserFromPreferences();
  Future<List<UserModel>> getAllKnownUsers();
  Future<void> addPeerUser(UserModel user);
  Future<void> removePeerUser(String userId);
  Future<void> updatePeerUser(UserModel user);
}

/// Implementation of user local data source
class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;
  final Database database;
  late Box<UserModel> userBox;

  UserLocalDataSourceImpl({
    required this.sharedPreferences,
    required this.database,
  });

  /// Initialize Hive box
  Future<void> _initializeHiveBox() async {
    if (!Hive.isBoxOpen('users')) {
      userBox = await Hive.openBox<UserModel>('users');
    } else {
      userBox = Hive.box<UserModel>('users');
    }
  }

  @override
  Future<UserModel?> getCurrentUser() async {
    try {
      // First try to get from SharedPreferences
      final userJson = sharedPreferences.getString(AppConstants.userIdKey);
      if (userJson != null) {
        final userData = json.decode(userJson);
        return UserModel.fromJson(userData);
      }

      // Then try to get from database
      final List<Map<String, dynamic>> maps = await database.query(
        'users',
        limit: 1,
        orderBy: 'created_at DESC',
      );

      if (maps.isNotEmpty) {
        return UserModel.fromDatabase(maps.first);
      }

      return null;
    } catch (e) {
      throw DatabaseException(message: 'Failed to get current user: $e');
    }
  }

  @override
  Future<UserModel> createUser({
    required String name,
    String? avatar,
    int? age,
    String? phoneNumber,
  }) async {
    try {
      final now = DateTime.now();
      final user = UserModel(
        id: UuidGenerator.generateUserId(),
        name: name,
        avatar: avatar,
        createdAt: now,
        updatedAt: now,
        age: age,
        phoneNumber: phoneNumber,
      );

      // Save to database
      await database.insert('users', user.toDatabase());

      // Save to SharedPreferences
      await saveUserToPreferences(user);

      // Save to Hive
      await _initializeHiveBox();
      await userBox.put(user.id, user);

      return user;
    } catch (e) {
      throw DatabaseException(message: 'Failed to create user: $e');
    }
  }

  @override
  Future<UserModel> updateUser(UserModel user) async {
    try {
      final updatedUser = user.copyWith(updatedAt: DateTime.now());

      // Update in database
      await database.update(
        'users',
        updatedUser.toDatabase(),
        where: 'id = ?',
        whereArgs: [updatedUser.id],
      );

      // Update in SharedPreferences
      await saveUserToPreferences(updatedUser);

      // Update in Hive
      await _initializeHiveBox();
      await userBox.put(updatedUser.id, updatedUser);

      return updatedUser;
    } catch (e) {
      throw DatabaseException(message: 'Failed to update user: $e');
    }
  }

  @override
  Future<void> deleteUser(String userId) async {
    try {
      // Delete from database
      await database.delete('users', where: 'id = ?', whereArgs: [userId]);

      // Remove from SharedPreferences
      await sharedPreferences.remove(AppConstants.userIdKey);

      // Remove from Hive
      await _initializeHiveBox();
      await userBox.delete(userId);
    } catch (e) {
      throw DatabaseException(message: 'Failed to delete user: $e');
    }
  }

  @override
  Future<bool> userExists() async {
    try {
      final user = await getCurrentUser();
      return user != null;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<UserModel?> getUserById(String userId) async {
    try {
      // Try Hive first (faster)
      await _initializeHiveBox();
      final user = userBox.get(userId);
      if (user != null) return user;

      // Then try database
      final List<Map<String, dynamic>> maps = await database.query(
        'users',
        where: 'id = ?',
        whereArgs: [userId],
      );

      if (maps.isNotEmpty) {
        return UserModel.fromDatabase(maps.first);
      }

      return null;
    } catch (e) {
      throw DatabaseException(message: 'Failed to get user by ID: $e');
    }
  }

  @override
  Future<void> saveUserToPreferences(UserModel user) async {
    try {
      await sharedPreferences.setString(
        AppConstants.userIdKey,
        json.encode(user.toJson()),
      );
    } catch (e) {
      throw StorageException(message: 'Failed to save user to preferences: $e');
    }
  }

  @override
  Future<UserModel?> loadUserFromPreferences() async {
    try {
      final userJson = sharedPreferences.getString(AppConstants.userIdKey);
      if (userJson != null) {
        final userData = json.decode(userJson);
        return UserModel.fromJson(userData);
      }
      return null;
    } catch (e) {
      throw StorageException(message: 'Failed to load user from preferences: $e');
    }
  }

  @override
  Future<List<UserModel>> getAllKnownUsers() async {
    try {
      final List<Map<String, dynamic>> maps = await database.query('users');
      return maps.map((map) => UserModel.fromDatabase(map)).toList();
    } catch (e) {
      throw DatabaseException(message: 'Failed to get all known users: $e');
    }
  }

  @override
  Future<void> addPeerUser(UserModel user) async {
    try {
      await database.insert(
        'users',
        user.toDatabase(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      // Also save to Hive
      await _initializeHiveBox();
      await userBox.put(user.id, user);
    } catch (e) {
      throw DatabaseException(message: 'Failed to add peer user: $e');
    }
  }

  @override
  Future<void> removePeerUser(String userId) async {
    try {
      await database.delete('users', where: 'id = ?', whereArgs: [userId]);

      // Also remove from Hive
      await _initializeHiveBox();
      await userBox.delete(userId);
    } catch (e) {
      throw DatabaseException(message: 'Failed to remove peer user: $e');
    }
  }

  @override
  Future<void> updatePeerUser(UserModel user) async {
    try {
      await database.update(
        'users',
        user.toDatabase(),
        where: 'id = ?',
        whereArgs: [user.id],
      );

      // Also update in Hive
      await _initializeHiveBox();
      await userBox.put(user.id, user);
    } catch (e) {
      throw DatabaseException(message: 'Failed to update peer user: $e');
    }
  }
}
