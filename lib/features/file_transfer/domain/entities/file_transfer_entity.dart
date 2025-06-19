import 'package:equatable/equatable.dart';

/// Enum for file transfer status
enum FileTransferStatus {
  pending,
  preparing,
  transferring,
  paused,
  completed,
  failed,
  cancelled,
}

/// Enum for file transfer type
enum FileTransferType {
  upload,
  download,
}

/// Enum for file transfer protocol
enum FileTransferProtocol {
  webrtc,
  webTorrent,
  ftp,
  http,
  https,
}

/// Entity representing a file transfer
class FileTransferEntity extends Equatable {
  final String id;
  final String messageId;
  final String fileName;
  final String filePath;
  final int fileSize;
  final String fileType;
  final String? mimeType;
  final FileTransferType transferType;
  final FileTransferProtocol protocol;
  final FileTransferStatus status;
  final double progress;
  final int bytesTransferred;
  final DateTime createdAt;
  final DateTime? startedAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;
  final String? thumbnailPath;
  final String? checksum;
  final bool isEncrypted;
  final String? encryptionKey;
  final double? transferSpeed; // bytes per second
  final Duration? estimatedTimeRemaining;

  const FileTransferEntity({
    required this.id,
    required this.messageId,
    required this.fileName,
    required this.filePath,
    required this.fileSize,
    required this.fileType,
    this.mimeType,
    required this.transferType,
    required this.protocol,
    this.status = FileTransferStatus.pending,
    this.progress = 0.0,
    this.bytesTransferred = 0,
    required this.createdAt,
    this.startedAt,
    this.completedAt,
    this.errorMessage,
    this.metadata,
    this.thumbnailPath,
    this.checksum,
    this.isEncrypted = true,
    this.encryptionKey,
    this.transferSpeed,
    this.estimatedTimeRemaining,
  });

  @override
  List<Object?> get props => [
        id,
        messageId,
        fileName,
        filePath,
        fileSize,
        fileType,
        mimeType,
        transferType,
        protocol,
        status,
        progress,
        bytesTransferred,
        createdAt,
        startedAt,
        completedAt,
        errorMessage,
        metadata,
        thumbnailPath,
        checksum,
        isEncrypted,
        encryptionKey,
        transferSpeed,
        estimatedTimeRemaining,
      ];

  FileTransferEntity copyWith({
    String? id,
    String? messageId,
    String? fileName,
    String? filePath,
    int? fileSize,
    String? fileType,
    String? mimeType,
    FileTransferType? transferType,
    FileTransferProtocol? protocol,
    FileTransferStatus? status,
    double? progress,
    int? bytesTransferred,
    DateTime? createdAt,
    DateTime? startedAt,
    DateTime? completedAt,
    String? errorMessage,
    Map<String, dynamic>? metadata,
    String? thumbnailPath,
    String? checksum,
    bool? isEncrypted,
    String? encryptionKey,
    double? transferSpeed,
    Duration? estimatedTimeRemaining,
  }) {
    return FileTransferEntity(
      id: id ?? this.id,
      messageId: messageId ?? this.messageId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      fileSize: fileSize ?? this.fileSize,
      fileType: fileType ?? this.fileType,
      mimeType: mimeType ?? this.mimeType,
      transferType: transferType ?? this.transferType,
      protocol: protocol ?? this.protocol,
      status: status ?? this.status,
      progress: progress ?? this.progress,
      bytesTransferred: bytesTransferred ?? this.bytesTransferred,
      createdAt: createdAt ?? this.createdAt,
      startedAt: startedAt ?? this.startedAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      metadata: metadata ?? this.metadata,
      thumbnailPath: thumbnailPath ?? this.thumbnailPath,
      checksum: checksum ?? this.checksum,
      isEncrypted: isEncrypted ?? this.isEncrypted,
      encryptionKey: encryptionKey ?? this.encryptionKey,
      transferSpeed: transferSpeed ?? this.transferSpeed,
      estimatedTimeRemaining: estimatedTimeRemaining ?? this.estimatedTimeRemaining,
    );
  }

  /// Check if transfer is in progress
  bool get isInProgress => status == FileTransferStatus.transferring;

  /// Check if transfer is completed
  bool get isCompleted => status == FileTransferStatus.completed;

  /// Check if transfer has failed
  bool get hasFailed => status == FileTransferStatus.failed;

  /// Check if transfer is paused
  bool get isPaused => status == FileTransferStatus.paused;

  /// Check if transfer can be resumed
  bool get canResume => isPaused || hasFailed;

  /// Check if transfer can be cancelled
  bool get canCancel => status == FileTransferStatus.pending ||
      status == FileTransferStatus.preparing ||
      status == FileTransferStatus.transferring ||
      status == FileTransferStatus.paused;

  /// Get formatted file size
  String get formattedFileSize => _formatBytes(fileSize);

  /// Get formatted bytes transferred
  String get formattedBytesTransferred => _formatBytes(bytesTransferred);

  /// Get formatted transfer speed
  String get formattedTransferSpeed {
    if (transferSpeed == null) return '';
    return '${_formatBytes(transferSpeed!.round())}/s';
  }

  /// Get formatted estimated time remaining
  String get formattedTimeRemaining {
    if (estimatedTimeRemaining == null) return '';
    
    final duration = estimatedTimeRemaining!;
    if (duration.inHours > 0) {
      return '${duration.inHours}h ${duration.inMinutes % 60}m';
    } else if (duration.inMinutes > 0) {
      return '${duration.inMinutes}m ${duration.inSeconds % 60}s';
    } else {
      return '${duration.inSeconds}s';
    }
  }

  /// Get progress percentage
  int get progressPercentage => (progress * 100).round();

  /// Get transfer duration
  Duration? get transferDuration {
    if (startedAt == null) return null;
    final endTime = completedAt ?? DateTime.now();
    return endTime.difference(startedAt!);
  }

  /// Check if file is an image
  bool get isImage => ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp'].contains(fileType.toLowerCase());

  /// Check if file is a video
  bool get isVideo => ['mp4', 'avi', 'mov', 'mkv', 'webm', 'flv'].contains(fileType.toLowerCase());

  /// Check if file is an audio
  bool get isAudio => ['mp3', 'wav', 'aac', 'flac', 'ogg', 'm4a'].contains(fileType.toLowerCase());

  /// Check if file is a document
  bool get isDocument => ['pdf', 'doc', 'docx', 'txt', 'rtf', 'odt'].contains(fileType.toLowerCase());

  /// Get file category icon
  String get categoryIcon {
    if (isImage) return '🖼️';
    if (isVideo) return '🎥';
    if (isAudio) return '🎵';
    if (isDocument) return '📄';
    return '📁';
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    if (bytes < 1024 * 1024 * 1024) return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
    return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}
