import '../../domain/entities/file_transfer_entity.dart';

/// Model class for file transfer data
class FileTransferModel extends FileTransferEntity {
  const FileTransferModel({
    required super.id,
    required super.messageId,
    required super.fileName,
    required super.filePath,
    required super.fileSize,
    required super.fileType,
    super.mimeType,
    required super.transferType,
    required super.protocol,
    super.status = FileTransferStatus.pending,
    super.progress = 0.0,
    super.bytesTransferred = 0,
    required super.createdAt,
    super.startedAt,
    super.completedAt,
    super.errorMessage,
    super.metadata,
    super.thumbnailPath,
    super.checksum,
    super.isEncrypted = true,
    super.encryptionKey,
    super.transferSpeed,
    super.estimatedTimeRemaining,
  });

  /// Create model from entity
  factory FileTransferModel.fromEntity(FileTransferEntity entity) {
    return FileTransferModel(
      id: entity.id,
      messageId: entity.messageId,
      fileName: entity.fileName,
      filePath: entity.filePath,
      fileSize: entity.fileSize,
      fileType: entity.fileType,
      mimeType: entity.mimeType,
      transferType: entity.transferType,
      protocol: entity.protocol,
      status: entity.status,
      progress: entity.progress,
      bytesTransferred: entity.bytesTransferred,
      createdAt: entity.createdAt,
      startedAt: entity.startedAt,
      completedAt: entity.completedAt,
      errorMessage: entity.errorMessage,
      metadata: entity.metadata,
      thumbnailPath: entity.thumbnailPath,
      checksum: entity.checksum,
      isEncrypted: entity.isEncrypted,
      encryptionKey: entity.encryptionKey,
      transferSpeed: entity.transferSpeed,
      estimatedTimeRemaining: entity.estimatedTimeRemaining,
    );
  }

  /// Create model from JSON
  factory FileTransferModel.fromJson(Map<String, dynamic> json) {
    return FileTransferModel(
      id: json['id'],
      messageId: json['messageId'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileSize: json['fileSize'],
      fileType: json['fileType'],
      mimeType: json['mimeType'],
      transferType: _parseTransferType(json['transferType']),
      protocol: _parseProtocol(json['protocol']),
      status: _parseStatus(json['status']),
      progress: (json['progress'] ?? 0.0).toDouble(),
      bytesTransferred: json['bytesTransferred'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      startedAt: json['startedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['startedAt'])
          : null,
      completedAt: json['completedAt'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['completedAt'])
          : null,
      errorMessage: json['errorMessage'],
      metadata: json['metadata'],
      thumbnailPath: json['thumbnailPath'],
      checksum: json['checksum'],
      isEncrypted: json['isEncrypted'] ?? true,
      encryptionKey: json['encryptionKey'],
      transferSpeed: json['transferSpeed']?.toDouble(),
      estimatedTimeRemaining: json['estimatedTimeRemaining'] != null
          ? Duration(milliseconds: json['estimatedTimeRemaining'])
          : null,
    );
  }

  /// Convert model to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'messageId': messageId,
      'fileName': fileName,
      'filePath': filePath,
      'fileSize': fileSize,
      'fileType': fileType,
      'mimeType': mimeType,
      'transferType': transferType.name,
      'protocol': protocol.name,
      'status': status.name,
      'progress': progress,
      'bytesTransferred': bytesTransferred,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'startedAt': startedAt?.millisecondsSinceEpoch,
      'completedAt': completedAt?.millisecondsSinceEpoch,
      'errorMessage': errorMessage,
      'metadata': metadata,
      'thumbnailPath': thumbnailPath,
      'checksum': checksum,
      'isEncrypted': isEncrypted,
      'encryptionKey': encryptionKey,
      'transferSpeed': transferSpeed,
      'estimatedTimeRemaining': estimatedTimeRemaining?.inMilliseconds,
    };
  }

  /// Create model from database map
  factory FileTransferModel.fromDatabase(Map<String, dynamic> map) {
    return FileTransferModel(
      id: map['id'],
      messageId: map['message_id'],
      fileName: map['file_name'],
      filePath: map['file_path'],
      fileSize: map['file_size'],
      fileType: map['file_type'],
      transferType: _parseTransferType(map['transfer_type']),
      protocol: _parseProtocol(map['protocol'] ?? 'webrtc'),
      status: _parseStatus(map['status']),
      progress: (map['progress'] ?? 0.0).toDouble(),
      bytesTransferred: map['bytes_transferred'] ?? 0,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      startedAt: map['started_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['started_at'])
          : null,
      completedAt: map['completed_at'] != null
          ? DateTime.fromMillisecondsSinceEpoch(map['completed_at'])
          : null,
      errorMessage: map['error_message'],
      thumbnailPath: map['thumbnail_path'],
      checksum: map['checksum'],
      isEncrypted: map['is_encrypted'] == 1,
      encryptionKey: map['encryption_key'],
    );
  }

  /// Convert model to database map
  Map<String, dynamic> toDatabase() {
    return {
      'id': id,
      'message_id': messageId,
      'file_name': fileName,
      'file_path': filePath,
      'file_size': fileSize,
      'file_type': fileType,
      'transfer_type': transferType.name,
      'protocol': protocol.name,
      'status': status.name,
      'progress': progress,
      'bytes_transferred': bytesTransferred,
      'created_at': createdAt.millisecondsSinceEpoch,
      'started_at': startedAt?.millisecondsSinceEpoch,
      'completed_at': completedAt?.millisecondsSinceEpoch,
      'error_message': errorMessage,
      'thumbnail_path': thumbnailPath,
      'checksum': checksum,
      'is_encrypted': isEncrypted ? 1 : 0,
      'encryption_key': encryptionKey,
    };
  }

  /// Copy with new values
  @override
  FileTransferModel copyWith({
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
    return FileTransferModel(
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

  /// Parse transfer type from string
  static FileTransferType _parseTransferType(String? type) {
    switch (type?.toLowerCase()) {
      case 'upload':
        return FileTransferType.upload;
      case 'download':
        return FileTransferType.download;
      default:
        return FileTransferType.upload;
    }
  }

  /// Parse protocol from string
  static FileTransferProtocol _parseProtocol(String? protocol) {
    switch (protocol?.toLowerCase()) {
      case 'webrtc':
        return FileTransferProtocol.webrtc;
      case 'webtorrent':
        return FileTransferProtocol.webTorrent;
      case 'ftp':
        return FileTransferProtocol.ftp;
      case 'http':
        return FileTransferProtocol.http;
      case 'https':
        return FileTransferProtocol.https;
      default:
        return FileTransferProtocol.webrtc;
    }
  }

  /// Parse status from string
  static FileTransferStatus _parseStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return FileTransferStatus.pending;
      case 'preparing':
        return FileTransferStatus.preparing;
      case 'transferring':
        return FileTransferStatus.transferring;
      case 'paused':
        return FileTransferStatus.paused;
      case 'completed':
        return FileTransferStatus.completed;
      case 'failed':
        return FileTransferStatus.failed;
      case 'cancelled':
        return FileTransferStatus.cancelled;
      default:
        return FileTransferStatus.pending;
    }
  }
}
