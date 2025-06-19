import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:dio/dio.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../../../core/utils/uuid_generator.dart';
import '../../../../core/utils/encryption_helper.dart';
import '../models/file_transfer_model.dart';

/// Abstract class for file transfer data operations
abstract class FileTransferDataSource {
  Future<FileTransferModel> startUpload({
    required String filePath,
    required String messageId,
    required String recipientId,
    required String protocol,
    Map<String, dynamic>? metadata,
  });
  
  Future<FileTransferModel> startDownload({
    required String transferId,
    required String savePath,
    required String protocol,
  });
  
  Future<void> pauseTransfer(String transferId);
  Future<void> resumeTransfer(String transferId);
  Future<void> cancelTransfer(String transferId);
  
  Future<List<FileTransferModel>> getAllTransfers();
  Future<FileTransferModel?> getTransferById(String transferId);
  
  Stream<FileTransferModel> watchTransferProgress(String transferId);
  Stream<List<FileTransferModel>> watchAllTransfers();
  
  Future<String> generateChecksum(String filePath);
  Future<bool> verifyFileIntegrity(String filePath, String expectedChecksum);
  Future<String?> generateThumbnail(String filePath, int width, int height);
  Future<Uint8List> encryptFile(String filePath, String encryptionKey);
  Future<void> decryptFile(Uint8List encryptedData, String outputPath, String encryptionKey);
}

/// Implementation of file transfer data source
class FileTransferDataSourceImpl implements FileTransferDataSource {
  final Dio _dio = Dio();
  final Map<String, FileTransferModel> _transfers = {};
  final Map<String, CancelToken> _cancelTokens = {};
  final Map<String, StreamController<FileTransferModel>> _progressControllers = {};
  final StreamController<List<FileTransferModel>> _allTransfersController =
      StreamController<List<FileTransferModel>>.broadcast();

  @override
  Future<FileTransferModel> startUpload({
    required String filePath,
    required String messageId,
    required String recipientId,
    required String protocol,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      final file = File(filePath);
      if (!await file.exists()) {
        throw FileTransferException(message: 'File does not exist: $filePath');
      }

      final fileStats = await file.stat();
      final fileName = file.path.split('/').last;
      final fileType = fileName.split('.').last.toLowerCase();
      
      // Check file size limit
      if (fileStats.size > AppConstants.maxFileSize) {
        throw FileTransferException(
          message: 'File size exceeds maximum limit of ${AppConstants.maxFileSize} bytes',
        );
      }

      // Check supported file types
      if (!AppConstants.supportedFileTypes.contains(fileType)) {
        throw FileTransferException(message: 'File type not supported: $fileType');
      }

      final transferId = UuidGenerator.generateFileTransferId();
      final checksum = await generateChecksum(filePath);
      
      final transfer = FileTransferModel(
        id: transferId,
        messageId: messageId,
        fileName: fileName,
        filePath: filePath,
        fileSize: fileStats.size,
        fileType: fileType,
        transferType: 'upload',
        protocol: protocol,
        status: 'preparing',
        createdAt: DateTime.now(),
        checksum: checksum,
        metadata: metadata,
      );

      _transfers[transferId] = transfer;
      _createProgressController(transferId);

      // Start the actual upload based on protocol
      _startUploadProcess(transfer);

      return transfer;
    } catch (e) {
      throw FileTransferException(message: 'Failed to start upload: $e');
    }
  }

  @override
  Future<FileTransferModel> startDownload({
    required String transferId,
    required String savePath,
    required String protocol,
  }) async {
    try {
      // This would typically receive download info from peer
      // For now, create a placeholder transfer
      final transfer = FileTransferModel(
        id: transferId,
        messageId: 'msg_download',
        fileName: 'downloaded_file',
        filePath: savePath,
        fileSize: 0,
        fileType: 'unknown',
        transferType: 'download',
        protocol: protocol,
        status: 'preparing',
        createdAt: DateTime.now(),
      );

      _transfers[transferId] = transfer;
      _createProgressController(transferId);

      // Start the actual download based on protocol
      _startDownloadProcess(transfer);

      return transfer;
    } catch (e) {
      throw FileTransferException(message: 'Failed to start download: $e');
    }
  }

