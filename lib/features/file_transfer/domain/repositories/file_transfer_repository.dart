import 'package:dartz/dartz.dart';
import 'dart:typed_data';
import '../../../../core/errors/failures.dart';
import '../entities/file_transfer_entity.dart';

/// Abstract repository for file transfer operations
abstract class FileTransferRepository {
  /// Start file upload
  Future<Either<Failure, FileTransferEntity>> startUpload({
    required String filePath,
    required String messageId,
    required String recipientId,
    FileTransferProtocol protocol = FileTransferProtocol.webrtc,
    Map<String, dynamic>? metadata,
  });
  
  /// Start file download
  Future<Either<Failure, FileTransferEntity>> startDownload({
    required String transferId,
    required String savePath,
    FileTransferProtocol protocol = FileTransferProtocol.webrtc,
  });
  
  /// Pause file transfer
  Future<Either<Failure, void>> pauseTransfer(String transferId);
  
  /// Resume file transfer
  Future<Either<Failure, void>> resumeTransfer(String transferId);
  
  /// Cancel file transfer
  Future<Either<Failure, void>> cancelTransfer(String transferId);
  
  /// Get file transfer by ID
  Future<Either<Failure, FileTransferEntity?>> getTransferById(String transferId);
  
  /// Get all file transfers
  Future<Either<Failure, List<FileTransferEntity>>> getAllTransfers();
  
  /// Get active file transfers
  Future<Either<Failure, List<FileTransferEntity>>> getActiveTransfers();
  
  /// Get completed file transfers
  Future<Either<Failure, List<FileTransferEntity>>> getCompletedTransfers();
  
  /// Delete file transfer record
  Future<Either<Failure, void>> deleteTransfer(String transferId);
  
  /// Clear completed transfers
  Future<Either<Failure, void>> clearCompletedTransfers();
  
  /// Watch file transfer progress
  Stream<FileTransferEntity> watchTransferProgress(String transferId);
  
  /// Watch all transfers
  Stream<List<FileTransferEntity>> watchAllTransfers();
  
  /// Get supported file types
  Future<Either<Failure, List<String>>> getSupportedFileTypes();
  
  /// Check if file type is supported
  Future<Either<Failure, bool>> isFileTypeSupported(String fileType);
  
  /// Get maximum file size
  Future<Either<Failure, int>> getMaxFileSize();
  
  /// Validate file for transfer
  Future<Either<Failure, bool>> validateFile(String filePath);
  
  /// Generate file checksum
  Future<Either<Failure, String>> generateChecksum(String filePath);
  
  /// Verify file integrity
  Future<Either<Failure, bool>> verifyFileIntegrity({
    required String filePath,
    required String expectedChecksum,
  });
  
  /// Compress file before transfer
  Future<Either<Failure, String>> compressFile({
    required String filePath,
    int quality = 80,
  });
  
  /// Decompress file after transfer
  Future<Either<Failure, String>> decompressFile(String compressedFilePath);
  
  /// Generate thumbnail for media files
  Future<Either<Failure, String?>> generateThumbnail({
    required String filePath,
    int width = 200,
    int height = 200,
  });
  
  /// Encrypt file for transfer
  Future<Either<Failure, Uint8List>> encryptFile({
    required String filePath,
    required String encryptionKey,
  });
  
  /// Decrypt file after transfer
  Future<Either<Failure, void>> decryptFile({
    required Uint8List encryptedData,
    required String outputPath,
    required String encryptionKey,
  });
  
  /// Get transfer statistics
  Future<Either<Failure, Map<String, dynamic>>> getTransferStatistics();
  
  /// Set transfer preferences
  Future<Either<Failure, void>> setTransferPreferences({
    FileTransferProtocol? defaultProtocol,
    int? maxConcurrentTransfers,
    bool? autoAcceptFiles,
    bool? compressFiles,
    int? compressionQuality,
  });
  
  /// Get transfer preferences
  Future<Either<Failure, Map<String, dynamic>>> getTransferPreferences();
  
  /// Check available storage space
  Future<Either<Failure, int>> getAvailableStorageSpace();
  
  /// Clean up temporary files
  Future<Either<Failure, void>> cleanupTempFiles();
  
  /// Get file transfer history
  Future<Either<Failure, List<FileTransferEntity>>> getTransferHistory({
    DateTime? startDate,
    DateTime? endDate,
    FileTransferType? type,
    FileTransferStatus? status,
  });
  
  /// Export transfer history
  Future<Either<Failure, String>> exportTransferHistory({
    DateTime? startDate,
    DateTime? endDate,
  });
}
