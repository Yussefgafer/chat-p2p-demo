import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/message_model.dart';
import '../repositories/chat_repository.dart';

/// Use case for sending messages
class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, MessageModel>> call(SendMessageParams params) async {
    return await repository.sendMessage(
      roomId: params.roomId,
      content: params.content,
      type: params.type,
      filePath: params.filePath,
      fileSize: params.fileSize,
      fileType: params.fileType,
      metadata: params.metadata,
    );
  }
}

/// Parameters for sending a message
class SendMessageParams extends Equatable {
  final String roomId;
  final String content;
  final MessageType type;
  final String? filePath;
  final int? fileSize;
  final String? fileType;
  final Map<String, dynamic>? metadata;

  const SendMessageParams({
    required this.roomId,
    required this.content,
    required this.type,
    this.filePath,
    this.fileSize,
    this.fileType,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        roomId,
        content,
        type,
        filePath,
        fileSize,
        fileType,
        metadata,
      ];
}
