import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/discovery_data_entity.dart';
import '../repositories/peer_discovery_repository.dart';

/// Use case for generating QR code data
class GenerateQRCodeUseCase {
  final PeerDiscoveryRepository repository;

  GenerateQRCodeUseCase(this.repository);

  Future<Either<Failure, DiscoveryDataEntity>> call(
    GenerateQRCodeParams params,
  ) async {
    return await repository.generateQRCodeData(
      expirationDuration: params.expirationDuration,
      metadata: params.metadata,
    );
  }
}

/// Parameters for generating QR code
class GenerateQRCodeParams extends Equatable {
  final Duration? expirationDuration;
  final Map<String, dynamic>? metadata;

  const GenerateQRCodeParams({
    this.expirationDuration,
    this.metadata,
  });

  @override
  List<Object?> get props => [expirationDuration, metadata];
}
