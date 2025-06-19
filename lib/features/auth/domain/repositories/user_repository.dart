import 'package:dartz/dartz.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/user_model.dart';

/// Abstract repository for user-related operations
abstract class UserRepository {
  /// Get current user profile
  Future<Either<Failure, UserModel?>> getCurrentUser();
  
  /// Create a new user profile
  Future<Either<Failure, UserModel>> createUser({
    required String name,
    String? avatar,
    int? age,
    String? phoneNumber,
  });
  
  /// Update user profile
  Future<Either<Failure, UserModel>> updateUser(UserModel user);
  
  /// Delete user profile
  Future<Either<Failure, void>> deleteUser(String userId);
  
  /// Check if user exists
  Future<Either<Failure, bool>> userExists();
  
  /// Get user by ID
  Future<Either<Failure, UserModel?>> getUserById(String userId);
  
  /// Save user to local storage
  Future<Either<Failure, void>> saveUserLocally(UserModel user);
  
  /// Load user from local storage
  Future<Either<Failure, UserModel?>> loadUserFromLocal();
  
  /// Generate new user ID
  String generateUserId();
  
  /// Generate public/private key pair for encryption
  Future<Either<Failure, Map<String, String>>> generateKeyPair();
  
  /// Update user online status
  Future<Either<Failure, void>> updateOnlineStatus(String userId, bool isOnline);
  
  /// Get all known users (peers)
  Future<Either<Failure, List<UserModel>>> getAllKnownUsers();
  
  /// Add a new peer user
  Future<Either<Failure, void>> addPeerUser(UserModel user);
  
  /// Remove a peer user
  Future<Either<Failure, void>> removePeerUser(String userId);
  
  /// Update peer user info
  Future<Either<Failure, void>> updatePeerUser(UserModel user);
}
