import 'package:equatable/equatable.dart';
import '../entities/file_transfer_entity.dart';
import '../repositories/file_transfer_repository.dart';

/// Use case for watching file transfer progress
class WatchTransferProgressUseCase {
  final FileTransferRepository repository;

  WatchTransferProgressUseCase(this.repository);

  Stream<FileTransferEntity> call(WatchTransferProgressParams params) {
    return repository.watchTransferProgress(params.transferId);
  }
}

/// Parameters for watching transfer progress
class WatchTransferProgressParams extends Equatable {
  final String transferId;

  const WatchTransferProgressParams({required this.transferId});

  @override
  List<Object> get props => [transferId];
}