  void _startUploadProcess(FileTransferModel transfer) async {
    try {
      final progressController = _progressControllers[transfer.id]!;
      final cancelToken = CancelToken();
      _cancelTokens[transfer.id] = cancelToken;

      // Update status to transferring
      final updatedTransfer = transfer.copyWith(
        status: 'transferring',
        startedAt: DateTime.now(),
      );
      _transfers[transfer.id] = updatedTransfer;
      progressController.add(updatedTransfer);
      _notifyAllTransfersChanged();

      // Simulate file upload with progress
      final file = File(transfer.filePath);
      final fileBytes = await file.readAsBytes();
      final chunkSize = AppConstants.chunkSize;
      int bytesTransferred = 0;

      for (int i = 0; i < fileBytes.length; i += chunkSize) {
        if (cancelToken.isCancelled) break;

        final end = (i + chunkSize < fileBytes.length) ? i + chunkSize : fileBytes.length;
        final chunk = fileBytes.sublist(i, end);
        
        // Simulate network delay
        await Future.delayed(const Duration(milliseconds: 100));
        
        bytesTransferred += chunk.length;
        final progress = bytesTransferred / transfer.fileSize;
        final speed = bytesTransferred / (DateTime.now().difference(updatedTransfer.startedAt!).inSeconds + 1);

        final progressTransfer = _transfers[transfer.id]!.copyWith(
          progress: progress,
          bytesTransferred: bytesTransferred,
          transferSpeed: speed,
        );
        
        _transfers[transfer.id] = progressTransfer;
        progressController.add(progressTransfer);
        _notifyAllTransfersChanged();
      }

      if (!cancelToken.isCancelled) {
        // Transfer completed
        final completedTransfer = _transfers[transfer.id]!.copyWith(
          status: 'completed',
          progress: 1.0,
          bytesTransferred: transfer.fileSize,
          completedAt: DateTime.now(),
        );
        
        _transfers[transfer.id] = completedTransfer;
        progressController.add(completedTransfer);
        _notifyAllTransfersChanged();
      }
    } catch (e) {
      final failedTransfer = _transfers[transfer.id]!.copyWith(
        status: 'failed',
        errorMessage: e.toString(),
      );
      
      _transfers[transfer.id] = failedTransfer;
      _progressControllers[transfer.id]?.add(failedTransfer);
      _notifyAllTransfersChanged();
    }
  }

  void _startDownloadProcess(FileTransferModel transfer) async {
    try {
      // Similar to upload but for downloading
      // This is a placeholder implementation
      final progressController = _progressControllers[transfer.id]!;
      
      await Future.delayed(const Duration(seconds: 2));
      
      final completedTransfer = transfer.copyWith(
        status: 'completed',
        progress: 1.0,
        completedAt: DateTime.now(),
      );
      
      _transfers[transfer.id] = completedTransfer;
      progressController.add(completedTransfer);
      _notifyAllTransfersChanged();
    } catch (e) {
      final failedTransfer = _transfers[transfer.id]!.copyWith(
        status: 'failed',
        errorMessage: e.toString(),
      );
      
      _transfers[transfer.id] = failedTransfer;
      _progressControllers[transfer.id]?.add(failedTransfer);
      _notifyAllTransfersChanged();
    }
  }

  @override
  Future<void> pauseTransfer(String transferId) async {
    try {
      final transfer = _transfers[transferId];
      if (transfer != null && transfer.status == 'transferring') {
        final pausedTransfer = transfer.copyWith(status: 'paused');
        _transfers[transferId] = pausedTransfer;
        _progressControllers[transferId]?.add(pausedTransfer);
        _notifyAllTransfersChanged();
      }
    } catch (e) {
      throw FileTransferException(message: 'Failed to pause transfer: $e');
    }
  }

