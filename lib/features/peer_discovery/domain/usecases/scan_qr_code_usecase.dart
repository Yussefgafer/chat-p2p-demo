import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/errors/failures.dart';
import '../entities/discovery_data_entity.dart';
import '../repositories/peer_discovery_repository.dart';

/// Use case for scanning and parsing QR code
class ScanQRCodeUseCase {
  final PeerDiscoveryRepository repository;

  ScanQRCodeUseCase(this.repository);

  Future<Either<Failure, DiscoveryDataEntity>> call(
    ScanQRCodeParams params,
  ) async {
    return await repository.parseQRCodeData(params.qrData);
  }
}

/// Parameters for scanning QR code
class ScanQRCodeParams extends Equatable {
  final String qrData;

  const ScanQRCodeParams({required this.qrData});

  @override
  List<Object> get props => [qrData];
}
