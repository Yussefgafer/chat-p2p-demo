import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/file_transfer_entity.dart';
import '../repositories/file_transfer_repository.dart';

/// Use case for starting file upload
class StartFileUploadUseCase {
  final FileTransferRepository repository;

  StartFileUploadUseCase(this.repository);

  Future<Either<Failure, FileTransferEntity>> call(
    StartFileUploadParams params,
  ) async {
    return await repository.startUpload(
      filePath: params.filePath,
      messageId: params.messageId,
      recipientId: params.recipientId,
      protocol: params.protocol,
      metadata: params.metadata,
    );
  }
}

/// Parameters for starting file upload
class StartFileUploadParams extends Equatable {
  final String filePath;
  final String messageId;
  final String recipientId;
  final FileTransferProtocol protocol;
  final Map<String, dynamic>? metadata;

  const StartFileUploadParams({
    required this.filePath,
    required this.messageId,
    required this.recipientId,
    this.protocol = FileTransferProtocol.webrtc,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        filePath,
        messageId,
        recipientId,
        protocol,
        metadata,
      ];
}
