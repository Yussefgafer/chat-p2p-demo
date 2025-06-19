import 'package:equatable/equatable.dart';

/// Base class for all failures in the application
abstract class Failure extends Equatable {
  final String message;
  final int? code;
  
  const Failure({
    required this.message,
    this.code,
  });
  
  @override
  List<Object?> get props => [message, code];
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
  });
}

/// WebRTC connection failures
class WebRTCFailure extends Failure {
  const WebRTCFailure({
    required super.message,
    super.code,
  });
}

/// Peer discovery failures
class PeerDiscoveryFailure extends Failure {
  const PeerDiscoveryFailure({
    required super.message,
    super.code,
  });
}

/// File transfer failures
class FileTransferFailure extends Failure {
  const FileTransferFailure({
    required super.message,
    super.code,
  });
}

/// Encryption/Decryption failures
class CryptographyFailure extends Failure {
  const CryptographyFailure({
    required super.message,
    super.code,
  });
}

/// Database operation failures
class DatabaseFailure extends Failure {
  const DatabaseFailure({
    required super.message,
    super.code,
  });
}

/// Permission-related failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
  });
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
  });
}

/// Storage failures
class StorageFailure extends Failure {
  const StorageFailure({
    required super.message,
    super.code,
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
  });
}

/// Unknown/Unexpected failures
class UnknownFailure extends Failure {
  const UnknownFailure({
    required super.message,
    super.code,
  });
}
