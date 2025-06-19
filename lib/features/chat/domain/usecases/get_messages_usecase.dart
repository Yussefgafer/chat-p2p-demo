import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../../../../shared/models/message_model.dart';
import '../repositories/chat_repository.dart';

/// Use case for getting messages
class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<MessageModel>>> call(GetMessagesParams params) async {
    return await repository.getMessages(
      roomId: params.roomId,
      limit: params.limit,
      beforeMessageId: params.beforeMessageId,
    );
  }
}

/// Parameters for getting messages
class GetMessagesParams extends Equatable {
  final String roomId;
  final int limit;
  final String? beforeMessageId;

  const GetMessagesParams({
    required this.roomId,
    this.limit = 50,
    this.beforeMessageId,
  });

  @override
  List<Object?> get props => [roomId, limit, beforeMessageId];
}
