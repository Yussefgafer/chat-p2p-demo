// import 'package:dartz/dartz.dart'; // Commented out for demo
import '../../../../core/utils/either.dart';
import '../../../../core/errors/failures.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../../core/utils/encryption_helper.dart';
import '../../../../shared/models/user_model.dart';
import '../../domain/repositories/user_repository.dart';
import '../datasources/user_local_data_source.dart';

/// Implementation of UserRepository
class UserRepositoryImpl implements UserRepository {
  final UserLocalDataSource localDataSource;

  UserRepositoryImpl({required this.localDataSource});

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getCurrentUser();
      return Right(user);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> createUser({
    required String name,
    String? avatar,
    int? age,
    String? phoneNumber,
  }) async {
    try {
      // Validate input
      if (name.trim().isEmpty) {
        return const Left(ValidationFailure(message: 'Name cannot be empty'));
      }

      // Generate key pair for encryption
      final keyPairResult = await generateKeyPair();
      String? publicKey;

      keyPairResult.fold(
        (failure) => publicKey = null,
        (keyPair) => publicKey = keyPair['publicKey'],
      );

      final user = await localDataSource.createUser(
        name: name.trim(),
        avatar: avatar,
        age: age,
        phoneNumber: phoneNumber,
      );

      // Update user with public key if generated successfully
      if (publicKey != null) {
        final updatedUser = user.copyWith(publicKey: publicKey);
        final updateResult = await updateUser(updatedUser);
        return updateResult.fold(
          (failure) => Right(user), // Return original user if update fails
          (updatedUser) => Right(updatedUser),
        );
      }

      return Right(user);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to create user: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel>> updateUser(UserModel user) async {
    try {
      final updatedUser = await localDataSource.updateUser(user);
      return Right(updatedUser);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(String userId) async {
    try {
      await localDataSource.deleteUser(userId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to delete user: $e'));
    }
  }

  @override
  Future<Either<Failure, bool>> userExists() async {
    try {
      final exists = await localDataSource.userExists();
      return Right(exists);
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Failed to check user existence: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getUserById(String userId) async {
    try {
      final user = await localDataSource.getUserById(userId);
      return Right(user);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get user by ID: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> saveUserLocally(UserModel user) async {
    try {
      await localDataSource.saveUserToPreferences(user);
      return const Right(null);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to save user locally: $e'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> loadUserFromLocal() async {
    try {
      final user = await localDataSource.loadUserFromPreferences();
      return Right(user);
    } on StorageException catch (e) {
      return Left(StorageFailure(message: e.message));
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Failed to load user from local: $e'),
      );
    }
  }

  @override
  String generateUserId() {
    return UuidGenerator.generateUserId();
  }

  @override
  Future<Either<Failure, Map<String, String>>> generateKeyPair() async {
    try {
      // Generate encryption key pair
      final key = EncryptionHelper.generateKey();
      final salt = EncryptionHelper.generateIV(); // Using IV as salt for demo

      // For now, we'll use the key as both public and private
      // In a real implementation, you'd use proper asymmetric encryption
      final keyPair = {
        'publicKey': key, // key is already a string in our demo implementation
        'privateKey': key, // key is already a string in our demo implementation
        'salt': salt,
      };

      return Right(keyPair);
    } on CryptographyException catch (e) {
      return Left(CryptographyFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to generate key pair: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updateOnlineStatus(
    String userId,
    bool isOnline,
  ) async {
    try {
      final userResult = await getUserById(userId);
      return userResult.fold((failure) => Left(failure), (user) async {
        if (user == null) {
          return const Left(DatabaseFailure(message: 'User not found'));
        }

        final updatedUser = user.copyWith(
          isOnline: isOnline,
          lastSeen: isOnline ? null : DateTime.now(),
        );

        final updateResult = await updateUser(updatedUser);
        return updateResult.fold(
          (failure) => Left(failure),
          (_) => const Right(null),
        );
      });
    } catch (e) {
      return Left(
        UnknownFailure(message: 'Failed to update online status: $e'),
      );
    }
  }

  @override
  Future<Either<Failure, List<UserModel>>> getAllKnownUsers() async {
    try {
      final users = await localDataSource.getAllKnownUsers();
      return Right(users);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to get all known users: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> addPeerUser(UserModel user) async {
    try {
      await localDataSource.addPeerUser(user);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to add peer user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> removePeerUser(String userId) async {
    try {
      await localDataSource.removePeerUser(userId);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to remove peer user: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> updatePeerUser(UserModel user) async {
    try {
      await localDataSource.updatePeerUser(user);
      return const Right(null);
    } on DatabaseException catch (e) {
      return Left(DatabaseFailure(message: e.message));
    } catch (e) {
      return Left(UnknownFailure(message: 'Failed to update peer user: $e'));
    }
  }
}