  @override
  Future<void> resumeTransfer(String transferId) async {
    try {
      final transfer = _transfers[transferId];
      if (transfer != null && transfer.status == 'paused') {
        final resumedTransfer = transfer.copyWith(status: 'transferring');
        _transfers[transferId] = resumedTransfer;
        _progressControllers[transferId]?.add(resumedTransfer);
        _notifyAllTransfersChanged();
        
        // Resume the transfer process
        if (transfer.transferType == 'upload') {
          _startUploadProcess(resumedTransfer);
        } else {
          _startDownloadProcess(resumedTransfer);
        }
      }
    } catch (e) {
      throw FileTransferException(message: 'Failed to resume transfer: $e');
    }
  }

  @override
  Future<void> cancelTransfer(String transferId) async {
    try {
      final cancelToken = _cancelTokens[transferId];
      cancelToken?.cancel();
      
      final transfer = _transfers[transferId];
      if (transfer != null) {
        final cancelledTransfer = transfer.copyWith(status: 'cancelled');
        _transfers[transferId] = cancelledTransfer;
        _progressControllers[transferId]?.add(cancelledTransfer);
        _notifyAllTransfersChanged();
      }
      
      _cancelTokens.remove(transferId);
    } catch (e) {
      throw FileTransferException(message: 'Failed to cancel transfer: $e');
    }
  }

  @override
  Future<List<FileTransferModel>> getAllTransfers() async {
    return _transfers.values.toList();
  }

  @override
  Future<FileTransferModel?> getTransferById(String transferId) async {
    return _transfers[transferId];
  }

  @override
  Stream<FileTransferModel> watchTransferProgress(String transferId) {
    _createProgressController(transferId);
    return _progressControllers[transferId]!.stream;
  }

  @override
  Stream<List<FileTransferModel>> watchAllTransfers() {
    return _allTransfersController.stream;
  }

  @override
  Future<String> generateChecksum(String filePath) async {
    try {
      final file = File(filePath);
      final bytes = await file.readAsBytes();
      final digest = sha256.convert(bytes);
      return digest.toString();
    } catch (e) {
      throw FileTransferException(message: 'Failed to generate checksum: $e');
    }
  }

  @override
  Future<bool> verifyFileIntegrity(String filePath, String expectedChecksum) async {
    try {
      final actualChecksum = await generateChecksum(filePath);
      return actualChecksum == expectedChecksum;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<String?> generateThumbnail(String filePath, int width, int height) async {
    try {
      // TODO: Implement thumbnail generation for images/videos
      // This would use packages like flutter_image_compress or video_thumbnail
      return null;
    } catch (e) {
      throw FileTransferException(message: 'Failed to generate thumbnail: $e');
    }
  }

  @override
  Future<Uint8List> encryptFile(String filePath, String encryptionKey) async {
    try {
      final file = File(filePath);
      final fileBytes = await file.readAsBytes();
      final key = Key.fromBase64(encryptionKey);
      final encryptedData = EncryptionHelper.encryptFileData(fileBytes, key);
      return Uint8List.fromList(encryptedData.encryptedText.codeUnits);
    } catch (e) {
      throw FileTransferException(message: 'Failed to encrypt file: $e');
    }
  }

  @override
  Future<void> decryptFile(Uint8List encryptedData, String outputPath, String encryptionKey) async {
    try {
      // TODO: Implement file decryption
      final outputFile = File(outputPath);
      await outputFile.writeAsBytes(encryptedData);
    } catch (e) {
      throw FileTransferException(message: 'Failed to decrypt file: $e');
    }
  }

  void _createProgressController(String transferId) {
    if (!_progressControllers.containsKey(transferId)) {
      _progressControllers[transferId] = StreamController<FileTransferModel>.broadcast();
    }
  }

  void _notifyAllTransfersChanged() {
    _allTransfersController.add(_transfers.values.toList());
  }

  void dispose() {
    for (final controller in _progressControllers.values) {
      controller.close();
    }
    _progressControllers.clear();
    _allTransfersController.close();
    _transfers.clear();
    _cancelTokens.clear();
  }
}
