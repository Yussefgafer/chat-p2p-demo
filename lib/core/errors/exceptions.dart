/// Base class for all exceptions in the application
abstract class AppException implements Exception {
  final String message;
  final int? code;
  
  const AppException({
    required this.message,
    this.code,
  });
  
  @override
  String toString() => 'AppException: $message (Code: $code)';
}

/// Network-related exceptions
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'NetworkException: $message (Code: $code)';
}

/// WebRTC connection exceptions
class WebRTCException extends AppException {
  const WebRTCException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'WebRTCException: $message (Code: $code)';
}

/// Peer discovery exceptions
class PeerDiscoveryException extends AppException {
  const PeerDiscoveryException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'PeerDiscoveryException: $message (Code: $code)';
}

/// File transfer exceptions
class FileTransferException extends AppException {
  const FileTransferException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'FileTransferException: $message (Code: $code)';
}

/// Encryption/Decryption exceptions
class CryptographyException extends AppException {
  const CryptographyException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'CryptographyException: $message (Code: $code)';
}

/// Database operation exceptions
class DatabaseException extends AppException {
  const DatabaseException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'DatabaseException: $message (Code: $code)';
}

/// Permission-related exceptions
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'PermissionException: $message (Code: $code)';
}

/// Authentication exceptions
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'AuthException: $message (Code: $code)';
}

/// Storage exceptions
class StorageException extends AppException {
  const StorageException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'StorageException: $message (Code: $code)';
}

/// Validation exceptions
class ValidationException extends AppException {
  const ValidationException({
    required super.message,
    super.code,
  });
  
  @override
  String toString() => 'ValidationException: $message (Code: $code)';
}
